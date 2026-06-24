# Pending Changes

## 2026-06-24 - Prepare combined Godot update push

### Summary

- Reviewed the large combined worktree before pushing the current Godot mobile prototype update.
- Confirmed the update includes Godot prototype optimization, verification harnesses, Android preview hardening, current runtime art changes, and deprecated web-runtime cleanup already recorded in earlier pending-change entries.
- Re-ran the current verification gates immediately before staging and pushing.

### Files Changed

- `docs/pending-changes.md`
- Combined changes already listed in the 2026-06-19 pending entries and `docs/combined-review-snapshot.md`.

### Verification

- Ran `git fetch origin`; local `main` was aligned with `origin/main` before committing.
- Reviewed `git status --porcelain=v1` summary: 2169 status entries, including 1864 tracked deletions, 206 tracked modifications, and 99 untracked entries.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_save_migration.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_economy_balance.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\preview_android.ps1 -GodotExe 'D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe'`.
- Reviewed `godot-prototype/exports/android-qa-preview-latest.png` and latest logcat; Android launched the app and reported `platform_android=true`, viewport `390x866`, window `1080x2400`, and safe-area top inset `136`.
- Ran `git diff --check`; only normal CRLF warnings appeared.

### Notes

- `gh` is not installed in this environment, so no GitHub CLI or PR flow was attempted.
- This entry records the final combined push preparation, not a separate gameplay or asset change.

## 2026-06-19 - Harden Android preview Java setup

### Summary

- Added local JDK discovery to the Godot Android preview script so `apksigner.bat` can sign APKs even when `JAVA_HOME` is not globally configured.
- Kept the new Java setup scoped to the preview script process and allowed an explicit `-JavaHome` override.
- Re-ran the full Android preview/export flow and updated `godot-prototype/PLAN.md` with the emulator proof.

### Files Changed

- `godot-prototype/scripts/preview_android.ps1`
- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`
- Generated/updated preview artifacts under `godot-prototype/exports/`, including `academic-garden-prototype-debug.apk`, `android-qa-preview-latest.png`, and `android-qa-preview-latest-logcat.txt`.

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\preview_android.ps1 -GodotExe 'D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe'`.
- The script exported a fresh debug APK, signed and verified it, installed it on the local Android emulator, launched `org.academicgarden.prototype`, and captured a screenshot plus logcat.
- Reviewed `godot-prototype/exports/android-qa-preview-latest.png`; the Android first screen is visible with the portrait garden layout, safe-area-adjusted header, and bottom warehouse controls in frame.
- Reviewed latest logcat; Godot reached `OnGodotMainLoopStarted` and printed `platform_android=true`, viewport `390x866`, window `1080x2400`, and safe-area top inset `136`.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_save_migration.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_economy_balance.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.
- Ran `git diff --check` for touched text files; only normal CRLF warnings appeared.

### Notes

- No gameplay, visual asset, seed data, or export preset behavior was intentionally changed in this slice.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-19 - Add combined review snapshot

### Summary

- Added a combined review snapshot for the current large local worktree before any final staging, commit, push, or pull request.
- Recorded the current `git status --porcelain=v1` shape, largest change buckets, Godogen optimization files, known concurrent work to keep separate, verification evidence, and final review checklist.
- Updated `godot-prototype/PLAN.md` to reference the snapshot as part of combined review preparation.

### Files Changed

- `docs/combined-review-snapshot.md`
- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`

### Verification

- Ran `git status --porcelain=v1` and grouped entries by status/path category.
- Reviewed 2026-06-19 entries in `docs/pending-changes.md`.
- Ran `git diff --check` for the touched text files; only normal CRLF warnings appeared.

### Notes

- No code or visual assets were changed in this slice.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-19 - Add taller mobile viewport proof

### Summary

- Updated the mobile layout capture scene to save direct named viewport PNGs for each required UI state.
- Updated the mobile layout verification wrapper to prefer direct named captures over Godot movie-maker frames and to validate both `390x844` and taller `430x932` portrait outputs by default.
- Fixed a capture timing race so screenshots are not saved before the first requested view is selected.
- Updated `godot-prototype/PLAN.md` to replace the old movie-maker limitation note with the new direct viewport proof status.

### Files Changed

- `godot-prototype/scripts/mobile_layout_capture.gd`
- `godot-prototype/scripts/verify_mobile_layout.ps1`
- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`
- `godot-prototype/screenshots/mobile-layout/390x844/`
- `godot-prototype/screenshots/mobile-layout/430x932/`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_save_migration.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_economy_balance.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.

### Notes

- No visual assets were generated, moved, deleted, or restored.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-19 - Extract layout sizing constants

### Summary

- Added a layout rules script for harvested page size, map aspect ratio, root margin, plot size tables, decor base size, map plant scale, ground anchor ratio, and decor size scale values.
- Updated `main.gd` to keep existing layout constant names as compatibility aliases while delegating sizing values to `layout_rules.gd`.
- Updated the detail UI and asset verification scripts so static layout guard snippets can live in the extracted layout rules script.
- Left map position anchors, decoration anchors, slots, and zone hotspots in `main.gd` because they remain coupled to rendering and save layout migration behavior.
- Updated `godot-prototype/PLAN.md` to record the fourth completed `main.gd` decomposition slice.

### Files Changed

- `godot-prototype/scripts/layout_rules.gd`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_save_migration.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_economy_balance.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.

### Notes

- No visual assets were generated, moved, deleted, or restored.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-19 - Extract save import/export contract rules

### Summary

- Added a pure save rules script for export payload construction, save checksums, import payload validation, schema ceiling checks, and required save-data shape checks.
- Updated `main.gd` to keep the existing `_make_export_payload`, `_extract_import_data`, `_save_checksum`, and `_is_valid_save_data` wrapper names while delegating save contract logic to `save_rules.gd`.
- Preserved file IO, FileDialog behavior, import backup writing, save migration, UI status updates, and render flow in `main.gd`.
- Updated `godot-prototype/PLAN.md` to record the third completed `main.gd` decomposition slice.

### Files Changed

- `godot-prototype/scripts/save_rules.gd`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_save_migration.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_economy_balance.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.

### Notes

- No visual assets were generated, moved, deleted, or restored.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-19 - Extract plant lifecycle and sprite path rules

### Summary

- Added a pure plant rules script for lifecycle order, legacy course stage-key migration, next/final stage checks, default stage growth, plant variety base parsing, normalized stage sprite path construction, and sprite base cleanup.
- Updated `main.gd` to keep existing lifecycle/resource helper names as compatibility wrappers while delegating the extracted logic to `plant_rules.gd`.
- Updated the asset and detail UI verification scripts so static guard snippets can live in the extracted rules script without weakening their existing checks.
- Updated `godot-prototype/PLAN.md` to record the second completed `main.gd` decomposition slice.

### Files Changed

- `godot-prototype/scripts/plant_rules.gd`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_save_migration.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_economy_balance.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.

### Notes

- No visual assets were generated, moved, deleted, or restored.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-19 - Add Godot asset contract manifest

### Summary

- Added a Godogen-resumable asset contract manifest for the Godot prototype.
- Classified runtime sprites, source/review art, direct-edit exceptions, deprecated web-runtime assets, and required verification for future asset work.
- Updated `godot-prototype/PLAN.md` to mark the asset contract slice as documented while leaving the large current deletion set for final combined review.

### Files Changed

- `godot-prototype/ASSETS.md`
- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`

### Verification

- Reviewed `docs/art-progress.md` and `docs/art-asset-rules.md`.
- Ran `python scripts\verify_godot_garden_assets.py`.

### Notes

- No assets were generated, moved, deleted, or restored in this slice.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-19 - Extract pure economy rules from main.gd

### Summary

- Added a small pure economy rules script for growth, daily coin, and variety unlock price calculations.
- Updated `main.gd` to keep its existing economy function names as compatibility wrappers while delegating the formulas and economy constants to the new script.
- Preserved existing UI/test call sites, including detail panel estimated coins, daily settlement, milestone checks, and seed shop unlock prices.
- Updated `godot-prototype/PLAN.md` to record the first completed `main.gd` decomposition slice.

### Files Changed

- `godot-prototype/scripts/economy_rules.gd`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_save_migration.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_economy_balance.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.

### Notes

- No new visual assets were generated.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-19 - Add economy balance regression guard

### Summary

- Added a Godot economy balance check scene and PowerShell wrapper that call the live economy functions through the real main scene.
- The new guard verifies daily care-to-growth examples, deterministic daily coin formula examples, negative-growth floor, per-plant cap, active/harvested/dormant settlement rules, care reset behavior, milestone growth without direct coin rewards, seed unlock prices, and representative light/normal/heavy/historical income bands.
- Corrected the internal economy documentation example for `growth=100` at final stage from `19` to `20`, matching the implemented logarithmic formula and the new guard.
- Updated `godot-prototype/PLAN.md` to list the new verification command and current evidence.

### Files Changed

- `godot-prototype/scripts/economy_balance_check.gd`
- `godot-prototype/scripts/verify_economy_balance.ps1`
- `godot-prototype/scenes/economy_balance_check.tscn`
- `godot-prototype/PLAN.md`
- `docs/economy-system.md`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_save_migration.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_economy_balance.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.
- Ran `git diff --check` for the touched text files; only normal CRLF warnings appeared.

### Notes

- No new visual assets were generated.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-19 - Add save migration regression guard

### Summary

- Added a Godot save migration check scene and PowerShell wrapper that run fixture saves through the real `res://scenes/main.tscn` load path.
- The new guard verifies legacy layout migration, old course stage-key migration, planted-variety unlock preservation, owned-decoration backfill, empty plot cleanup, default care/history/session fields, current-layout position preservation, selected-zone fallback, export checksum validation, raw import acceptance, and future-schema rejection.
- Fixed legacy course sprite/base migration so old course sprite filenames ending in `sowing`, `growing`, `fruit`, or `seed_saved` resolve to the correct current variety base after stage normalization, instead of generating missing paths such as `course-lotus-sowing-seed.png`.
- Updated `godot-prototype/PLAN.md` to list the new verification command and current evidence.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/save_migration_check.gd`
- `godot-prototype/scripts/verify_save_migration.ps1`
- `godot-prototype/scenes/save_migration_check.tscn`
- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_save_migration.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.
- Ran `git diff --check` for the touched text files; only normal CRLF warnings appeared.

### Notes

- No new visual assets were generated.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-19 - Add Godot mobile layout capture guard

### Summary

- Added a repeatable Godot movie-frame capture harness for the mobile portrait baseline at `390x844`.
- The capture flow drives the main scene through active, harvested, dormant, detail, record drawer, seed shop, decoration shop, backup panel, onboarding, and remove-confirmation states.
- Added a PowerShell wrapper that finds Godot, isolates `user://` under `.runtime`, writes named screenshots under `godot-prototype/screenshots/mobile-layout/390x844/`, and validates PNG dimensions and non-blank color variety.
- Fixed the remove-confirmation dialog's body label minimum width so its smart wrapping no longer inflates the dialog to an off-screen height in mobile portrait captures.
- Updated `godot-prototype/PLAN.md` to list the new verification command and record the Godot 4.6.3 movie-maker limitation: a taller `430x932` runtime viewport can be reached, but movie PNG output remains fixed to the project viewport override.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/mobile_layout_capture.gd`
- `godot-prototype/scripts/verify_mobile_layout.ps1`
- `godot-prototype/scenes/mobile_layout_capture.tscn`
- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`
- `godot-prototype/screenshots/mobile-layout/390x844/`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.
- Ran `git diff --check` for the touched text files; only normal CRLF warnings appeared.
- Visually inspected the generated active-map, detail, record drawer, onboarding, and remove-confirmation screenshots.

### Notes

- No new art assets were generated.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.
- The generated screenshot directory is a verification artifact for this slice; it is not an app runtime dependency.

## 2026-06-19 - Draft Godogen optimization audit plan

### Summary

- Used the newly installed Godogen workflow to review the current Godot mobile prototype direction, existing verification gates, major architectural risks, and concurrent worktree state.
- Added a resumable optimization plan at `godot-prototype/PLAN.md` covering mobile visual proof, `main.gd` decomposition, save migration guards, economy balance checks, and art asset contract cleanup.

### Files Changed

- `godot-prototype/PLAN.md`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`.
- Ran `git diff --check` for the touched planning and key verification files; only normal CRLF warnings appeared.

### Notes

- No runtime code or visual assets were modified.
- Existing unrelated local work, large asset deletion/cleanup state, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-18 - Move seed unlocks to seed shop and add care feedback

### Summary

- Split the bottom tray shop flow into separate `装饰` and `种子` modes while keeping `仓库` for owned decorations.
- Moved seed-variety unlocking out of the planting panel; planting now only selects already-unlocked varieties, and locked varieties point users to the seed shop.
- Made today's water/sun/fertilizer cells visible in plant details.
- Changed record actions to grant deterministic care values: quick slots map to water, sun, and fertilizer; note records add the currently lowest care type.
- Added care-specific feedback animations over the selected plant: falling water drops, a warm sunburst, and bouncing fertilizer soil particles, with the compact `+1` badge kept as the numeric confirmation.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `git diff --check -- godot-prototype\scripts\main.gd docs\pending-changes.md`; only normal CRLF warnings appeared.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd` with writable temporary app data; it exited 0.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3` with writable temporary app data; it exited 0 and printed layout version 30.
- Re-ran the asset check, detail UI check, Godot script check, and Godot 3-second headless startup after adding care-specific drawn animations.

### Notes

- No new visual assets were generated; the feedback reuses existing care icons.
- Existing unrelated local work, asset changes, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-12 - Prepare Godot mobile runtime for Android/iOS QA

### Summary

- Enabled the Android export preset's launcher activity visibility so directly shared APKs show up as a normal launchable app for testers.
- Added runtime layout logging for `platform`, `platform_ios`, `platform_mobile`, and the resolved `user://` directory so Android and future iOS safe-area/storage behavior can be compared from device logs.
- Added a static UI guard for the new cross-platform runtime log fields.

### Files Changed

- `godot-prototype/export_presets.cfg`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran JSON validation for `godot-prototype/data/garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `git diff --check` for the touched Godot config/script/check files; only normal CRLF warnings appeared.
- Ran Godot headless script check with `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe`.
- Ran Godot headless startup; it logged the new runtime platform fields. A local old Windows save produced one missing normalized-stage warning unrelated to this change.
- Ran `godot-prototype\scripts\preview_android.ps1` with `JAVA_HOME=D:\ag_runtime\jdk\jdk-17.0.19+10`; it exported, signed, installed, launched, and captured a fresh Android screenshot.
- Verified `adb shell cmd package resolve-activity --brief org.academicgarden.prototype` resolves `com.godot.game.GodotAppLauncher`.
- Reviewed the latest Android logcat: `platform` is `android`, `platform_mobile` is `true`, `platform_ios` is `false`, and the save path resolves under the Android app sandbox.
- Visually inspected `godot-prototype/exports/android-qa-preview-latest.png`; the APK starts to the garden screen without black-screen or obvious layout breakage.

### Notes

- No new visual assets were generated.
- Existing unrelated local work, asset changes, deprecated web runtime deletions, and other concurrent Godot/doc changes were left untouched.

## 2026-06-10 - Add seed shop variety unlocks

### Summary

- Added a seed shop unlock layer to the Godot planting panel: new saves start with two paper tree varieties and two course flower varieties unlocked, while locked varieties can be bought with coins.
- Made course flower variety unlocks cost `150` coins each.
- Made paper tree variety unlocks start at `240` coins and double with each non-initial paper tree variety already unlocked.
- Preserved compatibility for existing saves by keeping already-planted varieties unlocked during migration.
- Added ImageGen-generated seed shop and locked-seed UI icons and wired them into the planting panel.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `godot-prototype/assets/art/seed-shop-lock-icons-gpt-v1-source.png`
- `godot-prototype/assets/art/seed-shop-lock-icons-gpt-v1-source.png.import`
- `godot-prototype/assets/sprites/ui/seed-shop-gpt-v1.png`
- `godot-prototype/assets/sprites/ui/seed-shop-gpt-v1.png.import`
- `godot-prototype/assets/sprites/ui/seed-locked-gpt-v1.png`
- `godot-prototype/assets/sprites/ui/seed-locked-gpt-v1.png.import`
- `docs/economy-system.md`
- `docs/pending-changes.md`

### Verification

- Generated the seed shop and locked-seed icon source with the built-in ImageGen tool.
- Processed the generated chroma-key source into transparent runtime PNG icons and visually inspected both icons.
- Ran Godot import to create `.import` metadata for the new PNG assets.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran JSON validation for `godot-prototype/data/garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py` with the bundled Codex Python runtime; it passed with `ui sprite errors 0`.
- Ran a static seed-default check confirming the built-in seed starts with exactly `paper-ginkgo`, `paper-cherry`, `course-daisy`, and `course-rose` unlocked.
- Ran `git diff --check` for the touched files; only normal CRLF warnings appeared.
- Godot runtime checks were not rerun in this final pass because no local `Godot*.exe` executable was available on PATH or under the searched local folders.

### Asset Prompt

- Prompt constraints: cozy pixel-art UI icon sheet, two separate icons for seed shop and locked seed, flat `#00ff00` chroma-key background, Sprout Lands inspired warm wood/gold/leaf styling, no text, no labels, no characters, no watermark.

### Notes

- Existing unrelated local work and concurrent changes were left untouched.

## 2026-06-10 - Tune Godot economy display and decoration prices

### Summary

- Replaced the detail panel's bounded growth progress bar with an unbounded text readout showing `成长值` and estimated daily coins.
- Removed the global daily wallet cap from settlement while keeping the per-plant daily coin cap at `30`.
- Raised decoration prices from the first daily-economy pass to a slightly higher 45-120 coin range, for a full current set cost of 765 coins.
- Updated economy and product docs so growth is treated as an accumulated value rather than a 100% progress meter.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/economy-system.md`
- `docs/product-mvp.md`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran JSON validation for `godot-prototype/data/garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran Godot headless script check for `res://scripts/main.gd`.
- Ran Godot headless startup with layout version 30.
- Ran a temporary-save settlement test after moving the last settlement date to yesterday and adding balanced care to one active plant; settlement granted `+241` coins and `+15` growth, confirming the global `120` wallet cap no longer applies.

### Notes

- No new visual assets were generated; this pass removed a misleading UI component rather than adding an icon.
- Existing unrelated local work and concurrent changes were left untouched.

