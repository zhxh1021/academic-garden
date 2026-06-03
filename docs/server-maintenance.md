# Academic Garden Server Maintenance

## Deprecated Web/Backend Path

This document describes the old GitHub Pages plus Tencent Cloud browser-sync
architecture. That web runtime is deprecated. Keep this document as operational
history only unless the user explicitly asks for archival web/backend
maintenance. Current product work should target `godot-prototype/`.

This note is for the Tencent Cloud backend at `https://api.acagarden.site`.

## Services

- Frontend: GitHub Pages at `https://zhxh1021.github.io/academic-garden/`
- Backend API: Caddy HTTPS proxy at `https://api.acagarden.site`
- Node service: `academic-garden.service`
- Local backend target: `127.0.0.1:8787`
- Garden data: `/opt/academic-garden/server/data/garden.json`
- Account data: `/opt/academic-garden/server/data/accounts.json`
- Backups: `/opt/academic-garden/backups/`

## Routine Checks

```bash
systemctl status academic-garden --no-pager
systemctl status caddy --no-pager
journalctl -u academic-garden -n 80 --no-pager
ss -tulpn | grep -E '8787|80|443|18789|18791|22'
curl -u garden:*** https://api.acagarden.site/api/health
curl -X POST https://api.acagarden.site/api/auth/login \
  -H 'content-type: application/json' \
  -d '{"username":"garden","password":"***"}'
```

Do not print the real password in chat logs. Replace it with `***` when sharing output.

## Manual Backup

Run from `/opt/academic-garden`:

```bash
npm run backup:garden
ls -lh backups | tail
```

The backup script copies `server/data/garden.json` into `backups/` and keeps the newest 30 backup files by default.

## Daily Backup Timer

Create a systemd service:

```bash
cat > /etc/systemd/system/academic-garden-backup.service <<'EOF'
[Unit]
Description=Back up Academic Garden data

[Service]
Type=oneshot
WorkingDirectory=/opt/academic-garden
ExecStart=/usr/bin/node /opt/academic-garden/scripts/backup_garden.mjs
EOF
```

Create a systemd timer:

```bash
cat > /etc/systemd/system/academic-garden-backup.timer <<'EOF'
[Unit]
Description=Daily Academic Garden backup

[Timer]
OnCalendar=*-*-* 03:20:00
Persistent=true

[Install]
WantedBy=timers.target
EOF
```

Enable it:

```bash
systemctl daemon-reload
systemctl enable --now academic-garden-backup.timer
systemctl list-timers academic-garden-backup.timer --no-pager
```

## Restore From Backup

Stop the backend first:

```bash
systemctl stop academic-garden
cp backups/GARDEN_BACKUP_FILE.json server/data/garden.json
systemctl start academic-garden
curl -u garden:*** https://api.acagarden.site/api/health
```

Export a browser JSON backup before restoring if there is any chance the current cloud data contains newer work.

## Deploy Backend Updates

Use this only after the local changes have been pushed to GitHub or uploaded to the server.

Codex is responsible for telling the user whether a change needs this step. As a working rule:

- GitHub Pages-only changes do not need OpenClaw deployment.
- Backend/API/service/backup-script changes do need OpenClaw deployment.
- Ambiguous sync changes should be treated as needing an explicit Codex yes/no note.
- When deployment is needed, Codex should include a copy-ready OpenClaw instruction block for the user.

```bash
cd /opt/academic-garden
git pull
npm test
systemctl restart academic-garden
systemctl status academic-garden --no-pager
curl -u garden:*** https://api.acagarden.site/api/health
```

If GitHub access from the server is unreliable, upload only the changed backend files and then restart `academic-garden`.

## Safe OpenClaw Boundaries

OpenClaw can help with:

- status checks
- logs
- `npm test`
- `npm run backup:garden`
- restarting `academic-garden` after explicit approval

OpenClaw should not:

- modify `.env` secrets
- touch OpenClaw services or ports
- run `dnf update -y`
- delete data or backup directories without explicit confirmation
