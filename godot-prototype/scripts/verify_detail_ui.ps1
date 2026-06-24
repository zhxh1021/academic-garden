$ErrorActionPreference = "Stop"

$main = Get-Content -Path "$PSScriptRoot/main.gd" -Raw -Encoding UTF8
$layoutRulesPath = Join-Path $PSScriptRoot "layout_rules.gd"
$plantRulesPath = Join-Path $PSScriptRoot "plant_rules.gd"
$requiredSource = $main
if (Test-Path $layoutRulesPath) {
  $requiredSource += "`n" + (Get-Content -Path $layoutRulesPath -Raw -Encoding UTF8)
}
if (Test-Path $plantRulesPath) {
  $requiredSource += "`n" + (Get-Content -Path $plantRulesPath -Raw -Encoding UTF8)
}

$requiredSnippets = @(
  "detail_growth_value",
  "detail_care_grid",
  "record_panel",
  "plant_panel",
  "_show_plant_panel",
  "PLANTABLE_ZONE_IDS",
  "PLANT_VARIETIES",
  "INITIAL_UNLOCKED_VARIETY_COUNT",
  "TREE_VARIETY_UNLOCK_BASE_PRICE",
  "FLOWER_VARIETY_UNLOCK_PRICE",
  "SEED_SHOP_ICON_SPRITE",
  "SEED_LOCKED_ICON_SPRITE",
  "_sync_unlocked_varieties",
  "_unlock_variety",
  "_is_variety_unlocked",
  "_variety_unlock_price",
  "_can_plant_in_current_zone",
  "_show_plant_varieties",
  "SEED_SHOP_ICON_SPRITE",
  "SEED_LOCKED_ICON_SPRITE",
  "plant_variety_grid",
  "_plant_empty_plot",
  "_add_empty_plot_guide",
  "_draw_empty_plot_guide",
  "_show_remove_confirmation",
  "_confirm_remove_selected_plot",
  "_reset_plot_to_empty",
  "remove_confirm_overlay",
  "_hide_remove_confirmation",
  "_remove_confirm_card_style",
  "remove_confirm_ok_button = _remove_confirm_button",
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
  "history_button = _detail_action_button(",
  "NEXT_ACTION_LABELS",
  "QUICK_RECORD_DEFAULTS",
  "_record_quick_water_pressed",
  "_record_quick_sun_pressed",
  "_record_quick_fertilizer_pressed",
  "CARE_LABELS :=",
  "header_row",
  "plant_feedback_by_id",
  "_plant_feedback",
  "animated_stage_textures",
  "_apply_stage_animation",
  "_stage_animation_frames",
  "detail_sprite_path",
  "ROOT_MARGIN_PX",
  "_apply_root_safe_area_offsets",
  "DisplayServer.get_display_safe_area",
  "detail_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE",
  "detail_icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER",
  "LAYOUT_VERSION := 30",
  "HARVESTED_PAGE_SIZE := 9",
  "_paged_plots_for_zone",
  "_render_harvested_pager",
  "_on_harvested_next_page",
  "_on_move_plot_pressed",
  "_move_plot_in_current_zone",
  "moving_plot_id",
  "_build_decor_action_panel",
  "_select_placed_decoration",
  "_on_move_decoration_pressed",
  "_move_decoration_to_slot",
  "_remove_decoration_at_index",
  "_on_decor_slot_pressed",
  "_hud_panel_style",
  "_hint_panel_style",
  "SCROLL_MODE_AUTO",
  "_apply_button_tone",
  "UI_TONE_DANGER",
  "_update_onboarding_avatar_size",
  "_render_hotspot_sign",
  "_add_contact_shadow",
  "PLOT_GROUND_ANCHOR_Y",
  "_add_contact_shadow(button, button_size, 0.62, 0.30)",
  '_add_button_texture(button, plot.get("sprite", ""), sprite_filter, TextureRect.STRETCH_KEEP_ASPECT_CENTERED)',
  "_update_bottom_move_button",
  "_reset_plot_to_empty(empty_plot)",
  "sleep_button = _detail_action_button(",
  "_foreground_depth_scale",
  "Vector2(60, 68)",
  "_settlement_hint_line",
  "_runtime_platform_name",
  "_is_mobile_runtime",
  '"platform_ios": OS.has_feature("ios")',
  '"platform_mobile": _is_mobile_runtime()',
  '"user_data_dir": ProjectSettings.globalize_path("user://")',
  "_build_decor_action_panel",
  "SAVE_SCHEMA_VERSION",
  "IMPORT_BACKUP_PATH",
  "_make_export_payload",
  "_extract_import_data",
  "_save_checksum",
  "backup_button",
  "_backup_help_text",
  "FileDialog.FILE_MODE_SAVE_FILE",
  "FileDialog.FILE_MODE_OPEN_FILE",
  "_display_title(plot)",
  "DR_MEOW_SPRITE",
  "dr-meow-guide-gpt-v1.png",
  "onboarding_avatar",
  "onboarding_progress_bar",
  "mentor_label",
  "custom_minimum_size = Vector2(64, 40)",
  "ONBOARDING_Z_INDEX",
  "_settle_daily_economy",
  "_daily_coins_for_plot",
  "_estimated_daily_coins_for_plot",
  "_daily_growth_from_care",
  "_grant_random_care",
  "DAILY_COIN_PLANT_CAP",
  '"course": ["seed", "seedling", "bud", "bloom", "blossom"]',
  '"sowing": "seed"',
  'selected_zone_id != "active"',
  'selected_zone_id == "harvested"',
  "_settlement_hint_line"
)

