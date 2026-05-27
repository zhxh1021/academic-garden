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
      { id: "ginkgo", label: "银杏树" },
      { id: "camphor", label: "香樟树" }
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
      { id: "daisy", label: "雏菊" },
      { id: "hydrangea", label: "绣球花" }
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

export const ACTIVITY_RULES = {
  paper: [
    { id: "writing", label: "写作", keywords: ["写", "修改", "改写", "正文", "初稿", "撰写"], care: "浇水", growth: 8, coins: 4 },
    { id: "analysis", label: "分析", keywords: ["数据", "分析", "模型", "实验", "编码", "案例处理"], care: "施肥", growth: 9, coins: 4 },
    { id: "submission", label: "投稿事务", keywords: ["投稿", "审稿", "回复", "返修", "格式"], care: "浇水 + 施肥", growth: 10, coins: 5 },
    { id: "reading", label: "阅读", keywords: ["阅读", "读了", "文献", "笔记"], care: "阳光 + 养分", growth: 6, coins: 3 },
    { id: "discussion", label: "讨论", keywords: ["讨论", "会议", "组会", "汇报", "合作者"], care: "阳光", growth: 6, coins: 3 },
    { id: "idea", label: "构思", keywords: ["构思", "框架", "问题", "idea", "理论"], care: "阳光", growth: 6, coins: 3 }
  ],
  course: [
    { id: "teaching", label: "授课", keywords: ["授课", "上课", "课堂", "又上了一次课"], care: "浇水 + 阳光", growth: 8, coins: 4 },
    { id: "prep", label: "备课", keywords: ["备课", "课件", "教学设计"], care: "阳光", growth: 6, coins: 3 },
    { id: "materials", label: "材料更新", keywords: ["材料", "案例", "作业", "讲义"], care: "浇水", growth: 7, coins: 3 },
    { id: "interaction", label: "学生互动", keywords: ["学生", "答疑", "指导", "反馈"], care: "阳光", growth: 6, coins: 3 },
    { id: "reflection", label: "复盘", keywords: ["复盘", "总结", "结课报告", "评教"], care: "施肥", growth: 8, coins: 4 }
  ]
};

const GENERAL_ACTIVITY = {
  id: "progress",
  label: "日常推进",
  care: "阳光",
  growth: 4,
  coins: 2
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

export function recordActivity(plant, text, forcedActivityId = null) {
  if (plant.status !== "active") return { plant, activity: null, reward: null };
  const rawText = text.trim();
  if (!rawText) return { plant, activity: null, reward: null };
  const rule = classifyActivity(plant.type, rawText, forcedActivityId);
  const at = new Date().toISOString();
  const incrementsSession = plant.type === "course" && rule.id === "teaching";
  const updatedMetadata = incrementsSession
    ? { ...plant.metadata, sessions: plant.metadata.sessions + 1 }
    : plant.metadata;
  const reward = { growth: rule.growth, coins: rule.coins };
  return {
    plant: {
      ...plant,
      metadata: updatedMetadata,
      growth: plant.growth + reward.growth
    },
    activity: {
      id: createId(),
      plantId: plant.id,
      rawText,
      activityType: rule.id,
      activityLabel: rule.label,
      care: rule.care,
      growth: reward.growth,
      coins: reward.coins,
      classifiedBy: forcedActivityId ? "shortcut" : "local_rules",
      at
    },
    reward
  };
}
