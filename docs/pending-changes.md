# Pending Changes

## 2026-06-04 - Godot decoration redraw, three-garden layout, and sway animation

### Summary

- Redrew the 10 runtime decoration sprites with `imagegen` from a single GPT-Image-2 style sprite sheet, replacing the tiny rough Sprout decor cutouts with 96x96 transparent sprites.
- Added local processing/QA scripts to preserve the generated source sheet, remove the chroma-key background, crop app-ready sprites, create a contact sheet, extend the seed layout, and verify asset references.
- Increased Godot map decoration display size from `52x52` to `78x78`, closer to the visual footprint of a plot tile.
- Extended the active garden's 3x3 homepage plot layout to the harvested and dormant gardens, giving all three zones matching columns and rows.
- Expanded each zone to 5 placed decorations with zone-specific placement, so the two secondary gardens no longer feel sparse compared with the homepage.
- Replaced the old plant scale pulse with bottom-anchored side-to-side sway and small drifting leaf/butterfly-like ambient motes, avoiding the previous land-and-plant vertical bobbing.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/art/decoration-sheet-gpt-v3-source.png`
- `godot-prototype/assets/art/decoration-sheet-gpt-v3-contact.png`
- `godot-prototype/assets/sprites/sprout/decor/*.png`
- `scripts/rebuild_godot_decor_assets.py`
- `scripts/make_godot_decor_contact_sheet.py`
- `scripts/extend_godot_garden_layout.py`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Asset Notes

- Generated source purpose: a cohesive, polished decoration sprite sheet for the Godot mobile garden map.
- Prompt constraints: cozy pixel-art academic garden decorations, 5x2 sheet, no text/watermark/characters, flat `#00ff66` chroma-key background, items sized like plot tiles.
- Source sheet kept under `godot-prototype/assets/art/`; app-ready cropped sprites overwrite the existing `godot-prototype/assets/sprites/sprout/decor/` runtime files.
- Processing iterated through fixed grid cropping, manual crop boxes, and small-fragment cleanup before final contact-sheet QA.

### Verification

- Ran `python scripts\rebuild_godot_decor_assets.py`.
- Ran `python scripts\make_godot_decor_contact_sheet.py` and visually inspected `decoration-sheet-gpt-v3-contact.png`.
- Ran `python scripts\extend_godot_garden_layout.py`.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and 0 missing referenced sprites.
- Ran `python -m py_compile` for all new helper scripts.
- Queried Godot MCP project info; it recognized `godot-prototype` with Godot `4.6.3.stable.official.7d41c59c4`.
- Launched `res://scenes/main.tscn` through Godot MCP; output reported the Vulkan device and no errors.
- Stopped the Godot MCP debug run cleanly; final output had no errors.

### Notes

- Existing parallel Godot detail-action/signpost changes were left intact and are documented in the adjacent 2026-06-04 pending-changes entry.
- The deprecated root web runtime was not modified.
- OpenClaw deploy needed: no.

## 2026-06-04 - Godot plant detail actions and signpost empty plot

### Summary

- Expanded the Godot plant detail drawer from a simple log card into a mobile action panel with portrait art, kind/stage/status, growth, visit/log counts, today care totals, note text, and action buttons.
- Adapted the deprecated web runtime's local gameplay mechanisms into the Godot prototype:
  - record progress as daily care and growth,
  - course teaching shortcut increments water care and session count,
  - milestone advance moves plants through paper/course stage flows,
  - completed active plants move to the harvest garden with a coin reward,
  - active plants can sleep into the dormant garden and dormant plants can wake back into active,
  - non-empty plants can be removed from the current local prototype save.
- Replaced the empty plot's paper-like sprite with a transparent Sprout-style soil block plus inserted signpost, composed from existing Godot prototype soil/sign assets.
- Bumped Godot `layout_version` to `4` so existing local saves migrate empty plots to the new signpost land sprite and receive missing growth/care/session fields.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/sprites/sprout/ground/empty-plot-sign.png`
- `docs/pending-changes.md`

### Asset Notes

- No GPT-Image-2 generation was used for this slice.
- The new empty plot runtime sprite was locally composed from `plot-soil-gpt-v3.png` and the top sign tile from `decor-sign.png`.
- Output sprite: `112x88` transparent RGBA PNG under `godot-prototype/assets/sprites/sprout/ground/`.

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Checked all `sprite` and `portrait_sprite` paths referenced by seed plots exist.
- Checked `empty-plot-sign.png` is `112x88` RGBA.
- Queried Godot MCP project info; it recognized `godot-prototype` with Godot `4.6.3.stable.official.7d41c59c4`.
- Launched `res://scenes/main.tscn` through Godot MCP; output reported the Vulkan device and no errors.
- Stopped the Godot MCP debug run cleanly; final output had no errors.

### Notes

- Existing unrelated modified decoration sprites, decoration contact/source art, and decoration rebuild scripts were left untouched.
- Web cloud sync and backup/export remain historical web-runtime mechanisms and were not moved into the local Godot prototype in this slice.
- OpenClaw deploy needed: no.

## 2026-06-03 - Godot exported layout bake and plot alignment

### Summary

- Read the user's exported Godot debug layout from `godot-prototype/layout_debug_export.json`.
- Baked the exported decoration positions and decoration slot positions into the prototype defaults.
- Aligned the active garden's 9 plot anchors into a clean 3x3 grid while preserving the user's hand-placed overall position:
  - columns: `0.293`, `0.503`, `0.719`
  - rows: `0.488`, `0.585`, `0.676`
- Bumped `layout_version` to `3` so existing local saves migrate plot positions to the aligned anchors.
- Kept decoration migration limited to pre-v2 saves so the user's current decoration placement is not overwritten.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `docs/pending-changes.md`

### Verification

- Parsed `godot-prototype/data/garden_seed.json` with `python -m json.tool`.
- Printed active plot coordinates and confirmed the 9 anchors share exactly three x columns and three y rows.
- Launched the Godot project through MCP debug mode; output reported the Vulkan device and no errors.

### Notes

- Existing unrelated local web app, docs, and root asset changes were left untouched.
- The plot anchor semantics remain bottom/ground aligned: the coordinate represents the plant's soil/ground anchor rather than the canopy center. OpenClaw deploy needed: no.

## 2026-06-03 - Godot map and sprite style harmonization pass

### Summary

- Generated a v5 Godot map set from the existing v4 generated maps so the background better matches the lower-resolution cream-toned Sprout plant and decoration sprites.
- Tuned the maps by lowering effective detail density, lightly posterizing color, reducing contrast/saturation, and adding a subtle warm paper veil.
- Updated the Godot prototype to load the v5 active/harvested/dormant maps for both fresh seed data and existing-save map migration.
- Set the Godot map, plant, and decoration display layers to nearest-neighbor texture filtering so pixel art is not smoothed against the map.

### Files Changed

- `scripts/tune_godot_map_style.py`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-active-gpt-v5.png`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-harvested-gpt-v5.png`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-dormant-gpt-v5.png`
- `godot-prototype/assets/art/godot-map-style-v5-contact-sheet.png`
- `godot-prototype/assets/art/godot-active-map-v4-v5-plant-overlay.png`
- `docs/pending-changes.md`

### Asset Notes

- No new GPT-Image-2 generation was used; this pass locally retuned the existing Godot v4 generated maps.
- The v4 maps remain in place as source/reference assets.
- The contact sheet compares each v4 map to its v5 retuned output.
- The active overlay preview composites current plant sprites on v4 and v5 to check foreground/background style fit.

### Verification

- Ran `python -m json.tool godot-prototype/data/garden_seed.json`; JSON parsed successfully and shows all three zones using v5 maps.
- Ran `python -m py_compile scripts/tune_godot_map_style.py`.
- Verified the three v5 maps plus both QA preview images exist.
- Queried Godot MCP project info; it recognized `godot-prototype` with Godot `4.6.3.stable.official.7d41c59c4`.
- Launched the Godot project through MCP debug mode after the v5 map/style update; output reported the Vulkan device and no errors.
- Stopped the MCP debug run cleanly; final output had no errors.

### Notes

- Existing unrelated local web app, backend, docs, and root asset changes were left untouched.
- This is a local Godot prototype/static asset slice. OpenClaw deploy needed: no.

## 2026-06-03 - Godot early growth map sizing fix

### Summary

- Fixed the Godot map plant sizing bug where seed, sowing, sapling, growing, and course bloom/harvest stages reused mature tree-sized plot buttons.
- Added stage-specific Godot plot button sizes so seeds stay tiny near the soil, seedlings remain visibly smaller than mature trees, and course flower buds no longer occupy a whole field tile.
- Kept existing plot `x`/`y` positions untouched; debug-mode `size_scale` still applies on top of the new stage base size.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `docs/pending-changes.md`

### Verification

- Queried Godot MCP project info; it recognized `godot-prototype` with Godot `4.6.3.stable.official.7d41c59c4`, 1 scene, 1 script, and 640 assets.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Confirmed `STAGE_PLOT_SIZES` entries exist for `paper:seed`, `paper:sapling`, `course:sowing`, `course:growing`, `course:bloom`, `course:fruit`, and `course:seed_saved`.
- Launched `res://scenes/main.tscn` through Godot MCP; output reported the Vulkan device and no errors.
- Stopped the Godot MCP debug run cleanly; final output had no errors.

### Notes

- Existing Godot plot positions and user-adjusted layout coordinates were left untouched.
- No new visual assets were generated.
- OpenClaw deploy needed: no.

## 2026-06-03 - Deprecated root web runtime

### Summary

- Marked the root browser app as deprecated in project guidance and runtime entry files.
- Declared `godot-prototype/` as the active product path for mobile portrait UI, map, plant sizing, interaction, save-flow, and art integration work.
- Added a dedicated deprecated-web-runtime note so future Codex threads do not keep patching `index.html`, `styles.css`, or `src/*.js` by default.
- Added a visible deprecated banner to the old `index.html` page without deleting historical web code.

### Files Changed

- `AGENTS.md`
- `README.md`
- `index.html`
- `styles.css`
- `src/app.js`
- `src/domain.js`
- `src/store.js`
- `src/sync-auth.js`
- `sync-config.js`
- `scripts/open_local.py`
- `scripts/close_local.py`
- `scripts/serve_local.py`
- `server/server.mjs`
- `scripts/backup_garden.mjs`
- `package.json`
- `打开学术花园.cmd`
- `关闭学术花园.cmd`
- `启动同步版学术花园.cmd`
- `docs/art-asset-rules.md`
- `docs/backend-sync-plan.md`
- `docs/server-maintenance.md`
- `docs/web-runtime-deprecated.md`
- `docs/pending-changes.md`

### Verification

- Ran `node --check src/app.js`.
- Ran `node --check src/domain.js`.
- Ran `node --check src/store.js`.
- Ran `node --check src/sync-auth.js`.
- Ran `node --check sync-config.js`.
- Ran `node --check server/server.mjs`.
- Ran `node --check scripts/backup_garden.mjs`.
- Parsed `package.json` with `node -e`.
- Searched the root web files and web/backend docs for `DEPRECATED` markers.

### Notes

- Existing unrelated local work was left untouched.
- OpenClaw deploy needed: no.

## 2026-06-03 - Homepage early growth map sizing fix

### Summary

- Superseded: this was a web-runtime patch made after the project direction had already moved to the Godot mobile prototype. The root browser app is now explicitly marked deprecated.
- Shrank homepage map sprites for seed/sowing stages so newly planted items appear as tiny ground-level sprouts near the soil instead of filling a whole plot.
- Reduced sapling/growing stages so seedlings remain visibly smaller than mature trees.
- Reduced course flower bloom/fruit/seed-saved map sizing so flower stages do not read as tree-sized objects on the field.
- Kept the existing plant data, stage routing, and save files unchanged.

### Files Changed

- `styles.css`
- `docs/pending-changes.md`

### Verification

- Ran `node --test scripts/domain.test.mjs`.
- Confirmed the target desktop and mobile CSS overrides are present for seed/sowing, sapling/growing, and course flower map stages.
- Attempted Browser plugin QA at `http://127.0.0.1:8765/`, but the browser runtime failed twice with `windows sandbox failed: spawn setup refresh`; no fallback browser dependencies were installed.

### Notes

- No new visual assets were generated for this slice.
- Existing unrelated local work was left untouched.
- OpenClaw deploy needed: no.

## 2026-06-03 - Godot runtime layout debug mode

### Summary

- Added a runtime layout debug mode to the Godot prototype, toggled with `F2`.
- In debug mode, plants, placed decorations, decoration placement slots, and distant house hotspots can be selected and dragged directly on the running map.
- Added selected-item size adjustment with `[` and `]` for plants/decorations/hotspots.
- Added debug export with `\` and an `Export layout` overlay button, writing current positions and sizes to both `user://layout_debug_export.json` and `godot-prototype/layout_debug_export.json` for handoff before baking final coordinates into the project.
- Ignored `godot-prototype/layout_debug_export.json` so future debug exports do not dirty the repository after the layout has been baked.
- Added layout version protection so existing-save migration no longer overwrites manual position changes after the current layout version has been applied.
- Documented the debug controls in `godot-prototype/README.md`.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/README.md`
- `.gitignore`
- `docs/pending-changes.md`

### Verification

- Launched the Godot project through MCP debug mode after adding the layout debugger; output reported the Vulkan device and no errors or warnings.
- Stopped the MCP debug run cleanly; final output had no errors or warnings.

### Notes

- Existing unrelated local web app, docs, and root asset changes were left untouched.
- This is a local Godot prototype/debug tooling slice. OpenClaw deploy needed: no.

## 2026-06-03 - Godot generated map and rebuilt plant portrait pass

### Summary

- Replaced the visibly stitched Godot portrait map with a new unified generated active garden entrance map.
- Derived harvested and dormant v4 map variants from the same generated map so all three Godot zones avoid the old broken/patched background.
- Rebuilt the Sprout tree/flower runtime assets into two project-specific sets: map sprites with shared ground anchors, shadows, and paper/course badges; and larger portrait sprites for mobile detail panels.
- Added lightweight in-engine plant motion using `_process` scale pulses instead of baked animation frames.
- Reworked the plot detail UI into a mobile overlay: portrait illustration on top, status/title/log/note content below, without shrinking or scrambling the map.
- Updated fresh seed data and existing-save migration so map paths, plot coordinates, rebuilt sprites, and portrait sprites stay compatible with local JSON saves.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/README.md`
- `godot-prototype/assets/art/godot-active-entry-gpt-v1-source.png`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-active-gpt-v4.png`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-harvested-gpt-v4.png`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-dormant-gpt-v4.png`
- `godot-prototype/assets/sprites/sprout/plants-rebuilt/*.png`
- `godot-prototype/assets/sprites/sprout/portraits/*.png`
- `docs/pending-changes.md`

### Asset Notes

- Used the built-in image generation tool for the new active entrance map, then copied the source into `godot-prototype/assets/art/godot-active-entry-gpt-v1-source.png`.
- Prompt constraints: vertical mobile game home map, cohesive Sprout Lands-inspired pixel-art academic garden, 390:844 portrait composition, distant cottage and greenhouse, natural paths/fences/water/decor, 9 integrated soil beds, no UI, no labels, no seams, no collage or stitched grass.
- App-ready map files were resized to `780x1240` under `godot-prototype/assets/sprites/sprout/maps/`.
- Harvested and dormant maps are local color/mood variants of the generated active map.
- Plant map sprites and detail portraits were locally derived with Pillow from the existing Sprout stage sprites, preserving the original plant silhouettes while adding ground anchors, shadows, project badges, and detail-friendly framing.

### Verification

- Visually inspected the generated active map and rebuilt paper/course portrait assets.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`; JSON parsed successfully.
- Verified key new asset paths exist: source map, active v4 map, rebuilt course sprite, and course portrait sprite.
- Launched the Godot project through MCP debug mode after the v4 map/detail rewrite; output reported the Vulkan device and no errors.
- Stopped the MCP debug run cleanly; final output had no errors.

### Notes

- Existing unrelated local web app, docs, and root asset changes were left untouched.
- This is a local Godot prototype/static asset slice. OpenClaw deploy needed: no.

## 2026-06-03 - Godot immersive portrait garden map redo

### Summary

- Removed the menu-first Godot startup flow; the prototype now launches directly into the active garden map.
- Reworked the main Godot UI into a lightweight mobile HUD: compact title/coin header, large map stage, optional plant detail drawer, and fixed-size bottom decoration inventory strip.
- Replaced the broken/tiled entry map usage with portrait runtime maps derived from the existing unified Sprout map backgrounds.
- Kept three-garden navigation in the game world: distant house/greenhouse hotspots switch active, harvested, and dormant gardens instead of opening list-style buttons.
- Repositioned the active garden's 9 plot anchors into a clean 3x3 planting area on the portrait map, with harvested/dormant plot and decoration anchors moved onto stable map ground.
- Added a startup migration for existing local Godot saves so old saved plot/decor coordinates are moved to the new portrait map anchors without resetting visits, logs, status, coins, or inventory.
- Preserved local JSON loading/saving, plot visit/log updates, decoration inventory counts, placement, and removal behavior.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/README.md`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-active-portrait-v1.png`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-harvested-portrait-v1.png`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-dormant-portrait-v1.png`
- `docs/pending-changes.md`

### Asset Notes

- No GPT-Image-2 generation was used.
- The three portrait map PNGs were locally derived with Pillow from the existing `sprout-map-*-gpt-v3-empty.png` backgrounds.
- The portrait maps preserve the distant buildings, paths, fences, water, and garden edges from the existing unified maps, then extend the lower playable planting area with grass sampled from the same source maps.

### Verification

- Queried Godot MCP project info; it recognized `godot-prototype` with Godot `4.6.3.stable.official.7d41c59c4`, 1 scene, 1 script, and 516 assets.
- Launched the Godot project through MCP debug mode after the rewrite; output reported the Vulkan device and no errors or warnings.
- Stopped the MCP debug run cleanly; final output had no errors or warnings.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`; JSON parsed successfully and confirmed the active garden still has 9 plots.
- Verified the three new portrait map files exist.
- Searched `godot-prototype/scripts/main.gd` and `godot-prototype/README.md` for old entry/menu strings (`Choose a garden`, `screen_mode`, `entry scene`, `garden tabs`, `Home`); no stale runtime entry flow remains.

### Notes

- Existing unrelated local web app, docs, and root asset changes were left untouched.
- This is a local Godot prototype/static asset slice. OpenClaw deploy needed: no.

## 2026-06-03 - Godot three-garden mobile demo slice

### Summary

- Expanded the separate Godot prototype from a tappable 9-plot skeleton into a basic mobile demo.
- Imported the existing runtime sprites, art source files, and user-provided Sprout Lands source pack into `godot-prototype/assets/`.
- Added an entry scene flow with three garden choices: active, harvest, and dormant.
- Reworked the main demo screen around a portrait mobile layout with garden tabs, map backgrounds, plant overlays, decoration overlays, a detail card, and a decoration inventory bar.
- Preserved the local-first prototype mechanism by extending the JSON data model for zones, plots, visits, progress logs, coins, decoration catalog, owned decoration counts, and placed decorations.
- Added basic decoration interactions: select an owned decoration, tap a placement slot, and tap a placed decoration to return it to inventory.

### Files Changed

- `godot-prototype/project.godot`
- `godot-prototype/scenes/main.tscn`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/README.md`
- `godot-prototype/assets/art/**`
- `godot-prototype/assets/source-art/**`
- `godot-prototype/assets/sprites/**`
- `docs/pending-changes.md`

### Asset Notes

- No GPT-Image-2 generation was needed for this slice.
- Runtime sprites and composed map backgrounds were copied from the existing project assets under `assets/sprites/` and `assets/art/`.
- The original user-provided Sprout Lands art packs were copied under `godot-prototype/assets/source-art/` for future Godot-side slicing and adjustment.
- The demo currently composes existing map backgrounds, stage sprites, ground sprites, and decoration sprites in Godot UI layers sized for a portrait mobile window.

### Verification

- Ran Godot 4.6.3 headless validation for `godot-prototype`; it completed with no parse errors and no missing-resource errors.
- Launched the Godot project through MCP debug mode and stopped it; final output reported the Vulkan device and no warnings or errors.
- Verified key imported paths exist under `godot-prototype/assets/sprites/sprout/`, including maps, decorations, and stage sprites.

### Notes

- Existing unrelated local web app, docs, and art changes were left untouched.
- This is a local Godot prototype/static asset slice. OpenClaw deploy needed: no.

## 2026-06-03 - Godot mobile prototype bootstrap

### Summary

- Added a separate Godot 4.6.3 Standard prototype project under `godot-prototype/` without touching the existing web app runtime.
- Configured the prototype for a 390 x 844 portrait viewport.
- Added a first vertical slice with 9 tappable garden plots, local seed JSON, local `user://garden_state.json` saving, a detail card, and a simple progress log button.
- Copied a small set of existing Sprout Lands stage sprites into the prototype so the first run has real plant visuals.

### Files Changed

- `godot-prototype/project.godot`
- `godot-prototype/scenes/main.tscn`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/README.md`
- `godot-prototype/assets/sprites/stages/*`
- `docs/pending-changes.md`

### Asset Notes

- No new GPT-Image-2 generation was needed.
- Runtime prototype sprites were copied from existing Sprout Lands stage assets under `assets/sprites/sprout/stages/`.
- The prototype loads PNGs directly with `Image.load()` / `ImageTexture.create_from_image()` so the first headless run does not depend on editor-side import metadata.

### Verification

- Confirmed Godot version `4.6.3.stable.official.7d41c59c4`.
- Initial sandboxed headless Godot run crashed while trying to create `user://logs`; this was an environment permission issue, not a project script error.
- Re-ran headless project validation with normal Godot user-data access; the project loaded successfully after switching direct PNG loading on.
- Queried Godot MCP project info; it recognized `godot-prototype` with 1 scene, 1 script, and 8 assets.

### Notes

- Existing unrelated local web app, docs, and art changes were left untouched.
- This is a local prototype/static asset slice. OpenClaw deploy needed: no.

## 2026-06-02 - Sprout Lands 2.0 art rebuild slice

### Summary

- Rebuilt the homepage farm visual direction around Sprout Lands assets instead of the previous GPT-painted garden backgrounds.
- Added three Sprout Lands composite maps for active, harvested, and dormant zones while preserving the existing 9 plots, zone switching, plant click behavior, move mode, and decoration placement logic.
- Routed paper tree and course flower varieties/stages to Sprout Lands tree, fruit, farming-plant, and flower sprites under `assets/sprites/sprout/`.
- Replaced the decoration shop/runtime decoration sprites with Sprout Lands objects and expanded the existing fixed slots to 10 centralized `DECORATIONS` entries in `src/domain.js`.
- Re-skinned the HUD, wallet, tabs, toolbar, shop cards, project cards, dialogs, inputs, buttons, inventory-like slots, and preview grounds with Sprout Lands UI/font assets.
- Added mobile layout fixes so the HUD sits above the map and the farm toolbar uses a 2x2 action grid with short zone labels.
- Added Sprout Lands attribution/licensing notes to `README.md` and updated `docs/art-progress.md`.

### Files Changed

- `README.md`
- `docs/art-progress.md`
- `docs/pending-changes.md`
- `scripts/domain.test.mjs`
- `src/domain.js`
- `styles.css`
- `assets/art/sprout-source-contact-v1.png`
- `assets/art/sprout-components-v1/*`
- `assets/art/sprout-map-active-v1-source.png`
- `assets/art/sprout-map-harvested-v1-source.png`
- `assets/art/sprout-map-dormant-v1-source.png`
- `assets/sprites/sprout/**`

### Asset Notes

- No GPT-Image-2 generation was needed for this slice.
- Source art came from the user-provided, purchased Sprout Lands packs under `2.0美术重构/`: Sprites Basic, Sprites premium, and UI Pack Basic.
- `assets/art/sprout-source-contact-v1.png` and `assets/art/sprout-components-v1/*` document the source sheets and numbered crop candidates used for slicing.
- `assets/sprites/sprout/maps/sprout-map-*-v1.png` were locally composed from Sprout Lands grass, tilled dirt, path, water, fence, wooden house, tree, flower, well, workbench, sign, and bridge sprites.
- `assets/sprites/sprout/stages/*` were locally cropped from Sprout Lands fruit tree, tree/bush, farming plant, mushroom/flower/stone sheets to preserve the existing paper/course lifecycle stage semantics.
- `assets/sprites/sprout/decor/*`, `assets/sprites/sprout/ui/*`, and `assets/sprites/sprout/ground/*` were locally cropped or copied from Sprout Lands object/UI sheets and font files.

### Verification

- Ran `node --check src\app.js`.
- Ran `node --check src\domain.js`.
- Ran `npm test`; 29 tests passed.
- Ran `git diff --check`; only existing CRLF normalization warnings were reported.
- Ran a magenta/chroma-key scan across `assets/sprites/sprout/**/*.png`; 0 magenta pixels found.
- Started local preview at `http://127.0.0.1:4173/`.
- Browser plugin tools were not exposed by tool search, so rendered QA used bundled Playwright with system Microsoft Edge.
- Verified desktop 1365x900 and mobile 390x844:
  - page title matched `Academic Garden | 学术花园`;
  - active and harvested Sprout map backgrounds were present;
  - shop opened from the farm toolbar;
  - 10 shop cards rendered;
  - farm zone switching changed the homepage map to `harvested`;
  - no horizontal overflow at either viewport;
  - no relevant console errors or warnings.
