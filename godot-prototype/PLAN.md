# Godogen Optimization Plan: Academic Garden Godot Prototype

Audit date: 2026-06-19

Active target: `godot-prototype/` mobile portrait Godot 4.6.3 prototype. The root web runtime is historical reference only.

## Current Evidence

- `godot-prototype/scripts/main.gd` is a 5078-line single script with 270 `func` declarations. It owns save/import/export, economy, UI construction, map rendering, detail panels, onboarding, shop flows, debug layout, resource loading, animation, and visual effects.
- `godot-prototype/data/garden_seed.json` is valid JSON and currently defines active/harvested/dormant zones with 9/12/9 plots, 5 decorations per zone, 10 decoration catalog entries, and 10 owned-decoration counters.
- Runtime resource references in seed data resolve locally. Static asset verification reports zero missing resources, zero stage animation errors, zero safe-margin errors, zero course flower slice errors, zero audio import errors, zero UI sprite errors, and zero unstable mature paper-stage paths.
- `verify_detail_ui.ps1` passes.
- Godot 4.6.3 headless script check passes.
- Godot 4.6.3 headless startup for 3 seconds passes and logs layout version 30.
- `verify_mobile_layout.ps1` now captures direct viewport PNGs for both the 390x844 baseline and a taller 430x932 mobile portrait size. It no longer depends on Godot movie-maker frame dimensions, which stay pinned to the project viewport override on Windows.
- `verify_save_migration.ps1` loads fixture saves through the real main scene and verifies legacy course stage migration, layout-version position behavior, planted-variety unlock preservation, owned-decoration backfill, export checksum validation, and future-schema rejection.
- `verify_economy_balance.ps1` calls the live economy functions through the real main scene and verifies daily growth examples, deterministic coin examples, settlement zone rules, milestone growth/no-direct-coin behavior, seed unlock prices, and representative player-income bands.
- The first `main.gd` decomposition slice is complete: economy constants and pure formulas now live in `godot-prototype/scripts/economy_rules.gd`, while `main.gd` keeps compatibility wrappers for existing UI and verification calls.
- The second `main.gd` decomposition slice is complete: plant lifecycle flow, legacy course stage migration, plant variety base parsing, default stage growth, and normalized stage sprite path construction now live in `godot-prototype/scripts/plant_rules.gd`.
- The third `main.gd` decomposition slice is complete: export payload creation, save checksums, import payload validation, schema ceiling checks, and required save-data shape checks now live in `godot-prototype/scripts/save_rules.gd`.
- The fourth `main.gd` decomposition slice is complete: layout sizing and scaling constants now live in `godot-prototype/scripts/layout_rules.gd`; position anchors and hotspots remain in `main.gd` because they are still tightly coupled to map rendering and migration.
- `godot-prototype/ASSETS.md` now defines the Godot runtime/source/review asset contract, direct-edit exceptions, deprecated web asset boundary, and required verification for future art changes.
- `docs/combined-review-snapshot.md` now records the current large worktree shape, Godogen optimization files, known concurrent work buckets, verification evidence, and final review checklist before any combined staging/push.
- The worktree has substantial unrelated concurrent work. `docs/combined-review-snapshot.md` recorded 1864 tracked deletions, 206 tracked modifications, and 91 untracked files before the snapshot file itself was added; counts may drift as review artifacts are added. This must be reviewed before any combined push.
- `godot-prototype/scripts/preview_android.ps1` now configures a local JDK for Android signing when `JAVA_HOME` is not globally set. A full Android preview/export run passed on the local emulator: fresh debug APK export, APK signing/verification, install, launch, screenshot capture, and logcat capture completed. The latest Android log reports `platform_android=true`, viewport `390x866`, window `1080x2400`, and safe-area top inset `136`.

## Risk Tasks

### 1. Runtime Layout Proof For Real Mobile Portrait

- **Why isolated:** Headless startup passes, but the logged headless viewport is `844x844`, while the product target is portrait `390x844`. Layout regressions can hide in headless checks.
- **Approach:** Add or standardize a deterministic mobile capture path that launches the main scene at 390x844, captures active/harvested/dormant maps, detail panel, seed shop, decoration shop, record drawer, backup panel, onboarding, and remove confirmation.
- **Status:** The deterministic capture path now saves named viewport screenshots for active, harvested, dormant, detail, record drawer, seed shop, decoration shop, backup panel, onboarding, and remove confirmation at both 390x844 and 430x932.
- **Verify:** Fresh screenshots or video show no text overlap, clipped plant sprites, inaccessible buttons, or bottom toolbar crowding at 390x844 and one taller mobile size. Runtime logs have no missing resource or script errors.

### 2. Split The Monolithic `main.gd` Into Stable Boundaries

- **Why isolated:** The single-script shape makes every feature change risky because UI, economy, save migration, resource loading, and debug tools share one edit surface.
- **Approach:** First extract pure or near-pure logic into small GDScript resources/scripts without changing visible behavior: save schema/migration, economy calculation, stage/variety lookup, resource path resolution, and layout constants. Keep the main scene ownership unchanged until tests prove parity.
- **Status:** Economy calculation, plant lifecycle/resource path rules, save import/export contract rules, and layout sizing constants are extracted behind stable `main.gd` wrappers. Remaining higher-coupling layout anchors/hotspots should stay in `main.gd` unless a future slice adds stronger visual migration coverage.
- **Verify:** Before and after extraction, JSON validation, asset verification, detail UI static checks, Godot script check, and 3-second startup all pass. A temporary save migration run preserves selected zone, coins, unlocked varieties, plot stages, care values, and owned decorations.

