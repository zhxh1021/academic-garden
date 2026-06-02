# Pending Changes

## 2026-06-02 - House hotspot and decoration asset redraw pass

### Summary

- Moved homepage garden entrance hot zones down onto the painted house/cottage areas and fixed the hover transform mismatch that made the clickable area jump away from the house.
- Replaced the runtime wood bench sprite with a newly cropped complete bench asset from the existing decoration sheet and reduced its map/shop render size.
- Replaced the temporary generated stepping-stone sprite with a higher-quality hand-painted cobblestone path crop from the existing decoration sheet.
- Updated decoration sprite paths so the shop and map use the new bench/path assets.

### Files Changed

- `src/domain.js`
- `styles.css`
- `assets/sprites/decor-wood-bench-v6.png`
- `assets/sprites/decor-cobble-path-v6.png`
- `docs/pending-changes.md`

### Asset Notes

- `assets/sprites/decor-wood-bench-v6.png` and `assets/sprites/decor-cobble-path-v6.png` were cropped from `assets/art/decoration-sheet-v2.png`, with chroma-key background pixels removed locally.
- The generated image direction used for this pass was: complete compact wooden bench, full left/right arms and legs, and an organic hand-painted curved cobblestone path with moss/grass, no text.
- Existing generated originals were left in the Codex generated-images directory; app-ready runtime assets are under `assets/sprites/`.

### Verification

- Ran `node --check src\app.js`.
- Ran `node --test scripts\domain.test.mjs scripts\server.test.mjs`.
- Ran `git diff --check`.
- Ran PNG chroma-key scans on the new bench/path sprites.

### Notes

- Existing unrelated `AGENTS.md` local change was left untouched.
- This is GitHub Pages frontend/domain asset work. OpenClaw deploy needed: no.

## 2026-06-02 - Mature tree map anchor adjustment

### Summary

- Lowered mature paper tree sprites on the homepage farm map so the tree base sits back on the painted soil area instead of floating above it.
- Scoped the anchor adjustment to `.overview-plant.tree` mature stages (`tree`, `flower`, `fruit`) so course flowers and smaller growth stages keep their existing placement.
- Added matching mobile anchor values for the 390px layout.

### Files Changed

- `styles.css`
- `docs/pending-changes.md`

### Verification

- Ran `node --check src\app.js`.
- Ran `node --test scripts\domain.test.mjs scripts\server.test.mjs`; 23 tests passed.
- Ran `git diff --check`; only existing Windows line-ending warnings were reported.

### Notes

- Existing unrelated `AGENTS.md` local change was left untouched.
- This is GitHub Pages frontend CSS work. OpenClaw deploy needed: no.

## 2026-06-02 - Mature paper tree sprite clipping fix

### Summary

- Fixed the remaining half-cut mature tree problem by routing paper `tree`, `flower`, and `fruit` stages to the complete variety tree sprites instead of the cropped stage-specific tree PNGs.
- Added a domain regression test so mature paper stages keep using complete tree sprites.
- Removed leftover chroma-key magenta pixels from the complete paper tree sprites used at runtime.

### Files Changed

- `src/domain.js`
- `scripts/domain.test.mjs`
- `assets/sprites/tree-camphor.png`
- `assets/sprites/tree-cherry.png`
- `assets/sprites/tree-ginkgo.png`
- `assets/sprites/tree-maple.png`
- `assets/sprites/tree-willow.png`
- `docs/pending-changes.md`

### Verification

- Confirmed cropped stage PNGs had alpha content touching the top edge, while complete tree sprites have transparent margins.
- Confirmed `tree-maple.png` and `tree-ginkgo.png` have transparent corner alpha and zero remaining magenta pixels.
- Ran `node --test scripts\domain.test.mjs scripts\server.test.mjs`; 23 tests passed.

### Notes

- Existing unrelated `AGENTS.md` local change was left untouched.
- This is GitHub Pages frontend/domain asset work. OpenClaw deploy needed: no.

## 2026-06-02 - Homepage farm v5 entrance, tree, and decoration scope fixes

### Summary

- Changed homepage map destination entrances so each farm zone renders links to the other two zones, with zone-specific hot-zone classes instead of reusing the active-zone pair.
- Kept destination clicks inside the homepage farm map; clicking a map entrance switches `selectedFarmZone` and does not open the project-management view.
- Repositioned and shrank destination hot zones so their labels and count badges appear together near the entrance marker without sitting on the first row of plants.
- Adjusted overview plot coordinates and row-based mature plant sizing so back-row trees are smaller/higher while front-row plants remain fuller and bottom-anchored.
- Replaced the foreground path decoration sprite with a smaller v5 stepping-stone asset and tuned runtime decoration sizes so bench, pond, lamp, and path align more closely with decoration slot circles.
- Updated decoration placement behavior so owned decorations remain a shared global library, while each placement belongs to one zone; buying a decoration places it only in the current farm zone.

### Files Changed

- `src/app.js`
- `src/domain.js`
- `scripts/domain.test.mjs`
- `styles.css`
- `assets/sprites/decor-stepping-stones-v5.png`
- `docs/pending-changes.md`

