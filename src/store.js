import { DEFAULT_UNLOCKED_VARIETIES } from "./domain.js";
import { authHeadersFor, loginToCloud, logoutFromCloud } from "./sync-auth.js";

const DATABASE_NAME = "academic-garden";
const DATABASE_VERSION = 1;
const STORE_NAME = "garden";
const SNAPSHOT_KEY = "snapshot";
const API_URL_STORAGE_KEY = "academicGardenApiBaseUrl";
const API_USERNAME_STORAGE_KEY = "academicGardenApiUsername";
const API_PASSWORD_STORAGE_KEY = "academicGardenApiPassword";
const API_TOKEN_STORAGE_KEY = "academicGardenApiToken";
const API_TOKEN_EXPIRES_STORAGE_KEY = "academicGardenApiTokenExpiresAt";
const API_USER_STORAGE_KEY = "academicGardenApiUser";

let cloudEnabled = false;
let cloudVersion = null;
let cloudUpdatedAt = null;

export function emptyState() {
  return {
    schemaVersion: 1,
    plants: [],
    activities: [],
    harvestYields: [],
    settlements: [],
    decorations: {
      owned: []
    },
    wallet: {
      currentCoins: 0,
      lifetimeCoins: 0,
      unlockedVarieties: [...DEFAULT_UNLOCKED_VARIETIES]
    }
  };
}

