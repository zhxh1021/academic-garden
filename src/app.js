import {
  TYPE_CONFIG,
  ZONES,
  advanceMilestone,
  createPlant,
  recordActivity,
  setPlantStatus,
  stageOf,
  updatePaperDetails,
  varietyLabel
} from "./domain.js";
import { downloadBackup, loadState, saveState } from "./store.js";

let state = await loadState();
let selectedZone = "active";
let nurturedPlantId = null;
let nurtureTimer = null;

const elements = {
  coinCount: document.querySelector("#coin-count"),
  counts: {
    active: document.querySelector("#active-count"),
    harvested: document.querySelector("#harvested-count"),
    dormant: document.querySelector("#dormant-count")
  },
  tabs: [...document.querySelectorAll(".garden-tab")],
  grid: document.querySelector("#plant-grid"),
  summary: document.querySelector("#garden-summary"),
  zoneKicker: document.querySelector("#zone-kicker"),
  zoneTitle: document.querySelector("#zone-title"),
  zoneDescription: document.querySelector("#zone-description"),
  dialog: document.querySelector("#plant-dialog"),
  form: document.querySelector("#plant-form"),
  historical: document.querySelector("#historical-field"),
  type: document.querySelector("#plant-type"),
  variety: document.querySelector("#plant-variety"),
  paperFields: document.querySelector("#paper-fields"),
  courseFields: document.querySelector("#course-fields"),
  dialogKicker: document.querySelector("#dialog-kicker"),
  dialogTitle: document.querySelector("#dialog-title"),
  historyNote: document.querySelector("#history-note"),
  submitPlant: document.querySelector("#submit-plant"),
  detailDialog: document.querySelector("#detail-dialog"),
  detailForm: document.querySelector("#detail-form"),
  detailPlantId: document.querySelector("#detail-plant-id"),
  detailKicker: document.querySelector("#detail-kicker"),
  detailTitle: document.querySelector("#detail-title"),
  detailStatus: document.querySelector("#detail-status"),
  detailPaper: document.querySelector("#detail-paper"),
  detailCourse: document.querySelector("#detail-course"),
  detailActivities: document.querySelector("#detail-activities"),
  saveDetail: document.querySelector("#save-detail")
};

function plantsIn(zone) {
  return state.plants.filter((plant) => plant.status === zone);
}

function renderCounts() {
  Object.keys(elements.counts).forEach((zone) => {
    elements.counts[zone].textContent = plantsIn(zone).length;
  });
  elements.coinCount.textContent = state.wallet.currentCoins;
  const totalGrowth = state.plants.reduce((total, plant) => total + plant.growth, 0);
  elements.summary.innerHTML = `
    <div><strong>${plantsIn("active").length}</strong><span>正在培育</span></div>
    <div><strong>${plantsIn("harvested").length}</strong><span>已有收获</span></div>
    <div><strong>${totalGrowth}</strong><span>累计成长</span></div>
  `;
}

function escapeText(value) {
  const element = document.createElement("span");
  element.textContent = value;
  return element.innerHTML;
}

function metadataText(plant) {
  if (plant.type === "paper") {
    const role = plant.metadata.authorRole === "primary" ? "主要作者" : "共同作者";
    return plant.metadata.publicationYear ? `${role} · ${plant.metadata.publicationYear}` : role;
  }
  const term = plant.metadata.term || "尚未填写学期";
  return `${term} · 已授课 ${plant.metadata.sessions} 次`;
}

function milestoneLabel(plant, milestone) {
  if (plant.type === "paper" && milestone?.label === "结果") return "收获";
  return milestone?.label;
}

function recentActivityMarkup(plant) {
  const records = state.activities
    .filter((activity) => activity.plantId === plant.id)
    .slice(0, 2);
  if (records.length === 0) return "";
  return `
    <section class="recent-care" aria-label="近期培育">
      ${records.map((activity) => `
        <p><strong>${escapeText(activity.care)}</strong> ${escapeText(activity.activityLabel)}
        <em>${escapeText(activity.rawText)}</em>
        <span>+${activity.growth} 成长 · +${activity.coins} 金币</span></p>
      `).join("")}
    </section>
  `;
}

