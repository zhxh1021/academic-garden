import assert from "node:assert/strict";
import test from "node:test";

import {
  createPlant,
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
