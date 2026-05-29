# Pending Changes

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