### Asset Notes

- Added `assets/sprites/decor-stepping-stones-v5.png` as a compact pixel stepping-stone foreground decoration for the v5 floor.
- The asset is transparent PNG runtime art under `assets/sprites/`; no intermediate sheet was needed.
- Style constraints: small, low-profile tan stones with light grass tufts, sized to sit just larger than a decoration slot rather than covering the painted v5 ground.

### Verification

- Ran initial checks: `git status --short`; `git diff -- src/app.js styles.css index.html src/domain.js scripts/domain.test.mjs docs/pending-changes.md`; `node --check src\app.js`; `node --test scripts\domain.test.mjs scripts\server.test.mjs`.
- Ran `node --check src\app.js`.
- Ran `node --test scripts\domain.test.mjs scripts\server.test.mjs`; 22 tests passed.
- Started local preview at `http://127.0.0.1:4173/`.
- Used bundled Playwright with Microsoft Edge to verify desktop and 390px mobile rendering:
  - active, harvested, and dormant use the v5 background files;
  - each zone exposes exactly two map entrances to the other zones;
  - entrance clicks switch the homepage farm map and leave project management hidden;
  - hovered/focused entrance label and count badge appear together;
  - homepage mature plants stay inside the map, with back rows reduced and front rows larger;
  - project-card and detail plant sprites stay inside their scene frames;
  - active/harvested/dormant decorations render only in their placed zone;
  - the bench renders complete at runtime and the new foreground stepping stones replace the old tall path.

### Notes

- Existing parallel work in `AGENTS.md`, `index.html`, existing v4/v5 art files, and prior sprite cleanup files was left untouched.
- This slice is GitHub Pages frontend/domain UI work. OpenClaw deploy needed: no.

## 2026-06-01 - Homepage farm v5 visual interaction closure

### Summary

- Fixed homepage overview plant sprite selection so map plants use their real stage assets instead of falling back to a shared variety sprite for mature, flowering, and harvested stages.
- Repositioned the active-garden harvested/dormant entrance hot-zone labels and count badges so hover/focus reads like a small map marker near each destination.
- Increased mature-stage map presence while keeping the sprite bottom anchored to the same plot coordinate system.
- Widened project-card plant scenes and enlarged detail scenes so mature tree sprites fit fully in the card/detail artwork instead of being clipped by the scene frame.
- Reworked decoration slots toward visible map grid targets in movement mode, adjusted slot coordinates to sit better on the v5 path/edge/water areas, and kept decoration moves using the same slot coordinate as the rendered drop target.
- Improved decoration shop cards with clearer map-slot badges, owned/locked state copy, and more explicit relationship between purchased decorations and map placement.
- Tightened the mobile farm toolbar so the four core controls fit as a grid instead of clipping the final action.

### Files Changed

- `src/app.js`
- `src/domain.js`
- `styles.css`
- `docs/pending-changes.md`

### Verification

- Ran `git status --short` before editing and reviewed `git diff -- src/app.js styles.css index.html src/domain.js scripts/domain.test.mjs docs/pending-changes.md`.
- Ran `node --check src\app.js`.
- Ran `node --test scripts\domain.test.mjs scripts\server.test.mjs`; 21 tests passed.
- Ran `git diff --check`; only existing Windows line-ending warnings were reported.
- Started local preview at `http://127.0.0.1:4173/`.
- Browser plugin preview failed with the existing Windows sandbox error `spawn setup refresh`; used bundled Playwright with Microsoft Edge as the rendered fallback.
- Rendered QA verified:
  - active, harvested, and dormant zones still use the v5 background files;
  - active-garden entrance hover labels and badges appear near their destination paths;
  - homepage tree and flower stages use distinct `assets/sprites/stages/...` images for tree/flower/fruit/bloom/seed_saved;
  - mature map trees are larger while roots stay anchored to the plot coordinates;
  - project-card mature tree sprite fits inside the widened card scene, and detail mature tree fits inside the detail scene;
  - decoration movement mode exposes visible empty decoration grid slots and keeps drop coordinates aligned with the rendered slots;
  - decoration shop opens and shows slot relation, price/owned state, and move-placement copy;
  - 390px mobile preview keeps the toolbar controls visible without horizontal clipping.

### Notes

- Existing parallel work in `AGENTS.md`, `index.html`, `scripts/domain.test.mjs`, sprite cleanup assets, and the v4/v5 art files was left in place and not reverted.
- This slice is GitHub Pages frontend/domain UI work. OpenClaw deploy needed: no.

## 2026-06-01 - Homepage v5 recovery and preview stabilization

### Summary

- Repaired the interrupted `src/app.js` mojibake and broken string literals that prevented the homepage JavaScript from parsing.
- Kept the homepage farm v5 visual direction active for the active, harvested, and dormant gardens.
- Fixed the active-garden destination hot zones so clicking harvested or dormant switches the homepage farm zone in place instead of jumping into the project-management view.
- Kept the farm toolbar rendered inside the overview map with three-zone switching, planting, movement, decoration shop, and project management actions.
- Removed the CSS-drawn runtime dirt patch from empty plot targets so the painted v5 background pits remain the visual source of truth; hover/drop feedback now stays as transparent hit targets plus a centered outline.