## 2026-06-10 - Implement Godot daily economy settlement

### Summary

- Implemented daily economy settlement in the Godot prototype: active and harvested plants generate daily coins, dormant plants generate none, and harvested plants are protected from normal record/move/remove modification.
- Changed records to grant daily care signals first; daily settlement converts water/sun/fertilizer into growth and then calculates coins from growth and stage using a logarithmic curve, stage multipliers, light randomness, per-plant cap, and daily wallet cap.
- Removed direct milestone coin rewards so stage advancement grants growth and improves future daily yield instead of double-paying immediately.
- Unified runtime course flower stage flow to the current `seed/seedling/bud/bloom/blossom` keys while keeping migration compatibility for older `sowing/growing/fruit/seed_saved` saves.
- Repriced the current decoration catalog to a gentle 30-90 coin range based on simulation, with one full set costing 555 coins.
- Updated economy, product, and lifecycle docs to reflect fixed harvested growth, harvested daily coins, dormant no-income behavior, and the new pricing model.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `docs/economy-system.md`
- `docs/product-mvp.md`
- `docs/plant-lifecycle-rules.md`
- `docs/pending-changes.md`

### Verification

- Simulated the economy formula with representative light, normal, heavy, and collector player profiles before choosing the decoration prices.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran JSON validation for `godot-prototype/data/garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran Godot headless script check for `res://scripts/main.gd`.
- Ran Godot headless startup with layout version 30.
- Ran a temporary-save settlement test: after moving the last settlement date to yesterday and adding balanced care to one active plant, Godot granted `+120` capped coins, `+15` growth, recorded the settlement summary, and left the dormant garden out of settlement.
- Ran `git diff --check` for the touched files; only normal CRLF warnings appeared.

### Notes

- No new visual assets were generated; the implementation reuses the existing generated coin and care icon assets.
- Existing unrelated local work, asset changes, and deprecated web runtime changes were left untouched.

## 2026-06-10 - Draft Godot economy system design

### Summary

- Added an internal economy system document for the Godot mobile prototype covering care values, growth, daily coin generation, stage multipliers, random variance, settlement caps, and coin sinks.
- Evaluated the proposed design direction and recorded the main balance risks: passive money printing, stage multiplier dominance, record spam, random-care semantics, and direct milestone double payment.
- Proposed moving milestone rewards toward growth plus future yield instead of direct immediate coins once daily settlement is implemented.
- Corrected the economy stage table to use the current course flower keys `seed`, `seedling`, `bud`, `bloom`, and `blossom`.

### Files Changed

- `docs/economy-system.md`
- `docs/pending-changes.md`

### Verification

- Read the new design document after writing and checked it includes growth, coins, water/sun/fertilizer acquisition, coin spending, formulas, risks, and implementation order.
- Cross-checked the current decoration catalog prices in `godot-prototype/data/garden_seed.json` while drafting the sink table.
- Checked current lifecycle docs and seed data for the course flower stage-key rename before correcting the economy table.

### Notes

- Documentation-only change; no runtime Godot code or visual assets were modified.
- Existing unrelated local work and concurrent changes were left untouched.

## 2026-06-10 - Clean Godot wood bench transparent dark residue

### Summary

- Removed a small bottom-edge cluster of translucent dark residue pixels from the Godot wood bench decoration sprite.
- Preserved the existing sprite canvas size, visible stump shape, and opaque grass/outline detail.

### Files Changed

- `godot-prototype/assets/sprites/sprout/decor/decor-wood-bench.png`
- `docs/pending-changes.md`

### Verification

- Ran a pixel alpha/RGBA audit on `decor-wood-bench.png`; the bottom-edge translucent dark residue count is now `0`.
- Visually re-opened the cleaned PNG preview.

### Notes

- No new visual assets were generated.
- Existing unrelated dirty work and concurrent local changes were left untouched.

## 2026-06-09 - Fix Godot empty-plot planting affordance and variety picker

### Summary

- Limited empty-plot plus guides and direct planting entry to the active/growth garden, so harvested garden empty slots no longer imply that new plants can be planted there.
- Kept non-active empty plots selectable as ordinary detail items instead of opening the planting panel.
- Reworked the empty-plot planting panel so the first step uses larger plant-art category buttons for `论文树` and `课程花` instead of the small seed-bag icon.
- Added a second-step variety picker for paper tree and course flower varieties; planting now records the selected variety's first-stage sprite and title.
- Added static UI guards for plantable-zone gating and explicit variety selection.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd` with writable temporary `APPDATA`; it exited 0.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3` with writable temporary `APPDATA`; it exited 0 and printed the runtime layout without resource errors.

### Notes

- No new visual assets were generated; the category buttons reuse existing first-stage plant sprites.
- Existing unrelated local work, deleted historical web runtime files, and other concurrent Godot/doc/asset changes were left untouched.

## 2026-06-09 - Restore readable Godot HUD and decor labels

### Summary

- Replaced overly compressed one-character UI labels in the Godot prototype with readable short labels.
- Changed the top HUD manual guide button from `?` to `引导` and the backup button from `存` to `备份`.
- Changed the decoration tray mode buttons from `仓`/`店` to `仓库`/`商店`.
- Increased the affected button minimum widths so the restored Chinese labels are not cramped.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Rechecked the script labels with `Select-String` and confirmed the visible labels are now `引导`, `备份`, `仓库`, and `商店`.
- `godot`, `godot4`, and `godot4_console` were not available on PATH, so no local Godot runtime preview was run in this slice.

### Notes

- Existing unrelated local work and asset deletion/cleanup state was left untouched.

## 2026-06-09 - Fix Godot plant sprite edge clipping

### Summary

- Audited the Godot runtime plant sprites referenced through `web-normalized-stages` for alpha content touching the PNG canvas edge and for visibly broken course-flower source slicing.
- Found course flower runtime sprites with very small bottom/side margins and mature paper tree sprites/animation frames with edge contact, especially cherry flower, cherry fruit, ginkgo flower, and ginkgo fruit at the top edge.
- Added transparent safety padding to the course flower runtime sprites and mature paper tree runtime sprites so each checked sprite has at least 8px transparent margin on every side.
- Rechecked the Hydrangea bloom sprite after user review and found the earlier padding-only fix was insufficient: the runtime sprite was already a bad slice from the source sheet, with the full flower partly missing and an adjacent final-stage sparkle fragment included.
- Re-sliced all 48 course flower runtime sprites from the complete `course-flower-lifecycle-gpt-v1-source.png` grid, removed chroma-key halos, and kept only the main flower component for non-final stages so adjacent-column sparkles cannot leak into normal bloom/bud/seedling sprites.
- Rechecked Sunflower after user review and found its flower head crosses the mechanical row boundary in the source sheet, so equal-grid slicing still cut off the top petals.
- Re-cropped the Sunflower bloom from an expanded source region around the last row/fourth column, kept the main connected flower component, and applied that complete crop to `bloom`, `blossom`, and `seed_saved`.
- Checked for a Ginkgo source sheet comparable to the course flower lifecycle sheet; no current `godot-prototype/assets/art` tree/ginkgo sheet was present, so the runtime Ginkgo sprites and animation frames are the authoritative editable assets for now.
- Repaired the Ginkgo base directly on `paper-ginkgo-tree.png`, adding a fuller grass/soil mound behind the existing tree while preserving the existing canvas size and an 8px transparent bottom safety margin.
- Applied the same repaired Ginkgo base to `tree`, `flower`, and `fruit` static sprites and their animation frames so playback does not revert to the shorter base.
- Applied the same padding to paper tree stage animation frames as their matching static source sprite so animation playback does not reintroduce clipped-looking frames or frame-size mismatches.
- Extended `scripts/verify_godot_garden_assets.py` with alpha-margin checks for all course flower normalized sprites and mature paper tree static/animated sprites, plus course flower slice checks for magenta residue and unexpected extra components in non-final stages.
- Refreshed Godot imports and regenerated the Godot web asset preview/contact images after the sprite changes.

### Files Changed

- `godot-prototype/assets/sprites/web-normalized-stages/course-*.png`
- `godot-prototype/assets/sprites/web-normalized-stages/course-*.png.import`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-*-tree.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-*-flower.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-*-fruit.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-*.png.import`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-*-tree/frame-*.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-*-flower/frame-*.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-*-fruit/frame-*.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-*/*.png.import`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `godot-prototype/assets/art/godot-web-assets-dormant-preview.png`
- `godot-prototype/assets/art/godot-web-assets-harvested-preview.png`
- `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran a pixel alpha-margin audit before the fix; it identified the tree and course flower edge-contact cases above.
- Visually inspected `godot-prototype/assets/sprites/web-normalized-stages/course-hydrangea-bloom.png` after the corrected re-slice; the flower body, leaves, and soil are complete and the stray right-side sparkle fragment is gone.
- Visually inspected `godot-prototype/assets/sprites/web-normalized-stages/course-sunflower-bloom.png` after the expanded source crop; the top petals are now present.
- Visually inspected `godot-prototype/assets/sprites/web-normalized-stages/paper-ginkgo-tree.png`; the tree now has a fuller grass/soil base and still keeps a bottom transparent safety margin.
- Ran `python scripts\verify_godot_garden_assets.py`; it passed with `stage safe-margin errors 0` and `course flower slice errors 0`.
- Ran a full post-fix PNG scan over `godot-prototype/assets/sprites/web-normalized-stages`; remaining paper/course stage sprites with less than 8px alpha margin: `0`.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --import` to refresh imported textures.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --check-only --script godot-prototype\scripts\main.gd`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`; it exited 0 and printed runtime layout without resource errors.
- Ran `python scripts\preview_godot_web_assets.py` and inspected `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`; the visible map plants keep their full silhouettes without obvious top/bottom truncation.

### Notes

- No new art was generated; this pass added transparent canvas padding, corrected the course flower runtime slicing from the existing source sheet including an expanded crop for Sunflower, and repaired the Ginkgo base in-place because no comparable Ginkgo source sheet was present.
- Existing unrelated dirty work, deleted historical web runtime files, and other concurrent Godot/doc changes were left untouched.

## 2026-06-09 - Make Dr.Meow onboarding manual-only

### Summary

- Removed the first-launch automatic Dr.Meow onboarding trigger from the Godot mobile prototype.
- Kept the compact `?` HUD button as the manual entry point for the tutorial.
- Added a static guard so the first-launch auto-open hook does not return unnoticed.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`; this Godot console run crashed natively with signal 11 before reporting script diagnostics.
- Ran `godot-prototype\scripts\preview_android.ps1` without `-SkipExport` and with `JAVA_HOME=D:\ag_runtime\jdk\jdk-17.0.19+10`; it exported, installed, launched, and captured a fresh Android preview.
- Confirmed the new APK at `godot-prototype/exports/academic-garden-prototype-debug.apk` was written at `2026/6/9 18:17:28`, size `100,384,783` bytes.
- Confirmed the fresh first-screen preview at `godot-prototype/exports/android-qa-preview-latest.png` was written at `2026/6/9 18:17:39` and no longer shows the onboarding overlay.
- Used adb to tap the `?` button and captured `godot-prototype/exports/android-qa-preview-guide-button.png`; the Dr.Meow onboarding overlay opened manually as expected.
- Checked logcat for `OnGodotMainLoopStarted` and `platform_android=true`; no Godot script errors were found in the filtered startup lines.

### Notes

- No visual assets were generated.
- Existing unrelated dirty work and parallel changes were left untouched.

## 2026-06-09 - First mobile Godot UI consolidation pass

### Summary

- Added compact UI size/tone constants and a shared button tone helper in the Godot main script.
- Lightened the top HUD by shrinking the header, logo, coin pill, and converting the low-frequency onboarding/backup actions into compact `?` and `存` controls with tooltips.
- Reworked the plant detail card toward a smaller mobile bottom-sheet summary: reduced its height, shrank the plant preview, and hid the care grid and note text from the default summary so more of the garden stays visible.
- Standardized action button semantics: growth/record actions stay green, neutral controls use wood tones, sleep uses a quieter muted tone, and remove/confirm-remove use a danger tone.
- Tightened the bottom decoration tray, shortened its mode controls, and changed the decoration scroller to `SCROLL_MODE_AUTO` so horizontal overflow is discoverable.
- Improved onboarding readability by keeping the large Dr.Meow portrait for the first step and compacting it on later steps so Chinese body text gets more width.
- Replaced the first onboarding step's mixed Latin/CJK comma after `Dr.Meow` with an ASCII comma after Android preview showed that glyph rendering as a missing-character box.
- Updated the detail UI static verifier to check the new UI tone helper, visible tray scroll mode, compact onboarding button size, and avatar resizing hook.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --check-only --script godot-prototype\scripts\main.gd` with writable temporary `APPDATA`; it exited 0.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3` with writable temporary `APPDATA`; it exited 0 and printed runtime layout.
- Ran the Godot MCP project runner for `res://scenes/main.tscn`; it started and stopped successfully with a 390x844 viewport runtime layout.
- Ran `godot-prototype\scripts\preview_android.ps1` with `JAVA_HOME=D:\ag_runtime\jdk\jdk-17.0.19+10`; it exported, signed, installed, launched, and captured `godot-prototype/exports/android-qa-preview-latest.png`.
- Inspected the Android screenshot and confirmed the compact HUD, shorter bottom tray, visible horizontal scroll affordance, and fixed onboarding text rendering.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/scripts/verify_detail_ui.ps1`; only normal CRLF warnings appeared.

### Notes

- No new visual assets were generated.
- Godot MCP final output still reports an existing warning about a variable named `seed` shadowing a built-in function at `res://scripts/main.gd:642`; no runtime errors were reported.
- Android logcat includes normal emulator/system warnings such as missing network time and shared storage notices; Godot reached `OnGodotMainLoopStarted` and printed `platform_android=true` runtime layout.
- Existing unrelated dirty work, generated assets, deprecated root web-runtime deletions, and other parallel Godot changes were left untouched.

## 2026-06-08 - Fix Godot plant movement, flower display, and Chinese labels

### Summary

- Restored Chinese labels for lifecycle stages and next-stage actions so stage buttons no longer display `??`.
- Restored Chinese names for decoration catalog items so decoration UI no longer shows question marks.
- Moved the plant `移动` action out of the detail card and into the bottom function tray; the detail-card action now reads `暂时休眠` and sends active plants to the dormant garden.
- Changed cross-garden plant moves to reset the original slot into an empty plot instead of removing the slot, preserving the clickable empty-land prompt.
- Changed cross-garden moves to reuse an existing empty slot in the target garden before appending a new plot.
- Added course flower legacy/new stage display sizes and switched map plant art to aspect-preserving rendering to avoid flower sprites looking clipped.
- Fixed new course flowers planted into empty plots to start on the canonical `sowing` stage path.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --check-only --script godot-prototype\scripts\main.gd`; it exited 0 with only the existing Windows editor config directory warnings.
- Ran Godot headless project startup with a writable temporary `APPDATA`; it exited 0 and printed the runtime layout.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/data/garden_seed.json godot-prototype/scripts/verify_detail_ui.ps1`; only normal CRLF warnings appeared.

### Notes

- A plain project startup without writable `APPDATA` still triggers a Godot native crash after user-data directory creation fails; rerunning with a writable temp `APPDATA` avoids it.
- Existing unrelated local deletions, generated assets, APK/export changes, and deprecated root web-runtime changes were left untouched.

## 2026-06-08 - Export fresh Godot Android test APK

### Summary

- Generated a fresh Android debug APK from the current Godot mobile prototype.
- Used the cached Godot 4.6.3 Android export templates, local Android SDK/JDK, and local debug keystore.
- Cleaned up the temporary Godot APPDATA directory used during export.

### Files Changed

- `godot-prototype/exports/academic-garden-prototype-preview-unsigned.apk`
- `godot-prototype/exports/academic-garden-prototype-debug.apk`
- `godot-prototype/exports/academic-garden-prototype-debug.apk.idsig`
- `docs/pending-changes.md`

### Verification

- Ran Godot 4.6.3 headless Android export with preset `Android Debug`.
- Signed the APK with `academic-garden-debug.keystore`.
- Ran `apksigner verify --verbose`; v2 and v3 signature verification passed with 1 signer.
- Confirmed output APK timestamp `2026-06-08 21:37:46` and size `100,384,783` bytes.

### Notes

- Existing unrelated local and concurrent work was left untouched.

## 2026-06-08 - Decoration shop, inventory, and smaller garden decor

### Summary

- Reworked the Godot bottom decoration tray into two modes: `仓库` for placing owned decorations and `商店` for buying decorations with coins.
- Added coin purchase logic that deducts the catalog price, increments owned inventory, switches back to the warehouse, and selects the bought decoration for placement.
- Added catalog synchronization on load so older saves keep owned counts but receive the current decoration names, prices, and sprite paths.
- Reduced the default map decoration footprint and added per-decoration default scales so placed decor is less likely to cover plants or look pasted onto walls.
- Replaced oversized or mismatched decor art with GPT-Image-2 generated pixel sprites: mossy stone path, stump seat, short sign, book-and-stone stack, flower-rock clump, low wooden platform, and reading mat.
- Kept lamp, pond, and well as the stable existing water/light set; pond is scaled down in the default layout.
- Restored runtime course flower stage routing to the current canonical keys `sowing/growing/bloom/fruit/seed_saved` and added compatibility for old `seed/seedling/bud/blossom` saves and sprite suffixes, because the Godot startup check exposed legacy save pollution.
- Added canonical course stage sprite copies where only legacy-named files existed, then refreshed Godot imports.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `godot-prototype/assets/art/decoration-sheet-gpt-v4-source.png`
- `godot-prototype/assets/art/decor-reading-mat-gpt-v1-source.png`
- `godot-prototype/assets/art/decoration-v4-contact.png`
- `godot-prototype/assets/art/godot-web-assets-*-preview.png`
- `godot-prototype/assets/sprites/sprout/decor/decor-stone-path.png`
- `godot-prototype/assets/sprites/sprout/decor/decor-wood-bench.png`
- `godot-prototype/assets/sprites/sprout/decor/decor-sign.png`
- `godot-prototype/assets/sprites/sprout/decor/decor-workbench.png`
- `godot-prototype/assets/sprites/sprout/decor/decor-flower-rock.png`
- `godot-prototype/assets/sprites/sprout/decor/decor-wood-bridge.png`
- `godot-prototype/assets/sprites/sprout/decor/decor-picnic-rug.png`
- `godot-prototype/assets/sprites/web-normalized-stages/course-*-sowing.png`
- `godot-prototype/assets/sprites/web-normalized-stages/course-*-growing.png`
- `godot-prototype/assets/sprites/web-normalized-stages/course-*-seed_saved.png`

