export const ZONES = {
  active: {
    kicker: "ACTIVE PLOT",
    title: "正在生长的花园",
    description: "当前需要关心的树与花。",
    emptyTitle: "这里还没有正在生长的植物",
    emptyDescription: "种下一棵论文的树，或本学期课程的一朵花。"
  },
  harvested: {
    kicker: "ORCHARD",
    title: "收获园",
    description: "已经完成的成果持续留下职业积累的回响。",
    emptyTitle: "收获园正等待第一份成果",
    emptyDescription: "可以导入既往发表论文或已结课课程，从历史开始生长。"
  },
  dormant: {
    kicker: "QUIET PLOT",
    title: "沉睡花园",
    description: "暂时停下的项目会安静保留，准备好时再唤醒。",
    emptyTitle: "没有沉睡中的项目",
    emptyDescription: "暂停不等于失败；需要休整的植物会被妥善安放在这里。"
  }
};

export const TYPE_CONFIG = {
  paper: {
    label: "树",
    icon: "tree",
    varieties: [
      { id: "ginkgo", label: "银杏树", sprite: "./assets/sprites/tree-ginkgo.png" },
      { id: "camphor", label: "香樟树", sprite: "./assets/sprites/tree-camphor.png" },
      { id: "pine", label: "松树", sprite: "./assets/sprites/tree-pine.png" },
      { id: "maple", label: "枫树", sprite: "./assets/sprites/tree-maple.png" },
      { id: "willow", label: "柳树", sprite: "./assets/sprites/tree-willow.png" },
      { id: "cherry", label: "樱花树", sprite: "./assets/sprites/tree-cherry.png" }
    ],
    stages: [
      { id: "seed", label: "种子", nextAction: "开始推进" },
      { id: "sapling", label: "幼苗", nextAction: "标记初稿完成" },
      { id: "tree", label: "成树", nextAction: "标记完成投稿" },
      { id: "flower", label: "开花", nextAction: "标记接收或发表" },
      { id: "fruit", label: "收获", nextAction: null }
    ]
  },
  course: {
    label: "花",
    icon: "flower",
    varieties: [
      { id: "daisy", label: "雏菊", sprite: "./assets/sprites/flower-daisy.png" },
      { id: "hydrangea", label: "绣球花", sprite: "./assets/sprites/flower-hydrangea.png" },
      { id: "sunflower", label: "向日葵", sprite: "./assets/sprites/flower-sunflower.png" },
      { id: "lotus", label: "荷花", sprite: "./assets/sprites/flower-lotus.png" },
      { id: "lavender", label: "薰衣草", sprite: "./assets/sprites/flower-lavender.png" },
      { id: "rose", label: "玫瑰", sprite: "./assets/sprites/flower-rose.png" }
    ],
    stages: [
      { id: "sowing", label: "播种", nextAction: "开始教学" },
      { id: "growing", label: "生长", nextAction: "标记授课完成" },
      { id: "bloom", label: "开花", nextAction: "录入结课成果" },
      { id: "fruit", label: "结果", nextAction: "留种并收获" },
      { id: "seed_saved", label: "留种", nextAction: null }
    ]
  }
};

export const MILESTONE_REWARD = {
  growth: 18,
  coins: 12
};

export const CARE_TYPES = {
  sun: { label: "日照", growth: 3 },
  water: { label: "浇水", growth: 4 },
  fertilizer: { label: "施肥", growth: 5 }
};

export const DECORATIONS = [
  {
    id: "stone-path",
    label: "鹅卵石小径",
    price: 10,
    description: "给花园铺一段安静的小路。",
    className: "decor-path",
    sprite: "./assets/sprites/decor-stone-path.png"
  },
  {
    id: "wood-bench",
    label: "木长椅",
    price: 16,
    description: "给完成思考后的自己留一个座位。",
    className: "decor-bench",
    sprite: "./assets/sprites/decor-wood-bench.png"
  },
  {
    id: "lamp",
    label: "小路灯",
    price: 22,
    description: "夜里也能看见正在长大的项目。",
    className: "decor-lamp",
    sprite: "./assets/sprites/decor-lamp.png"
  },
  {
    id: "pond",
    label: "像素水池",
    price: 30,
    description: "让花园多一点清亮的呼吸。",
    className: "decor-pond",
    sprite: "./assets/sprites/decor-pond.png"
  }
];

export const DEFAULT_UNLOCKED_VARIETIES = TYPE_CONFIG.paper.varieties
  .concat(TYPE_CONFIG.course.varieties)
  .map((variety) => variety.id);