- Captured QA screenshots under `%TEMP%`: `academic-garden-sprout-active-debug.png`, `academic-garden-sprout-desktop-v2.png`, and `academic-garden-sprout-mobile-v3.png`.

### Notes

- Existing unrelated `AGENTS.md` local change was left untouched.
- Existing untracked full-stage sprite work under `assets/sprites/stages/*-full.png` was left untouched.
- This is GitHub Pages frontend/static asset work. OpenClaw deploy needed: no.

## 2026-06-02 - Homepage farm lifecycle, motion, and decoration closure

### Summary

- Restored distinct homepage/card/detail lifecycle sprite routing for paper tree `tree`, `flower`, and `fruit` stages with full-height derived tree assets instead of the cropped stage PNGs or a single collapsed variety sprite.
- Added distinct course flower `seed_saved` runtime sprites so `bloom`, `fruit`, and `seed_saved` no longer render as the same image.
- Added lightweight homepage ambience and plant motion: stage sprites sway subtly, leaves/petals drift, and a small bird accent moves behind the playable map layer with `prefers-reduced-motion` support.
- Tightened 390px mobile layout overflow and changed map plant name plaques to hover/focus tags so dense gardens no longer look like labels pasted over stems.
- Kept active/harvested/dormant homepage map entrances consistent and verified the dormant entrance switches only the homepage farm area.
- Reworked decoration slot labels, shop/warehouse ownership copy, occupied-slot swap targets, decoration sizing, and slot coordinates so map placement, shop preview, and move mode communicate the same target slots.

