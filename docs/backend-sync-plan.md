# Academic Garden Personal Sync Backend

## Deprecated Web/Sync Plan

This plan belongs to the old root browser app and GitHub Pages sync path. The
web runtime is deprecated. Keep this file as historical reference only unless
the user explicitly asks for archival web/backend maintenance. Current product
work should target `godot-prototype/`.

This is the small backend plan used for the personal multi-device version.

## Goal

- Keep the existing front-end and garden rules.
- Add a private sync server for one person's devices.
- Store one cloud snapshot of the whole garden state.
- Keep the existing IndexedDB local data as fallback and migration source.

## Correct Architecture

The public app is already hosted on GitHub Pages:

```text
https://zhxh1021.github.io/academic-garden/
```

GitHub Pages can only serve static files. It cannot run the Node backend. The sync version therefore has two parts:

```text
GitHub Pages frontend  ->  separate backend API  ->  private garden data file
```

The backend can still be run locally for testing, but real multi-device use needs the backend to be deployed somewhere that can run Node and keep a persistent data file.

## How It Works

When the app is opened from GitHub Pages:

1. `sync-config.js` tells the page where the backend API lives.
2. The user opens the header sync button and signs in through the cloud sync login panel.
3. The frontend calls `POST BACKEND_URL/api/auth/login` and stores the returned bearer token on the current browser device.
4. The app loads `GET BACKEND_URL/api/garden`.
5. Every local change still updates IndexedDB first.
6. If the backend is available, the app also saves to `PUT BACKEND_URL/api/garden`.
7. The backend writes the snapshot to `server/data/garden.json`.

The next-version backend also exposes account endpoints for future UI work:

- `POST /api/auth/login`
- `GET /api/auth/session`
- `POST /api/auth/logout`
- `POST /api/auth/register`

Registration exists as an API route but is closed by default. Keep `ACADEMIC_GARDEN_REGISTRATION_ENABLED=false` unless public registration has been designed and reviewed.

When the app is opened without the sync server, it keeps using the old local-only IndexedDB mode.

## Local Backend Test

1. Copy `.env.example` to `.env`.
2. Change `ACADEMIC_GARDEN_PASSWORD` in `.env`.
3. Run:

```powershell
npm run start:sync
```

Or double-click:

```text
启动同步版学术花园.cmd
```

Then open:

```text
http://127.0.0.1:8787
```

The default username from `.env.example` is:

```text
garden
```

This local mode is useful for testing, but it only syncs devices that can reach this computer while the command window stays open.

## GitHub Pages Sync Setup

After deploying the backend, edit `sync-config.js`:

```js
window.ACADEMIC_GARDEN_SYNC = {
  apiBaseUrl: "https://YOUR-BACKEND-DOMAIN"
};
```

Commit and push that file with the frontend. The API address is not a password, so it is safe to publish. Do not put the password in this file.

If you want to test a backend URL without editing the file, open the page with:

```text
https://zhxh1021.github.io/academic-garden/?gardenApi=https://YOUR-BACKEND-DOMAIN
```

The app will remember that API address in the current browser.

## Backend Deployment Notes

Use a host that supports:

- Node.js
- HTTPS
- persistent storage for `server/data/garden.json`
- environment variables

Set these environment variables on the host:

```env
ACADEMIC_GARDEN_HOST=0.0.0.0
ACADEMIC_GARDEN_PORT=8787
ACADEMIC_GARDEN_USERNAME=garden
ACADEMIC_GARDEN_PASSWORD=your-private-password
ACADEMIC_GARDEN_DATA_PATH=server/data/garden.json
ACADEMIC_GARDEN_ACCOUNTS_PATH=server/data/accounts.json
ACADEMIC_GARDEN_REGISTRATION_ENABLED=false
ACADEMIC_GARDEN_SESSION_TTL_HOURS=24
ACADEMIC_GARDEN_ALLOWED_ORIGIN=https://zhxh1021.github.io
```

The allowed origin is important because GitHub Pages and the backend are on different domains.

## Same Wi-Fi Use

For another device on the same Wi-Fi:

1. Set this in `.env`:

```env
ACADEMIC_GARDEN_HOST=0.0.0.0
```

2. Restart the sync server.
3. Find the computer's local network IP address.
4. Open this from the other device:

```text
http://YOUR-COMPUTER-IP:8787
```

Use the same username and password in the sync login panel.

This is not the same as GitHub Pages sync. Same-Wi-Fi mode uses your computer as the backend server.

## Safety Notes

- `.env` is ignored by Git because it contains the private password.
- `server/data/` is ignored by Git because it contains the personal garden data and account password hashes.
- `sync-config.js` may be committed because it only contains the public backend URL.
- Export JSON backups from the app before big changes or before trying sync on a new device.
- If two devices edit at the same time, the app detects stale saves and asks you to refresh before overwriting cloud data.
