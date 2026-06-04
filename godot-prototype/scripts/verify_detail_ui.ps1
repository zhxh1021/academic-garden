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
  "_record_quick_water_pressed",
  "_record_quick_sun_pressed",
  "_record_quick_fertilizer_pressed",
  'CARE_LABELS := {"sun": "阳光", "water": "水", "fertilizer": "肥料"}',
  "header_row",
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

Write-Host "Detail UI static checks passed."