### 3. Save Schema And Migration Regression Harness

- **Why isolated:** The prototype has active migration paths for layout version, old course stage keys, unlocked varieties, and saved map data. Regressions here can silently damage a real personal save.
- **Approach:** Create sample save fixtures for new seed data, old course stage names, missing unlocked varieties, old layout positions, imported backup payloads, and harvested/dormant edge cases.
- **Status:** Save migration verification now loads fixture saves through the real main scene and covers legacy layout migration, old course stage names, planted-variety unlock preservation, owned-decoration backfill, export checksum validation, raw data import, and future-schema rejection.
- **Verify:** A command-line or headless test loads each fixture into a temporary `user://`, runs migration, saves, and asserts schema version, layout version, stage normalization, no duplicate plot IDs, no missing variety unlocks for planted varieties, and stable export/import checksum behavior.

### 4. Economy Balance Guard

- **Why isolated:** Daily settlement, growth, harvested passive income, seed unlock prices, and decoration prices interact. Small formula changes can make the reward loop feel either stingy or inflated.
- **Approach:** Add a deterministic balance script with representative light, normal, heavy, and historical-garden profiles. Keep AI or keyword classification outside numeric reward decisions.
- **Status:** Economy balance verification now exercises live formulas through the real main scene and checks daily growth, coin caps, zone settlement rules, milestone growth/no-direct-coin behavior, seed unlock prices, and representative income bands documented in `docs/economy-system.md`.
- **Verify:** Simulated daily income remains within documented expectations in `docs/economy-system.md`; stage advancement grants growth but no direct coins; dormant plants do not settle; harvested plants produce fixed-growth income; per-plant coin cap is enforced.

### 5. Art Source And Runtime Asset Contract

- **Why isolated:** The worktree intentionally deletes many historical/source art files while adding new runtime sprites. Future edits need clarity on which sources must be retained under `assets/art/` and which runtime sprites are authoritative under `assets/sprites/`.
- **Approach:** Produce an asset manifest that classifies source sheets, generated review/contact sheets, app-ready sprites, deprecated web assets, and safe-to-delete intermediates. Keep prompts and slicing notes for GPT-Image-2 generated assets.
- **Status:** Asset contract manifest added at `godot-prototype/ASSETS.md`; the large current deletion set still needs final human review before combined staging/push.
- **Verify:** Asset verification still passes; every runtime sprite has either an explicit source asset or a documented direct-edit exception; deleted sources are intentionally listed before the combined push.

## Main Optimization Plan

1. **Stabilize verification first.**
   - Add mobile portrait visual proof for the main scene.
   - Keep the current static checks as fast gates.
   - Make the Godot executable path configurable in scripts so verification does not depend on PATH.

2. **Protect user data.**
   - Build save/import/migration fixtures before further feature work.
   - Treat backup/export/import as a core product flow, not a debug utility.
   - Add explicit checks for old saves using legacy course keys and missing unlock metadata.

3. **Reduce script blast radius.**
   - Extract pure logic from `main.gd` in small slices.
   - Avoid scene restructuring until behavior parity is proven.
   - Target first extractions: economy, lifecycle/stage mapping, save migration, resource lookup, and layout constants.

4. **Make the garden loop clearer.**
   - Finish the naming pass for paper lifecycle stages.
   - Clarify seed shop vs decoration shop vs warehouse modes with icon-forward UI.
   - Keep records low-pressure: care feedback should confirm progress without turning the app into a task tracker.

5. **Deepen visual feedback without adding fragile scope.**
   - Add stronger but lightweight state feedback for daily settlement, stage advancement, harvested garden review, dormant wake-up, and seed unlocks.
   - Prefer existing Sprout Lands and existing generated assets before new generation.
   - Generate new assets with GPT-Image-2 only when the current library lacks the needed item.

6. **Prepare for mobile QA and combined review.**
   - Keep Android preview/export as the platform gate after export, Android, or release-candidate changes; the latest run passed on the local emulator and wrote `godot-prototype/exports/android-qa-preview-latest.png` plus logcat.
   - Review `docs/pending-changes.md`, `docs/combined-review-snapshot.md`, full `git status`, and the large deletion set before staging.
   - Keep web-runtime deletions and Godot product changes accounted for separately.

## Verification Checklist For Future Slices

- `python -m json.tool godot-prototype/data/garden_seed.json`
- `python scripts/verify_godot_garden_assets.py`
- `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_mobile_layout.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_save_migration.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_economy_balance.ps1`
- `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`
- `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`
- Mobile portrait screenshot or video proof for any visual/layout/UI change.
- Android preview/export when platform behavior or export settings change.
- `git diff --check` for intentionally touched text files, treating CRLF warnings separately from real whitespace errors.

## Open Decisions

- Should `PLAN.md` live at `godot-prototype/PLAN.md` permanently, or should the project keep Godogen state files at repository root?
- Should deleted source/intermediate art files be committed as intentional cleanup, or moved to an archival folder before the combined push?
- Should Android emulator proof be required for every release-candidate review, or only when Android/export/platform behavior changes? Current recommendation: direct viewport captures for routine layout regression, Android emulator proof for release/export confidence.
