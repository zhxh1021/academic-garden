import {
  DECORATIONS,
  DECORATION_SLOTS,
  DEFAULT_UNLOCKED_VARIETIES,
  GARDEN_ZONES,
  ZONE_PLOTS,
  TYPE_CONFIG,
  ZONES,
  advanceMilestone,
  assignGardenLayout,
  careSummaryForDate,
  createPlant,
  dateKey,
  defaultDecorationPlacements,
  firstOpenPlotIndex,
  movePlantToPlot,
  pendingCareForDate,
  recordActivity,
  removePlantRecords,
  setPlantStatus,
  settleCareForDate,
  stageOf,
  updatePlantBasics,
  updatePaperDetails,
  varietyLabel,
  varietySprite
} from "./domain.js";
import { syncStatusViewModel } from "./sync-auth.js";
import { downloadBackup, getSyncStatus, loadState, loginSync, logoutSync, saveState } from "./store.js";

function normalizeState(snapshot) {
  const decorations = snapshot.decorations ?? { owned: [] };
  const ownedDecorations = decorations.owned ?? [];
  return {
    ...snapshot,
    plants: assignGardenLayout(snapshot.plants.map((plant) => ({
      ...plant,
      careLog: plant.careLog ?? {}
    }))),
    activities: snapshot.activities ?? [],
    settlements: snapshot.settlements ?? [],
    decorations: {
      ...decorations,
      owned: ownedDecorations,
      placements: decorations.placements ?? defaultDecorationPlacements(ownedDecorations)
    },
    wallet: {
      ...snapshot.wallet,
      currentCoins: snapshot.wallet?.currentCoins ?? 0,
      lifetimeCoins: snapshot.wallet?.lifetimeCoins ?? 0,
      unlockedVarieties: [
        ...new Set([...(snapshot.wallet?.unlockedVarieties ?? []), ...DEFAULT_UNLOCKED_VARIETIES])
      ]
    }
  };
}

function createId() {
  return globalThis.crypto?.randomUUID?.() ??
    `${Date.now()}-${Math.random().toString(16).slice(2)}`;
}

let state = normalizeState(await loadState());
let selectedZone = "active";
let selectedFarmZone = "active";
let selectedView = "home";
let nurturedPlantId = null;
let focusedPlantId = null;
let editingPlantId = null;
let pendingPlotIndex = null;
let isMovingPlants = false;
let movingPlantId = null;
let nurtureTimer = null;
let focusTimer = null;