### Verification

- Used built-in image generation with GPT-Image-2 for the new decoration source sheet and reading mat source.
- Removed chroma-key backgrounds locally, sliced and normalized runtime sprites to 96x96 transparent PNGs, and inspected `godot-prototype/assets/art/decoration-v4-contact.png`.
- Ran `python scripts\preview_godot_web_assets.py` and inspected `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`; the new decor reads smaller, low to the ground, and avoids obvious plant occlusion.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --import`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`; it exited 0 with only the expected runtime layout line.

### Asset Prompt Notes

- Decoration sheet prompt constraints: cozy mobile academic garden pixel-art decorations, six separate low/grass-friendly items in a 3x2 grid, flat `#00ff00` chroma-key background, no text, no labels, no characters, no watermark.
- Reading mat prompt constraints: compact low reading mat with a closed book and cup, ground-hugging footprint, flat `#00ff00` chroma-key background, no text, no labels, no characters, no watermark.

### Notes

- Test prices are intentionally provisional and should be revisited with the broader economy/reward design.
- Existing unrelated dirty work, including deprecated root web runtime deletions and other Godot asset/doc changes already present in the worktree, was left untouched.

## 2026-06-08 - Rename course flower internal stage keys

### Summary

- Renamed course flower internal stage keys from the historical `sowing/growing/bloom/fruit/seed_saved` set to the semantic `seed/seedling/bud/bloom/blossom` set.
- Kept paper tree keys unchanged because `seed/sapling/tree/flower/fruit` still match the paper-tree meanings.
- Added a course-only migration map so old saves and imported data are normalized on load before sprite routing, growth defaults, and next-stage logic run.
- Bumped the Godot layout version to `29` so saved data records this key migration.
- Renamed the 30 course flower runtime sprite files and matching `.import` files to the new stage names.
- Updated seeded demo data, lifecycle docs, preview helpers, and static asset guards to use the new keys.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `godot-prototype/assets/sprites/web-normalized-stages/course-*.png`
- `godot-prototype/assets/sprites/web-normalized-stages/course-*.png.import`
- `scripts/preview_godot_web_assets.py`
- `scripts/verify_godot_garden_assets.py`
- `docs/plant-lifecycle-rules.md`
- `docs/pending-changes.md`

### Verification

- Ran a structured seed-data and sprite audit confirming course stages are only `seed`, `seedling`, `bud`, `bloom`, and `blossom`, with all 30 renamed runtime sprites present and nonblank.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --check-only --script godot-prototype/scripts/main.gd`; it exited 0 after existing Windows editor config directory warnings.
- Searched current Godot scripts, seed data, active lifecycle docs, helper scripts, and course runtime sprite names; old course keys remain only in the explicit migration table and compatibility note.

### Notes

- Old course stage keys now have no active runtime meaning except migration compatibility.
- No visual content was regenerated in this pass; only the course flower asset filenames and references changed.
- Existing unrelated local work and deprecated root web runtime files were left untouched.

## 2026-06-08 - Rename lifecycle actions and redraw course flower stages

### Summary

- Updated Godot stage labels so course flowers display as `种子` → `幼苗` → `含苞` → `盛开` → `绽放`.
- Updated the four next-stage action labels for paper trees: `确定选题`, `写出第一版草稿`, `投稿`, `成功发表`.
- Updated the four next-stage action labels for course flowers: `备课`, `开始上课`, `结课`, `提交成绩`.
- Generated a new GPT-Image-2 course flower lifecycle sheet and sliced it into 30 runtime sprites covering six course flower varieties across the five stages.
- Replaced the old course flower runtime stage sprites under `web-normalized-stages`, including a new closed-bud visual for the `含苞` stage and sparkle-enhanced final `绽放` variants.
- Updated lifecycle rule docs and the product MVP lifecycle table to preserve the new stage naming and action mapping.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/assets/art/course-flower-lifecycle-gpt-v1-source.png`
- `godot-prototype/assets/art/course-flower-lifecycle-gpt-v1-transparent.png`
- `godot-prototype/assets/art/course-flower-lifecycle-gpt-v1-sliced-preview.png`
- `godot-prototype/assets/sprites/web-normalized-stages/course-*.png`
- `docs/plant-lifecycle-rules.md`
- `docs/product-mvp.md`
- `docs/pending-changes.md`

### Verification

- Used built-in `imagegen` with GPT-Image-2 to create a six-row, five-column pixel-art course flower lifecycle sheet on a flat chroma-key background.
- Removed the chroma-key background locally, sliced 30 runtime PNGs, and visually inspected `godot-prototype/assets/art/course-flower-lifecycle-gpt-v1-sliced-preview.png`.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --check-only --script godot-prototype/scripts/main.gd`; it exited 0 after existing Windows editor config directory warnings.
- Ran a PNG audit confirming all 30 course flower runtime sprites are nonblank, have transparent corners, and cover all six varieties with the five expected internal stage keys.

### Asset Prompt Notes

- Prompt constraints: cozy pixel-art RPG garden sprites, six course flower varieties inspired by daisy/hydrangea/lavender/lotus/rose/sunflower, five columns ordered seed/seedling/closed bud/full bloom/radiant blossom, flat `#ff00ff` chroma-key background, no text, no labels, no watermark.
- The generated source sheet and transparent intermediate were kept under `godot-prototype/assets/art/`; app-ready cropped sprites were saved under `godot-prototype/assets/sprites/web-normalized-stages/`.

### Notes

- Internal stage keys were kept unchanged for save compatibility: course `sowing/growing/bloom/fruit/seed_saved` now display as `种子/幼苗/含苞/盛开/绽放`.
- No deprecated root web runtime files were modified for this change.
- Existing unrelated local work and parallel asset cleanup changes were left untouched.

## 2026-06-08 - Remove detail-open plant FX clutter

### Summary

- Removed the selected-plant ambient FX that created random leaf, petal/flyby, and sparkle sprites when opening plant details.
- Kept the base plant sway animation and the decoration placement ring intact.
- Deleted the now-unreferenced runtime FX sprites and old cherry falling-petal frame folder.
- Updated the detail UI static check so the removed detail-open FX paths do not return.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `godot-prototype/assets/sprites/sprout/fx/fx-course-petal.png`
- `godot-prototype/assets/sprites/sprout/fx/fx-course-petal.png.import`
- `godot-prototype/assets/sprites/sprout/fx/fx-dormant-moon.png`
- `godot-prototype/assets/sprites/sprout/fx/fx-dormant-moon.png.import`
- `godot-prototype/assets/sprites/sprout/fx/fx-harvest-leaf.png`
- `godot-prototype/assets/sprites/sprout/fx/fx-harvest-leaf.png.import`
- `godot-prototype/assets/sprites/sprout/fx/fx-lantern-twinkle.png`
- `godot-prototype/assets/sprites/sprout/fx/fx-lantern-twinkle.png.import`
- `godot-prototype/assets/sprites/sprout/fx/fx-paper-sparkle.png`
- `godot-prototype/assets/sprites/sprout/fx/fx-paper-sparkle.png.import`
- `godot-prototype/assets/sprites/sprout/fx/cherry-fall-v1/`
- `docs/pending-changes.md`

### Verification

- Confirmed `godot-prototype/assets/sprites/sprout/fx/` now only contains `fx-placement-ring.png` and its `.import` file.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Searched runtime scripts for the removed detail-open FX names and helper paths; no remaining runtime references were found.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --check-only --script godot-prototype/scripts/main.gd`; it exited 0 after editor config directory warnings.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/scripts/verify_detail_ui.ps1 docs/pending-changes.md godot-prototype/assets/sprites/sprout/fx`; only normal CRLF warnings appeared.

### Notes

- Existing unrelated local deletions, generated previews, seed-data edits, and script changes were left untouched.
- Pre-existing deleted FX files outside this slice, such as `fx-seed-puff` and `fx-water-burst`, were left as they were.
- The deprecated root web runtime was not modified.

## 2026-06-08 - Preserve plant lifecycle baseline rules

### Summary

- Added a dedicated lifecycle rules document for the Godot prototype's tree and flower stages.
- Captured the current fixed five-stage flows for paper trees and course flowers.
- Added a naming workbench table so the next pass can decide final display names without changing the underlying stage keys.

### Files Changed

- `docs/plant-lifecycle-rules.md`
- `docs/pending-changes.md`

### Verification

- Compared the documented stage flows against `STAGE_FLOW` in `godot-prototype/scripts/main.gd`.

### Notes

- No Godot scripts, save data, or visual assets were modified.
- Existing unrelated local work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-08 - Make plant and decoration movement explicit

### Summary

- Replaced the hidden second-tap plant swap behavior with an explicit plant detail action: tap a plant, tap `移动`, then tap the target plot to move/swap it.
- Changed placed decorations so tapping them opens a small action panel instead of immediately reclaiming/removing them.
- Added decoration actions for `移动`, `收回`, and `取消`; moving a decoration now enters a slot-selection mode and reuses the existing glowing placement targets.
- Updated hint text and mode cleanup so moving plants/decorations exits cleanly when switching pages, switching gardens, or closing panels.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --check-only --script godot-prototype/scripts/main.gd`; it exited 0 after editor config directory warnings.
- Searched `godot-prototype/scripts/main.gd` and confirmed `_swap_plots_in_current_zone`, the old second-tap hint, and direct `button.pressed.connect(_remove_decoration...)` are absent.

### Notes

- No visual assets were generated or modified.
- Existing unrelated cleanup/deletion and parallel Godot tuning work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-08 - Reduce plant map scale again

### Summary

- Reduced all non-empty Godot map plant sprites to 70% of the previous rendered size.
- Changed total map plant scale from `0.70` to `0.49`, while preserving the fixed bottom-contact calculation from the prior pass.
- Regenerated Godot map preview PNGs so the reduced scale can be inspected against all three garden maps.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `scripts/preview_godot_web_assets.py`
- `scripts/verify_godot_garden_assets.py`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `godot-prototype/assets/art/godot-web-assets-harvested-preview.png`
- `godot-prototype/assets/art/godot-web-assets-dormant-preview.png`
- `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran Python syntax parsing for `scripts/preview_godot_web_assets.py` and `scripts/verify_godot_garden_assets.py`.
- Ran a size audit confirming the rendered plant boxes now use `0.49` total scale.
- Ran `python scripts/preview_godot_web_assets.py`.
- Visually inspected `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`.
- Ran the real Android/Godot preview flow with `godot-prototype/scripts/preview_android.ps1` after setting `JAVA_HOME=D:\ag_runtime\jdk\jdk-17.0.19+10`.
- Captured and visually inspected phone-ratio screenshots at `godot-prototype/exports/android-qa-preview-latest.png` and `godot-prototype/exports/android-qa-preview-map-clear.png`.

### Notes

- No plant source sprites were modified in this pass.
- Existing parallel APK export, placement alignment, cherry-base repair, cleanup/quarantine, and deprecated web-runtime changes were left untouched.
- Synthetic preview contact sheets are no longer treated as the final visual approval surface; Android/Godot screenshots are required for phone-ratio layout review.

## 2026-06-08 - Scale plant sprites down and remove willow shadow bar

### Summary

- Scaled all non-empty Godot map plant sprites to 70% of their current stage display boxes.
- Preserved the pre-scale plant bottom line so trees and flowers shrink upward from the same ground contact position instead of floating.
- Removed the extra runtime plant contact shadow that showed up as a dark horizontal bar under the willow.
- Updated the Godot preview helper and static guard to use/check the same `PLANT_MAP_SCALE` behavior.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `scripts/preview_godot_web_assets.py`
- `scripts/verify_godot_garden_assets.py`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `godot-prototype/assets/art/godot-web-assets-harvested-preview.png`
- `godot-prototype/assets/art/godot-web-assets-dormant-preview.png`
- `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran Python syntax parsing for `scripts/preview_godot_web_assets.py` and `scripts/verify_godot_garden_assets.py`.
- Ran a size audit confirming rendered plant boxes are 70% of the current stage boxes.
- Ran `python scripts/preview_godot_web_assets.py`.
- Visually inspected `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`; plant scale is reduced and the willow shadow bar is gone.

### Notes

- No willow source sprite pixels were changed; the black bar came from the runtime shadow layer, not the PNG itself.
- Existing parallel harvested pagination, placement alignment, plant sizing, cherry-base repair, cleanup/quarantine, APK export, and deprecated web-runtime changes were left untouched.

## 2026-06-08 - Export fresh Godot Android test APK

### Summary

- Exported a fresh Android debug APK from the current Godot prototype after the latest local BGM/import changes.
- Rebuilt the Godot import cache before export, including the main and dormant BGM imported audio samples.
- Signed the exported APK with the local Academic Garden debug keystore.

### Files Changed

- `godot-prototype/exports/academic-garden-prototype-preview-unsigned.apk`
- `godot-prototype/exports/academic-garden-prototype-debug.apk`
- `godot-prototype/exports/academic-garden-prototype-debug.apk.idsig`
- `godot-prototype/.godot/imported/`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran Godot 4.6.3 headless import and `--export-debug "Android Debug"`.
- Ran `apksigner sign` with `D:\ag_runtime\academic-garden-debug.keystore`.
- Ran `apksigner verify --verbose`; APK Signature Scheme v2 and v3 verified with one signer.

### Notes

- Output APK: `godot-prototype/exports/academic-garden-prototype-debug.apk`.
- The signed APK timestamp is `2026-06-08 14:40:45` and size is `99,002,879` bytes.
- Existing parallel source/art cleanup and unrelated local changes were left untouched.

## 2026-06-08 - Make Godot BGM audible in preview

### Summary

- Investigated why the Godot preview seemed to have no music even though BGM assets were present.
- Found the main loop source is quiet (`-27.9 dBFS` RMS) and was being played at `-15 dB`, making the runtime output easy to miss.
- Raised the normal garden BGM target to `-6 dB` and the dormant garden BGM target to `-8 dB`.
- Marked both Godot WAV imports as looping so the import metadata matches the runtime loop setup.
- Added an audio import guard to the Godot asset verification script.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/assets/audio/garden_bgm_main_loop.wav.import`
- `godot-prototype/assets/audio/garden_bgm_dormant_loop.wav.import`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `git diff --check` on the touched files; only expected Windows LF-to-CRLF warnings were reported.
- Ran Godot MCP `run_project` for `res://scenes/main.tscn`; final runtime errors were empty.

### Notes

- No BGM source audio was regenerated.
- Existing parallel asset cleanup, placement, sprite, and deprecated web-runtime changes were left untouched.

## 2026-06-08 - Align Godot plant placement grid

### Summary

- Unified all Godot plant slot anchors to the active garden's first-tree grid.
- Set every zone to the same three columns: `0.295`, `0.500`, and `0.720`.
- Set every zone to the same three rows: `0.471`, `0.592`, and `0.728`.
- Updated harvested overflow records so page 2 entries map back onto slots 1-3 instead of keeping old top-row coordinates.
- Updated the preview helper to render only the first harvested page, matching runtime pagination and avoiding stacked preview plants.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `scripts/preview_godot_web_assets.py`
- `scripts/verify_godot_garden_assets.py`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `godot-prototype/assets/art/godot-web-assets-harvested-preview.png`
- `godot-prototype/assets/art/godot-web-assets-dormant-preview.png`
- `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran a custom grid audit confirming active, harvested, and dormant slots all use the same 3x3 coordinates, with harvested page 2 records wrapping onto slots 1-3.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `python scripts/preview_godot_web_assets.py`.
- Visually inspected `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`.

### Notes

- No new art was generated; only map placement data, preview output, and runtime anchor constants changed.
- Existing parallel harvested pagination, plant sizing, cherry-base repair, cleanup/quarantine, and deprecated web-runtime changes were left untouched.

## 2026-06-08 - Repair cherry blossom soil base sprite

### Summary

- Fixed the cherry blossom flower-stage sprite whose bottom soil base was visibly cut flat in the source PNG.
- Repaired the lower soil arc with a targeted pixel pass, preserving the original `256x278` canvas, tree position, and runtime anchor behavior.
- Applied the same base repair to all six `paper-cherry-flower` animation frames so the map animation and static portrait stay consistent.
- Regenerated Godot map preview PNGs from the repaired runtime assets.

### Files Changed

- `godot-prototype/assets/sprites/web-normalized-stages/paper-cherry-flower.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-cherry-flower/frame-00.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-cherry-flower/frame-01.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-cherry-flower/frame-02.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-cherry-flower/frame-03.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-cherry-flower/frame-04.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-cherry-flower/frame-05.png`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `godot-prototype/assets/art/godot-web-assets-harvested-preview.png`
- `godot-prototype/assets/art/godot-web-assets-dormant-preview.png`
- `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran a Pillow check confirming the repaired static sprite and all six animation frames keep matching dimensions and repaired lower bounds.
- Ran `python scripts/preview_godot_web_assets.py`.
- Visually inspected `godot-prototype/assets/sprites/web-normalized-stages/paper-cherry-flower.png` and `godot-prototype/assets/art/godot-web-assets-active-preview.png`.

### Notes

- No new generated art source was created; this was a local pixel repair from the existing sprite colors.
- Existing parallel harvested pagination, plant sizing, cleanup/quarantine, and deprecated web-runtime changes were left untouched.

## 2026-06-08 - Normalize Godot tree and flower map sizing

### Summary

