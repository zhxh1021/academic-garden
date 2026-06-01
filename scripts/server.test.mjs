import assert from "node:assert/strict";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";

import { createGardenServer } from "../server/server.mjs";

function authHeader(username = "garden", password = "secret") {
  return `Basic ${Buffer.from(`${username}:${password}`).toString("base64")}`;
}

async function withServer(testBody) {
  const directory = await mkdtemp(join(tmpdir(), "academic-garden-"));
  const { server } = await createGardenServer({
    host: "127.0.0.1",
    port: 0,
    username: "garden",
    password: "secret",
    dataPath: join(directory, "garden.json"),
    allowedOrigin: "https://zhxh1021.github.io"
  });
  await new Promise((resolve) => server.listen(0, "127.0.0.1", resolve));
  const { port } = server.address();
  try {
    await testBody(`http://127.0.0.1:${port}`);
  } finally {
    await new Promise((resolve) => server.close(resolve));
    await rm(directory, { recursive: true, force: true });
  }
}

async function login(baseUrl, username = "garden", password = "secret") {
  const response = await fetch(`${baseUrl}/api/auth/login`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ username, password })
  });
  return { response, payload: await response.json() };
}

test("rejects unauthenticated API requests", async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/api/garden`);
    assert.equal(response.status, 401);
  });
});

test("logs in with an account password and uses the bearer token", async () => {
  await withServer(async (baseUrl) => {
    const { response, payload } = await login(baseUrl);
    assert.equal(response.status, 200);
    assert.equal(payload.user.username, "garden");
    assert.equal(typeof payload.token, "string");

    const garden = await fetch(`${baseUrl}/api/garden`, {
      headers: { authorization: `Bearer ${payload.token}` }
    });
    assert.equal(garden.status, 200);
  });
});

test("rejects wrong account passwords", async () => {
  await withServer(async (baseUrl) => {
    const { response, payload } = await login(baseUrl, "garden", "not-the-password");
    assert.equal(response.status, 401);
    assert.equal(payload.error, "Invalid username or password.");
  });
});

test("reports and clears bearer-token sessions", async () => {
  await withServer(async (baseUrl) => {
    const { payload } = await login(baseUrl);

    const session = await fetch(`${baseUrl}/api/auth/session`, {
      headers: { authorization: `Bearer ${payload.token}` }
    });
    assert.equal(session.status, 200);
    assert.equal((await session.json()).authenticated, true);

    const logout = await fetch(`${baseUrl}/api/auth/logout`, {
      method: "POST",
      headers: { authorization: `Bearer ${payload.token}` }
    });
    assert.equal(logout.status, 200);

    const expired = await fetch(`${baseUrl}/api/auth/session`, {
      headers: { authorization: `Bearer ${payload.token}` }
    });
    assert.equal(expired.status, 401);
  });
});

test("keeps public registration closed by default", async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/api/auth/register`, {
      method: "POST",
      headers: { "content-type": "application/json" },
      body: JSON.stringify({ username: "new-gardener", password: "long-enough-password" })
    });
    assert.equal(response.status, 403);
    assert.equal((await response.json()).error, "Registration is currently closed.");
  });
});

test("saves and reloads the cloud garden snapshot", async () => {
  await withServer(async (baseUrl) => {
    const firstLoad = await fetch(`${baseUrl}/api/garden`, {
      headers: { authorization: authHeader() }
    });
    const firstPayload = await firstLoad.json();

    const state = {
      ...firstPayload.state,
      plants: [{ id: "plant-1", title: "A paper tree" }],
      wallet: {
        currentCoins: 3,
        lifetimeCoins: 3,
        unlockedVarieties: []
      }
    };

    const save = await fetch(`${baseUrl}/api/garden`, {
      method: "PUT",
      headers: {
        authorization: authHeader(),
        "content-type": "application/json"
      },
      body: JSON.stringify({ state, version: firstPayload.version })
    });
    assert.equal(save.status, 200);
    const savedPayload = await save.json();
    assert.equal(savedPayload.version, 1);

    const secondLoad = await fetch(`${baseUrl}/api/garden`, {
      headers: { authorization: authHeader() }
    });
    const secondPayload = await secondLoad.json();
    assert.deepEqual(secondPayload.state.plants, state.plants);
    assert.equal(secondPayload.version, 1);
  });
});

test("reports storage health without leaking garden contents", async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/api/health`, {
      headers: { authorization: authHeader() }
    });
    assert.equal(response.status, 200);
    const payload = await response.json();
    assert.equal(payload.ok, true);
    assert.equal(payload.storage.writable, true);
    assert.equal(payload.storage.readable, true);
    assert.equal(payload.auth.accountsConfigured, true);
    assert.equal(payload.auth.registrationOpen, false);
    assert.equal(payload.garden.version, 0);
    assert.equal("state" in payload, false);
  });
});

test("rejects stale cloud garden saves", async () => {
  await withServer(async (baseUrl) => {
    const load = await fetch(`${baseUrl}/api/garden`, {
      headers: { authorization: authHeader() }
    });
    const payload = await load.json();

    const state = {
      ...payload.state,
      plants: [{ id: "plant-1" }]
    };

    const firstSave = await fetch(`${baseUrl}/api/garden`, {
      method: "PUT",
      headers: {
        authorization: authHeader(),
        "content-type": "application/json"
      },
      body: JSON.stringify({ state, version: payload.version })
    });
    assert.equal(firstSave.status, 200);

    const staleSave = await fetch(`${baseUrl}/api/garden`, {
      method: "PUT",
      headers: {
        authorization: authHeader(),
        "content-type": "application/json"
      },
      body: JSON.stringify({ state, version: payload.version })
    });
    assert.equal(staleSave.status, 409);
  });
});

test("allows GitHub Pages preflight requests", async () => {
  await withServer(async (baseUrl) => {
    const response = await fetch(`${baseUrl}/api/garden`, {
      method: "OPTIONS",
      headers: {
        origin: "https://zhxh1021.github.io",
        "access-control-request-method": "PUT",
        "access-control-request-headers": "authorization, content-type"
      }
    });
    assert.equal(response.status, 204);
    assert.equal(response.headers.get("access-control-allow-origin"), "https://zhxh1021.github.io");
    assert.match(response.headers.get("access-control-allow-headers"), /authorization/);
  });
});