### Files Changed

- `src/app.js`
- `styles.css`
- `docs/pending-changes.md`

### Verification

- Ran `git status --short` and reviewed `git diff -- src/app.js styles.css index.html src/domain.js scripts/domain.test.mjs docs/pending-changes.md` before editing.
- Ran `node --check src\app.js`.
- Ran `node --test scripts\domain.test.mjs scripts\server.test.mjs`; 21 tests passed.
- Ran `git diff --check`; only existing Windows line-ending warnings were reported.
- Started the local static server at `http://127.0.0.1:4173/`.
- Browser plugin preview failed with Windows sandbox error `spawn setup refresh`; Playwright CLI initially needed sandbox escalation, then Microsoft Edge was used as the rendered fallback.
- Rendered preview verified:
  - active uses `garden-background-active-v5.png`;
  - harvested uses `garden-background-harvested-v5.png`;
  - dormant uses `garden-background-dormant-v5.png`;
  - homepage summary and sync status render instead of staying empty/checking;
  - toolbar includes three-zone switching, planting, movement, decoration shop, and project management;
  - active hot zones expose harvested and dormant destinations, and harvested click switches the homepage farm zone without hiding the homepage;
  - empty plot runtime `::before` content/background is `none`;
  - 390px mobile toolbar buttons report no overlap.

### Notes

- Existing parallel work in `AGENTS.md`, `index.html`, `src/domain.js`, `scripts/domain.test.mjs`, sprite assets, and the v4/v5 art files was left in place and not reverted.
- This slice is GitHub Pages frontend recovery work. OpenClaw deploy needed: no.

## 2026-06-01 - Low-conflict UI visual refinement pass

### Summary

- Added a CSS-only refinement layer that softens the interface chrome while preserving the pixel RPG garden direction.
- Split typography treatment so Chinese body copy uses a softer UI font while labels, buttons, counters, and pixel-style headings keep the monospace character.
- Reduced secondary button, HUD, toolbar, and tab visual weight so the garden art remains the first visual priority.
- Tightened shop cards toward a compact item-card feel with steadier image, copy, price, and owned-button alignment.

### Files Changed

- `styles.css`
- `docs/pending-changes.md`

### Verification

- Ran `git diff --check`; only existing Windows line-ending warnings appeared.
- Started the local static server with the bundled Python runtime at `http://127.0.0.1:4173/`.
- Attempted a headless Edge screenshot for visual verification, but Edge exited without producing the screenshot file in this sandbox, so this pass was verified by CSS/static diff review rather than a fresh rendered screenshot.

### Notes

- This slice intentionally avoids `index.html`, `src/app.js`, and `src/domain.js` to reduce conflict with concurrent main-interface work.
- No new visual assets were generated.
- This is GitHub Pages frontend CSS work. OpenClaw deploy needed: no.

## 2026-06-01 - Homepage grid farm asset and movement completion

### Summary

- Wired the homepage overview to three generated v4 garden backgrounds for active, harvested, and dormant zones.
- Removed the remaining CSS-drawn and sprite-drawn plot surfaces from the homepage map; empty farm plots are now transparent click targets over the circular pits already painted into each background.
- Kept planted plots visually clear by rendering no empty plot button once a plant occupies that plot, and removed the extra homepage plant ground-base overlays so plants sit directly on the painted background pits.
- Extended the movement mode so decorations behave like movable map objects: select an owned decoration, move it to an empty decoration slot, or swap it with another decoration in the same zone.
- Reworked the map toolbar into one compact control strip for zone switching, planting, movement, the decoration shop, and project management; mobile uses a stacked toolbar with horizontally scrollable actions rather than overlapping buttons.
- Cleared the last chroma-key magenta pixels from the two reused plant ground-base v2 runtime sprites.

### Files Changed

- `index.html`
- `src/app.js`
- `src/domain.js`
- `styles.css`
- `scripts/domain.test.mjs`
- `assets/art/garden-background-active-v4.png`
- `assets/art/garden-background-harvested-v4.png`
- `assets/art/garden-background-dormant-v4.png`
- `assets/sprites/plant-ground-base-v2-back.png`
- `assets/sprites/plant-ground-base-v2-front.png`
- `docs/pending-changes.md`

### Asset Notes

- The three v4 backgrounds are GPT-Image-2-style pixel-art valley farm scenes using a shared 9-plot structure.
- Prompt/style constraints carried through integration: no labels or UI text in the art, active garden keeps the two rear destination paths visible, harvested garden uses a warm orchard palette, dormant garden uses a quiet twilight palette, and all three leave clear foreground plot space for runtime sprites.
- The v4 backgrounds remain under `assets/art/` as full scene art; the homepage now uses their painted pit circles instead of overlaying app-ready empty plot sprites.
- No new slicing was needed for the v4 backgrounds. Runtime integration is via CSS background switching on `.overview-garden[data-current-zone]`.

### Verification

