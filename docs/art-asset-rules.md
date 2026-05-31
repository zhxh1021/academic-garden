# Academic Garden Art Asset Rules

## Runtime vs Source Assets

- Runtime assets live under `assets/sprites/` and must be app-ready PNGs with alpha transparency.
- Source sheets and generated originals live under `assets/art/`. They may keep a flat chroma-key background when useful for future slicing or editing.
- Do not reference `assets/art/*sheet*`, `assets/art/*source*`, or `assets/art/*reference*` directly from runtime UI.

## Transparency Check

- App-ready sprites must not contain visible chroma-key pixels.
- Current chroma-key color family is magenta (`#ff00ff` / generated variants such as `#f503f4`).
- After adding or editing sprites, run a scan for magenta pixels in `assets/sprites/`.
- If a source image is generated on a chroma-key background, remove the key before placing the runtime file in `assets/sprites/`.

## Shared Usage Rules

- Plant stage sprites are loaded through `varietySprite()` in `src/domain.js` for cards and detail dialogs.
- Homepage map plants may use the higher-detail variety sprite for mature/blooming stages so the overview reads as a polished garden rather than a tiny stage-thumbnail board.
- Plant root grounding is shared through `plant-ground-base-v2-back.png` and `plant-ground-base-v2-front.png`.
- Decoration definitions are centralized in `DECORATIONS` in `src/domain.js`. If a decoration sprite path changes, the homepage map and shop preview update together.
- Empty garden plots use `empty-plot-a-v2.png`, `empty-plot-b-v2.png`, and `empty-plot-c-v2.png` in `src/app.js`.
- The wallet coin uses `assets/sprites/coin-v1.png` from `styles.css`.

## Map Layout Rules

- The central planting area is reserved for active plants and empty planting plots.
- The left foreground is reserved for paths and small guiding decor.
- The left midground is reserved for lamps or vertical accents.
- The right midground is reserved for benches and resting decor.
- The right foreground is reserved for ponds or low water decor.
- Destination houses are background click targets only; do not place active plants directly over them.

## Shop Preview Rules

- Shop previews must show the real decoration sprite, not CSS-drawn substitutes.
- `shop-preview-ground-v1.png` is the shared natural preview base behind all shop decoration sprites.
- CSS may provide sizing, light drop shadows, and interaction states, but should not draw the main subject of a decoration.

## Image Generation Notes

- Use GPT-Image-2 for new visual assets unless the user requests another source.
- Generate source art into `assets/art/`, then copy, crop, chroma-key, or slice runtime assets into `assets/sprites/`.
- Record the generated asset purpose, output paths, prompt constraints, and verification in `docs/pending-changes.md`.