### Files Changed

- `src/domain.js`
- `src/app.js`
- `styles.css`
- `scripts/domain.test.mjs`
- `assets/sprites/stages/paper-camphor-tree-full.png`
- `assets/sprites/stages/paper-camphor-flower-full.png`
- `assets/sprites/stages/paper-camphor-fruit-full.png`
- `assets/sprites/stages/paper-cherry-tree-full.png`
- `assets/sprites/stages/paper-cherry-flower-full.png`
- `assets/sprites/stages/paper-cherry-fruit-full.png`
- `assets/sprites/stages/paper-ginkgo-tree-full.png`
- `assets/sprites/stages/paper-ginkgo-flower-full.png`
- `assets/sprites/stages/paper-ginkgo-fruit-full.png`
- `assets/sprites/stages/paper-maple-tree-full.png`
- `assets/sprites/stages/paper-maple-flower-full.png`
- `assets/sprites/stages/paper-maple-fruit-full.png`
- `assets/sprites/stages/paper-pine-tree-full.png`
- `assets/sprites/stages/paper-pine-flower-full.png`
- `assets/sprites/stages/paper-pine-fruit-full.png`
- `assets/sprites/stages/paper-willow-tree-full.png`
- `assets/sprites/stages/paper-willow-flower-full.png`
- `assets/sprites/stages/paper-willow-fruit-full.png`
- `assets/sprites/stages/course-daisy-seed_saved-map.png`
- `assets/sprites/stages/course-hydrangea-seed_saved-map.png`
- `assets/sprites/stages/course-lavender-seed_saved-map.png`
- `assets/sprites/stages/course-lotus-seed_saved-map.png`
- `assets/sprites/stages/course-rose-seed_saved-map.png`
- `assets/sprites/stages/course-sunflower-seed_saved-map.png`
- `docs/pending-changes.md`