- Ran `node --check src/app.js`.
- Ran `node --test scripts/domain.test.mjs scripts/server.test.mjs`; 21 tests passed.
- Started a local static server with the bundled Python runtime at `http://127.0.0.1:4173/`.
- Browser plugin startup failed with Windows sandbox error `spawn setup refresh`; Playwright package fallback was unavailable because bundled `playwright` lacked `playwright-core`.
- Used Edge via Chrome DevTools Protocol as a fallback rendered QA path.
- Rendered QA verified:
  - active background uses `garden-background-active-v4.png`;
  - harvested background uses `garden-background-harvested-v4.png`;
  - dormant background uses `garden-background-dormant-v4.png`;
  - empty plot hit targets report `plotBackground: none`, so the only visible pits are the ones baked into the current garden background;
  - planting into plot 2 reduced empty plots from 7 to 6 and saved the new plant with `plotIndex: 2`;
  - moving `active-tree` saved it at `plotIndex: 8`;
  - moving the lamp decoration saved its active placement at `front-left-small`;
  - desktop and 390px mobile toolbar checks reported no button overlaps.
- Ran a PNG color-key scan across the three v4 backgrounds, empty plot v2 sprites, and plant ground-base v2 sprites; all scanned files now report `magenta: 0`.

### Notes

- Existing backend/auth/sync-login work in `.env.example`, `package.json`, `server/`, `src/store.js`, `src/sync-auth.js`, `scripts/server.test.mjs`, `scripts/sync-auth.test.mjs`, and related docs was left untouched.
- This slice is GitHub Pages frontend and asset work. OpenClaw deploy needed: no.

## 2026-06-01 - Frontend cloud sync login panel

### Summary

- Added a visible cloud sync login dialog opened from the header sync status button.
- Replaced the active prompt-based login path with `POST /api/auth/login` and bearer-token storage for the current browser device.
- Added logout handling through `POST /api/auth/logout`, clearing the saved token and local sync identity.
- Kept legacy Basic Auth headers as a compatibility fallback when older saved credentials still exist.
- Added a small `src/sync-auth.js` helper module for auth headers, login/logout requests, and sync button copy.
- Updated the backend sync plan to describe the login panel flow.

### Files Changed

- `index.html`
- `styles.css`
- `src/app.js`
- `src/store.js`
- `src/sync-auth.js`
- `scripts/sync-auth.test.mjs`
- `package.json`
- `docs/backend-sync-plan.md`
- `docs/pending-changes.md`

### Verification

- Ran `node --test scripts/sync-auth.test.mjs` and observed the new test fail before `src/sync-auth.js` existed.
- Ran `node --check src/sync-auth.js`.
- Ran `node --check src/store.js`.
- Ran `node --check src/app.js`.
- Ran `npm test`.
- Ran `git diff --check`; only existing Windows line-ending warnings appeared.
- Served the app locally at `http://127.0.0.1:4173/` and used headless Edge with Playwright to confirm the sync button opens the login dialog without console errors.
- Used Playwright route mocks to confirm a successful login closes the dialog, stores the bearer token, does not save the password, and updates the sync button to `同步：已连接 v7`.

### Notes

- Existing grid farm, art asset, backend auth foundation, and unrelated documentation work in the worktree was left untouched.
- No new visual assets were generated in this slice.

## 2026-05-31 - Next-version backend account auth foundation

### Summary

- Created the backend work branch `codex/backend-auth-v2`.
- Added a dependency-free account store backed by `server/data/accounts.json`, seeded from the existing sync username/password when no account file exists.
- Added password hashing with Node `scrypt`, bearer session tokens, and an HTTP-only session cookie for future login UI work.
- Added `POST /api/auth/login`, `GET /api/auth/session`, `POST /api/auth/logout`, and `POST /api/auth/register`.
- Kept registration closed by default with `ACADEMIC_GARDEN_REGISTRATION_ENABLED=false`.
- Preserved the existing Basic Auth flow so the current frontend sync code can keep using `/api/garden` without a frontend migration in this slice.
- Documented the new account env vars and persistent account-data file.

### Files Changed

- `.env.example`
- `server/server.mjs`
- `scripts/server.test.mjs`
- `docs/backend-sync-plan.md`
- `docs/server-maintenance.md`
- `docs/pending-changes.md`

### Verification

- Ran `node --check server/server.mjs`.
- Ran `node --check scripts/server.test.mjs`.
- Ran `npm test`.

### Notes

- Existing frontend, grid farm, art asset, and unrelated documentation work in the worktree was left untouched.
- No new visual assets were generated in this slice.

## 2026-05-31 - OpenClaw deployment reminder convention

### Summary

- Documented the shared convention that Codex should tell the user when a change requires OpenClaw to deploy server-side updates.
- Added examples separating GitHub Pages-only changes from backend/API/service changes.
- Updated the server maintenance guide so OpenClaw deployment is a Codex-explicit yes/no step rather than something the user has to infer.
- Added the convention that Codex should include a copy-ready OpenClaw command block whenever OpenClaw deployment is needed.

### Files Changed

- `AGENTS.md`
- `docs/server-maintenance.md`
- `docs/pending-changes.md`

### Verification

- Documentation-only change; reviewed the added instructions in both files.

### Notes

