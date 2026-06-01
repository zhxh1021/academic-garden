function base64Encode(value) {
  if (typeof btoa === "function") return btoa(value);
  return Buffer.from(value).toString("base64");
}

function apiUrl(baseUrl, path) {
  return `${baseUrl.trim().replace(/\/$/, "")}${path}`;
}

export function authHeadersFor(auth = {}) {
  if (auth.token) return { authorization: `Bearer ${auth.token}` };
  if (auth.username && auth.password) {
    return { authorization: `Basic ${base64Encode(`${auth.username}:${auth.password}`)}` };
  }
  return {};
}

export async function loginToCloud(baseUrl, credentials, fetchImpl = fetch) {
  const response = await fetchImpl(apiUrl(baseUrl, "/api/auth/login"), {
    method: "POST",
    headers: {
      accept: "application/json",
      "content-type": "application/json"
    },
    credentials: "include",
    body: JSON.stringify({
      username: credentials.username,
      password: credentials.password
    })
  });
  const payload = await response.json().catch(() => ({}));
  if (!response.ok) {
    throw new Error(payload.error || `Cloud login failed: ${response.status}`);
  }
  return payload;
}

export async function logoutFromCloud(baseUrl, auth, fetchImpl = fetch) {
  const headers = authHeadersFor(auth);
  if (!Object.keys(headers).length) return;
  await fetchImpl(apiUrl(baseUrl, "/api/auth/logout"), {
    method: "POST",
    headers,
    credentials: "include"
  }).catch(() => {});
}

export function syncStatusViewModel(sync = {}) {
  if (!sync.configured) {
    return {
      label: "同步：本地",
      title: "当前使用浏览器本地数据"
    };
  }
  if (sync.connected) {
    return {
      label: `同步：已连接 v${sync.version}`,
      title: sync.updatedAt ? `云端已连接，最近更新：${sync.updatedAt}` : "云端已连接"
    };
  }
  if (sync.hasSavedLogin) {
    return {
      label: "同步：待连接",
      title: "打开云端同步登录"
    };
  }
  return {
    label: "同步：未登录",
    title: "打开云端同步登录"
  };
}
