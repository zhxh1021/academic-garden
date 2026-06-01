import assert from "node:assert/strict";
import test from "node:test";

import {
  authHeadersFor,
  loginToCloud,
  syncStatusViewModel
} from "../src/sync-auth.js";

test("uses bearer token before legacy basic credentials", () => {
  assert.deepEqual(
    authHeadersFor({ token: "session-token", username: "garden", password: "secret" }),
    { authorization: "Bearer session-token" }
  );
});

test("falls back to basic credentials when no session token exists", () => {
  assert.deepEqual(
    authHeadersFor({ username: "garden", password: "secret" }),
    { authorization: `Basic ${Buffer.from("garden:secret").toString("base64")}` }
  );
});

test("logs in through the account API", async () => {
  const calls = [];
  const payload = await loginToCloud("https://api.example.test/", {
    username: "garden",
    password: "secret"
  }, async (url, options) => {
    calls.push({ url, options });
    return new Response(JSON.stringify({
      token: "session-token",
      expiresAt: "2026-06-02T00:00:00.000Z",
      user: { username: "garden" }
    }), { status: 200 });
  });

  assert.equal(calls[0].url, "https://api.example.test/api/auth/login");
  assert.equal(calls[0].options.method, "POST");
  assert.equal(calls[0].options.headers["content-type"], "application/json");
  assert.equal(JSON.parse(calls[0].options.body).username, "garden");
  assert.equal(payload.token, "session-token");
  assert.equal(payload.user.username, "garden");
});

test("reports failed account API logins", async () => {
  await assert.rejects(
    () => loginToCloud("https://api.example.test", {
      username: "garden",
      password: "wrong"
    }, async () => new Response(JSON.stringify({ error: "Invalid username or password." }), { status: 401 })),
    /Invalid username or password/
  );
});

test("describes sync button state for the login panel", () => {
  assert.deepEqual(syncStatusViewModel({ configured: false }), {
    label: "同步：本地",
    title: "当前使用浏览器本地数据"
  });
  assert.deepEqual(syncStatusViewModel({ configured: true, connected: false, hasSavedLogin: false }), {
    label: "同步：未登录",
    title: "打开云端同步登录"
  });
  assert.equal(
    syncStatusViewModel({ configured: true, connected: true, version: 3, updatedAt: null }).label,
    "同步：已连接 v3"
  );
});