- Existing grid farm, art asset, and backend maintenance entries were left intact.

## 2026-05-31 - Unified grid farm scene structure

### Summary

- Reworked the garden overview into a shared grid-based farm scene for active, harvested, and dormant zones.
- Added stable 9-plot placement data for plants, including old-data migration by zone and creation order.
- Added plant move mode for moving a plant to an empty plot or swapping two plants within the same zone.
- Added decoration slot data with default placements so unlocked decorations render from fixed grid slots while leaving room for future free placement UI.
- Changed shop copy from purchase ownership language to decoration unlock language.
- Kept the current valley background and existing runtime sprites in place; this slice builds the scene/data skeleton so future background repainting can replace the art without changing interaction rules.

### Files Changed

- `src/domain.js`
- `src/app.js`
- `styles.css`
- `scripts/domain.test.mjs`
- `docs/pending-changes.md`

### Verification

- Ran `node --check src/app.js`.
- Ran `node --test scripts/domain.test.mjs scripts/server.test.mjs`.
- Ran `git diff --check`; only existing Windows line-ending warnings appeared.
- Confirmed the local static server returned HTTP 200 at `http://127.0.0.1:4173/`.

### Notes

- No new image assets were generated in this slice.
- The new grid reserves 9 plant plots per zone and 10 decoration/expansion slots.
- Decoration free-placement UI is intentionally left for a future slice; the data shape now has `decorations.placements`.
- Existing art asset transparency work, sync status UI, backend sync work, and sprite files were left intact.

## 2026-05-31 - Backend reliability and sync maintenance

### Summary

- Added a dependency-free garden data backup script with configurable backup directory and retention count.
- Documented Tencent Cloud maintenance commands, backup setup, restore steps, health checks, and safe OpenClaw operating boundaries.
- Expanded `/api/health` to report storage readability, writability, version, and last cloud update time without returning garden contents.
- Added a small header sync status button that shows local/connected/pending state and lets the user clear saved sync login on the current device.

### Files Changed

- `.env.example`
- `.gitignore`
- `index.html`
- `package.json`
- `scripts/backup_garden.mjs`
- `scripts/server.test.mjs`
- `server/server.mjs`
- `src/app.js`
- `src/store.js`
- `styles.css`
- `docs/server-maintenance.md`
- `docs/pending-changes.md`

### Verification

- Ran `node --check server/server.mjs`.
- Ran `node --check scripts/backup_garden.mjs`.
- Ran `node --check src/store.js`.
- Ran `node --check src/app.js`.
- Ran `node --test scripts/domain.test.mjs scripts/server.test.mjs`.
- Ran `node scripts/backup_garden.mjs` against a `.runtime/backup-test` data file and confirmed a backup JSON was created.
- Ran `git diff --check`; only existing Windows line-ending warnings appeared.

### Notes

- Existing unrelated art asset edits were left untouched.

## 2026-05-30 - Art asset transparency and layout QA pass

### Summary

- Cleared chroma-key magenta from all app-ready runtime decoration, tree, and flower sprites under `assets/sprites/`.
- Added a GPT-Image-2-generated wallet coin sprite and replaced the CSS-drawn coin in the HUD.
- Added a GPT-Image-2-generated shop preview grass base and removed CSS-drawn shop decoration substitutes so the shop previews use real sprites.
- Rebalanced homepage placement rules so active plants and empty plots sit in the central planting area, while path, lamp, bench, and pond decorations reserve separate map zones.
- Cropped the lamp sprite to remove unrelated sheet fragments, moved the pond out of the bottom action-button area, and switched mature/blooming homepage plants to higher-detail variety sprites.
- Reset inherited CSS fallback styling on sprite-backed shop previews so the lamp card does not show a hard rectangular pseudo-element frame.
- Added explicit art asset rules documenting source-vs-runtime assets, transparency checks, shared usage points, map layout zones, and shop preview rules.

### Files Changed

- `assets/sprites/decor-lamp.png`
- `assets/sprites/decor-pond.png`
- `assets/sprites/decor-stone-path.png`
- `assets/sprites/decor-wood-bench.png`
- `assets/sprites/flower-*.png`
- `assets/sprites/tree-*.png`
- `assets/art/coin-v1-source.png`
- `assets/sprites/coin-v1.png`
- `assets/art/shop-preview-ground-v1-source.png`
- `assets/sprites/shop-preview-ground-v1.png`
- `assets/art/plant-ground-base-v2-source.png`
- `assets/sprites/plant-ground-base-v2-back.png`
- `assets/sprites/plant-ground-base-v2-front.png`
- `src/app.js`
- `styles.css`
- `docs/art-asset-rules.md`
- `docs/pending-changes.md`

### Verification

- Ran `python .runtime\scan_assets.py`; no magenta pixels remained in `assets/sprites/`.
- Ran `node --check src\app.js`.
- Ran `node --test scripts\domain.test.mjs scripts\server.test.mjs`.
- Ran `git diff --check`; only existing Windows line-ending warnings appeared.
- Confirmed the local server returned HTTP 200 at `http://127.0.0.1:4173/`.
- Reran `.runtime\render-qa.cjs` through the cached Playwright package with the local Edge channel; it rendered one overview, two active plants, four decoration sprites, and four shop sprites, and saved refreshed screenshots under `.runtime\render-qa-home-populated.png` and `.runtime\render-qa-shop.png`.

