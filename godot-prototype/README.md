# Academic Garden Godot Prototype

This is a separate Godot 4.6.3 Standard prototype for testing a mobile-portrait Academic Garden direction.

It intentionally does not connect to the existing web frontend or backend. The current demo slice covers:

- 390 x 844 portrait window settings
- direct launch into the active garden map
- active, harvest, and dormant garden switching through distant house hotspots
- a generated unified portrait map background with plant and decoration overlays
- rebuilt map plant sprites with project-type badges and lightweight motion
- tappable garden plots with mobile portrait detail panels
- a compact bottom decoration inventory bar with basic place/remove behavior
- local JSON seed data in `res://data/garden_seed.json`
- local runtime saves in `user://garden_state.json`
- a simple progress log button

## Layout Debug Mode

Run the project, then press `F2` to toggle layout debug mode.

- Drag plants, placed decorations, decoration slots, and distant house hotspots directly on the running map.
- Select an item and press `[` or `]` to shrink or grow it.
- Click `Export layout` in the debug overlay, or press `\`, to export the current layout.
- Press `Esc` to clear the current selection.

The debug export is written to `godot-prototype/layout_debug_export.json` and also to `user://layout_debug_export.json`. Send that file or its contents back to Codex to bake the final positions into the prototype.

Open `D:\academic garden\godot-prototype` in Godot and run the main scene.
