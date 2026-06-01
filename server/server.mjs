import { randomBytes, scrypt, timingSafeEqual } from "node:crypto";
import { createReadStream } from "node:fs";
import { mkdir, readFile, stat, unlink, writeFile } from "node:fs/promises";
import { createServer } from "node:http";
import { extname, join, normalize, resolve, sep } from "node:path";
import { fileURLToPath } from "node:url";
import { promisify } from "node:util";

const ROOT = resolve(fileURLToPath(new URL("..", import.meta.url)));
const ENV_PATH = join(ROOT, ".env");
const scryptAsync = promisify(scrypt);
const DEFAULT_STATE = {
  schemaVersion: 1,
  plants: [],
  activities: [],
  harvestYields: [],
  settlements: [],
  decorations: { owned: [] },
  wallet: {
    currentCoins: 0,
    lifetimeCoins: 0,
    unlockedVarieties: []
  }
};

const MIME_TYPES = new Map([
  [".html", "text/html; charset=utf-8"],
  [".css", "text/css; charset=utf-8"],
  [".js", "text/javascript; charset=utf-8"],
  [".mjs", "text/javascript; charset=utf-8"],
  [".json", "application/json; charset=utf-8"],
  [".png", "image/png"],
  [".jpg", "image/jpeg"],
  [".jpeg", "image/jpeg"],
  [".svg", "image/svg+xml; charset=utf-8"],
  [".ico", "image/x-icon"]
]);

