# Academic Garden Economy System

This document is the working source of truth for the Godot mobile prototype's growth, care, and coin economy. It is internal design documentation, not player-facing copy.

## Design Goals

- Reward real academic progress without turning the garden into a high-pressure task tracker.
- Make daily records useful even when they are small.
- Make milestone advancement matter by increasing coin yield through stage multipliers.
- Keep long-lived, high-growth projects valuable, but use diminishing returns so they do not dominate the economy forever.
- Keep randomness light: enough to add small delight, never enough to make outcomes feel unfair.
- Keep formulas deterministic enough that future tests can verify balance.
- Keep decoration costs gentle. The game records academic life; it should not push players to fabricate outcomes just to earn cosmetics.

## Core Resources

| Resource | Meaning | Persistence | Primary Use |
| --- | --- | --- | --- |
| Care values | Daily water, sun, and fertilizer signals from records | Reset or archived per day | Generate daily growth |
| Growth | Long-term project vitality and effort memory | Persistent per plant, unbounded in normal play | Base input for daily coin yield |
| Coins | Spendable soft currency | Persistent wallet | Buy decorations and future active choices |
| Variety unlocks | Which paper tree and course flower varieties are available | Persistent per save | Seed shop planting choices |

Care values should remain today's signals. Growth is the long-term progress meter. Coins are the economy output.

## Plant Stages

Both paper trees and course flowers currently use five stages. The stage should affect daily coin generation, not replace growth.

| Stage Index | Paper Stage | Course Stage | Proposed Coin Multiplier |
| --- | --- | --- | --- |
| 0 | `seed` | `seed` | `0.70` |
| 1 | `sapling` | `seedling` | `0.90` |
| 2 | `tree` | `bud` | `1.15` |
| 3 | `flower` | `bloom` | `1.45` |
| 4 | `fruit` | `blossom` | `1.80` |

Rationale: the multiplier is intentionally meaningful but not explosive. A mature plant should feel better than a seed, but a low-growth mature plant should not outperform a carefully tended mid-stage plant by stage alone.

## Care Acquisition

Each valid daily record for a plant grants care points.

Implemented default:

- `90%` chance: grant `1` point to one random care type.
- `10%` chance: grant `1` point to two different random care types.
- The three care types have equal probability: water, sun, fertilizer.
- Course "quick teaching" can force `water +1` because teaching already has an established water metaphor.
- Manual or AI classification can override the random type later, but AI must only classify care type. It must not decide numeric value.

This keeps the three care values symmetric while allowing a little surprise. It also avoids requiring users to choose the "correct" care type every time they record progress.

## Daily Growth Formula

At daily settlement, convert today's care values into growth.

Definitions:

- `W`, `S`, `F`: today's water, sun, and fertilizer points for one plant.
- `T = W + S + F`
- `D = count of care types with value > 0`
- `M = min(W, S, F)`

Recommended formula:

```text
daily_growth = min(18, round(3 * T + 2 * max(0, D - 1) + 2 * M))
```

Examples:

| Today Care | Daily Growth | Note |
| --- | --- | --- |
| `1/0/0` | `3` | One small record |
| `2/0/0` | `6` | Repeated same signal |
| `1/1/0` | `8` | Two-type variety bonus |
| `1/1/1` | `15` | Full care triangle bonus |
| `2/2/2` | `18` | Hits daily cap |

The cap of `18` intentionally matches the current milestone growth reward. One excellent care day can equal one milestone in growth, but cannot exceed it. This keeps daily care meaningful without making repeated note spam too powerful.

## Milestone Growth

Manual stage advancement should remain a major moment.

Recommended default:

- Stage advance grants `+18` growth.
- Stage advance does not grant direct coins.
- The stage itself increases future daily coin yield through the multiplier table.

Rationale: removing direct milestone coins avoids double payment. The player still receives a stronger economy because the plant's stage multiplier improves.

## Daily Coin Formula

Coins are generated once per day from active and harvested plants that are eligible for settlement.

Definitions:

- `G`: plant growth after daily growth is applied.
- `stage_multiplier`: value from the stage table.
- `base = 6 * ln(1 + G / 18)`
- `random_factor`: random value in `[0.95, 1.05]`

Recommended formula:

```text
plant_daily_coins = round(base * stage_multiplier * random_factor)
```

Examples without random factor:

| Growth | Stage 0 | Stage 2 | Stage 4 |
| --- | --- | --- | --- |
| `18` | `3` | `5` | `7` |
| `54` | `6` | `10` | `15` |
| `100` | `8` | `13` | `20` |
| `180` | `10` | `17` | `26` |

This gives the desired logarithmic curve: growth keeps helping, but each additional block of growth gives less coin yield than the previous one.

## Zone Rules

- Active garden: records add daily care; daily settlement converts care into growth and generates coins.
- Harvest garden: growth is fixed and cannot be edited by normal care, record, movement, or removal actions; plants still generate coins every day.
- Dormant garden: plants do not generate coins and do not settle care while dormant.

## Settlement Eligibility And Caps

