# Academic Garden Godot Asset Contract

Updated: 2026-06-19

Scope: current Godot mobile portrait prototype under `godot-prototype/`. Root-level web assets are deprecated reference unless a task explicitly asks for archival web maintenance.

## Runtime Assets

These files are app-ready and may be referenced by `res://` paths from `godot-prototype/data/garden_seed.json`, `godot-prototype/scripts/main.gd`, or scenes.

- `assets/sprites/sprout/maps/`: authoritative active, harvested, and dormant zone maps.
- `assets/sprites/web-normalized-stages/`: authoritative static plant stage sprites for paper trees and course flowers.
- `assets/sprites/stage-animations/paper-trees/`: six-frame animation sets for mature paper tree stages. Each animated stage must keep `frame-00.png` through `frame-05.png` plus Godot `.import` metadata after import.
- `assets/sprites/sprout/decor/`: authoritative decoration sprites used by the decoration catalog.
- `assets/sprites/sprout/ground/`: ground, plot, and shop-preview support sprites.
- `assets/sprites/sprout/ui/`: Sprout Lands UI frame, slot, button, and font assets.
- `assets/sprites/ui/`: generated app-specific UI sprites such as logo, guide avatar, seed shop, locked seed, and care icons.
- `assets/sprites/coin-v1.png`: wallet coin sprite.
- `assets/audio/`: current Godot audio loops and import metadata.

Runtime rules:

- Do not reference `assets/art/` directly from runtime code or seed data.
- Runtime sprites should be transparent PNGs without visible chroma-key residue.
- New runtime references must use `res://assets/...` paths and must pass `python scripts/verify_godot_garden_assets.py`.
- If a runtime sprite is replaced, preserve its current path when possible; saved games and seed data may depend on stable filenames.

## Source And Review Assets

These files are retained for future editing, slicing, prompt traceability, or visual review. They are not runtime dependencies unless explicitly copied or sliced into `assets/sprites/`.

- `assets/art/course-flower-lifecycle-gpt-v1-source.png`: GPT-Image-2 source sheet for course flower lifecycle work.
- `assets/art/course-flower-lifecycle-gpt-v1-transparent.png`: transparency-prepped course flower source.
- `assets/art/course-flower-lifecycle-gpt-v1-sliced-preview.png`: review sheet for sliced course flower outputs.
- `assets/art/decoration-sheet-gpt-v4-source.png`: GPT-Image-2 decoration source sheet.
- `assets/art/decoration-v4-contact.png`: decoration review/contact sheet.
- `assets/art/decor-reading-mat-gpt-v1-source.png`: source for the reading mat decoration concept.
- `assets/art/seed-shop-lock-icons-gpt-v1-source.png`: source for seed shop and locked seed UI icons.
- `assets/art/godot-web-assets-active-preview.png`, `assets/art/godot-web-assets-harvested-preview.png`, `assets/art/godot-web-assets-dormant-preview.png`, `assets/art/godot-web-assets-zone-preview-contact.png`: zone map preview and contact sheets.
- `assets/art/lavender-cleaned-review.png`, `assets/art/paper-ginkgo-resliced-review.png`, `assets/art/sunflower-ginkgo-inspection.png`: focused plant-stage inspection/review sheets.
- `assets/art/tree-stage-sheet-v2.png`: legacy tree stage sheet retained for comparison.

Source rules:

- Keep generated source sheets when they explain how runtime sprites were made or may need future edits.
- Keep review/contact sheets when they show slicing decisions or generated variants.
- A source or review asset may be deleted only after the corresponding runtime sprite family has a documented replacement source or a documented direct-edit exception.

## Direct-Edit Exceptions

Some runtime families come from purchased Sprout Lands packs, manual crops, or existing app assets rather than a project-local generated source sheet.

- `assets/sprites/sprout/**`: Sprout Lands-derived runtime assets. The original pack is the source of record; project copies are app-ready runtime files.
- `assets/sprites/stage-animations/paper-trees/**`: generated frame sets are runtime-ready outputs. Their static stage source is `assets/sprites/web-normalized-stages/`.
- `assets/sprites/coin-v1.png`: app-ready coin sprite; keep a source sheet if a future redesign replaces it.

Direct-edit rules:

- Direct-edit exceptions must still pass transparency, missing-resource, and safe-margin verification.
- If a direct-edit exception is regenerated with GPT-Image-2, place the generated original under `assets/art/` and record the prompt constraints in `docs/pending-changes.md`.

## Deprecated Or Historical Assets

- Root-level `assets/`, `src/`, `styles.css`, `index.html`, Node scripts, and browser UI files belong to the deprecated web runtime.
- Historical source sheets deleted in the current large cleanup should not be restored casually. Before the combined push, review the full deletion set and confirm each deleted source is either historical web-only, superseded by this contract, or intentionally archived elsewhere.
- If an old file is still referenced by `godot-prototype/data/garden_seed.json` or `godot-prototype/scripts/main.gd`, it is not historical and must either remain or have its reference migrated with verification.

## Required Verification

Run these after adding, removing, or replacing visual/audio assets:

- `python scripts/verify_godot_garden_assets.py`
- `powershell -NoProfile -ExecutionPolicy Bypass -File godot-prototype/scripts/verify_mobile_layout.ps1` for visible map, plant, decoration, or UI asset changes.
- Godot import or startup verification when new files need `.import` metadata.

When new generated assets are added, also record in `docs/pending-changes.md`:

- purpose,
- source files under `assets/art/`,
- runtime files under `assets/sprites/`,
- important prompt or style constraints,
- slicing, cleanup, resizing, or transparency steps,
- verification commands.