function plantMarkup(plant) {
  const config = TYPE_CONFIG[plant.type];
  const stage = stageOf(plant);
  const nextAction = plant.status === "active" ? stage.nextAction : null;
  const lastMilestone = plant.milestones.at(-1);
  return `
    <article class="plant-card ${config.icon} stage-${plant.stage} ${plant.id === nurturedPlantId ? "is-nurtured" : ""}">
      <div class="plant-illustration" aria-hidden="true">
        <span class="cloud"></span>
        <span class="care-particles"></span>
        <span class="plant-sprite">
          <span class="stem"></span>
          <span class="trunk"></span>
          <span class="branch"></span>
          <span class="canopy"></span>
          <span class="blossom"></span>
          <span class="fruit"></span>
        </span>
        <span class="soil"></span>
      </div>
      <div class="plant-content">
        <div class="plant-topline">
          <span class="kind">${config.label}</span>
          <span class="stage">${stage.label}</span>
        </div>
        <h3>${escapeText(plant.title)}</h3>
        <p class="plant-meta">${varietyLabel(plant)} · ${escapeText(metadataText(plant))}</p>
        <div class="growth-row">
          <span>成长值</span>
          <strong>${plant.growth}</strong>
          <div class="growth-track"><i style="width:${Math.min(plant.growth, 100)}%"></i></div>
        </div>
        ${lastMilestone ? `<p class="latest">最近节点：${escapeText(milestoneLabel(plant, lastMilestone))}</p>` : `<p class="latest muted">等待第一次里程碑推进</p>`}
        ${recentActivityMarkup(plant)}
        ${plant.status === "active" ? `
          <form class="nurture-form" data-plant-id="${plant.id}">
            <label for="activity-${plant.id}">今天培育了什么？</label>
            <div>
              <input id="activity-${plant.id}" name="activity" required maxlength="180" placeholder="修改了两页正文..." />
              <button type="submit" class="action-button">记录</button>
            </div>
          </form>
        ` : ""}
        <footer class="card-actions">
          <button type="button" class="text-action" data-action="details" data-id="${plant.id}">查看详情</button>
          ${plant.status === "active" && plant.type === "course" ? `<button type="button" class="action-button teaching" data-action="teach" data-id="${plant.id}">又上了一次课</button>` : ""}
          ${nextAction ? `<button type="button" class="action-button" data-action="advance" data-id="${plant.id}">${nextAction}</button>` : ""}
          ${plant.status === "active" ? `<button type="button" class="text-action" data-action="sleep" data-id="${plant.id}">暂时沉睡</button>` : ""}
          ${plant.status === "dormant" ? `<button type="button" class="action-button" data-action="wake" data-id="${plant.id}">重新唤醒</button>` : ""}
        </footer>
      </div>
    </article>
  `;
}

function renderZone() {
  const zone = ZONES[selectedZone];
  elements.zoneKicker.textContent = zone.kicker;
  elements.zoneTitle.textContent = zone.title;
  elements.zoneDescription.textContent = zone.description;
  elements.tabs.forEach((tab) => {
    tab.classList.toggle("is-selected", tab.dataset.zone === selectedZone);
  });
  const plants = plantsIn(selectedZone);
  if (plants.length === 0) {
    const template = document.querySelector("#empty-template").content.cloneNode(true);
    template.querySelector("h3").textContent = zone.emptyTitle;
    template.querySelector("p").textContent = zone.emptyDescription;
    elements.grid.replaceChildren(template);
    return;
  }
  elements.grid.innerHTML = plants.map(plantMarkup).join("");
}

function render() {
  renderCounts();
  renderZone();
}

function updateVarieties() {
  const varieties = TYPE_CONFIG[elements.type.value].varieties;
  elements.variety.innerHTML = varieties
    .map((variety) => `<option value="${variety.id}">${variety.label}</option>`)
    .join("");
  const isPaper = elements.type.value === "paper";
  elements.paperFields.hidden = !isPaper;
  elements.courseFields.hidden = isPaper;
}

function openForm(historical) {
  elements.form.reset();
  elements.historical.value = String(historical);
  elements.dialogKicker.textContent = historical ? "PAST HARVEST" : "NEW PLANT";
  elements.dialogTitle.textContent = historical ? "导入历史成果" : "种下一株植物";
  elements.historyNote.hidden = !historical;
  elements.submitPlant.textContent = historical ? "放入收获园" : "种下植物";
  updateVarieties();
  elements.dialog.showModal();
}

function activityHistoryMarkup(plant) {
  const activities = state.activities.filter((activity) => activity.plantId === plant.id);
  if (activities.length === 0) {
    return `<p class="detail-empty">还没有培育记录。第一句真实推进，会被好好留在这里。</p>`;
  }
  return activities.map((activity) => `
    <article class="history-row">
      <strong>${escapeText(activity.activityLabel)} · ${escapeText(activity.care)}</strong>
      <p>${escapeText(activity.rawText)}</p>
      <span>+${activity.growth} 成长 · +${activity.coins} 金币</span>
    </article>
  `).join("");
}

function openDetails(plant) {
  const stage = stageOf(plant);
  elements.detailPlantId.value = plant.id;
  elements.detailKicker.textContent = plant.type === "paper" ? "TREE JOURNAL" : "FLOWER JOURNAL";
  elements.detailTitle.textContent = plant.title;
  elements.detailStatus.textContent = `${TYPE_CONFIG[plant.type].label} · ${varietyLabel(plant)} · ${stage.label}`;
  elements.detailActivities.innerHTML = activityHistoryMarkup(plant);
  const isPaper = plant.type === "paper";
  elements.detailPaper.hidden = !isPaper;
  elements.detailCourse.hidden = isPaper;
  elements.saveDetail.hidden = !isPaper;
  if (isPaper) {
    elements.detailForm.elements.authors.value = plant.metadata.authors ?? "";
    elements.detailForm.elements.publicationYear.value = plant.metadata.publicationYear ?? "";
    elements.detailForm.elements.publicationDate.value = plant.metadata.publicationDate ?? "";
    elements.detailForm.elements.venue.value = plant.metadata.venue ?? "";
  } else {
    elements.detailCourse.innerHTML = `
      <h3>课程信息</h3>
      <p>${escapeText(metadataText(plant))}</p>
    `;
  }
  elements.detailDialog.showModal();
}