function openDatabase() {
  return new Promise((resolve, reject) => {
    const request = indexedDB.open(DATABASE_NAME, DATABASE_VERSION);
    request.onupgradeneeded = () => {
      if (!request.result.objectStoreNames.contains(STORE_NAME)) {
        request.result.createObjectStore(STORE_NAME);
      }
    };
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

function transactionResult(transaction) {
  return new Promise((resolve, reject) => {
    transaction.oncomplete = () => resolve();
    transaction.onerror = () => reject(transaction.error);
    transaction.onabort = () => reject(transaction.error);
  });
}

async function loadLocalState() {
  const database = await openDatabase();
  const transaction = database.transaction(STORE_NAME, "readonly");
  const request = transaction.objectStore(STORE_NAME).get(SNAPSHOT_KEY);
  const snapshot = await new Promise((resolve, reject) => {
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
  database.close();
  return snapshot ?? emptyState();
}

async function saveLocalState(state) {
  const database = await openDatabase();
  const transaction = database.transaction(STORE_NAME, "readwrite");
  transaction.objectStore(STORE_NAME).put(state, SNAPSHOT_KEY);
  await transactionResult(transaction);
  database.close();
}

function hasUserData(state) {
  return (
    state.plants.length > 0 ||
    state.activities.length > 0 ||
    state.settlements.length > 0 ||
    state.decorations.owned.length > 0 ||
    state.wallet.currentCoins > 0 ||
    state.wallet.lifetimeCoins > 0
  );
}

function configuredApiBaseUrl() {
  const params = new URLSearchParams(window.location.search);
  const queryApiUrl = params.get("gardenApi");
  if (queryApiUrl) {
    localStorage.setItem(API_URL_STORAGE_KEY, queryApiUrl);
    return queryApiUrl;
  }
  return (
    window.ACADEMIC_GARDEN_SYNC?.apiBaseUrl ||
    localStorage.getItem(API_URL_STORAGE_KEY) ||
    ""
  );
}

function cloudEndpoint() {
  const apiBaseUrl = configuredApiBaseUrl().trim().replace(/\/$/, "");
  return apiBaseUrl ? `${apiBaseUrl}/api/garden` : "./api/garden";
}

function isConfiguredCloudEndpoint() {
  return configuredApiBaseUrl().trim() !== "";
}

export function getSyncStatus() {
  const user = JSON.parse(localStorage.getItem(API_USER_STORAGE_KEY) || "null");
  return {
    configured: isConfiguredCloudEndpoint(),
    connected: cloudEnabled,
    hasSavedLogin: Boolean(
      localStorage.getItem(API_TOKEN_STORAGE_KEY) ||
      localStorage.getItem(API_USERNAME_STORAGE_KEY) &&
      localStorage.getItem(API_PASSWORD_STORAGE_KEY)
    ),
    apiBaseUrl: configuredApiBaseUrl().trim(),
    username: localStorage.getItem(API_USERNAME_STORAGE_KEY) || user?.username || "",
    user,
    version: cloudVersion,
    updatedAt: cloudUpdatedAt
  };
}

export function clearSyncLogin() {
  localStorage.removeItem(API_USERNAME_STORAGE_KEY);
  localStorage.removeItem(API_PASSWORD_STORAGE_KEY);
  localStorage.removeItem(API_TOKEN_STORAGE_KEY);
  localStorage.removeItem(API_TOKEN_EXPIRES_STORAGE_KEY);
  localStorage.removeItem(API_USER_STORAGE_KEY);
  cloudEnabled = false;
  cloudVersion = null;
  cloudUpdatedAt = null;
}

function cloudAuthHeaders() {
  if (!isConfiguredCloudEndpoint()) return {};
  return authHeadersFor({
    token: localStorage.getItem(API_TOKEN_STORAGE_KEY) || "",
    username: localStorage.getItem(API_USERNAME_STORAGE_KEY) || "",
    password: localStorage.getItem(API_PASSWORD_STORAGE_KEY) || ""
  });
}

export async function loginSync(username, password) {
  const apiBaseUrl = configuredApiBaseUrl().trim();
  if (!apiBaseUrl) throw new Error("Cloud sync is not configured.");
  const session = await loginToCloud(apiBaseUrl, { username, password });
  localStorage.setItem(API_USERNAME_STORAGE_KEY, session.user?.username || username);
  localStorage.setItem(API_TOKEN_STORAGE_KEY, session.token);
  localStorage.setItem(API_TOKEN_EXPIRES_STORAGE_KEY, session.expiresAt || "");
  localStorage.setItem(API_USER_STORAGE_KEY, JSON.stringify(session.user || { username }));
  localStorage.removeItem(API_PASSWORD_STORAGE_KEY);
  cloudEnabled = false;
  return session;
}

export async function logoutSync() {
  const apiBaseUrl = configuredApiBaseUrl().trim();
  if (apiBaseUrl) {
    await logoutFromCloud(apiBaseUrl, {
      token: localStorage.getItem(API_TOKEN_STORAGE_KEY) || "",
      username: localStorage.getItem(API_USERNAME_STORAGE_KEY) || "",
      password: localStorage.getItem(API_PASSWORD_STORAGE_KEY) || ""
    });
  }
  clearSyncLogin();
}

async function loadCloudGarden() {
  const authHeaders = cloudAuthHeaders();
  if (isConfiguredCloudEndpoint() && !Object.keys(authHeaders).length) {
    throw new Error("Cloud login is required.");
  }
  const response = await fetch(cloudEndpoint(), {
    method: "GET",
    headers: { accept: "application/json", ...authHeaders },
    credentials: "include",
    cache: "no-store"
  });
  if (response.status === 401) {
    localStorage.removeItem(API_TOKEN_STORAGE_KEY);
    localStorage.removeItem(API_PASSWORD_STORAGE_KEY);
    throw new Error("Cloud login failed.");
  }
  if (!response.ok) {
    throw new Error(`Cloud garden is unavailable: ${response.status}`);
  }
  return response.json();
}

async function saveCloudGarden(state) {
  const authHeaders = cloudAuthHeaders();
  if (!Object.keys(authHeaders).length) return false;
  const response = await fetch(cloudEndpoint(), {
    method: "PUT",
    headers: {
      accept: "application/json",
      "content-type": "application/json",
      ...authHeaders
    },
    credentials: "include",
    body: JSON.stringify({ state, version: cloudVersion })
  });
  const payload = await response.json().catch(() => ({}));
  if (response.status === 401) {
    localStorage.removeItem(API_TOKEN_STORAGE_KEY);
    localStorage.removeItem(API_PASSWORD_STORAGE_KEY);
    window.alert("云端同步登录失败。请刷新页面后重新输入密码。");
    return false;
  }
  if (response.status === 409) {
    window.alert("云端花园已经在另一台设备更新过。请先导出当前备份，然后刷新页面重新加载云端数据。");
    return false;
  }
  if (!response.ok) {
    window.alert(`云端保存失败：${payload.error ?? response.status}`);
    return false;
  }
  cloudVersion = payload.version;
  cloudUpdatedAt = payload.updatedAt;
  return true;
}

export async function loadState() {
  const localState = await loadLocalState();
  try {
    const cloudGarden = await loadCloudGarden();
    cloudEnabled = true;
    cloudVersion = cloudGarden.version;
    cloudUpdatedAt = cloudGarden.updatedAt;
    if (cloudGarden.isEmpty && hasUserData(localState)) {
      const shouldUpload = window.confirm("检测到这台电脑里已有本地花园。要把它上传到云端，作为多端同步的初始数据吗？");
      if (shouldUpload) {
        await saveCloudGarden(localState);
        return localState;
      }
    }
    await saveLocalState(cloudGarden.state);
    return cloudGarden.state;
  } catch {
    cloudEnabled = false;
    cloudVersion = null;
    cloudUpdatedAt = null;
    return localState;
  }
}

export async function saveState(state) {
  await saveLocalState(state);
  if (!cloudEnabled) return;
  await saveCloudGarden(state);
}

export function downloadBackup(state) {
  const payload = {
    exportedAt: new Date().toISOString(),
    application: "Academic Garden",
    ...state
  };
  const blob = new Blob([JSON.stringify(payload, null, 2)], { type: "application/json" });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = `academic-garden-backup-${new Date().toISOString().slice(0, 10)}.json`;
  link.click();
  URL.revokeObjectURL(link.href);
}
