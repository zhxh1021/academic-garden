# Combined Review Snapshot

Snapshot date: 2026-06-19

Purpose: make the current large local worktree auditable before any final staging, commit, push, or pull request. This is a review aid, not approval to stage every listed change.

## Current Git Status Shape

Command used:

- `git status --porcelain=v1`

Summary at snapshot time:

- Total status entries: 2161
- Deleted tracked entries: 1864
- Modified tracked entries: 206
- Untracked entries: 91

Largest groups:

- `godot-prototype/assets/sprites/`: 1087 entries, mostly tracked deletions plus modified/new runtime sprites.
- `godot-prototype/assets/source-art/`: 506 quoted deletion entries from non-ASCII Sprout Lands source-art paths.
- root `assets/`: 273 tracked deletions from the deprecated web/runtime overlap.
- `godot-prototype/assets/art/`: 225 entries, mostly tracked source/review-art deletions plus current review/source additions.
- `scripts/`: 25 entries, mostly deprecated web/runtime helper deletions plus current verification updates.
- `godot-prototype/scripts/`: 13 entries from current Godot verification and rules work.
- `docs/`: 4 entries, including this pending-change log and new/updated design/economy docs.

## Godogen Optimization Scope Added In This Run

Plan and manifests:

- `godot-prototype/PLAN.md`
- `godot-prototype/ASSETS.md`
- `docs/combined-review-snapshot.md`
- `docs/pending-changes.md`

Verification scenes and wrappers:

- `godot-prototype/scenes/mobile_layout_capture.tscn`
- `godot-prototype/scenes/save_migration_check.tscn`
- `godot-prototype/scenes/economy_balance_check.tscn`
- `godot-prototype/scripts/mobile_layout_capture.gd`
- `godot-prototype/scripts/save_migration_check.gd`
- `godot-prototype/scripts/economy_balance_check.gd`
- `godot-prototype/scripts/verify_mobile_layout.ps1`
- `godot-prototype/scripts/verify_save_migration.ps1`
- `godot-prototype/scripts/verify_economy_balance.ps1`

Extracted Godot rule modules:

- `godot-prototype/scripts/economy_rules.gd`
- `godot-prototype/scripts/plant_rules.gd`
- `godot-prototype/scripts/save_rules.gd`
- `godot-prototype/scripts/layout_rules.gd`

Updated existing verification/code:

- `godot-prototype/scripts/main.gd`
- `godot-prototype/scripts/verify_detail_ui.ps1`
- `scripts/verify_godot_garden_assets.py`

Generated proof artifacts:

- `godot-prototype/screenshots/mobile-layout/390x844/`
- `godot-prototype/screenshots/mobile-layout/430x932/`

## Known Concurrent Work To Keep Separate

Do not stage these wholesale without a separate review pass:

- Deprecated root web runtime deletions: `index.html`, `styles.css`, `src/`, `server/`, Node tests/scripts, root `assets/`, root music, and related GitHub Pages-era files.
- Historical Godot source-art deletions under `godot-prototype/assets/art/` and `godot-prototype/assets/source-art/`.
- Runtime sprite replacement/deletion set under `godot-prototype/assets/sprites/`.
- Pre-existing changes to `docs/product-mvp.md`, `godot-prototype/data/garden_seed.json`, `godot-prototype/export_presets.cfg`, `godot-prototype/scripts/preview_android.ps1`, and audio import metadata.

## Verification Evidence

Most recent completed verification set from the Godogen optimization work:

- `python -m json.tool godot-prototype\data\garden_seed.json`
- `python scripts\verify_godot_garden_assets.py`
- `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_detail_ui.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_save_migration.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_mobile_layout.ps1`
- `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype\scripts\verify_economy_balance.ps1`
- `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --check-only --script res://scripts/main.gd`
- `D:\Program Files\Godot\Godot_v4.6.3-stable_win64_console.exe --headless --path godot-prototype --quit-after 3`

Additional proof:

- The mobile layout verifier now validates direct viewport captures at both `390x844` and `430x932`.
- Asset verification reports zero missing resources, zero paper tree stage animation errors, zero stage safe-margin errors, zero course flower slice errors, zero audio import errors, zero UI sprite errors, and zero unstable mature paper-stage paths.

## Final Review Checklist

- Review every top entry in `docs/pending-changes.md` dated 2026-06-19.
- Re-run the full verification checklist in `godot-prototype/PLAN.md`.
- Decide whether `godot-prototype/PLAN.md`, `godot-prototype/ASSETS.md`, and this snapshot should remain in-repo as permanent Godogen state.
- Decide whether deleted source/intermediate art files should be committed as cleanup, restored, or archived outside runtime paths.
- Decide whether Android emulator screenshots are required before release, beyond the current direct viewport captures.
- Review the full `git status --porcelain=v1` before staging; use path-specific staging for Godogen optimization files instead of staging the whole tree.
