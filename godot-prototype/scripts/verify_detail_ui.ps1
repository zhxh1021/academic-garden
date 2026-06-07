$ErrorActionPreference = "Stop"

$main = Get-Content -Path "$PSScriptRoot/main.gd" -Raw

$requiredSnippets = @(
  "detail_growth_bar",
  "detail_care_grid",
  "record_panel",
  "plant_panel",
  "_show_plant_panel",
  "_plant_empty_plot",
  "z_as_relative = false",
  "z_index = 1500",
  "_panel_style",
  "_button_style",
  "_detail_panel_action_visibility",
  "_show_record_panel",
  "_show_record_history_panel",
  "_save_quick_record_labels_from_inputs",
  "_record_history_summary",
  "quick_record_labels",
  "record_history",
  "查看记录",
  "更新文稿",
  "备课",
  "_record_quick_water_pressed",
  "_record_quick_sun_pressed",
  "_record_quick_fertilizer_pressed",
  'CARE_LABELS := {"sun": "阳光", "water": "水", "fertilizer": "肥料"}',
  "header_row",
  "plant_feedback_by_id",
  "_plant_feedback",
  "_plot_feedback_fx_path",
  "_plot_feedback_offsets",
  "animated_stage_textures",
  "_apply_stage_animation",
  "_stage_animation_frames",
  "detail_sprite_path",
  "ROOT_MARGIN_PX",
  "_apply_root_safe_area_offsets",
  "DisplayServer.get_display_safe_area",
  "detail_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE",
  "detail_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER",
  "LAYOUT_VERSION := 23",
  "_hud_panel_style",
  "_hint_panel_style",
  "SCROLL_MODE_SHOW_NEVER",
  "_render_hotspot_sign",
  "_add_contact_shadow",
  "_foreground_depth_scale",
  "Vector2(60, 68)",
  "轻点植物、装饰或小屋",
  "把%s放到发光位置",
  '"leaf"',
  '"flyby"',
  '"sparkle"',
  "SAVE_SCHEMA_VERSION",
  "IMPORT_BACKUP_PATH",
  "_make_export_payload",
  "_extract_import_data",
  "_save_checksum",
  "backup_button",
  "_backup_help_text",
  "FileDialog.FILE_MODE_SAVE_FILE",
  "FileDialog.FILE_MODE_OPEN_FILE",
  "在%s种植"
)

foreach ($snippet in $requiredSnippets) {
  if (-not $main.Contains($snippet)) {
    Write-Error "Missing expected detail UI snippet: $snippet"
  }
}

if ($main.Contains("detail_panel.add_child(close_button)")) {
  Write-Error "Detail close button must not be a direct PanelContainer child."
}

if ($main.Contains("button.expand_icon = true")) {
  Write-Error "Record button icons must not expand over their text."
}

if ($main.Contains("icon_max_width")) {
  Write-Error "This Godot Button version does not support icon_max_width."
}

if ($main.Contains("animated_decor_buttons") -or $main.Contains("_animate_decor_button")) {
  Write-Error "Placed decorations must not be registered for sway/bob animation."
}

if ($main.Contains('if str(feedback.get("effect", "sway")) != "sway":')) {
  Write-Error "Randomized plant FX must not prevent the plant body from registering for base sway."
}

if ($main.Contains("BASE_PLANT_SWAY_PX")) {
  Write-Error "Plant body sway should stay subtle and per-plant randomized through the existing feedback data."
}

if (-not $main.Contains("_apply_root_safe_area_offsets()")) {
  Write-Error "Root layout must apply mobile safe-area offsets."
}

if ($main.Contains("_hide_map_plot_behind_detail")) {
  Write-Error "Opening the detail card must keep the selected map plant visible."
}

if ([regex]::IsMatch($main, "continue\r?\n\t\tvar button_size := _plot_button_size\(plot\)")) {
  Write-Error "Map plot rendering must not skip the selected plant when detail is open."
}

if ($main.Contains("detail_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL")) {
  Write-Error "Detail plant art must stay inside the fixed detail image frame."
}

$harvestFilter = [regex]::Match($main, '"harvested": \{"color": Color\([^\)]*\), "strength": ([0-9.]+), "brightness": ([0-9.]+)\}')
$dormantFilter = [regex]::Match($main, '"dormant": \{"color": Color\([^\)]*\), "strength": ([0-9.]+), "brightness": ([0-9.]+)\}')
if (-not $harvestFilter.Success -or -not $dormantFilter.Success) {
  Write-Error "Zone sprite filter constants must stay statically checkable."
}

$harvestStrength = [double]$harvestFilter.Groups[1].Value
$harvestBrightness = [double]$harvestFilter.Groups[2].Value
$dormantStrength = [double]$dormantFilter.Groups[1].Value
$dormantBrightness = [double]$dormantFilter.Groups[2].Value
if ($harvestBrightness -lt 1.0 -or $harvestBrightness -gt 1.08 -or $harvestStrength -gt 0.30) {
  Write-Error "Harvested garden sprites should stay warm but not over-bright."
}

if ($harvestStrength -ge $dormantStrength -or $harvestBrightness -le $dormantBrightness) {
  Write-Error "Harvested garden sprite filter must stay lighter than the dormant garden filter."
}

if ($dormantBrightness -lt 0.75) {
  Write-Error "Dormant garden interactables must stay bright enough to read as tappable."
}

Write-Host "Detail UI static checks passed."
