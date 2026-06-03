# Deprecated Web Runtime

The root browser app is deprecated.

Deprecated web runtime files include:

- `index.html`
- `styles.css`
- `src/app.js`
- `src/domain.js`
- `src/store.js`
- `src/sync-auth.js`
- `sync-config.js`
- GitHub Pages/browser-only workflows
- web sync notes that only apply to the old browser runtime
- `scripts/open_local.py`
- `scripts/close_local.py`
- `scripts/serve_local.py`
- `server/server.mjs`
- `scripts/backup_garden.mjs`
- `打开学术花园.cmd`
- `关闭学术花园.cmd`
- `启动同步版学术花园.cmd`

Current active development is the Godot mobile portrait prototype:

- `godot-prototype/project.godot`
- `godot-prototype/scenes/main.tscn`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- Godot runtime saves in `user://garden_state.json`

Rules for future work:

- For map, plant sizing, layout, UI, touch interaction, animation, save-flow, and art integration tasks, modify `godot-prototype/` first.
- Do not patch the deprecated web runtime unless the user explicitly asks for archival web maintenance.
- Keep the web files available as historical reference until the user asks to remove or archive them more aggressively.
- Godot prototype changes do not need OpenClaw deployment.
