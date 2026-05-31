import { mkdir, readdir, stat, copyFile, unlink } from "node:fs/promises";
import { basename, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = resolve(fileURLToPath(new URL("..", import.meta.url)));
const ENV_PATH = join(ROOT, ".env");
const DEFAULT_DATA_PATH = "server/data/garden.json";
const DEFAULT_BACKUP_DIR = "backups";
const DEFAULT_KEEP = 30;

async function readEnv() {
  try {
    const { readFile } = await import("node:fs/promises");
    const text = await readFile(ENV_PATH, "utf-8");
    return Object.fromEntries(
      text
        .split(/\r?\n/)
        .map((line) => line.trim())
        .filter((line) => line && !line.startsWith("#") && line.includes("="))
        .map((line) => {
          const index = line.indexOf("=");
          return [line.slice(0, index).trim(), line.slice(index + 1).trim().replace(/^["']|["']$/g, "")];
        })
    );
  } catch (error) {
    if (error.code === "ENOENT") return {};
    throw error;
  }
}

function timestamp() {
  return new Date().toISOString().replace(/[-:]/g, "").replace(/\.\d{3}Z$/, "Z");
}

async function pruneBackups(backupDir, keep) {
  const entries = await readdir(backupDir);
  const backups = [];
  for (const entry of entries) {
    if (!entry.startsWith("garden-") || !entry.endsWith(".json")) continue;
    const path = join(backupDir, entry);
    const fileStat = await stat(path);
    backups.push({ path, mtimeMs: fileStat.mtimeMs });
  }
  backups.sort((left, right) => right.mtimeMs - left.mtimeMs);
  await Promise.all(backups.slice(keep).map((item) => unlink(item.path)));
}

const env = { ...await readEnv(), ...process.env };
const dataPath = resolve(ROOT, env.ACADEMIC_GARDEN_DATA_PATH || DEFAULT_DATA_PATH);
const backupDir = resolve(ROOT, env.ACADEMIC_GARDEN_BACKUP_DIR || DEFAULT_BACKUP_DIR);
const keep = Number(env.ACADEMIC_GARDEN_BACKUP_KEEP || DEFAULT_KEEP);
const dataStat = await stat(dataPath);

if (!dataStat.isFile()) {
  throw new Error(`Garden data file does not exist: ${dataPath}`);
}

await mkdir(backupDir, { recursive: true });
const backupPath = join(backupDir, `garden-${timestamp()}-${basename(dataPath)}`);
await copyFile(dataPath, backupPath);
await pruneBackups(backupDir, keep);
console.log(`Backed up garden data to ${backupPath}`);