function parseEnvFile(text) {
  return Object.fromEntries(
    text
      .split(/\r?\n/)
      .map((line) => line.trim())
      .filter((line) => line && !line.startsWith("#") && line.includes("="))
      .map((line) => {
        const index = line.indexOf("=");
        const key = line.slice(0, index).trim();
        const value = line.slice(index + 1).trim().replace(/^["']|["']$/g, "");
        return [key, value];
      })
  );
}

async function loadConfig() {
  let fileConfig = {};
  try {
    fileConfig = parseEnvFile(await readFile(ENV_PATH, "utf-8"));
  } catch (error) {
    if (error.code !== "ENOENT") throw error;
  }
  const config = { ...fileConfig, ...process.env };
  return resolveConfig({
    host: config.ACADEMIC_GARDEN_HOST || "127.0.0.1",
    port: Number(config.ACADEMIC_GARDEN_PORT || 8787),
    username: config.ACADEMIC_GARDEN_USERNAME || "garden",
    password: config.ACADEMIC_GARDEN_PASSWORD || "change-this-password",
    dataPath: resolve(ROOT, config.ACADEMIC_GARDEN_DATA_PATH || "server/data/garden.json"),
    accountsPath: resolve(ROOT, config.ACADEMIC_GARDEN_ACCOUNTS_PATH || "server/data/accounts.json"),
    allowedOrigin: config.ACADEMIC_GARDEN_ALLOWED_ORIGIN || "",
    registrationEnabled: config.ACADEMIC_GARDEN_REGISTRATION_ENABLED === "true",
    sessionTtlMs: Number(config.ACADEMIC_GARDEN_SESSION_TTL_HOURS || 24) * 60 * 60 * 1000
  });
}

function resolveConfig(config) {
  const dataPath = config.dataPath ? resolve(ROOT, config.dataPath) : resolve(ROOT, "server/data/garden.json");
  return {
    host: config.host || "127.0.0.1",
    port: Number(config.port || 8787),
    username: config.username || "garden",
    password: config.password || "change-this-password",
    dataPath,
    accountsPath: config.accountsPath ? resolve(ROOT, config.accountsPath) : join(resolve(dataPath, ".."), "accounts.json"),
    allowedOrigin: config.allowedOrigin || "",
    registrationEnabled: config.registrationEnabled === true,
    sessionTtlMs: Number(config.sessionTtlMs || 24 * 60 * 60 * 1000)
  };
}

function applyCors(request, response, config) {
  const origin = request.headers.origin;
  if (!origin || !config.allowedOrigin) return;
  const allowedOrigins = config.allowedOrigin.split(",").map((item) => item.trim()).filter(Boolean);
  if (!allowedOrigins.includes("*") && !allowedOrigins.includes(origin)) return;
  response.setHeader("access-control-allow-origin", allowedOrigins.includes("*") ? origin : origin);
  response.setHeader("vary", "Origin");
  response.setHeader("access-control-allow-methods", "GET, PUT, POST, OPTIONS");
  response.setHeader("access-control-allow-headers", "authorization, content-type, accept");
  response.setHeader("access-control-allow-credentials", "true");
  response.setHeader("access-control-max-age", "600");
}

function sendJson(response, statusCode, payload) {
  response.writeHead(statusCode, {
    "content-type": "application/json; charset=utf-8",
    "cache-control": "no-store"
  });
  response.end(JSON.stringify(payload));
}

function sendText(response, statusCode, text) {
  response.writeHead(statusCode, { "content-type": "text/plain; charset=utf-8" });
  response.end(text);
}

function parseBasicAuth(request) {
  const header = request.headers.authorization || "";
  if (!header.startsWith("Basic ")) return null;
  try {
    const decoded = Buffer.from(header.slice(6), "base64").toString("utf-8");
    const separator = decoded.indexOf(":");
    if (separator === -1) return null;
    return {
      username: decoded.slice(0, separator),
      password: decoded.slice(separator + 1)
    };
  } catch {
    return null;
  }
}

function parseBearerToken(request) {
  const header = request.headers.authorization || "";
  if (!header.startsWith("Bearer ")) return "";
  return header.slice(7).trim();
}

function parseCookies(request) {
  const header = request.headers.cookie || "";
  return Object.fromEntries(
    header
      .split(";")
      .map((part) => part.trim())
      .filter(Boolean)
      .map((part) => {
        const index = part.indexOf("=");
        return index === -1 ? [part, ""] : [part.slice(0, index), decodeURIComponent(part.slice(index + 1))];
      })
  );
}

function normalizeUsername(username) {
  return String(username || "").trim().toLowerCase();
}

function publicUser(user) {
  return {
    id: user.id,
    username: user.username,
    displayName: user.displayName || user.username,
    createdAt: user.createdAt
  };
}

function validateNewUser(input = {}) {
  input = input && typeof input === "object" ? input : {};
  const username = normalizeUsername(input.username);
  const password = String(input.password || "");
  if (!/^[a-z0-9_@.-]{3,40}$/.test(username)) {
    return { error: "Username must be 3-40 characters using letters, numbers, _, ., @, or -." };
  }
  if (password.length < 8) {
    return { error: "Password must be at least 8 characters." };
  }
  return { username, password };
}

async function hashPassword(password) {
  const salt = randomBytes(16).toString("hex");
  const key = await scryptAsync(password, salt, 64);
  return {
    algorithm: "scrypt",
    salt,
    key: Buffer.from(key).toString("hex")
  };
}

async function verifyPassword(password, passwordHash) {
  if (!passwordHash || passwordHash.algorithm !== "scrypt" || !passwordHash.salt || !passwordHash.key) {
    return false;
  }
  const actual = await scryptAsync(password, passwordHash.salt, 64);
  const expected = Buffer.from(passwordHash.key, "hex");
  return actual.length === expected.length && timingSafeEqual(actual, expected);
}

function createSessionStore(config) {
  const sessions = new Map();

  function create(user) {
    const token = randomBytes(32).toString("base64url");
    const expiresAt = new Date(Date.now() + config.sessionTtlMs).toISOString();
    sessions.set(token, {
      userId: user.id,
      username: user.username,
      expiresAt
    });
    return { token, expiresAt };
  }

  function consume(token) {
    if (!token) return null;
    const session = sessions.get(token);
    if (!session) return null;
    if (Date.parse(session.expiresAt) <= Date.now()) {
      sessions.delete(token);
      return null;
    }
    return session;
  }

  function destroy(token) {
    if (token) sessions.delete(token);
  }

  return { create, consume, destroy };
}

function createAccountStore(config) {
  let cache = null;

  async function save(accounts) {
    await mkdir(resolve(config.accountsPath, ".."), { recursive: true });
    await writeFile(config.accountsPath, `${JSON.stringify(accounts, null, 2)}\n`, "utf-8");
    cache = accounts;
  }

  async function load() {
    if (cache) return cache;
    try {
      const accounts = JSON.parse(await readFile(config.accountsPath, "utf-8"));
      if (accounts.schemaVersion !== 1 || !Array.isArray(accounts.users)) {
        throw new Error("Invalid account store.");
      }
      cache = accounts;
      return accounts;
    } catch (error) {
      if (error.code !== "ENOENT") throw error;
      const now = new Date().toISOString();
      const seeded = {
        schemaVersion: 1,
        users: [
          {
            id: "owner",
            username: normalizeUsername(config.username),
            displayName: config.username,
            passwordHash: await hashPassword(config.password),
            disabled: false,
            createdAt: now
          }
        ]
      };
      await save(seeded);
      return seeded;
    }
  }

  async function findByUsername(username) {
    const accounts = await load();
    return accounts.users.find((user) => normalizeUsername(user.username) === normalizeUsername(username)) || null;
  }

  async function findById(id) {
    const accounts = await load();
    return accounts.users.find((user) => user.id === id) || null;
  }

  async function authenticate(username, password) {
    const user = await findByUsername(username);
    if (!user || user.disabled) return null;
    if (!await verifyPassword(String(password || ""), user.passwordHash)) return null;
    return user;
  }

  async function createUser(input) {
    const validated = validateNewUser(input);
    if (validated.error) return { error: validated.error };
    const accounts = await load();
    if (accounts.users.some((user) => normalizeUsername(user.username) === validated.username)) {
      return { error: "Username is already taken." };
    }
    const now = new Date().toISOString();
    const user = {
      id: `user_${randomBytes(8).toString("hex")}`,
      username: validated.username,
      displayName: input?.displayName || validated.username,
      passwordHash: await hashPassword(validated.password),
      disabled: false,
      createdAt: now
    };
    accounts.users.push(user);
    await save(accounts);
    return { user };
  }

  async function status() {
    const accounts = await load();
    return {
      accountsConfigured: accounts.users.length > 0,
      registrationOpen: config.registrationEnabled
    };
  }

  return { authenticate, createUser, findById, status };
}

async function authenticateRequest(request, auth) {
  const bearerToken = parseBearerToken(request);
  const cookieToken = parseCookies(request).garden_session;
  const session = auth.sessions.consume(bearerToken || cookieToken);
  if (session) {
    const user = await auth.accounts.findById(session.userId);
    if (user && !user.disabled) return user;
  }
  const basic = parseBasicAuth(request);
  if (basic) return auth.accounts.authenticate(basic.username, basic.password);
  return null;
}

async function requireAuth(request, response, auth) {
  const user = await authenticateRequest(request, auth);
  if (user) return user;
  response.writeHead(401, {
    "www-authenticate": 'Basic realm="Academic Garden"',
    "content-type": "text/plain; charset=utf-8"
  });
  response.end("Academic Garden needs your username and password.");
  return null;
}

async function readBody(request) {
  const chunks = [];
  let length = 0;
  for await (const chunk of request) {
    length += chunk.length;
    if (length > 2_000_000) {
      const error = new Error("Request body is too large.");
      error.statusCode = 413;
      throw error;
    }
    chunks.push(chunk);
  }
  return Buffer.concat(chunks).toString("utf-8");
}

function validateState(state) {
  if (!state || typeof state !== "object" || Array.isArray(state)) return "state must be an object";
  if (state.schemaVersion !== 1) return "schemaVersion must be 1";
  if (!Array.isArray(state.plants)) return "plants must be an array";
  if (!Array.isArray(state.activities)) return "activities must be an array";
  if (!Array.isArray(state.settlements)) return "settlements must be an array";
  if (!state.decorations || !Array.isArray(state.decorations.owned)) {
    return "decorations.owned must be an array";
  }
  if (!state.wallet || typeof state.wallet !== "object") return "wallet must be an object";
  if (typeof state.wallet.currentCoins !== "number") return "wallet.currentCoins must be a number";
  if (typeof state.wallet.lifetimeCoins !== "number") return "wallet.lifetimeCoins must be a number";
  if (!Array.isArray(state.wallet.unlockedVarieties)) {
    return "wallet.unlockedVarieties must be an array";
  }
  return null;
}

async function loadGarden(dataPath) {
  try {
    const payload = JSON.parse(await readFile(dataPath, "utf-8"));
    return {
      state: payload.state || DEFAULT_STATE,
      version: Number(payload.version || 0),
      updatedAt: payload.updatedAt || null
    };
  } catch (error) {
    if (error.code !== "ENOENT") throw error;
    return { state: DEFAULT_STATE, version: 0, updatedAt: null };
  }
}

async function saveGarden(dataPath, garden) {
  await mkdir(resolve(dataPath, ".."), { recursive: true });
  await writeFile(dataPath, `${JSON.stringify(garden, null, 2)}\n`, "utf-8");
}

function isEmptyGarden(state) {
  return (
    state.plants.length === 0 &&
    state.activities.length === 0 &&
    state.settlements.length === 0 &&
    state.wallet.currentCoins === 0 &&
    state.wallet.lifetimeCoins === 0 &&
    state.decorations.owned.length === 0
  );
}

async function healthSnapshot(config, auth) {
  const directory = resolve(config.dataPath, "..");
  const result = {
    ok: true,
    auth: {
      accountsConfigured: false,
      registrationOpen: config.registrationEnabled
    },
    storage: {
      exists: false,
      readable: false,
      writable: false
    },
    garden: {
      version: 0,
      updatedAt: null
    }
  };
  try {
    await mkdir(directory, { recursive: true });
    const probePath = join(directory, `.health-${Date.now()}.tmp`);
    await writeFile(probePath, "ok", "utf-8");
    await unlink(probePath);
    result.storage.writable = true;
  } catch {
    result.ok = false;
  }
  try {
    const fileStat = await stat(config.dataPath);
    result.storage.exists = fileStat.isFile();
  } catch (error) {
    if (error.code !== "ENOENT") result.ok = false;
  }
  try {
    const garden = await loadGarden(config.dataPath);
    result.storage.readable = true;
    result.garden.version = garden.version;
    result.garden.updatedAt = garden.updatedAt;
  } catch {
    result.ok = false;
  }
  try {
    result.auth = await auth.accounts.status();
  } catch {
    result.ok = false;
  }
  return result;
}

async function readJsonBody(request) {
  try {
    return JSON.parse(await readBody(request));
  } catch (error) {
    error.statusCode = error.statusCode || 400;
    error.message = error.message || "Invalid JSON body.";
    throw error;
  }
}

function setSessionCookie(response, token, expiresAt) {
  response.setHeader(
    "set-cookie",
    `garden_session=${encodeURIComponent(token)}; Path=/; HttpOnly; SameSite=Lax; Expires=${new Date(expiresAt).toUTCString()}`
  );
}

function clearSessionCookie(response) {
  response.setHeader("set-cookie", "garden_session=; Path=/; HttpOnly; SameSite=Lax; Max-Age=0");
}

async function handleAuthApi(request, response, config, auth) {
  if (request.url === "/api/auth/register" && request.method === "POST") {
    if (!config.registrationEnabled) {
      sendJson(response, 403, { error: "Registration is currently closed." });
      return;
    }
    let body;
    try {
      body = await readJsonBody(request);
    } catch (error) {
      sendJson(response, error.statusCode, { error: error.message });
      return;
    }
    body = body && typeof body === "object" ? body : {};
    const result = await auth.accounts.createUser(body);
    if (result.error) {
      sendJson(response, 422, { error: result.error });
      return;
    }
    sendJson(response, 201, { user: publicUser(result.user) });
    return;
  }

  if (request.url === "/api/auth/login" && request.method === "POST") {
    let body;
    try {
      body = await readJsonBody(request);
    } catch (error) {
      sendJson(response, error.statusCode, { error: error.message });
      return;
    }
    body = body && typeof body === "object" ? body : {};
    const user = await auth.accounts.authenticate(body.username, body.password);
    if (!user) {
      sendJson(response, 401, { error: "Invalid username or password." });
      return;
    }
    const session = auth.sessions.create(user);
    setSessionCookie(response, session.token, session.expiresAt);
    sendJson(response, 200, {
      token: session.token,
      expiresAt: session.expiresAt,
      user: publicUser(user)
    });
    return;
  }

  if (request.url === "/api/auth/logout" && request.method === "POST") {
    auth.sessions.destroy(parseBearerToken(request) || parseCookies(request).garden_session);
    clearSessionCookie(response);
    sendJson(response, 200, { ok: true });
    return;
  }

  if (request.url === "/api/auth/session" && request.method === "GET") {
    const user = await authenticateRequest(request, auth);
    if (!user) {
      sendJson(response, 401, { authenticated: false });
      return;
    }
    sendJson(response, 200, { authenticated: true, user: publicUser(user) });
    return;
  }

  sendJson(response, 404, { error: "Not found" });
}

async function handleApi(request, response, config, auth) {
  if (request.url.startsWith("/api/auth/")) {
    await handleAuthApi(request, response, config, auth);
    return;
  }
  if (!await requireAuth(request, response, auth)) return;
  if (request.url === "/api/health" && request.method === "GET") {
    const health = await healthSnapshot(config, auth);
    sendJson(response, health.ok ? 200 : 503, health);
    return;
  }
  if (request.url === "/api/garden" && request.method === "GET") {
    const garden = await loadGarden(config.dataPath);
    sendJson(response, 200, { ...garden, isEmpty: isEmptyGarden(garden.state) });
    return;
  }
  if (request.url === "/api/garden" && request.method === "PUT") {
    let body;
    try {
      body = JSON.parse(await readBody(request));
    } catch (error) {
      sendJson(response, error.statusCode || 400, { error: error.message || "Invalid JSON body." });
      return;
    }
    const validationError = validateState(body.state);
    if (validationError) {
      sendJson(response, 422, { error: validationError });
      return;
    }
    const garden = await loadGarden(config.dataPath);
    if (body.version !== garden.version) {
      sendJson(response, 409, {
        error: "The cloud garden changed on another device. Refresh before saving.",
        version: garden.version,
        updatedAt: garden.updatedAt
      });
      return;
    }
    const updated = {
      state: body.state,
      version: garden.version + 1,
      updatedAt: new Date().toISOString()
    };
    await saveGarden(config.dataPath, updated);
    sendJson(response, 200, { ...updated, isEmpty: isEmptyGarden(updated.state) });
    return;
  }
  sendJson(response, 404, { error: "Not found" });
}

function safeStaticPath(urlPath) {
  const cleanPath = decodeURIComponent(new URL(urlPath, "http://localhost").pathname);
  const relativePath = normalize(cleanPath === "/" ? "index.html" : cleanPath.slice(1));
  const filePath = resolve(ROOT, relativePath);
  if (filePath !== ROOT && !filePath.startsWith(`${ROOT}${sep}`)) return null;
  return filePath;
}

async function serveStatic(request, response, config, auth) {
  if (!await requireAuth(request, response, auth)) return;
  const filePath = safeStaticPath(request.url);
  if (!filePath) {
    sendText(response, 403, "Forbidden");
    return;
  }
  try {
    const fileStat = await stat(filePath);
    if (!fileStat.isFile()) {
      sendText(response, 404, "Not found");
      return;
    }
    response.writeHead(200, {
      "content-type": MIME_TYPES.get(extname(filePath)) || "application/octet-stream",
      "cache-control": "no-store"
    });
    if (request.method === "HEAD") {
      response.end();
      return;
    }
    createReadStream(filePath).pipe(response);
  } catch (error) {
    if (error.code === "ENOENT") {
      sendText(response, 404, "Not found");
      return;
    }
    throw error;
  }
}

export async function createGardenServer(config = null) {
  const resolvedConfig = resolveConfig(config || await loadConfig());
  const auth = {
    accounts: createAccountStore(resolvedConfig),
    sessions: createSessionStore(resolvedConfig)
  };
  const server = createServer(async (request, response) => {
    try {
      applyCors(request, response, resolvedConfig);
      if (request.method === "OPTIONS") {
        response.writeHead(204);
        response.end();
        return;
      }
      if (request.url.startsWith("/api/")) {
        await handleApi(request, response, resolvedConfig, auth);
      } else if (request.method === "GET" || request.method === "HEAD") {
        await serveStatic(request, response, resolvedConfig, auth);
      } else {
        sendText(response, 405, "Method not allowed");
      }
    } catch (error) {
      console.error(error);
      sendJson(response, 500, { error: "Internal server error" });
    }
  });
  return { server, config: resolvedConfig };
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const { server, config } = await createGardenServer();
  server.listen(config.port, config.host, () => {
    console.log(`Academic Garden sync server: http://${config.host}:${config.port}`);
    if (config.password === "change-this-password") {
      console.log("Tip: copy .env.example to .env and change ACADEMIC_GARDEN_PASSWORD.");
    }
  });
}
