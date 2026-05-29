import { createHash, timingSafeEqual } from "node:crypto";
import { createReadStream } from "node:fs";
import { mkdir, readFile, stat, writeFile } from "node:fs/promises";
import { createServer } from "node:http";
import { extname, join, normalize, resolve, sep } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = resolve(fileURLToPath(new URL("..", import.meta.url)));
const ENV_PATH = join(ROOT, ".env");
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
  return {
    host: config.ACADEMIC_GARDEN_HOST || "127.0.0.1",
    port: Number(config.ACADEMIC_GARDEN_PORT || 8787),
    username: config.ACADEMIC_GARDEN_USERNAME || "garden",
    password: config.ACADEMIC_GARDEN_PASSWORD || "change-this-password",
    dataPath: resolve(ROOT, config.ACADEMIC_GARDEN_DATA_PATH || "server/data/garden.json"),
    allowedOrigin: config.ACADEMIC_GARDEN_ALLOWED_ORIGIN || ""
  };
}

function applyCors(request, response, config) {
  const origin = request.headers.origin;
  if (!origin || !config.allowedOrigin) return;
  const allowedOrigins = config.allowedOrigin.split(",").map((item) => item.trim()).filter(Boolean);
  if (!allowedOrigins.includes("*") && !allowedOrigins.includes(origin)) return;
  response.setHeader("access-control-allow-origin", allowedOrigins.includes("*") ? origin : origin);
  response.setHeader("vary", "Origin");
  response.setHeader("access-control-allow-methods", "GET, PUT, OPTIONS");
  response.setHeader("access-control-allow-headers", "authorization, content-type, accept");
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

function hashSecret(secret) {
  return createHash("sha256").update(secret).digest();
}

function isAuthorized(request, config) {
  const header = request.headers.authorization || "";
  if (!header.startsWith("Basic ")) return false;
  let username = "";
  let password = "";
  try {
    [username, password] = Buffer.from(header.slice(6), "base64").toString("utf-8").split(":");
  } catch {
    return false;
  }
  const expectedUser = hashSecret(config.username);
  const expectedPassword = hashSecret(config.password);
  const actualUser = hashSecret(username || "");
  const actualPassword = hashSecret(password || "");
  return timingSafeEqual(expectedUser, actualUser) && timingSafeEqual(expectedPassword, actualPassword);
}

function requireAuth(request, response, config) {
  if (isAuthorized(request, config)) return true;
  response.writeHead(401, {
    "www-authenticate": 'Basic realm="Academic Garden"',
    "content-type": "text/plain; charset=utf-8"
  });
  response.end("Academic Garden needs your username and password.");
  return false;
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

async function handleApi(request, response, config) {
  if (!requireAuth(request, response, config)) return;
  if (request.url === "/api/health" && request.method === "GET") {
    sendJson(response, 200, { ok: true });
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

async function serveStatic(request, response, config) {
  if (!requireAuth(request, response, config)) return;
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
  const resolvedConfig = config || await loadConfig();
  const server = createServer(async (request, response) => {
    try {
      applyCors(request, response, resolvedConfig);
      if (request.method === "OPTIONS") {
        response.writeHead(204);
        response.end();
        return;
      }
      if (request.url.startsWith("/api/")) {
        await handleApi(request, response, resolvedConfig);
      } else if (request.method === "GET" || request.method === "HEAD") {
        await serveStatic(request, response, resolvedConfig);
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
