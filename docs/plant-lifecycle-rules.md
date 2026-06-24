# Plant Lifecycle Rules

This document preserves the baseline lifecycle rules for the current Godot mobile prototype. Product work should keep these rules aligned with `godot-prototype/scripts/main.gd`.

## Scope

- The current product target is the Godot prototype under `godot-prototype/`.
- The deprecated root web runtime is historical reference only.
- Plants have two project kinds:
  - `paper`: paper projects, represented as trees.
  - `course`: course projects, represented as flowers.

## Baseline Rule

Both trees and flowers use exactly five lifecycle stages.

The stage order is fixed by `STAGE_FLOW` in `godot-prototype/scripts/main.gd`:

```gdscript
"paper": ["seed", "sapling", "tree", "flower", "fruit"]
"course": ["seed", "seedling", "bud", "bloom", "blossom"]
```

## Tree / Paper Stages

| Order | Internal key | Current meaning | Naming status |
| --- | --- | --- | --- |
| 1 | `seed` | A paper idea has been captured. | To be named |
| 2 | `sapling` | The paper has entered active reading, notes, or exploration. | To be named |
| 3 | `tree` | The paper has reached a mature draft or substantial form. | To be named |
| 4 | `flower` | The paper has reached submission or visible external-facing output. | To be named |
| 5 | `fruit` | The paper has been accepted, published, or moved into harvest. | To be named |

Notes:

- `flower` here means the tree's flowering stage, not a course flower.
- Mature paper stages use the larger tree display treatment: `tree`, `flower`, and `fruit`.
- Rejection should not roll the plant backward or deduct growth. It can be recorded as a normal care/event note.

## Flower / Course Stages

| Order | Internal key | Display name | Current meaning |
| --- | --- | --- | --- |
| 1 | `seed` | 种子 | A course has been created or prepared for the current cycle. |
| 2 | `seedling` | 幼苗 | The course is being prepared for delivery. |
| 3 | `bud` | 含苞 | The course has started and is not yet complete. |
| 4 | `bloom` | 盛开 | The course has concluded. |
| 5 | `blossom` | 绽放 | Grades have been submitted and the course has reached its final visible outcome. |

Notes:

- Course flowering uses `bloom`, not `flower`, to avoid confusing it with paper-tree flowering.
- `bud` is the closed-bud stage and should read smaller/less open than the final flower stages.
- Mature course stages use the mature flower display treatment: `bloom` and `blossom`.
- Older saves may still contain `sowing`, `growing`, `bloom`, `fruit`, or `seed_saved` with the previous meanings. Godot migrates those course-only keys to `seed`, `seedling`, `bud`, `bloom`, and `blossom` on load.

## Next Stage Actions

Each five-stage lifecycle has four actions that move a plant into the next stage.

| Kind | From internal key | Action label | Moves into |
| --- | --- | --- | --- |
| paper | `seed` | 确定选题 | `sapling` |
| paper | `sapling` | 写出第一版草稿 | `tree` |
| paper | `tree` | 投稿 | `flower` |
| paper | `flower` | 成功发表 | `fruit` |
| course | `seed` | 备课 | `seedling` |
| course | `seedling` | 开始上课 | `bud` |
| course | `bud` | 结课 | `bloom` |
| course | `bloom` | 提交成绩 | `blossom` |

## Growth And Rewards

- Each manual milestone advance currently awards `18` growth and no direct coins.
- Daily care records contribute water, sun, and fertilizer signals; daily settlement converts those signals into growth.
- Daily settlement uses growth and stage to generate coins for active and harvested plants.
- Harvested plants keep fixed growth and cannot be modified through normal care actions; dormant plants generate no coins.
- Growth values are long-term progress; Water, Sun, and Fertilizer are today's care signals.

## Naming Workbench

Use this section for the upcoming naming pass.

| Kind | Internal key | Final display name | Short UI label | Notes |
| --- | --- | --- | --- | --- |
| paper | `seed` |  |  |  |
| paper | `sapling` |  |  |  |
| paper | `tree` |  |  |  |
| paper | `flower` |  |  |  |
| paper | `fruit` |  |  |  |
| course | `seed` | 种子 | 种子 | Confirmed |
| course | `seedling` | 幼苗 | 幼苗 | Confirmed |
| course | `bud` | 含苞 | 含苞 | Confirmed |
| course | `bloom` | 盛开 | 盛开 | Confirmed |
| course | `blossom` | 绽放 | 绽放 | Confirmed |