export const ACTIVITY_RULES = {
  paper: [
    { id: "writing", label: "写作", keywords: ["写", "修改", "改写", "正文", "初稿", "撰写"], careType: "water" },
    { id: "analysis", label: "分析", keywords: ["数据", "分析", "模型", "实验", "编码", "案例处理"], careType: "fertilizer" },
    { id: "submission", label: "投稿事务", keywords: ["投稿", "审稿", "回复", "返修", "格式"], careType: "fertilizer" },
    { id: "reading", label: "阅读", keywords: ["阅读", "读了", "文献", "笔记"], careType: "sun" },
    { id: "discussion", label: "讨论", keywords: ["讨论", "会议", "组会", "汇报", "合作者"], careType: "sun" },
    { id: "idea", label: "构思", keywords: ["构思", "框架", "问题", "idea", "理论"], careType: "sun" }
  ],
  course: [
    { id: "teaching", label: "授课", keywords: ["授课", "上课", "课堂", "又上了一次课"], careType: "water" },
    { id: "prep", label: "备课", keywords: ["备课", "课件", "教学设计"], careType: "sun" },
    { id: "materials", label: "材料更新", keywords: ["材料", "案例", "作业", "讲义"], careType: "water" },
    { id: "interaction", label: "学生互动", keywords: ["学生", "答疑", "指导", "反馈"], careType: "sun" },
    { id: "reflection", label: "复盘", keywords: ["复盘", "总结", "结课报告", "评教"], careType: "fertilizer" }
  ]
};

const GENERAL_ACTIVITY = {
  id: "progress",
  label: "日常推进",
  careType: "sun"
};

function createId() {
  return globalThis.crypto?.randomUUID?.() ??
    `${Date.now()}-${Math.random().toString(16).slice(2)}`;
}

function initialStage(type, historical) {
  const stages = TYPE_CONFIG[type].stages;
  return historical ? stages.at(-1).id : stages[0].id;
}

export function createPlant(input) {
  const now = new Date().toISOString();
  const historical = input.historical === true;
  return {
    id: createId(),
    title: input.title.trim(),
    type: input.type,
    variety: input.variety,
    status: historical ? "harvested" : "active",
    stage: initialStage(input.type, historical),
    growth: historical ? 100 : 0,
    createdAt: now,
    isHistoricalImport: historical,
    metadata: input.type === "paper"
      ? {
          authorRole: input.authorRole,
          authors: "",
          publicationYear: "",
          publicationDate: "",
          venue: ""
        }
      : { term: input.term.trim(), sessions: 0, inheritedFrom: null },
    careLog: {},
    milestones: historical
      ? [{ id: createId(), kind: "history_import", label: "导入历史成果", at: now }]
      : []
  };
}

export function stageOf(plant) {
  return TYPE_CONFIG[plant.type].stages.find((stage) => stage.id === plant.stage);
}

export function varietyLabel(plant) {
  return TYPE_CONFIG[plant.type].varieties.find((item) => item.id === plant.variety)?.label ?? plant.variety;
}

export function varietySprite(plant) {
  const variety = TYPE_CONFIG[plant.type].varieties.find((item) => item.id === plant.variety);
  const stage = TYPE_CONFIG[plant.type].stages.find((item) => item.id === plant.stage);
  if (!variety) return "";
  if (stage) return `./assets/sprites/stages/${plant.type}-${variety.id}-${stage.id}.png`;
  return variety.sprite ?? "";
}

export function advanceMilestone(plant) {
  if (plant.status !== "active") return { plant, reward: null };
  const stages = TYPE_CONFIG[plant.type].stages;
  const currentIndex = stages.findIndex((stage) => stage.id === plant.stage);
  if (currentIndex < 0 || currentIndex === stages.length - 1) return { plant, reward: null };
  const nextStage = stages[currentIndex + 1];
  const completed = currentIndex + 1 === stages.length - 1;
  return {
    plant: {
      ...plant,
      stage: nextStage.id,
      status: completed ? "harvested" : plant.status,
      growth: plant.growth + MILESTONE_REWARD.growth,
      milestones: [
        ...plant.milestones,
        {
          id: createId(),
          kind: "milestone",
          label: nextStage.label,
          at: new Date().toISOString()
        }
      ]
    },
    reward: MILESTONE_REWARD
  };
}

export function setPlantStatus(plant, status) {
  return { ...plant, status };
}

export function updatePlantBasics(plant, input) {
  const title = input.title.trim();
  return {
    ...plant,
    title,
    variety: input.variety,
    metadata: plant.type === "paper"
      ? {
          ...plant.metadata,
          authorRole: input.authorRole
        }
      : {
          ...plant.metadata,
          term: input.term.trim()
        }
  };
}

export function removePlantRecords(state, plantId) {
  return {
    ...state,
    plants: state.plants.filter((plant) => plant.id !== plantId),
    activities: state.activities.filter((activity) => activity.plantId !== plantId),
    settlements: state.settlements.filter((settlement) => settlement.plantId !== plantId)
  };
}

