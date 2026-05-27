const DATABASE_NAME = "academic-garden";
const DATABASE_VERSION = 1;
const STORE_NAME = "garden";
const SNAPSHOT_KEY = "snapshot";

export function emptyState() {
  return {
    schemaVersion: 1,
    plants: [],
    activities: [],
    harvestYields: [],
    wallet: {
      currentCoins: 0,
      lifetimeCoins: 0,
      unlockedVarieties: ["ginkgo", "daisy", "camphor", "hydrangea"]
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

export async function loadState() {
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

export async function saveState(state) {
  const database = await openDatabase();
  const transaction = database.transaction(STORE_NAME, "readwrite");
  transaction.objectStore(STORE_NAME).put(state, SNAPSHOT_KEY);
  await transactionResult(transaction);
  database.close();
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