### Asset Notes

- No new GPT-Image-2 generation was needed for this slice.
- The eighteen `paper-*-tree-full.png`, `paper-*-flower-full.png`, and `paper-*-fruit-full.png` runtime sprites were derived locally from the complete `tree-*.png` assets, with small flower/fruit marker overlays added to preserve stage differences while keeping full trunks, canopies, and bases.
- The six `course-*-seed_saved-map.png` runtime sprites were derived locally from the existing `course-*-seed_saved.png` / fruit-stage sprites by adding a small seed-saved marker treatment, preserving alpha transparency.
- No source sheets were added; the derived runtime sprites live under `assets/sprites/stages/` because they are app-ready transparent PNGs.

### Verification

- Ran initial baseline checks: `git status --short`; `git diff -- src/app.js styles.css index.html src/domain.js scripts/domain.test.mjs docs/pending-changes.md`; `node --check src\app.js`; `node --test scripts\domain.test.mjs scripts\server.test.mjs`.
- Watched new domain regression tests fail before changing production sprite routing, then pass after the fix.
- Ran `node --check src\app.js`.
- Ran `node --test scripts\domain.test.mjs scripts\server.test.mjs`; 24 tests passed.
- Ran `git diff --check`; only existing Windows line-ending warnings were reported.
- Ran a native PowerShell/System.Drawing chroma-key scan on the 24 new derived runtime sprites; 0 magenta pixels found.
- Started local preview at `http://127.0.0.1:4173/`.
- Browser plugin attempt failed with a Windows sandbox startup error (`windows sandbox failed: spawn setup refresh`), so rendered QA used headless Microsoft Edge via CDP.
- Captured desktop and 390px fixture screenshots with seeded active/harvested/dormant plants and owned decorations; verified lifecycle stages are distinct, sprites remain inside the map, decorations sit on their slots, and mobile `scrollWidth` stays 390.
- Re-rendered fixture screenshots after replacing cropped tree stage PNGs with full-height tree stage assets; verified mature trees now show complete trunks, canopies, and bases on desktop and 390px mobile.
- Used CDP interaction checks at 390px to verify the dormant homepage entrance switches `selectedFarmZone` to `dormant`, leaves project management hidden, shop opens from the toolbar, and a decoration drop target center matches the final decoration landing center (`centerDelta: { x: 0, y: 0 }`).

### Notes

- Existing unrelated `AGENTS.md` local change was left untouched.
- Temporary QA helper files used for IndexedDB seeding and CDP checks were removed before final verification.
- This is GitHub Pages frontend/domain asset work. OpenClaw deploy needed: no.

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