### Notes

- Generated coin and shop preview base with the built-in image generation tool on a flat magenta chroma-key background, then removed the key locally.
- Source sheets and generated source files under `assets/art/` intentionally retain chroma-key backgrounds for future slicing/editing; runtime files under `assets/sprites/` must be transparent.
- The rendered QA screenshots exposed a cropped-lamp problem, a pond/button overlap, low-detail mature map plants, and a hard frame behind the shop lamp preview; those were addressed and verified in the refreshed screenshots.
- Existing unrelated sync/backend work was left untouched.

## 2026-05-29 - Remember sync login on device

### Summary

- Changed the cloud sync password cache from session-only storage to device-local storage.
- After a successful prompt, the same browser device can keep syncing without asking for the password after every browser restart.
- Login failures still clear the saved password so the next refresh can ask again.

### Files Changed

- `src/store.js`
- `docs/pending-changes.md`

### Verification

- Ran `node --check src/store.js`.
- Ran `node --test scripts/domain.test.mjs scripts/server.test.mjs`.
- Ran `git diff --check`; only existing Windows line-ending warnings appeared.

### Notes

- A polished in-page login/settings panel is intentionally left for a later UI pass.

## 2026-05-29 - GitHub Pages sync endpoint

### Summary

- Pointed the GitHub Pages frontend sync configuration at the deployed Tencent Cloud HTTPS backend.
- The public frontend will now call `https://api.acagarden.site/api/garden` when cloud sync is available.

### Files Changed

- `sync-config.js`
- `docs/pending-changes.md`

### Verification

- Ran `node --check src/store.js`.
- Ran `node --check src/app.js`.
- Ran `git diff --check`; only existing Windows line-ending warnings appeared.

### Notes

- This endpoint update is being pushed together with the existing homepage planted-base art polish.

## 2026-05-29 - Homepage destination affordance and empty plot art fix

### Summary

- Replaced the empty planting plot sprites with a new GPT-Image-2-generated v2 sheet and transparent cropped runtime assets.
- Updated the homepage empty state to use `empty-plot-a-v2.png`, `empty-plot-b-v2.png`, and `empty-plot-c-v2.png`.
- Tightened the harvested/dormant destination click targets around the painted background houses and replaced the hard focus box with a lighter hover/focus floating hint.
- Replaced the CSS-drawn planted-tree root ellipses with a generated transparent grass/soil base sprite.

### Files Changed

- `assets/art/empty-plot-sheet-v2-source.png`
- `assets/sprites/empty-plot-sheet-v2.png`
- `assets/sprites/empty-plot-a-v2.png`
- `assets/sprites/empty-plot-b-v2.png`
- `assets/sprites/empty-plot-c-v2.png`
- `assets/art/plant-ground-base-v1-source.png`
- `assets/sprites/plant-ground-base-v1.png`
- `src/app.js`
- `styles.css`
- `docs/pending-changes.md`

### Verification

- Ran `node --check src/app.js`.
- Validated the new empty-plot PNGs have alpha channels and transparent corners.
- Confirmed homepage code references the new v2 empty-plot assets.
- Validated the planted ground-base PNG has an alpha channel and transparent corners.

### Notes

- Generated with the built-in image generation tool on a flat chroma-key background, then removed the key locally and sliced the sheet into runtime sprites.
- Prompt constraints: high-quality sunny RPG garden pixel-art soil patches, refined grass rims, no labels, no UI, no heavy outlines, no sticker-like shadow.
- Additional planted-base prompt constraints: low natural grass and subtle root opening, no large oval dirt blob, no CSS-like ellipse.

## 2026-05-29 - Homepage integrated destination houses

### Summary

- Replaced the homepage map background with `garden-background-v3.png`, generated from the existing garden scene with the two destination houses painted directly into the distant landscape.
- Kept the old harvested/dormant house sprite files available for future detail-scene decoration, but removed them from the homepage overview markup.
- Converted the two homepage destination buttons into transparent click targets with subtle hover/focus labels and count badges.

### Files Changed

- `assets/art/garden-background-v3.png`
- `src/app.js`
- `styles.css`
- `docs/pending-changes.md`

### Verification

- Visually inspected `assets/art/garden-background-v3.png`.
- Ran `node --check src/app.js`.
- Confirmed `http://127.0.0.1:4173/` returned HTTP 200.
- Confirmed `http://127.0.0.1:4173/assets/art/garden-background-v3.png` returned HTTP 200.
- Ran `git diff --check`; only existing Windows line-ending warnings appeared.

### Notes

- Generated with the built-in image generation tool using the current `garden-background-v2.png` as the visual reference.
- Prompt constraints: preserve the 1536x1024 sunny pixel-art garden composition, integrate a warm harvest destination on the left path and a cooler quiet dormant cottage on the right path, keep both buildings distant, hazy, and free of labels or UI text.
- Existing unrelated sync-backend work was left untouched.