const elements = {
  coinCount: document.querySelector("#coin-count"),
  syncStatus: document.querySelector("#sync-status"),
  syncDialog: document.querySelector("#sync-dialog"),
  syncForm: document.querySelector("#sync-form"),
  syncCurrent: document.querySelector("#sync-current"),
  syncMessage: document.querySelector("#sync-message"),
  syncUsername: document.querySelector("#sync-username"),
  syncPassword: document.querySelector("#sync-password"),
  syncSubmit: document.querySelector("#sync-submit"),
  syncLogout: document.querySelector("#sync-logout"),
  viewTabs: [...document.querySelectorAll(".view-tab")],
  gardenHome: document.querySelector("#garden-home"),
  projectWorkbench: document.querySelector("#project-workbench"),
  overviewGarden: document.querySelector("#overview-garden"),
  shopSection: document.querySelector("#shop-section"),
  shopGrid: document.querySelector("#shop-grid"),
  settleToday: document.querySelector("#settle-today"),
  settlementCopy: document.querySelector("#settlement-copy"),
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
  detailScene: document.querySelector("#detail-scene"),
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

function zoneLabel(zone) {
  return ZONES[zone]?.title ?? zone;
}

function renderSyncStatus() {
  const sync = getSyncStatus();
  if (!elements.syncStatus) return;
  const view = syncStatusViewModel(sync);
  elements.syncStatus.textContent = view.label;
  elements.syncStatus.title = view.title;
  elements.syncStatus.dataset.syncState = sync.connected ? "connected" : sync.hasSavedLogin ? "pending" : "signed-out";
  if (elements.syncDialog?.open) renderSyncDialog();
}

function escapeText(value) {
  const element = document.createElement("span");
  element.textContent = value;
  return element.innerHTML;
}

function spriteImage(src, className, alt = "") {
  if (!src) return "";
  return `<img class="asset-sprite ${className}" src="${src}" alt="${escapeText(alt)}" loading="lazy" />`;
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

function careLine(care) {
  return `日照 ${care.sun} · 浇水 ${care.water} · 施肥 ${care.fertilizer}`;
}

function todayCareMarkup(plant) {
  if (plant.status !== "active") return "";
  const care = careSummaryForDate(plant);
  return `
    <div class="care-meter" aria-label="今日照料">
      <span>今日照料</span>
      <strong>${careLine(care)}</strong>
    </div>
  `;
}

function activityRewardText(activity) {
  if (activity.careType) return `今日${escapeText(activity.care)} +1，等待结算`;
  return `+${activity.growth} 成长 · +${activity.coins} 金币`;
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
        <span>${activityRewardText(activity)}</span></p>
      `).join("")}
    </section>
  `;
}

function plantSceneMarkup(plant, spriteClassName) {
  const sprite = varietySprite(plant);
  if (!sprite) return "";
  return `
    <span class="scene-glow"></span>
    <span class="scene-root"></span>
    ${spriteImage(sprite, spriteClassName, varietyLabel(plant))}
  `;
}

function plantMarkup(plant) {
  const config = TYPE_CONFIG[plant.type];
  const stage = stageOf(plant);
  const nextAction = plant.status === "active" ? stage.nextAction : null;
  const lastMilestone = plant.milestones.at(-1);
  const sprite = varietySprite(plant);
  return `
    <article id="plant-${plant.id}" class="plant-card ${config.icon} stage-${plant.stage} ${sprite ? "has-asset-sprite" : ""} ${plant.id === nurturedPlantId ? "is-nurtured" : ""} ${plant.id === focusedPlantId ? "is-focused" : ""}">
      <div class="plant-illustration" aria-hidden="true">
        <span class="care-particles"></span>
        ${plantSceneMarkup(plant, "card-plant-sprite")}
        ${sprite ? "" : `<span class="plant-sprite">
          <span class="stem"></span>
          <span class="trunk"></span>
          <span class="branch"></span>
          <span class="canopy"></span>
          <span class="blossom"></span>
          <span class="fruit"></span>
        </span>`}
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
        ${todayCareMarkup(plant)}
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
          <button type="button" class="text-action" data-action="edit" data-id="${plant.id}">编辑</button>
          ${plant.status === "active" && plant.type === "course" ? `<button type="button" class="action-button teaching" data-action="teach" data-id="${plant.id}">又上了一次课</button>` : ""}
          ${nextAction ? `<button type="button" class="action-button" data-action="advance" data-id="${plant.id}">${nextAction}</button>` : ""}
          ${plant.status === "active" ? `<button type="button" class="text-action" data-action="sleep" data-id="${plant.id}">暂时沉睡</button>` : ""}
          ${plant.status === "dormant" ? `<button type="button" class="action-button" data-action="wake" data-id="${plant.id}">重新唤醒</button>` : ""}
          <button type="button" class="text-action danger-action" data-action="remove" data-id="${plant.id}">移除</button>
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

function renderView() {
  elements.gardenHome.hidden = selectedView !== "home";
  elements.projectWorkbench.hidden = selectedView !== "projects";
  elements.viewTabs.forEach((tab) => {
    tab.classList.toggle("is-selected", tab.dataset.view === selectedView);
  });
}

function renderSettlement() {
  const today = dateKey();
  const activePlants = plantsIn("active");
  const totals = activePlants.reduce(
    (total, plant) => {
      const care = careSummaryForDate(plant, today);
      const pendingCare = pendingCareForDate(plant, today);
      total.sun += care.sun;
      total.water += care.water;
      total.fertilizer += care.fertilizer;
      if (pendingCare.sun + pendingCare.water + pendingCare.fertilizer > 0) total.unsettled += 1;
      return total;
    },
    { sun: 0, water: 0, fertilizer: 0, unsettled: 0 }
  );
  const totalCare = totals.sun + totals.water + totals.fertilizer;
  if (totalCare === 0) {
    elements.settlementCopy.textContent = "今天还没有照料记录。去项目管理里写一句真实推进，就会积累今日照料。";
    elements.settleToday.disabled = true;
    return;
  }
  elements.settlementCopy.textContent =
    `今日已积累：日照 ${totals.sun}、浇水 ${totals.water}、施肥 ${totals.fertilizer}。结算后会统一增加成长值。`;
  elements.settleToday.disabled = totals.unsettled === 0;
}

function miniPlantMarkup(plant, plot) {
  const config = TYPE_CONFIG[plant.type];
  const stage = stageOf(plant);
  const sprite = varietySprite(plant);
  const variety = config.varieties.find((item) => item.id === plant.variety);
  const mapSprite = ["tree", "flower", "fruit", "bloom", "seed_saved"].includes(stage.id)
    ? variety?.sprite ?? sprite
    : sprite;
  return `
    <button type="button" class="overview-plant ${config.icon} stage-${plant.stage} ${mapSprite ? "has-asset-sprite" : ""} ${movingPlantId === plant.id ? "is-moving" : ""}" data-overview-plant-id="${plant.id}" style="--x:${plot.x}%;--y:${plot.y}%;--z:${plot.z}" aria-label="${movingPlantId ? `移动${escapeText(plant.title)}` : `打开${escapeText(plant.title)}的项目记录`}" title="${escapeText(plant.title)}">
      ${mapSprite ? spriteImage(mapSprite, "map-plant-sprite", varietyLabel(plant)) : `<span class="mini-sprite" aria-hidden="true"></span>`}
      <strong>${escapeText(plant.title)}</strong>
      <em>${config.label} · ${stage.label}</em>
    </button>
  `;
}

function decorationMarkup(placement) {
  const decoration = DECORATIONS.find((item) => item.id === placement.decorationId);
  const slot = DECORATION_SLOTS.find((item) => item.id === placement.slotId);
  if (!decoration || !slot) return "";
  return `
    <span class="garden-decoration ${decoration.className}" style="--x:${slot.x}%;--y:${slot.y}%;--z:${slot.z}" title="${escapeText(decoration.label)}">
      ${spriteImage(decoration.sprite, "decor-sprite", decoration.label)}
    </span>
  `;
}

function emptyPlotMarkup(plot, isOccupied) {
  const canPlant = selectedFarmZone === "active" && !isOccupied;
  const idleCopy = selectedFarmZone === "active" ? "空地" : "预留";
  return `
    <button type="button" class="farm-plot ${isOccupied ? "is-occupied" : ""} ${canPlant ? "can-plant" : ""}" data-plot-index="${plot.index}" style="--x:${plot.x}%;--y:${plot.y}%;--z:${plot.z - 1}" ${canPlant || movingPlantId ? "" : "disabled"} aria-label="${canPlant ? "在这块空地种下一株植物" : `${zoneLabel(selectedFarmZone)}${idleCopy} ${plot.index + 1}`}">
      <span>${canPlant ? "种植" : idleCopy}</span>
    </button>
  `;
}

function decorationPlaceholdersMarkup() {
  return DECORATION_SLOTS.map((slot) => `
    <span class="decoration-slot" style="--x:${slot.x}%;--y:${slot.y}%;--z:${slot.z - 1}" aria-hidden="true"></span>
  `).join("");
}

function farmZoneButtonMarkup(zone) {
  return `
    <button type="button" class="farm-zone-tab ${selectedFarmZone === zone ? "is-selected" : ""}" data-farm-zone="${zone}">
      <span>${zoneLabel(zone)}</span>
      <strong>${plantsIn(zone).length}</strong>
    </button>
  `;
}

function plantedByPlot(zone) {
  return new Map(plantsIn(zone)
    .filter((plant) => Number.isInteger(plant.plotIndex) && plant.plotIndex >= 0 && plant.plotIndex < ZONE_PLOTS.length)
    .map((plant) => [plant.plotIndex, plant]));
}

function renderOverview() {
  const zonePlants = plantedByPlot(selectedFarmZone);
  const zone = ZONES[selectedFarmZone];
  const zoneDecorationPlacements = (state.decorations.placements ?? [])
    .filter((placement) => placement.zone === selectedFarmZone && state.decorations.owned.includes(placement.decorationId));
  elements.overviewGarden.innerHTML = `
    <div class="map-sky" aria-hidden="true"></div>
    <div class="farm-scene-bar">
      <div>
        <p class="eyebrow">${zone.kicker}</p>
        <h2>${zone.title}</h2>
      </div>
      <button type="button" class="quiet-button farm-move-toggle ${isMovingPlants ? "is-active" : ""}" data-farm-action="move">
        ${isMovingPlants ? movingPlantId ? "取消移动" : "退出移动" : "移动植物"}
      </button>
    </div>
    <nav class="farm-zone-switch" aria-label="切换花园区域">
      ${GARDEN_ZONES.map(farmZoneButtonMarkup).join("")}
    </nav>
    <div class="map-field">
      ${decorationPlaceholdersMarkup()}
      ${zoneDecorationPlacements.map(decorationMarkup).join("")}
      ${ZONE_PLOTS.map((plot, index) => {
        const plant = zonePlants.get(index);
        return `
          <div class="farm-cell" style="--x:${plot.x}%;--y:${plot.y}%;--z:${plot.z}">
            ${emptyPlotMarkup({ ...plot, index }, Boolean(plant))}
            ${plant ? miniPlantMarkup(plant, plot) : ""}
          </div>
        `;
      }).join("")}
    </div>
  `;
}

function renderShop() {
  elements.shopGrid.innerHTML = DECORATIONS.map((decoration) => {
    const owned = state.decorations.owned.includes(decoration.id);
    const affordable = state.wallet.currentCoins >= decoration.price;
    return `
      <article class="shop-card">
        <span class="shop-preview ${decoration.className}" aria-hidden="true">
          ${spriteImage(decoration.sprite, "shop-sprite", decoration.label)}
        </span>
        <h3>${escapeText(decoration.label)}</h3>
        <p>${escapeText(decoration.description)}</p>
        <footer>
          <strong>${decoration.price} 金币</strong>
          <button type="button" class="action-button" data-decoration-id="${decoration.id}" ${owned || !affordable ? "disabled" : ""}>
            ${owned ? "已解锁" : "解锁"}
          </button>
        </footer>
      </article>
    `;
  }).join("");
}

function render() {
  renderCounts();
  renderSyncStatus();
  renderView();
  renderSettlement();
  renderOverview();
  renderShop();
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

function openForm(historical, plant = null, plotIndex = null) {
  editingPlantId = plant?.id ?? null;
  pendingPlotIndex = plotIndex;
  elements.form.reset();
  elements.historical.value = String(historical);
  elements.type.disabled = Boolean(plant);
  elements.dialogKicker.textContent = plant ? "EDIT PLANT" : historical ? "PAST HARVEST" : "NEW PLANT";
  elements.dialogTitle.textContent = plant ? "编辑植物" : historical ? "导入历史成果" : plotIndex === null ? "种下一株植物" : `种到第 ${plotIndex + 1} 块地`;
  elements.historyNote.hidden = !historical || Boolean(plant);
  elements.submitPlant.textContent = plant ? "保存修改" : historical ? "放入收获园" : "种下植物";
  if (plant) {
    elements.form.elements.title.value = plant.title;
    elements.type.value = plant.type;
  }
  updateVarieties();
  if (plant) {
    elements.variety.value = plant.variety;
    if (plant.type === "paper") {
      elements.form.elements.authorRole.value = plant.metadata.authorRole ?? "primary";
    } else {
      elements.form.elements.term.value = plant.metadata.term ?? "";
    }
  }
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
      <span>${activityRewardText(activity)}</span>
    </article>
  `).join("");
}

function openDetails(plant) {
  const stage = stageOf(plant);
  elements.detailPlantId.value = plant.id;
  elements.detailKicker.textContent = plant.type === "paper" ? "TREE JOURNAL" : "FLOWER JOURNAL";
  elements.detailTitle.textContent = plant.title;
  elements.detailStatus.textContent = `${TYPE_CONFIG[plant.type].label} · ${varietyLabel(plant)} · ${stage.label}`;
  elements.detailScene.className = `detail-scene ${TYPE_CONFIG[plant.type].icon} stage-${plant.stage}`;
  elements.detailScene.innerHTML = plantSceneMarkup(plant, "detail-plant-sprite");
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

function settlePendingCare(includeToday = false) {
  const today = dateKey();
  const settlements = [];
  const plants = state.plants.map((plant) => {
    if (!plant.careLog) return plant;
    return Object.keys(plant.careLog).reduce((currentPlant, day) => {
      if (day > today || (!includeToday && day === today)) return currentPlant;
      const result = settleCareForDate(currentPlant, day);
      if (result.settlement) {
        settlements.push({
          id: createId(),
          ...result.settlement,
          at: new Date().toISOString()
        });
      }
      return result.plant;
    }, plant);
  });
  if (settlements.length === 0) return false;
  state = {
    ...state,
    plants,
    settlements: [...settlements, ...state.settlements]
  };
  return true;
}

async function buyDecoration(decorationId) {
  const decoration = DECORATIONS.find((item) => item.id === decorationId);
  if (!decoration || state.decorations.owned.includes(decoration.id)) return;
  if (state.wallet.currentCoins < decoration.price) return;
  state = {
    ...state,
    wallet: {
      ...state.wallet,
      currentCoins: state.wallet.currentCoins - decoration.price
    },
    decorations: {
      ...state.decorations,
      owned: [...state.decorations.owned, decoration.id],
      placements: defaultDecorationPlacements([...state.decorations.owned, decoration.id])
    }
  };
  await storeAndRender();
}

function setSyncMessage(message, kind = "") {
  if (!elements.syncMessage) return;
  elements.syncMessage.hidden = !message;
  elements.syncMessage.textContent = message;
  elements.syncMessage.dataset.kind = kind;
}

function renderSyncDialog() {
  const sync = getSyncStatus();
  const view = syncStatusViewModel(sync);
  if (elements.syncCurrent) elements.syncCurrent.textContent = view.label;
  if (elements.syncLogout) elements.syncLogout.hidden = !sync.hasSavedLogin;
  if (elements.syncSubmit) elements.syncSubmit.textContent = sync.connected ? "重新登录" : "登录";
}

function openSyncDialog() {
  const sync = getSyncStatus();
  if (!sync.configured) {
    window.alert("当前没有配置云端同步地址，正在使用浏览器本地数据。");
    return;
  }
  elements.syncUsername.value = sync.username || "garden";
  elements.syncPassword.value = "";
  setSyncMessage(sync.connected ? "当前设备已连接云端同步。" : "", "ok");
  renderSyncDialog();
  elements.syncDialog.showModal();
  (elements.syncUsername.value ? elements.syncPassword : elements.syncUsername).focus();
}

async function reloadFromCloud() {
  state = normalizeState(await loadState());
  render();
}

function plantWithZonePlot(plant, zone) {
  const plotIndex = firstOpenPlotIndex(
    state.plants.filter((item) => item.id !== plant.id),
    zone
  );
  return {
    ...setPlantStatus(plant, zone),
    plotIndex
  };
}

function focusPlantCard(plantId) {
  focusedPlantId = plantId;
  window.clearTimeout(focusTimer);
  render();
  requestAnimationFrame(() => {
    const card = document.querySelector(`#plant-${CSS.escape(plantId)}`);
    card?.scrollIntoView({ behavior: "smooth", block: "center" });
    const input = card?.querySelector(".nurture-form input");
    input?.focus();
  });
  focusTimer = window.setTimeout(() => {
    focusedPlantId = null;
    renderZone();
  }, 2200);
}

function goToZone(zone) {
  selectedView = "projects";
  selectedZone = zone;
  selectedFarmZone = zone;
  render();
  elements.projectWorkbench.scrollIntoView({ behavior: "smooth", block: "start" });
}

function goToPlant(plant) {
  selectedView = "projects";
  selectedZone = plant.status;
  render();
  focusPlantCard(plant.id);
}

elements.viewTabs.forEach((tab) => {
  tab.addEventListener("click", () => {
    selectedView = tab.dataset.view;
    render();
  });
});

elements.tabs.forEach((tab) => {
  tab.addEventListener("click", () => {
    selectedZone = tab.dataset.zone;
    renderZone();
  });
});

elements.settleToday.addEventListener("click", async () => {
  if (settlePendingCare(true)) await storeAndRender();
});

elements.shopGrid.addEventListener("click", async (event) => {
  const button = event.target.closest("button[data-decoration-id]");
  if (!button) return;
  await buyDecoration(button.dataset.decorationId);
});

elements.overviewGarden.addEventListener("click", (event) => {
  const farmZone = event.target.closest("[data-farm-zone]");
  if (farmZone) {
    selectedFarmZone = farmZone.dataset.farmZone;
    isMovingPlants = false;
    movingPlantId = null;
    renderOverview();
    return;
  }
  const farmAction = event.target.closest("[data-farm-action='move']");
  if (farmAction) {
    isMovingPlants = !isMovingPlants;
    movingPlantId = null;
    renderOverview();
    return;
  }
  const plotButton = event.target.closest("[data-plot-index]");
  if (plotButton && isMovingPlants && movingPlantId) {
    state = {
      ...state,
      plants: movePlantToPlot(state.plants, movingPlantId, Number(plotButton.dataset.plotIndex))
    };
    isMovingPlants = false;
    movingPlantId = null;
    void storeAndRender();
    return;
  }
  const plantButton = event.target.closest("button[data-overview-plant-id]");
  if (plantButton) {
    const plant = state.plants.find((item) => item.id === plantButton.dataset.overviewPlantId);
    if (!plant) return;
    if (isMovingPlants && movingPlantId) {
      state = {
        ...state,
        plants: movePlantToPlot(state.plants, movingPlantId, plant.plotIndex)
      };
      isMovingPlants = false;
      movingPlantId = null;
      void storeAndRender();
      return;
    }
    if (isMovingPlants) {
      movingPlantId = plant.id;
      renderOverview();
      return;
    }
    goToPlant(plant);
    return;
  }
  if (plotButton && selectedFarmZone === "active") {
    openForm(false, null, Number(plotButton.dataset.plotIndex));
    return;
  }
  const zoneTarget = event.target.closest("[data-overview-zone]");
  if (zoneTarget) goToZone(zoneTarget.dataset.overviewZone);
});

document.querySelector("[data-home-action='shop']").addEventListener("click", () => {
  elements.shopSection.classList.toggle("is-collapsed");
  if (!elements.shopSection.classList.contains("is-collapsed")) {
    elements.shopSection.scrollIntoView({ behavior: "smooth", block: "start" });
  }
});

document.querySelector("[data-home-action='projects']").addEventListener("click", () => goToZone("active"));

document.querySelector("#open-create").addEventListener("click", () => openForm(false));
document.querySelector("#import-history").addEventListener("click", () => openForm(true));
document.querySelector("#export-button").addEventListener("click", () => downloadBackup(state));
elements.syncStatus?.addEventListener("click", openSyncDialog);
document.querySelector("#close-sync")?.addEventListener("click", () => elements.syncDialog.close());
document.querySelector("#cancel-sync")?.addEventListener("click", () => elements.syncDialog.close());
elements.syncForm?.addEventListener("submit", async (event) => {
  event.preventDefault();
  const username = elements.syncUsername.value.trim();
  const password = elements.syncPassword.value;
  if (!username || !password) {
    setSyncMessage("请输入用户名和密码。", "error");
    return;
  }
  elements.syncSubmit.disabled = true;
  setSyncMessage("正在登录云端同步……");
  try {
    await loginSync(username, password);
    await reloadFromCloud();
    elements.syncDialog.close();
  } catch (error) {
    setSyncMessage(error.message || "登录失败，请稍后重试。", "error");
  } finally {
    elements.syncSubmit.disabled = false;
    renderSyncDialog();
    renderSyncStatus();
  }
});
elements.syncLogout?.addEventListener("click", async () => {
  elements.syncLogout.disabled = true;
  setSyncMessage("正在退出登录……");
  try {
    await logoutSync();
    setSyncMessage("已退出云端同步。", "ok");
    render();
  } finally {
    elements.syncLogout.disabled = false;
    renderSyncDialog();
  }
});
document.querySelector("#close-dialog").addEventListener("click", () => {
  editingPlantId = null;
  pendingPlotIndex = null;
  elements.type.disabled = false;
  elements.dialog.close();
});
document.querySelector("#cancel-dialog").addEventListener("click", () => {
  editingPlantId = null;
  pendingPlotIndex = null;
  elements.type.disabled = false;
  elements.dialog.close();
});
document.querySelector("#close-detail").addEventListener("click", () => elements.detailDialog.close());
document.querySelector("#cancel-detail").addEventListener("click", () => elements.detailDialog.close());
elements.dialog.addEventListener("close", () => {
  editingPlantId = null;
  pendingPlotIndex = null;
  elements.type.disabled = false;
});
elements.type.addEventListener("change", updateVarieties);

elements.form.addEventListener("submit", async (event) => {
  event.preventDefault();
  const formData = new FormData(elements.form);
  if (editingPlantId) {
    const plant = state.plants.find((item) => item.id === editingPlantId);
    if (!plant) return;
    const replacement = updatePlantBasics(plant, {
      title: String(formData.get("title") ?? ""),
      variety: String(formData.get("variety") ?? ""),
      authorRole: String(formData.get("authorRole") ?? plant.metadata.authorRole ?? "primary"),
      term: String(formData.get("term") ?? plant.metadata.term ?? "")
    });
    state = {
      ...state,
      plants: state.plants.map((item) => item.id === plant.id ? replacement : item)
    };
    editingPlantId = null;
    elements.type.disabled = false;
    elements.dialog.close();
    await storeAndRender();
    return;
  }
  const plant = createPlant({
    title: formData.get("title"),
    type: formData.get("type"),
    variety: formData.get("variety"),
    historical: formData.get("historical") === "true",
    authorRole: formData.get("authorRole"),
    term: formData.get("term") ?? "",
    plotIndex: pendingPlotIndex ?? firstOpenPlotIndex(state.plants, formData.get("historical") === "true" ? "harvested" : "active")
  });
  if (plant.status === "active" && plant.plotIndex === null) {
    window.alert("正在生长的花园已经有 9 株植物了。请先收获或沉睡一个项目，再种下新的植物。");
    return;
  }
  state = { ...state, plants: [plant, ...state.plants] };
  selectedZone = plant.status;
  selectedFarmZone = plant.status;
  pendingPlotIndex = null;
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
  if (button.dataset.action === "edit") {
    openForm(false, plant);
    return;
  }
  if (button.dataset.action === "remove") {
    if (!window.confirm(`确定移除「${plant.title}」吗？相关培育记录也会一起删除。`)) return;
    state = removePlantRecords(state, plant.id);
    await storeAndRender();
    return;
  }
  if (button.dataset.action === "advance") {
    const result = advanceMilestone(plant);
    replacement = result.plant.status === "harvested" ? {
      ...result.plant,
      plotIndex: firstOpenPlotIndex(state.plants.filter((item) => item.id !== plant.id), "harvested")
    } : result.plant;
    applyReward(result.reward);
    celebratePlant(plant.id);
    if (replacement.status === "harvested") {
      selectedZone = "harvested";
      selectedFarmZone = "harvested";
    }
  }
  if (button.dataset.action === "teach") {
    if (applyActivity(plant, "又上了一次课", "teaching")) await storeAndRender();
    return;
  }
  if (button.dataset.action === "sleep") {
    replacement = plantWithZonePlot(plant, "dormant");
    selectedZone = "dormant";
    selectedFarmZone = "dormant";
  }
  if (button.dataset.action === "wake") {
    replacement = plantWithZonePlot(plant, "active");
    if (replacement.plotIndex === null) {
      window.alert("正在生长的花园已经有 9 株植物了。请先腾出一块地，再唤醒这个项目。");
      return;
    }
    selectedZone = "active";
    selectedFarmZone = "active";
  }
  state = {
    ...state,
    plants: state.plants.map((item) => item.id === plant.id ? replacement : item)
  };
  await storeAndRender();
});

updateVarieties();
if (settlePendingCare(false)) await saveState(state);
render();