async function storeAndRender() {
  await saveState(state);
  render();
}

function celebratePlant(plantId) {
  nurturedPlantId = plantId;
  window.clearTimeout(nurtureTimer);
  nurtureTimer = window.setTimeout(() => {
    nurturedPlantId = null;
    renderZone();
  }, 1400);
}

function applyReward(reward) {
  if (!reward) return;
  state = {
    ...state,
    wallet: {
      ...state.wallet,
      currentCoins: state.wallet.currentCoins + reward.coins,
      lifetimeCoins: state.wallet.lifetimeCoins + reward.coins
    }
  };
}

function applyActivity(plant, text, forcedActivityId = null) {
  const result = recordActivity(plant, text, forcedActivityId);
  if (!result.activity) return false;
  applyReward(result.reward);
  state = {
    ...state,
    plants: state.plants.map((item) => item.id === plant.id ? result.plant : item),
    activities: [result.activity, ...state.activities]
  };
  celebratePlant(plant.id);
  return true;
}

elements.tabs.forEach((tab) => {
  tab.addEventListener("click", () => {
    selectedZone = tab.dataset.zone;
    renderZone();
  });
});

document.querySelector("#open-create").addEventListener("click", () => openForm(false));
document.querySelector("#import-history").addEventListener("click", () => openForm(true));
document.querySelector("#export-button").addEventListener("click", () => downloadBackup(state));
document.querySelector("#close-dialog").addEventListener("click", () => elements.dialog.close());
document.querySelector("#cancel-dialog").addEventListener("click", () => elements.dialog.close());
document.querySelector("#close-detail").addEventListener("click", () => elements.detailDialog.close());
document.querySelector("#cancel-detail").addEventListener("click", () => elements.detailDialog.close());
elements.type.addEventListener("change", updateVarieties);

elements.form.addEventListener("submit", async (event) => {
  event.preventDefault();
  const formData = new FormData(elements.form);
  const plant = createPlant({
    title: formData.get("title"),
    type: formData.get("type"),
    variety: formData.get("variety"),
    historical: formData.get("historical") === "true",
    authorRole: formData.get("authorRole"),
    term: formData.get("term") ?? ""
  });
  state = { ...state, plants: [plant, ...state.plants] };
  selectedZone = plant.status;
  elements.dialog.close();
  await storeAndRender();
});

elements.detailForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  const plant = state.plants.find((item) => item.id === elements.detailPlantId.value);
  if (!plant || plant.type !== "paper") return;
  const formData = new FormData(elements.detailForm);
  const replacement = updatePaperDetails(plant, {
    authors: String(formData.get("authors") ?? ""),
    publicationYear: String(formData.get("publicationYear") ?? ""),
    publicationDate: String(formData.get("publicationDate") ?? ""),
    venue: String(formData.get("venue") ?? "")
  });
  state = {
    ...state,
    plants: state.plants.map((item) => item.id === plant.id ? replacement : item)
  };
  elements.detailDialog.close();
  await storeAndRender();
});

elements.grid.addEventListener("submit", async (event) => {
  const form = event.target.closest(".nurture-form");
  if (!form) return;
  event.preventDefault();
  const plant = state.plants.find((item) => item.id === form.dataset.plantId);
  if (!plant) return;
  const text = new FormData(form).get("activity");
  if (applyActivity(plant, String(text))) await storeAndRender();
});

elements.grid.addEventListener("click", async (event) => {
  const button = event.target.closest("button[data-action]");
  if (!button) return;
  const plant = state.plants.find((item) => item.id === button.dataset.id);
  if (!plant) return;
  let replacement = plant;
  if (button.dataset.action === "details") {
    openDetails(plant);
    return;
  }
  if (button.dataset.action === "advance") {
    const result = advanceMilestone(plant);
    replacement = result.plant;
    applyReward(result.reward);
    celebratePlant(plant.id);
    if (replacement.status === "harvested") selectedZone = "harvested";
  }
  if (button.dataset.action === "teach") {
    if (applyActivity(plant, "又上了一次课", "teaching")) await storeAndRender();
    return;
  }
  if (button.dataset.action === "sleep") {
    replacement = setPlantStatus(plant, "dormant");
    selectedZone = "dormant";
  }
  if (button.dataset.action === "wake") {
    replacement = setPlantStatus(plant, "active");
    selectedZone = "active";
  }
  state = {
    ...state,
    plants: state.plants.map((item) => item.id === plant.id ? replacement : item)
  };
  await storeAndRender();
});

updateVarieties();
render();