## 2026-05-29 - Personal sync backend

### Summary

- Added a small dependency-free Node backend for personal multi-device syncing.
- The sync server protects the app with browser Basic Auth, serves the existing static frontend, and exposes `GET /api/garden` / `PUT /api/garden`.
- Corrected the sync architecture for the existing GitHub Pages deployment: Pages keeps serving the frontend, while `sync-config.js` points the app at a separately deployed backend API.
- Added cross-origin support for `https://zhxh1021.github.io` so the GitHub Pages frontend can call the backend API.
- Cloud garden data is saved as a private JSON snapshot under `server/data/`, while the frontend keeps IndexedDB as local fallback and first-time migration source.
- Added stale-version detection so a save from an older device state does not silently overwrite newer cloud data.
- Added beginner-facing setup notes and a Windows launcher for the sync version.

### Files Changed

- `.gitignore`
- `.env.example`
- `package.json`
- `server/server.mjs`
- `src/store.js`
- `sync-config.js`
- `scripts/server.test.mjs`
- `docs/backend-sync-plan.md`
- `docs/pending-changes.md`
- `启动同步版学术花园.cmd`

### Verification

- Ran `node --check server/server.mjs`.
- Ran `node --check src/store.js`.
- Ran `node --test scripts/server.test.mjs`.
- Ran `node --test scripts/domain.test.mjs scripts/server.test.mjs`.
- Started the sync server locally and confirmed authenticated requests returned `200` for `/` and an empty cloud snapshot for `/api/garden`.
- Added and tested CORS preflight support for the GitHub Pages origin.

### Notes

- No external npm dependencies were added.
- Existing local-only launcher and Python static server were left untouched.
- Existing art assets and unrelated frontend layout files were left untouched.

## 2026-05-28 - Paper tree stage sprite crop fix

### Summary

- Fixed paper tree stage sprites that contained two vertically separated sprite fragments in one PNG.
- Cropped the `sapling`, `tree`, and `flower` stage assets for all six paper tree varieties to keep only the first valid sprite segment.
- Confirmed `paper-ginkgo-tree.png` now contains a single tree instead of a split tree plus leftover lower fragment.

### Files Changed

- `assets/sprites/stages/paper-*-sapling.png`
- `assets/sprites/stages/paper-*-tree.png`
- `assets/sprites/stages/paper-*-flower.png`

### Verification

- Re-scanned alpha row segments for all updated PNGs; each file now reports one continuous segment.
- Visually inspected `assets/sprites/stages/paper-ginkgo-tree.png`.

### Notes

- This fixes the card/detail split-tree artifact shown when rendering the broken stage asset.
- Existing concurrent edits in `src/app.js` and `styles.css` were not modified as part of this asset fix.

## 2026-05-28 - Major garden art refresh rollup

### Summary

- Consolidates the currently unpushed local work into one larger visual update candidate.
- Adds project working requirements in `AGENTS.md` so future parallel Codex work records completed local slices before a combined push.
- Keeps the plant card, overview garden, and detail dialog aligned around the shared `garden-background-v2.png` bitmap direction.
- Reuses stage sprites in both compact cards and detail dialogs, with corrected seed/sapling and sowing/growing display sizes.
- Moves plant labels and sprite anchors into safer positions so tall pixel assets do not overlap important text.

### Unpushed Local Scope

- Modified: `index.html`
- Modified: `src/app.js`
- Modified: `styles.css`
- Added: `AGENTS.md`
- Added: `docs/pending-changes.md`

### Verification

- Reviewed `docs/pending-changes.md` against `git status --short --branch`.
- Reviewed the working tree diff for `index.html`, `src/app.js`, and `styles.css`.
- Ran `git diff --check`; only Git line-ending warnings appeared for existing files, with no whitespace errors.

### Notes

- No commits are ahead of `origin/main`; the remaining unpushed work is currently in the local working tree.
- No new image assets were generated in this rollup.
- Existing tracked art assets and `docs/art-progress.md` were left untouched.

## Standing Workflow Note

- Project working requirements are now documented in `AGENTS.md`.
- For parallel Codex work, record each completed local fix or feature slice here before a combined review and push.
- For generated art assets, also record the asset purpose, generated files, prompt/style constraints, and integration notes here.

## 2026-05-28 - Design system and homepage polish

### Summary

- Refined the overall pixel garden interface based on the design audit.
- Moved the primary "种下一株植物" action from the top header into the garden map controls so the homepage reads more like a playable garden scene.
- Downgraded the backup export action visually, tightened the HUD styling, and added consistent focus-visible treatment for keyboard navigation.
- Improved empty plot affordances with hover/focus planting labels and clearer empty garden copy.
- Rebalanced the project workbench so plant cards feel more like compact research journal entries while the homepage remains the immersive garden overview.
- Tightened mobile layout rules for the HUD, home actions, empty plots, overview plants, and plant cards.

### Files Changed

- `index.html`
- `src/app.js`
- `styles.css`
- `docs/pending-changes.md`

### Verification