export function updatePaperDetails(plant, details) {
  if (plant.type !== "paper") return plant;
  return {
    ...plant,
    metadata: {
      ...plant.metadata,
      authors: details.authors.trim(),
      publicationYear: details.publicationYear.trim(),
      publicationDate: details.publicationDate.trim(),
      venue: details.venue.trim()
    }
  };
}

export function classifyActivity(plantType, text, forcedActivityId = null) {
  const rules = ACTIVITY_RULES[plantType];
  if (forcedActivityId) {
    return rules.find((rule) => rule.id === forcedActivityId) ?? GENERAL_ACTIVITY;
  }
  const normalizedText = text.toLowerCase();
  const scoredRules = rules.map((rule) => ({
    rule,
    score: rule.keywords.reduce(
      (score, keyword) => score + (normalizedText.includes(keyword.toLowerCase()) ? 1 : 0),
      0
    )
  }));
  scoredRules.sort((left, right) => right.score - left.score);
  return scoredRules[0].score > 0 ? scoredRules[0].rule : GENERAL_ACTIVITY;
}

export function dateKey(date = new Date()) {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function emptyCareDay() {
  return {
    sun: 0,
    water: 0,
    fertilizer: 0,
    settledSun: 0,
    settledWater: 0,
    settledFertilizer: 0,
    settled: false
  };
}

export function careSummaryForDate(plant, day = dateKey()) {
  return { ...emptyCareDay(), ...(plant.careLog?.[day] ?? {}) };
}

export function pendingCareForDate(plant, day = dateKey()) {
  const care = careSummaryForDate(plant, day);
  const settledSun = care.settledSun || (care.settled ? care.sun : 0);
  const settledWater = care.settledWater || (care.settled ? care.water : 0);
  const settledFertilizer = care.settledFertilizer || (care.settled ? care.fertilizer : 0);
  return {
    sun: Math.max(0, care.sun - settledSun),
    water: Math.max(0, care.water - settledWater),
    fertilizer: Math.max(0, care.fertilizer - settledFertilizer)
  };
}

export function careLabel(careType) {
  return CARE_TYPES[careType]?.label ?? CARE_TYPES.sun.label;
}

export function addCare(plant, careType, day = dateKey()) {
  const current = careSummaryForDate(plant, day);
  return {
    ...plant,
    careLog: {
      ...(plant.careLog ?? {}),
      [day]: {
        ...current,
        [careType]: current[careType] + 1,
        settled: false
      }
    }
  };
}

export function settleCareForDate(plant, day) {
  const care = careSummaryForDate(plant, day);
  const pendingCare = pendingCareForDate(plant, day);
  const totalCare = pendingCare.sun + pendingCare.water + pendingCare.fertilizer;
  if (totalCare === 0) return { plant, settlement: null };
  const balanceBonus = pendingCare.sun > 0 && pendingCare.water > 0 && pendingCare.fertilizer > 0 ? 4 : 0;
  const growth =
    pendingCare.sun * CARE_TYPES.sun.growth +
    pendingCare.water * CARE_TYPES.water.growth +
    pendingCare.fertilizer * CARE_TYPES.fertilizer.growth +
    balanceBonus;
  return {
    plant: {
      ...plant,
      growth: plant.growth + growth,
      careLog: {
        ...(plant.careLog ?? {}),
        [day]: {
          ...care,
          settledSun: care.sun,
          settledWater: care.water,
          settledFertilizer: care.fertilizer,
          settled: true
        }
      }
    },
    settlement: {
      plantId: plant.id,
      day,
      care: pendingCare,
      growth,
      balanceBonus
    }
  };
}

export function recordActivity(plant, text, forcedActivityId = null) {
  if (plant.status !== "active") return { plant, activity: null, reward: null };
  const rawText = text.trim();
  if (!rawText) return { plant, activity: null, reward: null };
  const rule = classifyActivity(plant.type, rawText, forcedActivityId);
  const at = new Date().toISOString();
  const careType = rule.careType;
  const incrementsSession = plant.type === "course" && rule.id === "teaching";
  const updatedMetadata = incrementsSession
    ? { ...plant.metadata, sessions: plant.metadata.sessions + 1 }
    : plant.metadata;
  const updatedPlant = addCare({ ...plant, metadata: updatedMetadata }, careType);
  return {
    plant: updatedPlant,
    activity: {
      id: createId(),
      plantId: plant.id,
      rawText,
      activityType: rule.id,
      activityLabel: rule.label,
      careType,
      care: careLabel(careType),
      growth: 0,
      coins: 0,
      classifiedBy: forcedActivityId ? "shortcut" : "local_rules",
      at
    },
    reward: null
  };
}