- Kept paper tree stage sizes tiered by growth stage so seeds, saplings, and mature trees remain visually distinct.
- Standardized mature paper trees at `148x184` and course mature flowers at `104x128`, making flowers about 70% of mature tree size.
- Reduced course sowing and growing map boxes to keep flower lifecycle stages proportional and prevent flower varieties from diverging too much on the map.
- Lowered the shared plant ground anchor to reveal the cherry tree's lower soil/base area more completely.
- Updated the Godot map preview helper and asset guard to match the new stage-size rules.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `scripts/preview_godot_web_assets.py`
- `scripts/verify_godot_garden_assets.py`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `godot-prototype/assets/art/godot-web-assets-harvested-preview.png`
- `godot-prototype/assets/art/godot-web-assets-dormant-preview.png`
- `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran a custom Python size audit confirming each non-empty plant stage now resolves to a single display size; mature flowers are `104x128` and mature trees are `148x184`.
- Ran `python scripts/preview_godot_web_assets.py` and visually inspected `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/data/garden_seed.json scripts/preview_godot_web_assets.py scripts/verify_godot_garden_assets.py docs/pending-changes.md`; only normal CRLF warnings appeared.

### Notes

- No new generated source art was created; preview PNGs were regenerated from existing runtime sprites.
- Existing parallel work in harvested pagination, cleanup/quarantine changes, and deprecated root web runtime files was left untouched.
- A plain Godot `--headless --path godot-prototype --quit` attempt crashed in the engine startup/shutdown path, matching the existing note above; static/resource checks and rendered previews passed.

## 2026-06-08 - Add plant swapping and harvested pagination

### Summary

- Added click-to-swap plant movement in the Godot map: tap one planted item to select it, then tap another planted item in the same garden to exchange their positions.
- Added harvested garden pagination with 9 visible result slots per page and previous/next buttons when more completed papers/courses exist.
- Made harvested records beyond the first page render into the same 9 map positions without losing the underlying extra records.
- Added sample completed harvested records so the default seed data exercises page 2.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/data/garden_seed.json godot-prototype/scripts/verify_detail_ui.ps1 scripts/verify_godot_garden_assets.py docs/pending-changes.md`; only normal CRLF warnings appeared.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --check-only --script godot-prototype/scripts/main.gd`; it exited 0 after editor config directory warnings.

### Notes

- No visual assets were generated or modified.
- A plain Godot `--headless --path godot-prototype --quit` attempt crashed in the engine startup/shutdown path, so runtime visual approval still needs a later normal Godot/app launch.
- Existing unrelated cleanup/deletion work in the wider worktree was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-08 - Quarantine deprecated web and unused Godot assets

### Summary

- Quarantined deprecated root web runtime files and historical root art/audio packs under `unused-cleanup-2026-06-08/` so current work is focused on `godot-prototype/`.
- Quarantined Godot source/review/contact art, source-art packs, generated import cache, previous APK/PCK/screens/logcat exports, old map versions, old fallback stage sprites, old Sprout rebuilt/portrait/ground sprites, unused top-level legacy sprites, unused demo audio, and unused pipeline/test scripts.
- Kept the current Godot runtime asset set in place: `web-normalized-stages`, paper tree `stage-animations`, current three map sprites, decor sprites, active FX sprites, UI sprites, `coin-v1`, and the main/dormant BGM.
- Updated `godot-prototype/scripts/preview_android.ps1` to prefer `.runtime/android-avd` but fall back to `godot-prototype/android-avd` if the local AVD cannot be moved.
- Left `godot-prototype/android-avd` in place because Windows denied both moving the directory and writing a `.gdignore`, likely due to emulator ownership/permissions; this is local runtime state, not a current visual asset.

### Files Changed

- `.gitignore`
- `godot-prototype/scripts/preview_android.ps1`
- `docs/pending-changes.md`
- `unused-cleanup-2026-06-08/`
- Deprecated root web runtime files moved into the cleanup folder.
- Unused Godot source/art/cache/export/sprite/script artifacts moved into the cleanup folder.

### Verification

- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Parsed `scripts/preview_godot_web_assets.py` and `scripts/verify_godot_garden_assets.py` with Python `ast.parse`.
- Confirmed `godot-prototype/assets` is reduced from about 202 MB to about 47.7 MB while current resource checks still report missing 0.
- Confirmed the cleanup folder currently holds about 1.15 GB of quarantined web/runtime/source/export artifacts.

### Notes

- No runtime visual assets were regenerated.
- No current Godot map, normalized plant stage, paper-tree animation, decor, UI, or active BGM references were intentionally moved.
- A fresh Godot import/export will recreate `godot-prototype/.godot` with only currently present project resources.
- Existing unrelated deleted root `.cmd` files were left untouched.

## 2026-06-08 - Fix exported APK plant stage resource selection

### Summary

- Fixed a Godot export/runtime mismatch where plant stage sprite selection used `FileAccess.file_exists()` on imported PNG resources.
- In the editor, raw `.png` files exist, so plants selected `web-normalized-stages/*.png`; in exported APKs, raw PNGs are remapped to imported `.ctex` resources, so the same checks failed and fell back to `assets/sprites/stages/*.png`.
- The fallback path explains why most APK plants appeared split, cropped, or misplaced, while `paper-camphor-fruit` still looked normal: its fallback stage sprite is effectively the same full-canvas sprite as the normalized one.
- Replaced those checks with `ResourceLoader.exists()` so editor preview and exported APK resolve the same imported texture resources.
- Applied the same resource-aware check to paper tree animation frame discovery.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Inspected the current APK contents and confirmed source PNGs such as `assets/sprites/web-normalized-stages/course-daisy-bloom.png` are absent while their `.png.import` and `.ctex` resources are present, matching the root cause.
- Confirmed `paper-camphor-fruit` fallback dimensions match its normalized/full-canvas dimensions, unlike broken examples such as `paper-ginkgo-tree`, `paper-cherry-flower`, and `paper-willow-flower`.

### Notes

- No visual assets were generated or modified.
- No Android signing/template changes were made; this slice targets preview/export visual consistency only.
- Existing unrelated local changes were left untouched.

## 2026-06-08 - Normalize Godot map plant sprite sizing

### Summary

- Fixed a remaining Godot map sprite distortion path by sizing non-empty plot buttons from each sprite's actual texture dimensions.
- Copied the harvested garden's normal center-tree display setup into the rest of the map by using the camphor fruit texture/frame ratio as the shared map reference.
- Bumped the layout to 25 and reset all non-empty plot `size_scale` values to `0.72`, removing the old row-by-row enlargement that made lower plants explode in size.
- Updated the Python map preview helper and static asset guards to use/check the same reference texture scale.
- Tightened the Android preview script so it fails when no Godot executable is available instead of silently reusing an old APK.
- Shifted verification expectations toward Android emulator screenshots for visual truth; Godot desktop/Python previews are not treated as final WYSIWYG evidence.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/preview_android.ps1`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/preview_godot_web_assets.py`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Parsed `scripts/preview_godot_web_assets.py` and `scripts/verify_godot_garden_assets.py` with Python `ast.parse`.
- Parsed `godot-prototype/scripts/preview_android.ps1` with PowerShell `ScriptBlock`.
- Read the seed data and confirmed every non-empty plot now has `size_scale` 0.72 while empty plots keep their own scale.
- Calculated the runtime display sizes from the actual sprite dimensions; mature harvested trees now cluster around the normal center tree size instead of using row-enlarged boxes.
- Ran Godot MCP debug startup for `res://scenes/main.tscn`; it reported `layout_version` 25 and no final errors. This was used only as a runtime/script check, not visual approval.
- Previously ran `godot-prototype/scripts/preview_android.ps1`; it installed/launched the emulator app and captured `godot-prototype/exports/android-qa-preview-latest.png`, but the old script reused an existing APK when no Godot executable was found. That screenshot is not accepted as proof of this change, and the script now fails in that situation.
- Searched `D:\ag_runtime`, the project tree, AppData, common Program Files paths, and running process command lines for a usable Godot executable; none was found.

### Notes

- No new art assets were generated.
- Existing unrelated root `.cmd` deletion states were left untouched.
- The deprecated root web runtime was not modified.
- A fresh Android APK export is still needed before final visual approval of this slice.

## 2026-06-08 - Fix Godot map plant grounding and shadow bars

### Summary

- Fixed the active Godot map plant grounding path that still rendered plants with a centered texture box and a dark detached contact-shadow bar.
- Added a shared `PLOT_GROUND_ANCHOR_Y` so plot placement, onboarding highlight, debug dragging, and plant sway pivot use the same baseline.
- Rendered non-empty map plants with full-canvas `TextureRect.STRETCH_SCALE`, preserving normalized sprite baselines instead of recentering each asset.
- Made plant contact shadows shorter, lighter, and closer to the root baseline.
- Kept the adjacent empty-plot dashed guide and removal-confirmation work in place, and tightened the guide size so empty plots read as planting slots rather than large dirt rectangles.
- Updated the Godot preview helper and static guards so the plant grounding behavior remains checkable.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `scripts/preview_godot_web_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Parsed `scripts/preview_godot_web_assets.py` and `scripts/verify_godot_garden_assets.py` with Python `ast.parse`.
- Rendered the active zone preview in memory through `scripts/preview_godot_web_assets.py`; it produced a `780x1240` canvas.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/data/garden_seed.json godot-prototype/scripts/verify_detail_ui.ps1 scripts/verify_godot_garden_assets.py scripts/preview_godot_web_assets.py`; only normal Windows line-ending warnings were reported.
- Ran Godot 4.6.3 debug startup for `res://scenes/main.tscn`; final runtime output had no errors and reported `layout_version` 24.

### Notes

- The shell sandbox denied writing preview PNGs and `__pycache__` files, so preview verification used in-memory rendering rather than saving a new contact sheet.
- Existing unrelated root `.cmd` deletion states were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-08 - Empty plot dashed guide and plant removal confirmation

### Summary

- Replaced empty plot runtime visuals with a transparent dashed click guide drawn by Godot, so empty land no longer shows the prominent soil sprite.
- Cleared empty plot sprite paths in the Godot seed data so fresh saves and migrated saves do not reintroduce the soil tile.
- Added a "移除" confirmation dialog for planted plots; confirming now resets the same plot back to an empty, reusable slot instead of deleting the plot entry.
- Added static guards for the dashed empty guide, confirmation flow, and non-deleting remove behavior.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; first red run failed on the missing empty-guide/remove-confirm snippets, final run passed.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; missing assets 0, paper tree animation errors 0, unstable mature paper paths 0.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/data/garden_seed.json godot-prototype/scripts/verify_detail_ui.ps1 scripts/verify_godot_garden_assets.py docs/pending-changes.md`; only normal Windows line-ending warnings were reported.
- Ran Godot 4.6.3 debug startup for `res://scenes/main.tscn`; runtime output printed `AcademicGardenRuntimeLayout` and had no errors.
- Attempted a Windows screenshot pass for visual inspection, but the Computer Use helper failed twice with `windows sandbox failed: spawn setup refresh`; stopped retrying and relied on static/resource/runtime checks.

### Notes

- No new visual assets were generated; the empty guide is runtime-drawn.
- Existing unrelated local changes, including prior Godot edits and unrelated deleted root `.cmd` files, were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-08 - Add Dr.Meow Godot onboarding guide

### Summary

- Added a first-run and replayable onboarding guide to the Godot portrait prototype.
- Introduced the "新手引导" header button and a Dr.Meow dialog overlay with dimming, target highlights, arrows, step navigation, skip/finish controls, and contextual copy for the app's core loop.
- The guide explains the three garden views, plant/project records, detail cards, quick notes, stage progression, decoration placement, and save backup entry point.
- Added `onboarding_seen` to saved data so the guide auto-opens until completed, then can be replayed manually.
- Refined the onboarding sheet using mobile UI/UX checks: stronger scrim, clearer card hierarchy, 44px+ tutorial buttons, a step progress bar, and a real Dr.Meow avatar frame.
- Generated the Dr.Meow mascot as a doctoral-cap cat holding a gardening trowel, then chroma-key removed the background and cropped it into a 512x512 transparent runtime sprite.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `godot-prototype/assets/art/dr-meow-guide-gpt-v1-source.png`
- `godot-prototype/assets/sprites/ui/dr-meow-guide-gpt-v1.png`
- `docs/pending-changes.md`

### Verification

- Ran `rg -n "ONBOARDING_STEPS|onboarding_seen|Dr\\.Meow|_show_onboarding" godot-prototype/scripts/main.gd`; before implementation it returned no matches, after implementation it found the expected onboarding entry points.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran Godot 4.6.3 debug startup for `res://scenes/main.tscn`; final runtime output had no errors.
- Ran a Pillow alpha/size check on the Dr.Meow runtime sprite; output is 512x512 with transparent corners and a centered subject bbox.

### Notes

- Asset prompt constraints: cozy pixel-art scholar cat gardener, black doctoral cap, tiny gardening trowel, moss-green gardening apron, crisp mobile-readable silhouette, flat #ff00ff chroma-key background.
- The source sheet was kept under `assets/art/`; the app-ready transparent sprite is under `assets/sprites/ui/`.
- Existing unrelated root `.cmd` deletion states were left untouched.

## 2026-06-08 - Android preview workflow and runtime visual alignment

### Summary

- Added a one-click Android preview entrypoint at `godot-prototype/preview_android.cmd`.
- Added `godot-prototype/scripts/preview_android.ps1` to start the project AVD, optionally export/sign the Android debug APK, install it, launch it, and capture screenshot/logcat artifacts under `godot-prototype/exports/android-qa-preview-*`.
- The preview script clears the emulator app data by default so APK previews use the currently bundled seed/layout instead of stale Android `user://garden_state.json`; pass `-KeepData` to preserve emulator data.
- Bumped the Godot layout version to 23 so existing saves migrate to the current plot anchors, sizes, and sprites.
- Changed empty plot runtime/seed sprites from the transparent square plot to `plot-soil-gpt-v3.png` so open land no longer looks like a translucent bar.
- Enlarged mature plant display frames and reduced the separate contact shadow, which makes APK plant rendering closer to the Godot desktop run and reduces the "half-cut" visual.
- Added a runtime layout diagnostic line, `AcademicGardenRuntimeLayout=...`, to Godot output/logcat with viewport, window, safe area, root offsets, map canvas, and map rect data.
- Extended debug layout export metadata with the same runtime layout snapshot.

### Files Changed

- `godot-prototype/preview_android.cmd`
- `godot-prototype/scripts/preview_android.ps1`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python scripts/verify_godot_garden_assets.py`; layout 23, missing assets 0, paper tree animation errors 0.
- Ran `git diff --check`; only existing CRLF normalization warnings were reported.
- Ran Godot MCP `run_project` on `res://scenes/main.tscn`; project started cleanly and printed `AcademicGardenRuntimeLayout` with no debug errors.
- Ran `godot-prototype/scripts/preview_android.ps1 -SkipExport`; it started `academic_garden_api35`, cleared emulator app data, installed the existing APK, launched the app, and captured `godot-prototype/exports/android-qa-preview-latest.png` plus logcat.

### Notes

- The shell environment could not locate a `Godot*.exe`; the Android script therefore could not export a new APK during this pass. Use `godot-prototype/preview_android.cmd -GodotExe "path\to\Godot.exe"` or put Godot on `PATH`/`GODOT_EXE` to make the same script export the fresh APK before installing.
- The `-SkipExport` screenshot verifies the preview workflow, but it reflects the pre-existing APK rather than the visual code changes in this slice.
- Existing unrelated local changes, including generated APK artifacts and unrelated deleted root `.cmd` files, were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-06 - Rebuild Android APK for portrait compatibility

### Summary

- Rebuilt the Godot Android prototype APK after phone testing showed the previous build opened as a blank landscape screen.
- Locked the Godot mobile project orientation to portrait and switched the Android/mobile rendering method to `gl_compatibility`.
- Fixed Android-exported runtime asset loading by using Godot's `ResourceLoader` for imported textures and audio instead of raw file reads that fail inside exported packs.
- Added x86_64 Android native libraries alongside arm64 so the local Android emulator can run the APK without ARM translation.
- Added `.gdignore` to the export output directory so generated APKs, screenshots, and log files are not imported as Godot resources.
- Re-exported the APK through Godot's Android exporter and signed the generated unsigned APK with the local debug keystore.
- Confirmed the rebuilt APK manifest now reports portrait orientation and Godot rendering metadata `gl_compatibility`.

### Files Changed

- `godot-prototype/project.godot`
- `godot-prototype/export_presets.cfg`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/exports/.gdignore`
- `godot-prototype/exports/academic-garden-prototype-debug.apk` (generated local test artifact)
- `godot-prototype/exports/academic-garden-prototype-godot-unsigned.apk` (generated local intermediate artifact)
- `.gitignore`
- `docs/pending-changes.md`

### Verification

- Ran Godot CLI `--import` after the Android/mobile project setting changes.
- Exported `godot-prototype/exports/academic-garden-prototype-godot-unsigned.apk` with Godot's Android exporter.
- Signed `godot-prototype/exports/academic-garden-prototype-debug.apk` using the local debug keystore.
- Ran `apksigner verify --verbose`; the APK verifies with v2 and v3 signatures.
- Ran `aapt dump xmltree`; `android:screenOrientation` is `0x1` and `org.godotengine.rendering.method` is `gl_compatibility`.
- Ran `aapt dump badging`; the APK reports package `org.academicgarden.prototype`, label `Academic Garden`, portrait screen support, and native code for `arm64-v8a` and `x86_64`.
- Confirmed the APK contains `assets/project.binary`, `assets/scenes/main.tscn.remap`, `assets/data/garden_seed.json`, `lib/arm64-v8a/libgodot_android.so`, and `lib/x86_64/libgodot_android.so`.
- Launched `res://scenes/main.tscn` through Godot MCP; debug output reported no errors.
- Installed Android Emulator and an Android 35 Google APIs x86_64 system image under the local runtime, created the `academic_garden_api35` AVD, and verified the APK on that emulator.
- Verified the first emulator attempts using SwiftShader were not suitable proof: Vulkan produced `QueuePresentKHR failed`, while GLES SwiftShader hit `GL_MAX_FRAGMENT_UNIFORM_VECTORS`.
- Restarted the emulator with host GPU rendering, installed the signed APK, launched `org.academicgarden.prototype`, and captured `android-qa-screenshot-hostgpu-gl.png`; the app opened to the garden screen in portrait.
- Captured `android-qa-logcat-hostgpu-gl.txt`; it shows `lib/x86_64/libgodot_android.so`, `usesVulkan(): false`, `renderer: gl_compatibility`, `OpenGL ES 3.1` on NVIDIA host GPU, and `OnGodotMainLoopStarted` with no resource-loading, shader-link, or crash errors.
- Ran a basic interaction smoke test by tapping a garden plant; `android-qa-screenshot-interaction.png` shows the plant detail panel, and `android-qa-logcat-interaction.txt` had no crash, script, resource, or shader errors.

### Notes

- Existing unrelated local work in `godot-prototype/scripts/main.gd` and `godot-prototype/scripts/verify_detail_ui.ps1` was left untouched.
- Android QA screenshots and logcats are generated under `godot-prototype/exports/android-qa-*` and ignored by Git.
- The deprecated root web runtime was not modified.

## 2026-06-06 - Godot local save import/export

### Summary

- Added a Godot mobile backup entry in the portrait HUD for local save import/export.
- Kept automatic saves on `user://garden_state.json`, and added a versioned export payload with app id, schema version, exported timestamp, layout version, garden data, and checksum.
- Added JSON import validation, support for both wrapped export files and raw legacy garden data, and an automatic pre-import backup at `user://garden_state.before-import.json`.
- Added a backup panel with export/import file dialogs, status feedback, and short mobile operation instructions explaining where exported files are saved and how to restore them.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Launched `res://scenes/main.tscn` through Godot MCP; debug output reported no errors.
- Reviewed the targeted diff for `godot-prototype/scripts/main.gd` and `godot-prototype/scripts/verify_detail_ui.ps1`.

### Notes

- No server, deprecated root web runtime, or visual assets were changed.
- Existing unrelated local work was left untouched.

## 2026-06-05 - Godot homepage mobile UI consolidation pass

### Summary

- Tightened the Godot portrait homepage HUD so the logo and coin counter read as compact mobile HUD elements instead of a large web header.
- Rebalanced homepage foreground depth with smaller upper-row plants, medium middle-row plants, larger lower-row plants, softer harvested coloring, brighter dormant interactables, and shared contact shadows for plants and decorations.
- Replaced floating garden entrance labels with wood-sign map markers while preserving the existing transparent hotspot click areas.
- Restyled the bottom decoration tray to hide the horizontal scrollbar, keep real sprite previews and quantity badges, increase touch targets, and clarify selected/disabled/placeable states.
- Shortened the bottom hint copy and moved it into a more readable in-game prompt strip.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python scripts/verify_godot_garden_assets.py`; it reported `missing 0`, `paper tree stage animation errors 0`, and `unstable paper mature stage paths 0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/data/garden_seed.json godot-prototype/scripts/verify_detail_ui.ps1 scripts/verify_godot_garden_assets.py`; only normal Windows line-ending warnings appeared.
- Launched `res://scenes/main.tscn` through Godot MCP and confirmed final debug output had no errors.

### Notes

- No new visual assets were generated for this pass.
- Existing unrelated local work, including deprecated root web runtime changes already present in the working tree, was left untouched.

## 2026-06-05 - Brighten harvested garden sprite filter

### Summary

- Adjusted the Godot harvested garden sprite filter so trees, flowers, and placed decorations read as mature warm-gold highlights instead of being dimmed like the dormant garden.
- Kept the dormant garden filter blue-gray and low-brightness so it still communicates sleep/rest.
- Added a static detail-UI guard that fails if the harvested garden filter is ever changed back to a dimmer-than-normal treatment.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; it reported `missing 0`, `paper tree stage animation errors 0`, and `unstable paper mature stage paths 0`.

### Notes

- Existing unrelated local work and generated art assets were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Keep selected Godot tree visible behind detail

### Summary

- Changed the Godot map/detail interaction so tapping a planted tree keeps the original map tree rendered while opening the detail panel.
- Removed the selected-plot render skip and the matching selected ambient-FX suppression tied to the old detail-card behavior.
- Updated the detail UI static check so future changes do not reintroduce hiding the selected map plant when detail opens.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/scripts/verify_detail_ui.ps1 docs/pending-changes.md`; only normal CRLF warnings appeared.
- Confirmed `godot-prototype/scripts/main.gd` no longer contains `_hide_map_plot_behind_detail`.
- Attempted to launch `res://scenes/main.tscn` twice through Godot MCP; the MCP reported the project started, then immediately reported no active Godot process before debug output was available.

### Notes

- Existing unrelated local work was left untouched.

## 2026-06-08 - Clean Lotus Fruit Sprite Marker Dots

### Summary

- Removed six stray green square marker dots from the Godot lotus fruit-stage sprite.
- Repaired only the affected small petal areas using the clean lotus bloom sprite as the local pixel reference.
- Kept the original sprite canvas size, transparent padding, and baseline alignment unchanged.

### Files Changed

- `godot-prototype/assets/sprites/web-normalized-stages/course-lotus-fruit.png`
- `docs/pending-changes.md`

### Verification

- Visually checked the cleaned lotus fruit sprite.
- Ran a targeted pixel check confirming the six former marker-dot regions no longer contain the green marker pixels.

### Notes

- Existing unrelated local work was left untouched.

## 2026-06-08 - Restyle Godot Remove Confirmation

### Summary

- Replaced the default Godot remove confirmation dialog with a garden-styled custom overlay.
- Matched the existing Sprout Lands-inspired UI language with a dimmed modal layer, warm paper panel, dark wood border, Dr.Meow art, and wood/green action buttons.
- Preserved the existing remove behavior: tapping remove opens confirmation, cancel/X/Esc clears the pending action, and confirming resets the selected plot to an empty guide.
- Fixed a minimal indentation parse error in `main.gd`'s plot upgrade branch that prevented Godot from parsing the script.
- Kept concurrent harvested pagination work parseable by preserving its helper implementation, adding minimal type annotations in the plot-swap path, and syncing static check version guards to layout 27.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --check-only --script godot-prototype/scripts/main.gd`.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/scripts/verify_detail_ui.ps1 scripts/verify_godot_garden_assets.py docs/pending-changes.md`; only normal CRLF warnings appeared.

### Notes

- Existing unrelated local work was left untouched.

## 2026-06-06 - Build Android Prototype APK Test Package

### Summary

- Added a Godot Android debug export preset for the portrait prototype.
- Configured the Godot project icon with the existing Academic Garden logo.
- Enabled Android ETC2/ASTC texture import, which Godot's Android exporter requires before it will produce a valid APK.
- Replaced the earlier manual template APK with a proper Godot Android export: Godot now builds the APK structure and project assets, then the unsigned APK is signed separately with a local debug keystore to avoid a Windows file-lock issue in Godot's internal signing step.
- Added ignore rules so generated APK/PCK/signature artifacts under `godot-prototype/exports/` are not accidentally committed.

### Files Changed

- `.gitignore`
- `godot-prototype/project.godot`
- `godot-prototype/export_presets.cfg`
- `godot-prototype/exports/.gitkeep`
- `godot-prototype/exports/academic-garden-prototype-debug.apk` (generated local test artifact)
- `godot-prototype/exports/academic-garden-prototype-godot-unsigned.apk` (generated local intermediate artifact)
- `docs/pending-changes.md`

### Verification

- Ran Godot MCP `run_project` on `res://scenes/main.tscn`; startup output was clean.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran Godot CLI `--import` after enabling Android ETC2/ASTC texture import.
- Exported `godot-prototype/exports/academic-garden-prototype-godot-unsigned.apk` with Godot's Android exporter.
- Signed `godot-prototype/exports/academic-garden-prototype-debug.apk` using the local debug keystore on a no-space temporary path.
- Ran `apksigner verify --verbose` successfully; the APK verifies with v2 and v3 signatures.
- Ran `aapt dump badging`; the APK now reports package `org.academicgarden.prototype`, version `0.1.0`, and label `Academic Garden`.

### Notes

- Existing unrelated local work was left untouched, including prior changes in `godot-prototype/scripts/main.gd` and `godot-prototype/scripts/verify_detail_ui.ps1`.
- The earlier manual template APK could install but failed at launch with `unable to setup Godot engine`; it has been replaced at the same output path by the proper Godot-exported APK.
- The deprecated root web runtime was not modified.

## 2026-06-05 - ImageGen camphor flower and fruit replacement

### Summary

- Replaced the hand-drawn camphor flower/fruit attempt with an ImageGen-generated source sheet after review feedback that the previous flower and fruit markers were effectively missing.
- Generated a two-column ImageGen source for camphor flower and fruit stages with obvious cream blossoms and purple-blue berry clusters.
- Removed the chroma-key background, normalized both sprites back into the existing 241x279 Godot canvas, and regenerated the stage animations and review GIFs.

### Files Changed

- `godot-prototype/assets/art/paper-camphor-flower-fruit-imagegen-v1-source-cyan.png`
- `godot-prototype/assets/art/paper-camphor-flower-fruit-imagegen-v1-sheet.png`
- `godot-prototype/assets/art/paper-camphor-flower-fruit-imagegen-v1-review.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-camphor-flower.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-camphor-fruit.png`
- `godot-prototype/assets/sprites/stages/paper-camphor-flower.png`
- `godot-prototype/assets/sprites/stages/paper-camphor-fruit.png`
- `godot-prototype/assets/sprites/stages/paper-camphor-flower-full.png`
- `godot-prototype/assets/sprites/stages/paper-camphor-fruit-full.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-camphor-flower/`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-camphor-fruit/`
- `godot-prototype/assets/art/paper-camphor-flower-animation-v1.gif`
- `godot-prototype/assets/art/paper-camphor-fruit-animation-v1.gif`
- `godot-prototype/assets/art/paper-tree-stage-animation-v1-review.png`
- `scripts/redraw_camphor_flower_fruit.py` removed because it was the superseded local drawing path.
- `docs/pending-changes.md`

### Verification

- Visually inspected `paper-camphor-flower-fruit-imagegen-v1-review.png` and `paper-tree-stage-animation-v1-review.png`.
- Confirmed `paper-camphor-flower.png` and `paper-camphor-fruit.png` are 241x279 with visible ImageGen blossoms/fruit and complete crowns.
- Confirmed camphor flower/fruit preview GIFs have 6 frames.
- Ran `python scripts/verify_godot_garden_assets.py`; it reported `paper tree stage animation errors 0`, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran syntax parsing for `scripts/generate_paper_tree_stage_animations.py`.
- Launched `res://scenes/main.tscn` through Godot MCP and observed no debug errors.

### Asset Notes

- ImageGen prompt required the current camphor tree identity, a full rounded crown, obvious cream-white/yellow blossoms for flower, obvious purple-blue berries for fruit, equal two-column layout, no labels/UI, and a flat cyan chroma-key background.
- Local processing only removed chroma key and normalized the generated trees to the existing Godot canvas; the flower/fruit artwork itself came from ImageGen.
- The previous local pixel-marker camphor flower/fruit attempt is superseded by this ImageGen pass, and the local redraw script has been removed to prevent reuse.

### Notes

- Existing unrelated local work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Redraw camphor flower and fruit crowns

### Summary

- Fixed the camphor flower/fruit trees after review feedback showed the previous rightmost last-row trees had flat, incomplete-looking crowns.
- Root cause: the camphor flower/fruit source sprites themselves had a flat-top canopy shape; the previous canvas-fit change only added transparent padding around the bad silhouette.
- Rebuilt `paper-camphor-flower` and `paper-camphor-fruit` from the rounded `paper-camphor-tree` base, then added readable flowers or purple fruit markers on top.
- Regenerated the paper tree animation frames and review GIFs from the corrected sprites.

### Files Changed

- `scripts/redraw_camphor_flower_fruit.py`
- `scripts/generate_paper_tree_stage_animations.py`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-camphor-flower.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-camphor-fruit.png`
- `godot-prototype/assets/sprites/stages/paper-camphor-flower.png`
- `godot-prototype/assets/sprites/stages/paper-camphor-fruit.png`
- `godot-prototype/assets/sprites/stages/paper-camphor-flower-full.png`
- `godot-prototype/assets/sprites/stages/paper-camphor-fruit-full.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-camphor-flower/`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-camphor-fruit/`
- `godot-prototype/assets/art/paper-camphor-flower-animation-v1.gif`
- `godot-prototype/assets/art/paper-camphor-fruit-animation-v1.gif`
- `godot-prototype/assets/art/paper-tree-stage-animation-v1-review.png`
- `godot-prototype/assets/art/paper-tree-stage-animation-v1.txt`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/redraw_camphor_flower_fruit.py`.
- Ran `python scripts/generate_paper_tree_stage_animations.py`.
- Visually inspected `paper-camphor-flower.png`, `paper-camphor-fruit.png`, and `paper-tree-stage-animation-v1-review.png`.
- Confirmed camphor flower/fruit static sprites now have rounded full-crown bounding boxes `(8, 8, 233, 271)` and transparent corners.
- Confirmed camphor flower/fruit animation frames keep full-crown bounds and transparent corners.
- Ran `python scripts/verify_godot_garden_assets.py`; it reported `paper tree stage animation errors 0`, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran syntax parsing for `scripts/redraw_camphor_flower_fruit.py` and `scripts/generate_paper_tree_stage_animations.py`.

### Notes

- Existing unrelated local work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Fit camphor animation previews inside canvas

### Summary

- Adjusted the last-row rightmost paper tree animation previews after the camphor flower/fruit trees looked clipped at the top.
- Added a targeted post-fit step for `paper-camphor-flower` and `paper-camphor-fruit`, scaling visible content to 92% inside the original canvas while preserving the lower anchor.
- Regenerated all paper tree animation frames and preview GIFs with the updated generator.

### Files Changed

- `scripts/generate_paper_tree_stage_animations.py`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-camphor-flower/`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-camphor-fruit/`
- `godot-prototype/assets/art/paper-camphor-flower-animation-v1.gif`
- `godot-prototype/assets/art/paper-camphor-fruit-animation-v1.gif`
- `godot-prototype/assets/art/paper-tree-stage-animation-v1-review.png`
- `godot-prototype/assets/art/paper-tree-stage-animation-v1.txt`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/generate_paper_tree_stage_animations.py`.
- Visually inspected `godot-prototype/assets/art/paper-tree-stage-animation-v1-review.png`.
- Confirmed camphor flower/fruit animation frame bounding boxes now leave 32-36 px of top transparent padding while keeping transparent corners.
- Ran `python scripts/verify_godot_garden_assets.py`; it reported `paper tree stage animation errors 0`, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.

### Notes

- Existing unrelated local work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot paper tree stage animations

### Summary

- Repeated the approved cherry v7 animation mode across all paper tree mature stage sprites.
- Generated 18 six-frame animations for 6 tree varieties across the third, fourth, and fifth lifecycle columns: `tree`, `flower`, and `fruit`.
- Third-column `tree` animations include rooted canopy micro-rotation plus falling petals/leaves; fourth/fifth `flower` and `fruit` animations use rooted canopy micro-rotation only.
- Added a lightweight Godot texture-frame player so both map plant sprites and detail-card portrait sprites play the generated animation frames when a matching stage-animation folder exists.

### Files Changed

- `scripts/generate_paper_tree_stage_animations.py`
- `scripts/verify_godot_garden_assets.py`
- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/`
- `godot-prototype/assets/art/paper-*-animation-v1.gif`
- `godot-prototype/assets/art/paper-tree-stage-animation-v1-review.png`
- `godot-prototype/assets/art/paper-tree-stage-animation-v1.txt`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/generate_paper_tree_stage_animations.py`.
- Ran `python -c "import ast, pathlib; ast.parse(pathlib.Path('scripts/generate_paper_tree_stage_animations.py').read_text(encoding='utf-8')); print('animation generator syntax ok')"`.
- Ran `python scripts/verify_godot_garden_assets.py`; it reported `paper tree stage animation errors 0`, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Launched `res://scenes/main.tscn` through Godot MCP and confirmed final output had no errors.
- Visually inspected `godot-prototype/assets/art/paper-tree-stage-animation-v1-review.png`.

### Asset Notes

- Runtime frames live under `assets/sprites/stage-animations/paper-trees/paper-<variety>-<stage>/frame-00.png` through `frame-05.png`.
- Each animation preserves the original static sprite dimensions so Godot map and detail layouts keep their existing boxes and anchors.
- The generated preview GIFs under `assets/art/` are for review; Godot runtime uses PNG frame sequences rather than GIF files.
- Generated with local layer processing from existing Godot sprites; no new ImageGen call was used for this batch.

### Notes

- Existing unrelated local work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Cherry canopy pivot sway preview

### Summary

- Reworked the cherry falling-petals animation after review feedback that v6 still looked like horizontal translation.
- Built a v7 preview where the full pink blossom canopy micro-rotates around a rooted base pivot instead of sliding left and right.
- Kept the trunk, branches, roots, grass base, and ground flowers fixed, while preserving visible falling petals.

### Files Changed

- `godot-prototype/assets/art/paper-cherry-falling-petals-v7-canopy-pivot-petals-godot-sheet.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v7-canopy-pivot-petals-review.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v7-canopy-pivot-petals-preview.gif`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v7-canopy-pivot-petals.txt`
- `godot-prototype/assets/sprites/sprout/fx/cherry-fall-v1/paper-cherry-fall-v7-canopy-pivot-petals-*.png`
- `docs/pending-changes.md`

### Verification

- Visually inspected `paper-cherry-falling-petals-v7-canopy-pivot-petals-review.png`.
- Confirmed the preview GIF has 6 frames, the Godot preview sheet is 1536x256, and each normalized frame is 256x256 with transparent corners.
- Confirmed the root/base band remains stable; visible bounding boxes only expand in frames with falling petals.

### Asset Notes

- Used the v3 clean base frame as the source and animated the full pink blossom canopy mask above the base band.
- Motion sidecar records `pivot=(128, 232)` and `angles_degrees=[0.0, -0.35, -0.55, -0.25, 0.35, 0.0]`.
- This remains preview art only; no Godot runtime script or scene reference was changed.

### Notes

- Existing unrelated local work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Cherry full-pink canopy sway with restored petals

### Summary

- Reworked the cherry falling-petals preview after review feedback that v3 only moved the top of the canopy and made the falling petals too subtle.
- Built a v6 preview where the whole pink blossom canopy moves together while the trunk, branches, roots, grass base, and ground flowers stay fixed.
- Restored more readable falling petals using small 2-3 px blossom particles along a right/down drift path.

### Files Changed

- `godot-prototype/assets/art/paper-cherry-falling-petals-v6-full-pink-sway-visible-petals-godot-sheet.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v6-full-pink-sway-visible-petals-review.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v6-full-pink-sway-visible-petals-preview.gif`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v6-full-pink-sway-visible-petals.txt`
- `godot-prototype/assets/sprites/sprout/fx/cherry-fall-v1/paper-cherry-fall-v6-full-pink-sway-visible-petals-*.png`
- `docs/pending-changes.md`

### Verification

- Visually inspected `paper-cherry-falling-petals-v6-full-pink-sway-visible-petals-review.png`.
- Confirmed the preview GIF has 6 frames, the Godot preview sheet is 1536x256, and each normalized frame is 256x256 with transparent corners.
- Confirmed the root/base band remains stable; visible bounding boxes only expand in frames with falling petals.

### Asset Notes

- Used the v3 clean base frame as the source and expanded the animated mask to cover all pink blossom canopy pixels above the base band.
- Motion sidecar records `canopy_offsets_px=[0, 1, 2, 1, -1, 0]`.
- Ground flowers on the grass base remain fixed because they belong to the grounded base layer, not the wind-swaying canopy.
- This remains preview art only; no Godot runtime script or scene reference was changed.

### Notes

- Existing unrelated local work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Cherry crown-only micro sway preview

### Summary

- Reworked the cherry falling-petals animation after review feedback that the root-anchored rotation still looked too large and made the ground/trunk behave incorrectly.
- Built a v3 preview where the trunk, branches, roots, and grass base remain fixed, and only the pink blossom canopy gets a tiny crown-only sway.
- Reduced motion amplitude to at most 1 px of canopy offset and slowed the GIF preview timing.

### Files Changed

- `godot-prototype/assets/art/paper-cherry-falling-petals-v3-crown-only-godot-sheet.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v3-crown-only-review.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v3-crown-only-preview.gif`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v3-crown-only.txt`
- `godot-prototype/assets/sprites/sprout/fx/cherry-fall-v1/paper-cherry-fall-v3-crown-only-*.png`
- `docs/pending-changes.md`

### Verification

- Visually inspected `paper-cherry-falling-petals-v3-crown-only-review.png`.
- Confirmed the preview GIF has 6 frames, the Godot preview sheet is 1536x256, and each normalized frame is 256x256 with transparent corners.
- Confirmed all v3 frames share the same visible bounding box; central trunk/base pixels remain stable apart from tiny falling-petal pixels crossing the inspected area.

### Asset Notes

- Used the existing v2 transparent tree sheet as the source, then locally separated the pink blossom canopy from the fixed trunk/base layer.
- Motion sidecar records `canopy_offsets_px=[0, 1, 1, 0, -1, 0]`; no full-sprite rotation or ground movement is used.
- This remains preview art only; no Godot runtime script or scene reference was changed.

### Notes

- Existing unrelated local work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Cherry root-anchored falling-petals animation preview

### Summary

- Corrected the cherry falling-petals animation direction so the motion reads as a root-anchored tilt instead of left-right translation.
- Generated a second ImageGen source strip, removed the cyan chroma-key background, then normalized and post-processed the frames with a fixed root pivot.
- Applied a subtle tilt sequence around the root anchor while keeping the grass/root base visually fixed.

### Files Changed

- `godot-prototype/assets/art/paper-cherry-falling-petals-v2-source-cyan.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v2-sheet.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v2-anchor-godot-sheet.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v2-anchor-review.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v2-anchor-preview.gif`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v2-anchor.txt`
- `godot-prototype/assets/sprites/sprout/fx/cherry-fall-v1/paper-cherry-fall-v2-anchor-*.png`
- `docs/pending-changes.md`

### Verification

- Visually inspected `paper-cherry-falling-petals-v2-anchor-review.png`.
- Confirmed the root-anchor sidecar records `root_anchor=(128, 232)`, `base_y=210`, and tilt angles `[0.0, -1.1, -2.0, -0.7, 1.1, 0.0]`.
- Confirmed the preview GIF has 6 frames, the Godot preview sheet is 1536x256, and all normalized frames are 256x256 with transparent corners.

### Asset Notes

- Built-in ImageGen mode was used for the updated full-tree source strip.
- Local post-processing intentionally fixed the root/base band and rotated the tree around the root pivot so the animation follows the requested rooted sway behavior.
- This remains preview art only; no Godot runtime script or scene reference was changed.

### Notes

- Existing unrelated local work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Cherry falling-petals animation art preview

### Summary

- Generated a first-pass complete-action falling-petals animation for the mature cherry tree.
- Used a full 6-frame ImageGen sprite strip so each frame redraws the complete tree with petals in motion, instead of compositing a separate FX layer onto a static tree.
- Removed the cyan chroma-key background, sliced the strip, normalized a Godot-preview frame set to 256x256 with a shared bottom-center anchor, and rendered review/GIF previews.

### Files Changed

- `godot-prototype/assets/art/paper-cherry-falling-petals-v1-source-cyan.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v1-sheet.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v1-godot-sheet.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v1-review.png`
- `godot-prototype/assets/art/paper-cherry-falling-petals-v1-preview.gif`
- `godot-prototype/assets/sprites/sprout/fx/cherry-fall-v1/`
- `docs/pending-changes.md`

### Verification

- Visually inspected `paper-cherry-falling-petals-v1-review.png`.
- Confirmed the generated source is a 6-slot horizontal strip and the normalized runtime-preview frames are 256x256.
- Confirmed the normalized frames retain alpha transparency.

### Asset Notes

- Built-in ImageGen mode was used with the current cherry tree sprite visible as style/silhouette reference.
- Prompt constraints: complete tree redrawn in every frame, six equal chronological slots, stable bottom-center root anchor, Sprout Lands-like cozy pixel art, no text/UI/scenery, cyan chroma-key background for local removal.
- This is preview art only; no Godot runtime script or scene reference was changed.

### Notes

- Existing unrelated local work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Revert overactive Godot plant FX attempt

### Summary

- Reverted the latest attempt to make every mature map plant render randomized ambient FX.
- Root cause for the bad result: enabling `leaf`, `flyby`, and `sparkle` FX across all mature plants at once overloaded the portrait map with large repeated particles.
- Removed the temporary balanced feedback chooser and its per-launch effect counter.
- Restored selected-plot-only ambient FX behavior from before this attempt while keeping the existing detail-card suppression guard.
- Left placed decorations unregistered for animation.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Confirmed `main.gd` no longer contains the temporary `plant_feedback_effect_counts` state or `_choose_plant_feedback_effect()` helper.
- Confirmed `_render_plot_ambient()` is back behind the selected-plot guard.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/scripts/verify_detail_ui.ps1 docs/pending-changes.md`; only normal CRLF warnings appeared.

### Notes

- Existing unrelated local Godot/web/audio/import-file work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Hide selected map plant behind Godot detail card

### Summary

- Fixed the detail-card visual leak where the selected map plant could keep swaying behind the open detail panel.
- Root cause: the map renderer still drew and animated the selected plot after `_render_detail()` made the detail panel visible, and the static check had been guarding the wrong behavior.
- Added a detail-state guard so the selected map plot and its selected ambient FX are skipped while the detail card is open; the detail portrait remains visible inside the card.
- Updated the detail UI static check to require this guard instead of rejecting it.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported valid plot/decor counts, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/scripts/verify_detail_ui.ps1 docs/pending-changes.md`; only normal CRLF warnings appeared.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local Godot/web/audio/import-file work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Fix Godot plant random FX freezing body sway

### Summary

- Fixed the Godot map plant animation regression where only plants randomly assigned `sway` moved.
- Root cause: `_animate_plot_button()` returned early for `leaf`, `flyby`, and `sparkle`, so those plants never registered for the base body animation.
- Restored base bottom-anchored body sway for every non-empty plant while keeping randomized FX selection for selected-plant ambient feedback.
- Updated the detail UI static check so randomized FX cannot block plant body animation again.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/scripts/verify_detail_ui.ps1 docs/pending-changes.md`; only normal CRLF warnings appeared.
- Confirmed `_animate_plot_button()` no longer contains the non-`sway` early return and still appends plant buttons to `animated_plot_buttons`.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local Godot/web/audio/import-file work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot mobile safe-area inspection pass

### Summary

- Used the Game Studio inspection flow against the current Godot mobile prototype rather than the deprecated root web runtime.
- Checked the Godot project metadata, main scene, single-script runtime, resource references, seed data, detail UI guards, existing pending-change history, and current worktree boundaries.
- Added safe-area-aware root layout margins so portrait mobile builds keep the header, map, detail panel, and bottom decoration bar away from notches and gesture areas while preserving the existing 10 px desktop/debug margin.
- Recomputed the root safe-area offsets on resize so orientation/window changes keep the map layout and controls aligned.
- Extended the Godot detail UI static check to guard the safe-area root layout behavior.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported valid plot/decor counts, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/scripts/verify_detail_ui.ps1 docs/pending-changes.md`; only normal CRLF warnings appeared.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local Godot/web/audio/import-file work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Restore randomized Godot plant feedback semantics

### Summary

- Restored the requested randomized plant feedback semantics after a bad follow-up edit briefly forced every non-empty map plant into the same base sway path.
- Kept body sway limited to plants assigned the `sway` feedback type; plants assigned `leaf`, `flyby`, or `sparkle` keep their selected-plant ambient FX path.
- Removed the detail-card visibility guard that incorrectly disabled selected plant ambient FX.
- Extended the detail UI static check so future edits reject forced all-plant sway and reject disabling selected FX just because the detail card is open.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Confirmed `main.gd` no longer contains `BASE_PLANT_SWAY_PX`.
- Confirmed `_animate_plot_button()` returns early for non-`sway` feedback and `_render_plot_ambient()` still handles selected non-`sway` FX.

### Notes

- Existing unrelated local Godot/web/audio/import-file work was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Fix ImageGen tree sprite crop and animation anchor regression

### Summary

- Investigated the broken homepage tree animation/half-tree regression after the ImageGen flower/fruit replacement.
- Root cause: the first ImageGen slicing pass exported flower/fruit sprites with large transparent top padding, especially pine and willow, so Godot scaled and animated the full canvas while the visible tree sat in the lower half.
- Regenerated the ImageGen source sheet with stricter tall-tree/full-height prompt constraints.
- Replaced `paper-tree-flower-fruit-imagegen-v1-source.png` with the corrected generated sheet and re-sliced all paper tree flower/fruit runtime sprites.
- Confirmed the homepage preview no longer shows half-height tree sprites.

### Files Changed

- `godot-prototype/assets/art/paper-tree-flower-fruit-imagegen-v1-source.png`
- `godot-prototype/assets/art/tree-stage-contact-sheet-imagegen-flower-fruit-v1.png`
- `godot-prototype/assets/sprites/stages/paper-*-flower-full.png`
- `godot-prototype/assets/sprites/stages/paper-*-fruit-full.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-*-flower.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-*-fruit.png`
- `scripts/slice_imagegen_tree_flower_fruit.py`
- `docs/pending-changes.md`

### Verification

- Checked alpha bounding boxes before/after; the broken pass had visible content starting as low as y=170, while the corrected pass brings most sprites back near the top of the canvas.
- Ran `python scripts/slice_imagegen_tree_flower_fruit.py`.
- Ran `python scripts/preview_godot_web_assets.py` and visually inspected `godot-prototype/assets/art/godot-web-assets-active-preview.png`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Launched `res://scenes/main.tscn` through Godot MCP; debug output reported no errors.

### Notes

- The animation code path was left intact; the regression was caused by sprite canvas/alpha bounds.
- Existing unrelated local Godot work and untracked `.import` files were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - ImageGen redraw for paper tree flower and fruit stages

### Summary

- Replaced the rough procedural flower/fruit overlay attempt with a GPT-Image-2/ImageGen-generated sprite sheet.
- Generated a 6-row by 2-column pixel-art source sheet for all paper tree flower and fruit stages, with distinct visuals per variety.
- Copied the generated source sheet into `assets/art/` for future edits, then sliced it into runtime sprites.
- Wrote the sliced ImageGen results to both `assets/sprites/stages/*-full.png` and `assets/sprites/web-normalized-stages/*.png` so the Godot runtime displays the new art regardless of the current stage path branch.
- Removed the rough procedural review sheet and replaced it with a new ImageGen numbered review sheet.

### Files Changed

- `godot-prototype/assets/art/paper-tree-flower-fruit-imagegen-v1-source.png`
- `godot-prototype/assets/art/tree-stage-contact-sheet-imagegen-flower-fruit-v1.png`
- `godot-prototype/assets/sprites/stages/paper-*-flower-full.png`
- `godot-prototype/assets/sprites/stages/paper-*-fruit-full.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-*-flower.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-*-fruit.png`
- `scripts/slice_imagegen_tree_flower_fruit.py`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/slice_imagegen_tree_flower_fruit.py`.
- Visually inspected `godot-prototype/assets/art/tree-stage-contact-sheet-imagegen-flower-fruit-v1.png`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Confirmed each sliced `flower`/`fruit` full sprite matches the corresponding `web-normalized-stages` sprite in pixels.

### Asset Notes

- ImageGen prompt required Sprout Lands style, transparent-background pixel art, full uncropped tree sprites, 6 rows by 2 columns, no labels/text, and distinct flower/fruit states.
- The generated source contained a checkerboard transparency preview, so the slicer removes border-connected checkerboard pixels and strips row-overlap fragments before exporting transparent PNGs.

### Notes

- The previous procedural overlay attempt is superseded by this ImageGen pass.
- Existing unrelated local Godot work and untracked `.import` files were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot redrawn paper tree flower and fruit stages

### Summary

- Redrew the paper tree `flower` and `fruit` stages for all six tree varieties so the right two lifecycle columns read distinctly from `Mature`.
- Ginkgo now uses visible hanging flower tassels and orange-gold fruit; cherry uses dense blossoms and red cherry clusters; maple uses bright flower speckles and winged samaras.
- Pine uses yellow pollen/flower flecks and large pinecones; willow uses catkins and white seed fluff; camphor uses cream flowers and dark berry clusters.
- Wrote the same redrawn output to both `assets/sprites/stages/*-full.png` and `assets/sprites/web-normalized-stages/*.png` so the result appears no matter which current runtime path is selected.
- Added a reproducible redraw script and a fresh numbered review sheet.

### Files Changed

- `godot-prototype/assets/sprites/stages/paper-*-flower-full.png`
- `godot-prototype/assets/sprites/stages/paper-*-fruit-full.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-*-flower.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-*-fruit.png`
- `godot-prototype/assets/art/tree-stage-contact-sheet-redrawn-flower-fruit.png`
- `scripts/redraw_paper_tree_flower_fruit.py`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/redraw_paper_tree_flower_fruit.py`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Confirmed each redrawn `flower`/`fruit` full sprite matches the corresponding `web-normalized-stages` sprite in dimensions and pixels.
- Visually inspected `godot-prototype/assets/art/tree-stage-contact-sheet-redrawn-flower-fruit.png`.

### Notes

- Runtime code was not changed in this slice.
- Existing unrelated local work and untracked `.import` files were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot full tree stage review sheet

### Summary

- Regenerated the paper tree stage contact sheet using complete mature-stage source sprites.
- The previous review sheet used non-full `assets/sprites/stages/paper-*-tree|flower|fruit.png` crops, which made mature, flower, and fruit stages appear cut in half.
- The new sheet uses `assets/sprites/stages/paper-*-tree|flower|fruit-full.png` for mature stages and keeps numbered labels for follow-up review.

### Files Changed

- `godot-prototype/assets/art/tree-stage-contact-sheet-full-numbered.png`
- `docs/pending-changes.md`

### Verification

- Inspected the complete source sprite dimensions and confirmed all 18 `paper-*-tree|flower|fruit-full.png` files exist.
- Visually inspected `godot-prototype/assets/art/tree-stage-contact-sheet-full-numbered.png`.

### Notes

- Runtime code was not changed in this slice because adjacent Godot sprite-path logic is being edited concurrently.
- Existing unrelated local work and untracked `.import` files were left untouched.

## 2026-06-05 - Godot varied plant feedback animations

### Summary

- Changed Godot map plant feedback from one shared left-right sway pattern to per-plant session-random feedback.
- Mature plants can now be assigned sway, falling leaf, flyby, or sparkle feedback, with varied phase, speed, and travel so selected-tree responses feel less identical each app run.
- Stopped placed decorations from registering for bob/sway animation, so ponds, wells, benches, and similar static objects stay visually grounded.
- Kept decoration placement slot glow animation because it represents the placement target, not a placed decoration object.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed, including the no placed-decoration animation guard.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Launched `res://scenes/main.tscn` through Godot MCP; debug output reported no errors.

### Notes

- Existing unrelated local Godot work and untracked `.import`/asset files were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot tree stage review sheet and mature-stage sprite guard

### Summary

- Generated a numbered contact sheet for all current paper tree stage sprites so the 30 tree-stage images can be reviewed by index.
- Switched paper tree mature runtime stages (`tree`, `flower`, `fruit`) to the visibly distinct `assets/sprites/stages/*.png` sprites instead of the nearly identical normalized mature sprites.
- Raised the Godot layout version to 21 so existing local saves migrate to the updated stage sprite paths and plot sizes.
- Added clipping/scaling guards around plot, decoration, and ambient FX texture rendering to prevent oversized source sprites from spilling outside their intended boxes.
- Added verification checks that paper tree mature stages do not regress back to indistinct normalized sprite paths.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/art/tree-stage-contact-sheet-numbered.png`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/verify_godot_garden_assets.py`; all zone assets existed, missing `0`, and indistinct mature paper-stage paths `0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Visually inspected `godot-prototype/assets/art/tree-stage-contact-sheet-numbered.png`.

### Notes

- Existing unrelated local work, including record/history UI edits, logo/background work, and untracked Godot `.import` files, was left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot wood backdrop and coin HUD label

### Summary

- Replaced the light green app backdrop with a wooden plank pixel texture so the title sign sits on a matching wood-toned base.
- Updated the coin HUD from a bare count suffix to an icon plus explicit `金币 N` text.
- Reused the existing previous-web coin sprite already present in the Godot assets.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/assets/sprites/ui/app-wood-bg-v1.png`
- `docs/pending-changes.md`

### Asset Notes

- Created `app-wood-bg-v1.png` locally as a deterministic pixel-art wooden plank texture; no new image generation was used.
- Coin icon path uses the existing `res://assets/sprites/coin-v1.png` asset from the earlier web visual pass.

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations, `missing 0`, and `unstable paper mature stage paths 0`.
- Checked `app-wood-bg-v1.png` is `768x1248` RGBA and the reused coin sprite has a non-empty alpha bounding box.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local work and untracked Godot `.import` files were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot homepage wooden pixel logo

### Summary

- Generated a wooden pixel-art title logo with `学术花园` above `Academic Garden`.
- Preserved the generated source image and processed a transparent runtime PNG for the Godot header.
- Replaced the visible homepage title/subtitle label stack with a `TextureRect` that loads the new logo, while keeping the old labels hidden as state holders.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/assets/art/academic-garden-logo-gpt-v1-source.png`
- `godot-prototype/assets/sprites/ui/academic-garden-logo-gpt-v1.png`
- `docs/pending-changes.md`

### Asset Notes

- Generated with the built-in imagegen workflow.
- Prompt constraints: cozy Sprout Lands inspired pixel-art wooden title sign, large readable `学术花园`, `Academic Garden` subtitle, warm carved wood, leaf/moss accents, no characters, no extra text, no watermark.
- The generated source contained a baked checkerboard backdrop, so the runtime sprite was locally processed by removing border-connected neutral checker pixels, cropping to the logo, and saving as transparent RGBA.

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and `missing 0`.
- Checked the runtime logo PNG is `960x401` RGBA with transparent corners and a non-empty alpha bounding box.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local work and untracked Godot `.import` files were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Restore Godot plant sprite alignment

### Summary

- Restored map plant sprites to the normalized/full-stage asset path so paper tree state changes no longer swap in tight partial stage canvases.
- Removed forced clipping from plot/decoration buttons and their plant texture child so established sprite alignment and full silhouettes are preserved.
- Updated the Godot asset verifier to reject mature paper sprites that point at unstable partial `assets/sprites/stages/` canvases.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations, `missing 0`, and `unstable paper mature stage paths 0`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/data/garden_seed.json scripts/verify_godot_garden_assets.py docs/pending-changes.md`; only normal CRLF warnings appeared.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing quick-record/history UI work, BGM work, and untracked Godot `.import` files were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot customizable project record actions

### Summary

- Changed the Godot record drawer's three quick buttons from generic Water/Sun/Fertilizer actions to project-specific record actions.
- Paper projects default to `更新文稿`, `进行讨论`, and `阅读文献`; course projects default to `备课`, `上课`, and `批改作业`.
- Added editable text fields and a save button for the three quick record labels while preserving the free-form record input below them.
- Added a `查看记录` detail-card entry and a lightweight project history panel backed by per-project `record_history` data.
- Fixed record/plant button icon layout so UI icons no longer expand over button text.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and `missing 0`.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local work and untracked `.import` files were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot homepage ambient FX restraint

### Summary

- Prevented mature-plant ambient FX from rendering across the whole active garden on initial home load.
- Limited plant ambient FX to the selected plot only, reduced its display size, and clipped the FX texture rect so oversized source sprites cannot spill past their intended bounds.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and `missing 0`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `git diff --check -- godot-prototype/scripts/main.gd docs/pending-changes.md`; only normal CRLF warnings appeared.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local work, including concurrent `main.gd` quick-record/history edits visible in the working tree, was left untouched.
- Untracked Godot `.import` files were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot three-round art polish, FX, and UI icon pass

### Summary

- Completed three review/improvement rounds for the Godot mobile portrait prototype, focused on migrated rough edges in FX, decoration presentation, care UI, and verification coverage.
- Round 1 replaced ColorRect ambient motes and text-like placement slots with GPT-Image-2 pixel FX sprites, added light decoration bob/tilt animation, and localized remaining player-facing map hints/tooltips.
- Round 2 generated care UI icons and upgraded detail care cells, record buttons, planting buttons, and the decoration inventory bar toward icon-led pixel UI instead of default Godot button/icon layout.
- Round 3 expanded preview and asset verification so all three zones, placed decorations, and `main.gd` asset constants are covered.
- Updated the art progress note with the new FX/icon state and current follow-up areas.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `scripts/slice_godot_fx_sheet.py`
- `scripts/slice_godot_care_icons.py`
- `scripts/preview_godot_web_assets.py`
- `scripts/verify_godot_garden_assets.py`
- `docs/art-progress.md`
- `docs/pending-changes.md`
- `godot-prototype/assets/art/garden-fx-sheet-gpt-v1-source.png`
- `godot-prototype/assets/art/garden-fx-sheet-gpt-v1-contact.png`
- `godot-prototype/assets/art/care-ui-icons-gpt-v1-source.png`
- `godot-prototype/assets/art/care-ui-icons-gpt-v1-contact.png`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `godot-prototype/assets/art/godot-web-assets-harvested-preview.png`
- `godot-prototype/assets/art/godot-web-assets-dormant-preview.png`
- `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`
- `godot-prototype/assets/sprites/sprout/fx/*.png`
- `godot-prototype/assets/sprites/ui/care-*-gpt-v1.png`

### Asset Notes

- Generated the FX sheet with the built-in imagegen workflow on a flat `#ff00ff` chroma-key background.
- FX prompt constraints: cozy Sprout Lands inspired pixel-art garden effects, 4x2 grid, separate paper sparkle, course petal, dormant moon, harvest leaf, placement ring, water burst, lantern twinkle, and seed puff cells; no text/UI/characters/watermark.
- Generated the care UI sheet with the built-in imagegen workflow on a flat `#ff00ff` chroma-key background.
- Care icon prompt constraints: Sprout Lands inspired pixel-art UI icons, 3x2 grid, sun, water, fertilizer pouch, record notebook, coin, and seed packet; no text/UI labels/characters/watermark.
- Preserved source sheets under `godot-prototype/assets/art/`, removed chroma-key locally, and sliced runtime transparent PNGs under `godot-prototype/assets/sprites/sprout/fx/` and `godot-prototype/assets/sprites/ui/`.

### Verification

- Visually inspected `garden-fx-sheet-gpt-v1-contact.png`, `care-ui-icons-gpt-v1-contact.png`, and `godot-web-assets-zone-preview-contact.png`.
- Ran `python scripts/slice_godot_fx_sheet.py`.
- Ran `python scripts/slice_godot_care_icons.py`.
- Ran `python scripts/preview_godot_web_assets.py`; generated active, harvested, dormant, and combined zone previews.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and `missing 0`, including `main.gd` asset constants.
- Ran `python -m py_compile scripts/preview_godot_web_assets.py scripts/verify_godot_garden_assets.py scripts/slice_godot_care_icons.py scripts/slice_godot_fx_sheet.py`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `git diff --check -- godot-prototype/scripts/main.gd scripts/preview_godot_web_assets.py scripts/verify_godot_garden_assets.py scripts/slice_godot_care_icons.py scripts/slice_godot_fx_sheet.py`; only normal CRLF warnings appeared.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP after rounds 1 and 2; final outputs had no errors.

### Notes

- Existing unrelated local work in `AGENTS.md`, `garden_seed.json`, `verify_detail_ui.ps1`, and earlier v6 harvested/dormant map assets was left intact and is still part of the combined local worktree.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot structural harvested and dormant map generations

### Summary

- Generated new harvested and dormant Godot base maps with the built-in imagegen workflow instead of reusing color-only variants.
- Preserved the active map's broad structure: top destination-building area, forked path, large clear fenced field, and centered bottom gate.
- Changed concrete scene details for immersion: harvested uses amber harvest clutter, crates, seed sacks, autumn foliage, and a cool dormant destination cottage; dormant uses blue twilight, resting tools, moss, lantern glows, and a warm harvest archive/granary destination.
- Kept destination-building identities consistent by treating the active garden as the green-roof timber cottage, the harvested garden as the warm archive/granary cottage, and the dormant garden as the cool stone cottage.
- Updated Godot map defaults and seed data so harvested/dormant zones use the new structural v6 maps.
- Bumped the Godot layout version to `19` so existing local saves migrate to the new map paths.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/art/sprout-map-harvested-gpt-v6-structural-source.png`
- `godot-prototype/assets/art/sprout-map-dormant-gpt-v6-structural-source.png`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-harvested-gpt-v6-structural.png`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-dormant-gpt-v6-structural.png`
- `docs/pending-changes.md`

### Asset Notes

- Generated with the built-in imagegen tool using the current active tallfield map as the visual reference in conversation.
- Source outputs were preserved under `godot-prototype/assets/art/` at `984x1598`.
- Runtime outputs were resized to `768x1248` under `godot-prototype/assets/sprites/sprout/maps/` to match the existing Godot map dimensions.
- Prompt constraints: Sprout Lands inspired cozy pixel art, preserve overall portrait map structure, keep central field clear, no 3x3 soil blocks, no UI/text/characters/watermark, and change concrete edge details beyond color.

### Verification

- Visually inspected both generated source images and both resized runtime maps.
- Checked source and runtime PNG dimensions with Pillow; source images are `984x1598`, runtime maps are `768x1248`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and 0 missing referenced assets.
- Ran `python -m py_compile scripts/verify_godot_garden_assets.py`.
- Ran `git diff --check -- godot-prototype/scripts/main.gd godot-prototype/data/garden_seed.json docs/pending-changes.md`; only existing CRLF warnings appeared.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local work and untracked `.import` files were left untouched.
- The deprecated root web runtime was not modified.

## 2026-06-05 - Godot zone sprite filters and entrance labels

### Summary

- Replaced the weak map-plant `modulate` tint with a per-zone sprite shader filter that mixes sprites toward the garden color and adjusts brightness.
- Applied the same zone filter to placed decorations, so dormant/harvested scene props no longer sit over the map in their original bright colors.
- Kept empty plots and detail-card portraits untinted so only placed map sprites inherit the garden mood.
- Renamed the in-map garden entrance labels from English to Chinese: `生长园`, `收获园`, and `沉睡园`.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and 0 missing referenced assets.
- Ran `python -m py_compile scripts/verify_godot_garden_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Searched `godot-prototype/scripts/main.gd` for old entrance labels and confirmed hotspot labels now use the Chinese names.
- Started `res://scenes/main.tscn` through Godot MCP; the process returned without a persistent active Godot instance to stop.

### Notes

- Existing unrelated local work and import metadata were left untouched.
- The deprecated root web runtime was not modified.
- OpenClaw deploy needed: no.

## 2026-06-04 - Godot detail layering, empty planting panel, and zone map tones

### Summary

- Moved the detail card close button into the panel's top-right corner.
- Raised detail, record, and planting panels above map plants/decorations using bounded Godot z-index values.
- Added a separate empty-plot planting panel with Paper Tree and Course Flower choices instead of reusing the tree detail card for empty land.
- Added warm harvested and cool nighttime dormant map variants generated from the current v4 tallfield maps.
- Updated Godot map migration and seed data so harvested/dormant zones use their distinct map tones.
- Strengthened local verification to check panel layering, empty planting UI, and zone map asset existence.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-harvested-gpt-v4-noplot-tallfield-warm.png`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-dormant-gpt-v4-noplot-tallfield-night.png`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/colorize_godot_zone_maps.py`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/colorize_godot_zone_maps.py`.
- Visually inspected the warm harvested and night dormant map variants.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; all zones reported 9 plots/5 decorations and 0 missing map/sprite references.
- Ran `python -m py_compile scripts/colorize_godot_zone_maps.py scripts/verify_godot_garden_assets.py`.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- The harvested/dormant maps are local color treatments of the existing v4 tallfield maps, not new GPT-Image-2 generations.
- Existing unrelated local work was left untouched.

## 2026-06-05 - Integrate sourced BGM loops for Godot zones

### Summary

- Used the user-provided `music/mixkit-silent-descent-614.mp3` as the source for two 48-second BGM loops.
- Generated `garden_bgm_main_loop.wav` for the normal garden zones.
- Generated `garden_bgm_dormant_loop.wav` for the dormant garden, with the user-provided cricket ambience mixed quietly into the track.
- Added a small Godot audio layer that plays the main loop on startup and switches to the dormant loop when entering the dormant garden.
- Removed temporary unsupported MP3 slice outputs and the separate cricket ambience output after moving to final WAV loops.

### Files Changed

- `godot-prototype/assets/audio/garden_bgm_main_loop.wav`
- `godot-prototype/assets/audio/garden_bgm_dormant_loop.wav`
- `godot-prototype/scripts/main.gd`
- `docs/pending-changes.md`

### Verification

- Verified both final WAV loops are 48.00 seconds, 44.1 kHz, stereo.
- Ran Godot `res://scenes/main.tscn` through the Godot debug tool and confirmed final output had no errors.
- Ran `git diff --check` on the touched text files; only normal CRLF warnings appeared.

### Notes

- Source files under `music/` were read but not modified.
- Existing unrelated local work was left untouched.

## 2026-06-05 - Add BGM toggle to deprecated web preview

### Summary

- Added a manual music toggle to the historical root web preview so the currently used browser preview can audition the same BGM files.
- Reused the Godot-generated `garden_bgm_main_loop.wav` and `garden_bgm_dormant_loop.wav` assets from `godot-prototype/assets/audio/`.
- The browser preview plays audio only after the user clicks the music button, matching browser autoplay restrictions.
- The preview switches to the dormant loop when the active preview zone is dormant.

### Files Changed

- `index.html`
- `src/app.js`
- `styles.css`
- `docs/pending-changes.md`

### Verification

- Ran `node --check src/app.js`.
- Verified `index.html`, `src/app.js`, `garden_bgm_main_loop.wav`, and `garden_bgm_dormant_loop.wav` returned HTTP 200 from a temporary local static server.
- Ran `git diff --check` on the touched text files; only normal CRLF warnings appeared.

### Notes

- This is a narrow compatibility fix for the deprecated web preview because the user-facing preview launcher still opens it.
- Existing unrelated local work was left untouched.

## 2026-06-05 - Naturalize lightweight BGM audition loop

### Summary

- Replaced the softened BGM audition loop with a more natural procedural version.
- Added slow phrase-level crescendo and decrescendo, very quiet background air texture, small timing/velocity variation, and gentle wrapped delay taps for softer space.

### Files Changed

- `godot-prototype/assets/audio/demo_garden_bgm_loop.wav`
- `docs/pending-changes.md`

### Verification

- Regenerated the WAV locally at 44.1 kHz stereo.
- Verified the updated duration is about 25.95 seconds from the WAV metadata.

### Notes

- Existing unrelated local work was left untouched.
- OpenClaw deploy needed: no.

## 2026-06-04 - Godot active plot grid realignment

### Summary

- Re-aligned the hand-dragged active garden plot coordinates into a clean 3x3 grid while preserving the user's approximate layout area and exported plot scales.
- Normalized active garden columns to `0.295`, `0.500`, `0.720` and rows to `0.471`, `0.592`, `0.728`.
- Updated both Godot default plot anchors and seed data so fresh saves and migrated saves use the same aligned coordinates.
- Bumped the Godot layout version to `17` so existing local saves pick up the corrected active plot alignment.
- Regenerated the active preview image after the alignment pass.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/preview_godot_web_assets.py` and visually inspected `godot-web-assets-active-preview.png`.
- Ran `python scripts/verify_godot_garden_assets.py`; active plots now report exactly three x columns and three y rows, and all referenced sprites exist.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python -m py_compile scripts/preview_godot_web_assets.py scripts/stretch_godot_v5_field_maps.py scripts/verify_godot_garden_assets.py`.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local changes, including the deleted GitHub Pages workflow and unrelated import metadata, were left untouched.
- The deprecated root web runtime was not modified.
- OpenClaw deploy needed: no.

## 2026-06-04 - Godot tree detail A-style record drawer

### Summary

- Updated the Godot plant detail drawer toward the selected A-style design direction: the portrait remains prominent, growth is shown as a progress bar, and today's Water/Sun/Fertilizer care counts appear as a compact icon row.
- Added a lightweight Record panel with quick Water/Sun/Fertilizer buttons plus an optional note input.
- Changed the main Record action to open the lightweight record panel instead of immediately logging Sun.
- Added explicit opaque panel/button styling and hid legacy secondary action buttons from the active tree detail card so the UI renders as a compact card instead of transparent text over the map.
- Added a small static verification script for the new detail UI structure.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `.gitignore`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`; static checks passed.
- Queried Godot MCP project info; it recognized `godot-prototype` with Godot `4.6.3.stable.official.7d41c59c4`.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- No new image assets were generated; the care icons are lightweight in-UI placeholders for now.
- Added `.superpowers/` to `.gitignore` so local visual brainstorming mockups stay out of Git.
- Existing unrelated local work was left untouched.
- OpenClaw deploy needed: no.

## 2026-06-04 - Godot square empty plot sprite

### Summary

- Generated a new square empty soil plot sprite with the built-in imagegen workflow to replace the temporary signboard empty plot art.
- Preserved the generated chroma-key source under `godot-prototype/assets/art/` and processed a transparent runtime sprite under `godot-prototype/assets/sprites/sprout/ground/`.
- Updated Godot seed data and existing-save migration to use `empty-plot-square-gpt-v1.png` for empty plots.
- Changed empty plot display boxes from a wide rectangle to a square `72x72` footprint.
- Updated the preview script so empty plots render with the same square footprint.
- Bumped the Godot layout version to `16` so existing local saves pick up the new empty plot sprite.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/art/empty-plot-square-gpt-v1-source.png`
- `godot-prototype/assets/art/empty-plot-square-gpt-v1-transparent-raw.png`
- `godot-prototype/assets/sprites/sprout/ground/empty-plot-square-gpt-v1.png`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `scripts/preview_godot_web_assets.py`
- `docs/pending-changes.md`

### Asset Notes

- Generated with the built-in imagegen tool on a flat magenta chroma-key background, then removed the key locally.
- Prompt constraints: square tilled brown soil plot, grassy rim, crisp colorful pixel art, no signpost, no text, no characters, no shadow, no watermark, generous padding.
- Runtime output: `96x96` transparent RGBA PNG, displayed in Godot as a square `72x72` empty plot.

### Verification

- Ran `python C:\Users\75843\.codex\skills\.system\imagegen\scripts\remove_chroma_key.py` on the generated source.
- Checked the runtime sprite is RGBA and has transparent corners.
- Ran `python scripts/preview_godot_web_assets.py` and visually inspected `godot-web-assets-active-preview.png`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and 0 missing referenced sprites.
- Ran `python -m py_compile scripts/preview_godot_web_assets.py scripts/stretch_godot_v5_field_maps.py scripts/verify_godot_garden_assets.py`.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local changes, including the deleted GitHub Pages workflow and unrelated import metadata, were left untouched.
- The deprecated root web runtime was not modified.
- OpenClaw deploy needed: no.

## 2026-06-04 - Godot exported plant layout applied

### Summary

- Applied the latest `godot-prototype/layout_debug_export.json` plot layout to the Godot defaults and seed data.
- Updated the active garden's exported plant anchors and set exported non-empty active plants to `size_scale: 0.75`.
- Applied the exported `size_scale: 0.75` to harvested/dormant plots that were present in the export, while leaving unexported plots and placed decoration instances unchanged.
- Updated the sixth decoration slot anchor from the exported layout.
- Added `PLOT_SIZE_SCALES` so existing local saves migrate to the exported per-plot scales instead of resetting all plants to `1.0`.
- Updated the preview script so generated previews honor each plot's `size_scale`.
- Bumped the Godot layout version to `15` so existing saves pick up the exported layout.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `scripts/preview_godot_web_assets.py`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/preview_godot_web_assets.py` and visually inspected `godot-web-assets-active-preview.png`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and 0 missing referenced sprites.
- Ran `python -m py_compile scripts/preview_godot_web_assets.py scripts/stretch_godot_v5_field_maps.py scripts/verify_godot_garden_assets.py`.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- The export's placed decoration list was partial and did not match the seed's decoration instances, so placed decoration instances were left unchanged to avoid deleting/replacing unrelated decor.
- Existing unrelated local changes, including the deleted GitHub Pages workflow and unrelated import metadata, were left untouched.
- The deprecated root web runtime was not modified.
- OpenClaw deploy needed: no.

## 2026-06-04 - Godot runtime sprite sizing and v4 map color restore

### Summary

- Fixed the mismatch between the local preview PNG and the Godot runtime by replacing map plot/decor `Button.icon` rendering with fixed-size child `TextureRect` nodes.
- Prevented large legacy web plant source images from expanding Godot button minimum sizes, which made the user's runtime trees and flowers much larger than the Python preview.
- Rebuilt the taller no-plot map set from the more saturated `gpt-v4` maps instead of the cream-toned `gpt-v5` maps.
- Updated Godot seed data and existing-save map migration to use `sprout-map-*-gpt-v4-noplot-tallfield.png`.
- Bumped the Godot layout version to `13` so existing local saves pick up the fixed runtime map paths and migrated layout.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-*-gpt-v4-noplot-tallfield.png`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `scripts/stretch_godot_v5_field_maps.py`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/stretch_godot_v5_field_maps.py`.
- Ran `python scripts/preview_godot_web_assets.py` and visually inspected `godot-web-assets-active-preview.png`; the map color is back to the more saturated v4 direction and the plants stay within their fixed preview boxes.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and 0 missing referenced sprites.
- Ran `python -m py_compile scripts/stretch_godot_v5_field_maps.py scripts/preview_godot_web_assets.py scripts/verify_godot_garden_assets.py`.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local changes, including the deleted GitHub Pages workflow and unrelated import metadata, were left untouched.
- The deprecated root web runtime was not modified.
- OpenClaw deploy needed: no.

## 2026-06-04 - Godot taller central field map

### Summary

- Added stretched `v5-noplot-tallfield` map variants for active, harvested, and dormant gardens.
- Kept the upper building area fixed, stretched the central fenced field vertically, and compressed the lower entrance band slightly so the lowest plant row no longer sits on the bottom fence/wall.
- Updated Godot seed data and existing-save map migration to use the taller-field maps.
- Bumped the Godot layout version to `12` so existing local saves pick up the new base map paths.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-*-gpt-v5-noplot-tallfield.png`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `scripts/stretch_godot_v5_field_maps.py`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/stretch_godot_v5_field_maps.py`.
- Ran `python scripts/preview_godot_web_assets.py` and visually inspected `godot-web-assets-active-preview.png`; the lowest row now sits inside the field instead of on the bottom fence/wall.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and 0 missing referenced sprites.
- Ran `python -m py_compile scripts/stretch_godot_v5_field_maps.py scripts/preview_godot_web_assets.py scripts/verify_godot_garden_assets.py`.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local changes, including the deleted GitHub Pages workflow and unrelated import metadata, were left untouched.
- The deprecated root web runtime was not modified.
- OpenClaw deploy needed: no.

## 2026-06-04 - Godot plant depth spacing and draw order

### Summary

- Increased the Godot 3x3 plot row spacing for all three garden zones so larger legacy web tree/flower sprites do not cover the row behind them.
- Bumped the Godot layout version to `11` so existing local saves migrate to the wider depth spacing.
- Added deterministic y/x sorting plus y-based `z_index` for plants, decorations, and plant ambient motes, keeping foreground depth predictable without letting lower-row trees swallow the next row's body.
- Synced the empty-plot migration constant to the current `empty-plot-sign.png` sprite so upgraded saves do not regress to an older empty-plot asset.
- Updated the local active-map preview script to render plants in the same sorted depth order as Godot.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `scripts/preview_godot_web_assets.py`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `godot-prototype/assets/art/godot-stage-fit-audit.png`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/preview_godot_web_assets.py` and visually inspected `godot-web-assets-active-preview.png`; the lower-row willow no longer blocks the middle-row plant.
- Ran `python scripts/audit_godot_stage_fit.py`; used normalized sprites still reported non-transparent content away from source edges.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and 0 missing referenced sprites.
- Ran `python -m py_compile` for the Godot art helper and verification scripts.
- Ran `git diff --check` for the touched Godot/script/docs files.
- Launched and stopped `res://scenes/main.tscn` through Godot MCP; final output had no errors.

### Notes

- Existing unrelated local changes, including the deleted GitHub Pages workflow and unrelated import metadata, were left untouched.
- The deprecated root web runtime was not modified.
- OpenClaw deploy needed: no.

## 2026-06-04 - Godot v5 map with legacy web plant sprites

### Summary

- Switched the Godot prototype foreground plants from Sprout `plants-rebuilt` sprites back to the older high-resolution web-stage tree/flower sprites under `godot-prototype/assets/sprites/stages/`.
- Added a normalized Godot runtime copy of all 60 legacy web-stage sprites under `godot-prototype/assets/sprites/web-normalized-stages/`, so every tree/flower stage is cropped to its actual subject plus padding instead of relying on tight or partially clipped web-era source canvases.
- Added `*-full.png` preference for source mature stage sprites when available, while keeping seed/sapling/growing source stages on their regular files before normalization.
- Increased Godot stage display boxes for the larger legacy web sprites, replacing the smaller Sprout-oriented sizes that made several plants read as half-height.
- Generated three vertical `v5-noplot` map variants from the existing Godot v5 maps, removing the built-in 3x3 soil blocks from the background while keeping the same portrait garden composition.
- Cleaned chroma-key magenta backgrounds from the legacy stage sprites so they composite cleanly over the v5 map.
- Added a local active-map preview image at `godot-prototype/assets/art/godot-web-assets-active-preview.png` for quick visual review.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/data/garden_seed.json`
- `godot-prototype/assets/sprites/sprout/maps/sprout-map-*-gpt-v5-noplot.png`
- `godot-prototype/assets/sprites/stages/*.png`
- `godot-prototype/assets/sprites/web-normalized-stages/*.png`
- `godot-prototype/assets/art/godot-web-assets-active-preview.png`
- `godot-prototype/assets/art/godot-stage-fit-audit.png`
- `godot-prototype/assets/art/godot-normalized-stage-sheet.png`
- `scripts/create_godot_v5_noplot_maps.py`
- `scripts/clean_web_stage_transparency.py`
- `scripts/build_godot_normalized_stage_sprites.py`
- `scripts/audit_godot_stage_fit.py`
- `scripts/preview_normalized_stage_sheet.py`
- `scripts/switch_godot_to_web_assets.py`
- `scripts/preview_godot_web_assets.py`
- `docs/pending-changes.md`

### Verification

- Ran `python scripts/create_godot_v5_noplot_maps.py`.
- Ran `python scripts/clean_web_stage_transparency.py`.
- Ran `python scripts/build_godot_normalized_stage_sprites.py`; generated normalized runtime copies for all 60 paper/course stage sprites.
- Ran `python scripts/switch_godot_to_web_assets.py`.
- Ran `python scripts/audit_godot_stage_fit.py` and visually inspected `godot-stage-fit-audit.png`; current visible stages no longer have non-transparent pixels touching the source edge.
- Ran full normalized-stage edge check; all 60 normalized sprites reported `edge_bad 0`.
- Ran `python scripts/preview_normalized_stage_sheet.py` and visually inspected `godot-normalized-stage-sheet.png`.
- Ran `python scripts/preview_godot_web_assets.py` and visually inspected `godot-web-assets-active-preview.png`.
- Ran `python -m json.tool godot-prototype/data/garden_seed.json`.
- Ran `python scripts/verify_godot_garden_assets.py`; all three zones reported 9 plots/5 decorations and 0 missing referenced sprites.
- Ran `python -m py_compile` for all seven helper scripts.
- Launched the Godot project through Godot MCP; it started successfully.
- Stopped the Godot MCP run cleanly; final output had no errors.

### Notes

- The deprecated root web runtime behavior was not modified; this only reuses its older stage-art assets inside the active Godot prototype.
- Existing unrelated local changes such as `.github/workflows/pages.yml` deletion and prior decoration/import metadata were left untouched.
- OpenClaw deploy needed: no.

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

## 2026-06-04 - Disable deprecated GitHub Pages workflow

### Summary

- Removed the deprecated GitHub Pages deployment workflow so pushes to `main` no longer trigger Pages deploy failures or email notifications.
- Left the historical root web runtime files in place as reference.

### Files Changed

- `.github/workflows/pages.yml`
- `docs/pending-changes.md`

### Verification

- Confirmed the worktree was clean before the change.
- Verified the failing workflow source was `.github/workflows/pages.yml`.

### Notes

- This is deprecated GitHub Pages workflow cleanup. OpenClaw deploy needed: no.
- Existing unrelated local work was left untouched.

## 2026-06-05 - Remove OpenClaw project rule

### Summary

- Removed the project-level instruction requiring Codex to report OpenClaw deployment status.
- Left historical deployment notes in prior change-log entries untouched.

### Files Changed

- `AGENTS.md`
- `docs/pending-changes.md`

### Verification

- Searched project docs for the active OpenClaw rule location before editing.
- Reviewed the resulting diff.

### Notes

- Existing unrelated local work was left untouched.

## 2026-06-05 - Fix Godot detail card close button and Chinese copy

### Summary

- Fixed the plant detail card close button so it sits as a small top-right control inside the card header instead of being stretched by the panel container.
- Localized the plant detail card, record drawer, empty-plot planting panel, care labels, action labels, status labels, title labels, and seed notes shown in the detail flow.
- Updated the detail UI static check so it catches the stretched-close-button regression and verifies the Chinese care labels.

### Files Changed

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `docs/pending-changes.md`

### Verification

- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_detail_ui.ps1`.
- Ran `git diff --check`; only normal CRLF warnings appeared.
- Ran Godot `res://scenes/main.tscn` through the Godot debug tool and confirmed the final output had no errors.

### Notes

- Existing unrelated local work was left untouched, including prior AGENTS/pending-changes edits and map/import-file changes already present in the worktree.

## 2026-06-08 - Re-export Clean Godot Android APK

### Summary

- Rechecked the Godot-only project after the unused cleanup folder was moved out of the workspace.
- Confirmed the APK/preview mismatch fix is still in place: plant stage sprites resolve through `ResourceLoader.exists()` and `web-normalized-stages`, with no fallback to the old cropped `assets/sprites/stages` path.
- Generated a fresh signed Android debug APK from the cleaned Godot project.

### Files Changed

- `docs/pending-changes.md`

### Verification

- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `python -m json.tool godot-prototype\data\garden_seed.json`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.
- Ran Godot import and Android export with `Godot_v4.6.3-stable_win64_console.exe`.
- Signed `godot-prototype/exports/academic-garden-prototype-debug.apk` with the local debug keystore.
- Verified the signed APK with `apksigner verify --verbose`; v2 and v3 signatures passed.
- Inspected APK contents: old `assets/sprites/stages/` entries 0, deprecated web runtime entries 0, local emulator/export clutter entries 0, imported normalized stage textures present.
- Ran `res://scenes/main.tscn` through the Godot debug tool; final errors were empty.
- Ran `godot-prototype/scripts/preview_android.ps1 -SkipExport`; it installed the signed APK on the local Android emulator, launched the app, captured `godot-prototype/exports/android-qa-preview-20260608-132824.png`, and wrote `godot-prototype/exports/android-qa-preview-20260608-132824-logcat.txt`.
- Reviewed the Android screenshot; visible map plants use the expected full sprites/empty guide instead of split bottom fragments.
- Reviewed the app/Godot logcat lines; Godot started on Android and printed `platform_android=true` runtime layout without normalized-stage or image-load warnings.

### Notes

- Existing unrelated cleanup/deletion work was left untouched.
- `godot-prototype/exports/academic-garden-prototype-debug.apk` is the current signed APK.

## 2026-06-05 - Generate lightweight Godot BGM audition loop

### Summary

- Generated a short procedural background music audition loop for the Godot prototype.
- The loop uses simple synthesized pad, kalimba-like arpeggio, soft bass pulse, and quiet paper/leaf tick layers for a lightweight garden-menu feel.

### Files Changed

- `godot-prototype/assets/audio/demo_garden_bgm_loop.wav`
- `docs/pending-changes.md`

### Verification

- Generated the WAV locally at 44.1 kHz stereo.
- Verified the generated duration is about 20.87 seconds from the WAV metadata.

### Notes

- Existing unrelated local work was left untouched.

## 2026-06-05 - Soften lightweight BGM audition loop

### Summary

- Replaced the initial BGM audition loop with a softer procedural version.
- Reduced high-frequency tick layers and busy arpeggios, slowed the tempo, lowered overall loudness, and shifted the tone toward warm pad plus sparse soft plucked notes.

### Files Changed

- `godot-prototype/assets/audio/demo_garden_bgm_loop.wav`
- `docs/pending-changes.md`

### Verification

- Regenerated the WAV locally at 44.1 kHz stereo.
- Verified the updated duration is about 25.26 seconds from the WAV metadata.

### Notes

- Existing unrelated local work was left untouched.

## 2026-06-05 - Clean Willow Bottom Crop Artifact

### Summary

- Removed the stray lower tree-crown fragment from the Godot willow flower sprite.
- Applied the same cleanup to the matching willow fruit sprite and rebuilt the existing willow flower/fruit animation sheets so the artifact does not reappear during stage animation.
- Kept the original sprite canvas sizes and baseline alignment unchanged.

### Files Changed

- `godot-prototype/assets/sprites/web-normalized-stages/paper-willow-flower.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-willow-fruit.png`
- `godot-prototype/assets/sprites/stages/paper-willow-flower-full.png`
- `godot-prototype/assets/sprites/stages/paper-willow-fruit-full.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-willow-flower/`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-willow-fruit/`
- `godot-prototype/assets/art/paper-willow-flower-clean-preview.png`
- `godot-prototype/assets/art/paper-willow-fruit-clean-preview.png`
- `docs/pending-changes.md`

### Verification

- Visually checked the willow flower and fruit sprites on a light tan preview background.
- Ran a connected-component alpha check confirming the large bottom fragments were removed from willow flower and fruit assets.
- Ran `python scripts/verify_godot_garden_assets.py`.
- Ran `git diff --check`; only normal CRLF warnings appeared.

### Notes

- Existing unrelated local work was left untouched.

## 2026-06-09 - Re-slice Sunflower and Ginkgo Stage Sprites

### Summary

- Re-sliced the sunflower blossom/bloom/final course sprites from the magenta lifecycle source sheet so the top petals are no longer cropped.
- Restored the tree lifecycle source sheet for Godot art reference and re-sliced the ginkgo seed, sapling, tree, flower, and fruit sprites from its first column.
- Cleaned magenta source-background residue from the ginkgo cuts, normalized mature ginkgo stages on a stable canvas with bottom safety margin, and rebuilt the matching ginkgo tree/flower/fruit animation frames.

### Files Changed

- `godot-prototype/assets/art/course-flower-lifecycle-gpt-v1-source.png`
- `godot-prototype/assets/art/course-flower-lifecycle-gpt-v1-transparent.png`
- `godot-prototype/assets/art/tree-stage-sheet-v2.png`
- `godot-prototype/assets/art/course-flower-lifecycle-gpt-v1-sliced-preview.png`
- `godot-prototype/assets/art/paper-ginkgo-resliced-review.png`
- `godot-prototype/assets/art/sunflower-ginkgo-inspection.png`
- `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`
- `godot-prototype/assets/sprites/web-normalized-stages/course-sunflower-bloom.png`
- `godot-prototype/assets/sprites/web-normalized-stages/course-sunflower-blossom.png`
- `godot-prototype/assets/sprites/web-normalized-stages/course-sunflower-seed_saved.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-ginkgo-seed.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-ginkgo-sapling.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-ginkgo-tree.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-ginkgo-flower.png`
- `godot-prototype/assets/sprites/web-normalized-stages/paper-ginkgo-fruit.png`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-ginkgo-tree/`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-ginkgo-flower/`
- `godot-prototype/assets/sprites/stage-animations/paper-trees/paper-ginkgo-fruit/`
- `scripts/verify_godot_garden_assets.py`
- `docs/pending-changes.md`

### Verification

- Visually checked `paper-ginkgo-resliced-review.png`, `sunflower-ginkgo-inspection.png`, and `godot-web-assets-zone-preview-contact.png`.
- Ran `python scripts\preview_godot_web_assets.py`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `git diff --check` for the touched docs/check files; only existing CRLF warnings appeared.

### Notes

- The tree lifecycle source sheet had been deleted from the current worktree, so this slice restored the Godot art source from the existing `.runtime` worktree copy instead of generating new art.
- Existing unrelated local work was left untouched.

## 2026-06-10 - Clean Lavender Final Sprite Top Artifact

### Summary

- Re-sliced the lavender final course sprite from the lifecycle source sheet so the top no longer includes the bottom of another plant.
- Applied the same cleaned sprite to `blossom` and `seed_saved`, removed edge-touching crop fragments, and lightly shifted lavender highlight pixels away from the magenta-key threshold used by asset verification.

### Files Changed

- `godot-prototype/assets/sprites/web-normalized-stages/course-lavender-blossom.png`
- `godot-prototype/assets/sprites/web-normalized-stages/course-lavender-seed_saved.png`
- `godot-prototype/assets/art/lavender-cleaned-review.png`
- `godot-prototype/assets/art/godot-web-assets-zone-preview-contact.png`
- `docs/pending-changes.md`

### Verification

- Visually checked `lavender-cleaned-review.png` and `godot-web-assets-zone-preview-contact.png`.
- Ran `python scripts\verify_godot_garden_assets.py`.
- Ran `python scripts\preview_godot_web_assets.py`.
- Ran `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`.

### Notes

- Existing unrelated local work was left untouched.
