import assert from "node:assert/strict";
import test from "node:test";

import {
  assignGardenLayout,
  createPlant,
  defaultDecorationPlacements,
  firstOpenPlotIndex,
  movePlantToPlot,
  removePlantRecords,
  updatePlantBasics
} from "../src/domain.js";

test("updates editable paper plant fields without changing progress", () => {
  const plant = {
    ...createPlant({
      title: "Test tree",
      type: "paper",
      variety: "ginkgo",
      historical: false,
      authorRole: "primary",
      term: ""
    }),
    stage: "sapling",
    growth: 42,
    milestones: [{ id: "m1", label: "started" }]
  };

  const updated = updatePlantBasics(plant, {
    title: "Renamed tree",
    variety: "pine",
    authorRole: "coauthor",
    term: "ignored"
  });

  assert.equal(updated.title, "Renamed tree");
  assert.equal(updated.variety, "pine");
  assert.equal(updated.metadata.authorRole, "coauthor");
  assert.equal(updated.stage, "sapling");
  assert.equal(updated.growth, 42);
  assert.deepEqual(updated.milestones, plant.milestones);
});

test("updates editable course plant fields without changing progress", () => {
  const plant = {
    ...createPlant({
      title: "Test flower",
      type: "course",
      variety: "daisy",
      historical: false,
      authorRole: "primary",
      term: "2026 Spring"
    }),
    stage: "growing",
    growth: 24
  };

  const updated = updatePlantBasics(plant, {
    title: "Renamed flower",
    variety: "rose",
    authorRole: "ignored",
    term: "2026 Fall"
  });

  assert.equal(updated.title, "Renamed flower");
  assert.equal(updated.variety, "rose");
  assert.equal(updated.metadata.term, "2026 Fall");
  assert.equal(updated.stage, "growing");
  assert.equal(updated.growth, 24);
});

test("removes a plant and its dependent records from state", () => {
  const state = {
    plants: [{ id: "keep" }, { id: "remove-me" }],
    activities: [{ plantId: "remove-me" }, { plantId: "keep" }],
    settlements: [{ plantId: "remove-me" }, { plantId: "keep" }],
    wallet: { currentCoins: 0 }
  };

  const updated = removePlantRecords(state, "remove-me");

  assert.deepEqual(updated.plants, [{ id: "keep" }]);
  assert.deepEqual(updated.activities, [{ plantId: "keep" }]);
  assert.deepEqual(updated.settlements, [{ plantId: "keep" }]);
  assert.equal(updated.wallet, state.wallet);
});

test("assigns stable plot indexes by status and creation order", () => {
  const plants = [
    { id: "active-new", status: "active", createdAt: "2026-01-03T00:00:00.000Z" },
    { id: "active-old", status: "active", createdAt: "2026-01-01T00:00:00.000Z" },
    { id: "harvested-old", status: "harvested", createdAt: "2026-01-01T00:00:00.000Z" },
    { id: "dormant-old", status: "dormant", createdAt: "2026-01-01T00:00:00.000Z" }
  ];

  const assigned = assignGardenLayout(plants);

  assert.equal(assigned.find((plant) => plant.id === "active-old").plotIndex, 0);
  assert.equal(assigned.find((plant) => plant.id === "active-new").plotIndex, 1);
  assert.equal(assigned.find((plant) => plant.id === "harvested-old").plotIndex, 0);
  assert.equal(assigned.find((plant) => plant.id === "dormant-old").plotIndex, 0);
});

test("repairs duplicate and invalid plot indexes within each zone", () => {
  const plants = [
    { id: "keep-active", status: "active", plotIndex: 2, createdAt: "2026-01-01T00:00:00.000Z" },
    { id: "duplicate-active", status: "active", plotIndex: 2, createdAt: "2026-01-02T00:00:00.000Z" },
    { id: "invalid-active", status: "active", plotIndex: 12, createdAt: "2026-01-03T00:00:00.000Z" },
    { id: "keep-harvested", status: "harvested", plotIndex: 2, createdAt: "2026-01-01T00:00:00.000Z" }
  ];

  const assigned = assignGardenLayout(plants);
  const activeIndexes = assigned
    .filter((plant) => plant.status === "active")
    .map((plant) => plant.plotIndex);

  assert.deepEqual(activeIndexes, [2, 0, 1]);
  assert.equal(assigned.find((plant) => plant.id === "keep-harvested").plotIndex, 2);
});

test("finds the first open plot in a zone and returns null when full", () => {
  const plants = Array.from({ length: 9 }, (_, index) => ({
    id: `plant-${index}`,
    status: "active",
    plotIndex: index
  }));

  assert.equal(firstOpenPlotIndex(plants.slice(0, 4), "active"), 4);
  assert.equal(firstOpenPlotIndex(plants, "active"), null);
  assert.equal(firstOpenPlotIndex(plants, "harvested"), 0);
});

test("moves a plant to an empty plot or swaps with another plant in the same zone", () => {
  const plants = [
    { id: "a", status: "active", plotIndex: 0 },
    { id: "b", status: "active", plotIndex: 1 },
    { id: "c", status: "harvested", plotIndex: 1 }
  ];

  const moved = movePlantToPlot(plants, "a", 3);
  assert.equal(moved.find((plant) => plant.id === "a").plotIndex, 3);
  assert.equal(moved.find((plant) => plant.id === "b").plotIndex, 1);

  const swapped = movePlantToPlot(plants, "a", 1);
  assert.equal(swapped.find((plant) => plant.id === "a").plotIndex, 1);
  assert.equal(swapped.find((plant) => plant.id === "b").plotIndex, 0);
  assert.equal(swapped.find((plant) => plant.id === "c").plotIndex, 1);
});

test("creates default decoration placements for owned decorations", () => {
  const placements = defaultDecorationPlacements(["lamp", "pond"]);

  assert.deepEqual(placements, [
    { zone: "active", slotId: "left-lamp", decorationId: "lamp" },
    { zone: "harvested", slotId: "left-lamp", decorationId: "lamp" },
    { zone: "dormant", slotId: "left-lamp", decorationId: "lamp" },
    { zone: "active", slotId: "right-water", decorationId: "pond" },
    { zone: "harvested", slotId: "right-water", decorationId: "pond" },
    { zone: "dormant", slotId: "right-water", decorationId: "pond" }
  ]);
});