- Ran `node --check src/app.js`.
- Ran `node --test scripts/domain.test.mjs`.
- Ran `git diff --check`; only existing Windows line-ending warnings appeared.
- Confirmed the local server returned the app at `http://127.0.0.1:4173`.
- Confirmed the served HTML includes the updated garden map, in-map planting action, and backup button styling hook.

### Notes

- No new image assets were generated for this slice.
- Existing in-progress edits for plant edit/remove, destination landmarks, and sprite alignment were preserved and built upon.
- Attempted direct Edge headless screenshot capture, but the command did not produce a screenshot file in this sandbox; verification fell back to local server and static checks.

## 2026-05-28 - Plant edit and remove controls

### Summary

- Added card-level edit and remove actions for tree and flower records.
- Reused the existing plant form for edits while preserving plant type, lifecycle stage, growth, milestones, and status.
- Added remove logic that deletes the selected plant plus its activity and settlement records, so temporary test plants can be cleaned out.
- Added a small Node test file covering editable fields and dependent-record removal.

### Files Changed

- `src/app.js`
- `src/domain.js`
- `styles.css`
- `scripts/domain.test.mjs`
- `docs/pending-changes.md`

### Verification

- Ran `node --test scripts/domain.test.mjs`.
- Ran `node --check src/app.js`.

### Notes

- Browser automation could not be completed because the in-app browser runtime crashed during startup with `windows sandbox failed: spawn setup refresh`.
- Existing unrelated local work in `src/app.js`, `styles.css`, and `docs/pending-changes.md` was left untouched.

## 2026-05-28 - Overview destination landmark integration

### Summary

- Kept the 收获园 and 沉睡园 map buildings as clickable destination buttons that switch into their corresponding project zones.
- Repositioned and restyled the two map buildings as quieter midground landmarks, with reduced scale, softer shading, foreground grass cover, and smaller sign treatment so they read as part of the background scene.
- Added explicit `aria-label` and `title` text for the two destination buttons.

### Files Changed

- `src/app.js`
- `styles.css`
- `docs/pending-changes.md`

### Verification

- Ran `node --check src/app.js`.
- Ran `git diff --check`; only existing line-ending warnings appeared for `src/app.js`, `styles.css`, and `docs/pending-changes.md`.
- Confirmed the local server returned HTTP 200 at `http://127.0.0.1:4173`.
- Captured a headless Edge screenshot of a temporary `.runtime` landmark fixture to verify the updated map landmark styling.

### Notes

- No new image assets were generated for this slice.
- Existing unrelated local work was left untouched.

## 2026-05-28 - Planted root grounding pass

### Summary

- Removed the overview map plant sprite bobbing that made trees read like floating stickers.
- Added soil shadow, soil mound, and grass-edge layers under overview map plants so their roots appear seated in the ground.
- Added a matching foreground root/soil layer to plant cards and detail scenes, so larger plant sprites are visually tucked into the scene instead of sitting on top of it.

### Files Changed

- `src/app.js`
- `styles.css`
- `docs/pending-changes.md`

### Verification

- Captured a headless Edge screenshot of a temporary `.runtime` plant-root fixture showing mature, sapling, and seed stages on the overview map plus a plant card.
- Ran `node --check src/app.js`.
- Ran `git diff --check`; only existing line-ending warnings appeared for edited text files.

### Notes

- No new image assets were generated for this slice.
- Existing unrelated local work was left untouched.

## 2026-05-28 - Plant sprite alignment and sizing

### Summary

- Fixed overview garden plant sprites using a centered ground-anchor layout.
- Adjusted seed/sapling and sowing/growing sprite display boxes so tall pixel assets keep their intended proportions.
- Moved overview plant labels below the sprite instead of overlapping the tree canopy or trunk.
- Matched card and detail scene sapling/growing sprite proportions with the actual tall source assets.
- Follow-up: reapplied the overview map portion after confirming the committed refresh still had the old `112px` square sprite box and negative label margin.

### Files Changed

- `styles.css`

### Verification

- Confirmed the local server returned HTTP 200 at `http://127.0.0.1:4173`.
- Ran `git diff --check`; only line-ending warnings appeared for existing files, with no whitespace errors.

### Notes

- This change is intentionally left unpushed so it can be included with the other in-progress work.
- Existing unrelated edits in `index.html`, `src/app.js`, and empty-plot assets were not modified as part of this fix.

## 2026-05-28 - Detail scene visual style unification

### Summary

- Replaced the rough CSS-drawn card scene background with the shared `garden-background-v2.png` art direction.
- Added a matching bitmap scene to the tree and flower detail dialog.
- Reused existing stage sprites for both card and detail scenes, instead of drawing the plant body with CSS.

### Files Changed

- `index.html`
- `src/app.js`
- `styles.css`

### Verification

- Ran a local Playwright check through Microsoft Edge at `http://127.0.0.1:4173`.
- Created QA tree and flower entries, opened both detail dialogs, and confirmed the shared garden background and stage sprites loaded.
- Confirmed no relevant console warnings or errors were emitted during that check.

### Notes

- No new visual assets were generated for this slice.
- Existing empty-plot assets, `AGENTS.md`, and unrelated `docs/art-progress.md` edits were left untouched.