The formula needs practical limits, otherwise a full garden of old high-growth projects will inflate the economy.

Recommended defaults:

- Only active and harvested plants generate coins.
- Dormant plants do not generate coins.
- Empty plots generate nothing.
- Maximum daily coin output from one plant: `30`.
- Active plants can gain growth through today's care before their coin value is calculated.
- Harvested plants generate from their fixed growth and stage.

The per-plant soft cap is the main guardrail. There is no total wallet income cap: a user with many harvested plants can earn more, which is acceptable because the game is a record of work rather than an anti-cheat economy.

## Coin Sinks

Coins should pay for visible, optional, or strategic choices. Basic recording and plant growth should remain free.

Current implemented sink:

| Sink | Current Prototype Price | Proposed Role |
| --- | --- | --- |
| Stone path / sign | `45` | Entry decoration |
| Bench | `55` | Common seating |
| Flower rock | `65` | Common garden detail |
| Lamp | `75` | Mid decoration |
| Workbench / reading mat | `80` | Mid decoration |
| Bridge | `95` | Mid-high decoration |
| Well | `105` | Premium early decoration |
| Pond | `120` | Premium early decoration |

Total cost for one of each current decoration is `765` coins.

## Seed Shop

Plant variety unlocks are also coin sinks.

- New saves start with two paper tree varieties unlocked: Ginkgo and Cherry.
- New saves start with two course flower varieties unlocked: Daisy and Rose.
- Existing saves keep any already-planted varieties unlocked during migration.
- Locked varieties appear in the seed shop with a lock icon and price.
- Unlocking a variety is permanent.

Current implemented prices:

| Unlock Type | Price Rule | Notes |
| --- | --- | --- |
| Course flower variety | `150` coins each | Gentle cosmetic variety unlock |
| Paper tree variety | `240 * 2^extra_unlocked_tree_count` | Trees are premium; each non-initial tree unlock doubles the next tree price |

For the four locked paper tree varieties, the current sequence is `240`, `480`, `960`, and `1920` coins if the player unlocks all of them. This is intentionally much more expensive than flowers because trees are the main long-term achievement visual.

Balance read:

- A light player with two harvested plants and two active plants earns about `54` coins/day and can buy all current decorations in about `14-15` days.
- A normal player with five harvested plants and three active plants earns about `115` coins/day and can buy all current decorations in about `7` days.
- A heavy collector with twelve harvested plants and four active plants earns about `244` coins/day and can buy all current decorations in about `3-4` days.
- A very large historical garden with about twenty-five harvested plants can buy the current set in about `2` days, which is acceptable because those decorations are cosmetic and the user is mainly expressing an existing body of work.

This is intentionally generous. Decoration is a reward layer, not a gate.

Future sinks can include:

- Extra garden plots or zone unlocks.
- Cosmetic plant frames, labels, or ambient effects.
- Research tools that improve organization but do not replace academic work.
- Weekly contract or exhibition submissions, if a later loop needs larger goals.

Avoid coin costs for writing records, advancing legitimate milestones, or recovering from rejection. The product should not punish real academic uncertainty.

## Assessment Of The Proposed System

The user's proposed direction is strong:

- Growth as the basis of coin output makes academic effort valuable over time.
- Stage multipliers correctly encourage moving papers/courses through their lifecycle.
- Logarithmic growth-to-coin conversion avoids runaway returns.
- Small random fluctuation fits the cozy game tone.
- Random care assignment reduces cognitive burden and adds small delight.

Main risks and mitigations:

| Risk | Why It Matters | Mitigation |
| --- | --- | --- |
| Old plants become passive money printers | Persistent growth plus daily coins can inflate fast | Per-plant cap, logarithmic growth curve, dormant no-income rule |
| Stage multiplier overwhelms growth | Players might rush stages without caring for projects | Keep multiplier range under `2.0x`; require growth or care for settlement |
| Random care feels unrelated to the record | A serious writing note randomly becoming fertilizer may feel arbitrary | Keep the type mostly cosmetic; allow future keyword/AI classification to override |
| Record spam becomes optimal | Users could tap many tiny records | Daily growth cap and optional per-plant settled-record cap |
| Direct milestone coins double-pay progression | Stage advance would pay immediately and improve future income | Move milestone reward to growth plus multiplier, not direct coins |
| Too many currencies create confusion | Care, growth, coins, research points can blur | Keep care as daily signals, growth as progress, coins as spendable currency |

## Implementation Order

1. Add daily settlement data: `last_settlement_date`, daily care buckets, and settlement summary.
2. Change record actions so they add care values first, then daily settlement converts care to growth.
3. Add stage multiplier and logarithmic daily coin formula.
4. Remove direct `+12` milestone coins, keeping `+18` growth.
5. Rebalance decoration prices after one simulated week of income.
6. Add a small static balance test with several representative gardens.

## Open Questions

- Should courses use the same coin curve as papers, or have a lower cap because teaching records may be more frequent?
- Should the wallet income cap be global per day or scale with unlocked garden zones?
- Should daily settlement be explicit, with a button and summary, or automatic on app open?