foreach ($snippet in $requiredSnippets) {
  if (-not $requiredSource.Contains($snippet)) {
    Write-Error "Missing expected detail UI snippet: $snippet"
  }
}

if ($main.Contains("detail_panel.add_child(close_button)")) {
  Write-Error "Detail close button must not be a direct PanelContainer child."
}

if ($main.Contains('call_deferred("_maybe_show_first_onboarding")') -or $main.Contains("func _maybe_show_first_onboarding")) {
  Write-Error "Onboarding should only open from the manual guide button, not automatically on first launch."
}

if ($main.Contains("detail_growth_bar") -or $main.Contains("DAILY_COIN_WALLET_CAP")) {
  Write-Error "Growth should be shown as an unbounded value and daily coins should not use a wallet cap."
}

if ($main.Contains("button.expand_icon = true")) {
  Write-Error "Record button icons must not expand over their text."
}

if ($main.Contains("icon_max_width")) {
  Write-Error "This Godot Button version does not support icon_max_width."
}

if (-not [regex]::IsMatch($main, 'if kind == "empty" and _can_plant_in_zone\(selected_zone_id\):\s*\r?\n\s*_add_empty_plot_guide')) {
  Write-Error "Empty plot plus guides should only render in plantable zones."
}

if (-not [regex]::IsMatch($main, 'if _can_plant_in_current_zone\(\):\s*\r?\n\s*_save_data\(\)\s*\r?\n\s*_show_plant_panel\(\)')) {
  Write-Error "Empty plot taps should only open the planting panel in plantable zones."
}

if (-not [regex]::IsMatch($main, '_plant_empty_plot\.bind\(kind, base, label\)')) {
  Write-Error "Planting should require an explicit variety choice, not only a plant kind."
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

foreach ($removedFx in @('"leaf"', '"flyby"', '"sparkle"', "_plot_feedback_fx_path", "_plot_feedback_offsets", "_render_plot_ambient", "fx-paper-sparkle", "fx-course-petal", "fx-harvest-leaf", "fx-lantern-twinkle")) {
  if ($main.Contains($removedFx)) {
    Write-Error "Detail-open plant FX should stay removed: $removedFx"
  }
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

if ($main.Contains("EMPTY_PLOT_SIGN_SPRITE := `"res://assets/sprites/sprout/ground/plot-soil-gpt-v3.png`"")) {
  Write-Error "Empty plots should use a drawn dashed guide, not the soil sprite."
}

if ([regex]::IsMatch($main, "(?m)^\s*plots\.remove_at\(index\)")) {
  Write-Error "Removing a plant should reset the selected plot to an empty guide, not delete the plot."
}

if (-not [regex]::IsMatch($main, "remove_confirm_ok_button = _remove_confirm_button\([^\r\n]+_confirm_remove_selected_plot\)")) {
  Write-Error "Remove action must require the custom confirmation overlay before mutating the plot."
}

if ($main.Contains("ConfirmationDialog")) {
  Write-Error "Remove confirmation should use the garden-styled custom overlay, not the default system dialog."
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

$drMeowSprite = Join-Path $PSScriptRoot "../assets/sprites/ui/dr-meow-guide-gpt-v1.png"
if (-not (Test-Path $drMeowSprite)) {
  Write-Error "Dr.Meow onboarding sprite is missing."
}

if ($main.Contains('avatar.text = "Dr.\nMeow"')) {
  Write-Error "Onboarding must use the Dr.Meow sprite, not the old text-only avatar."
}

Write-Host "Detail UI static checks passed."
