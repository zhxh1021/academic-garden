# Project Working Requirements

## Active Platform

- The root web runtime is deprecated. Treat `index.html`, `styles.css`, `src/*.js`, `sync-config.js`, GitHub Pages workflows, and browser-only UI behavior as historical reference unless the user explicitly asks for archival web maintenance.
- Current product work should target the Godot mobile portrait prototype under `godot-prototype/`.
- For visual, layout, plant sizing, map, interaction, save-flow, and art integration issues, inspect and modify the Godot project first.
- Do not spend implementation effort on the deprecated web runtime simply because matching files still exist in the repository.

## Concurrent Work

- When multiple Codex threads or collaborators are working in parallel, avoid pushing partial changes directly.
- For each completed local fix or feature slice, add a short entry to `docs/pending-changes.md` describing:
  - what changed,
  - which files were intentionally touched,
  - what verification was run,
  - whether any unrelated existing work was left untouched.
- Keep the actual code changes unpushed until the other in-progress parts are ready to be reviewed and pushed together.
- Do not overwrite or revert unrelated local changes unless the user explicitly asks for it.
- Before the final combined push, review `docs/pending-changes.md` and the full `git status`/diff so all concurrent work is accounted for.

## Frontend vs Backend Deployment

- Codex should explicitly tell the user whether a completed change needs OpenClaw to deploy server-side updates.
- Deprecated web/GitHub Pages-only changes usually do not need OpenClaw deployment, but they are no longer the active product path. Examples: `index.html`, `styles.css`, most `src/app.js` UI work, `src/domain.js` client rules, `assets/`, and `sync-config.js`.
- Godot prototype changes under `godot-prototype/` usually do not need OpenClaw deployment.
- Backend/server changes do need OpenClaw deployment after the local commit is pushed. Examples: `server/server.mjs`, `scripts/backup_garden.mjs`, `scripts/server.test.mjs`, `package.json` scripts used by the server, backend maintenance docs that change server procedures, or any change that modifies API behavior expected from `https://api.acagarden.site`.
- If a change crosses the boundary or the user may not be able to tell, Codex should make the call and include a clear "OpenClaw deploy needed: yes/no" note in the final response.
- When OpenClaw deployment is needed, provide a copy-ready message/command block for OpenClaw based on `docs/server-maintenance.md` rather than expecting the user to infer the deployment steps.

## Art Asset Workflow

- Follow `docs/art-progress.md` for current art direction and asset status.
- When new visual assets are needed, use GPT-Image-2 as the default image-generation source unless the user asks for a different source.
- Record generated asset work in `docs/pending-changes.md`, including:
  - the purpose of the asset,
  - the generated or edited output files,
  - any important prompt or style constraints,
  - how the asset was sliced, resized, or integrated.
- Keep generated source sheets or intermediate files when they are useful for future edits; place them under `assets/art/`.
- Put app-ready sprites and cropped runtime assets under `assets/sprites/` using the existing naming style.
