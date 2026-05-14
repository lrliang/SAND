# Story 4.0: 完善 Orchestrate 阶段理论基础

Status: done

## Story

As a SAND 框架开发者,
I want Orchestrate 阶段的理论文档完整且可操作化,
so that 后续 Story 4-1（sand-design-orchestration Skill 实现）的 `data/topology-rules.yaml`、`templates/orchestration-plan.yaml` 和 step 文件有坚实、可溯源的理论依据，且理论与操作化数据零偏差。

## Acceptance Criteria

1. **拓扑模式理论完整** — `topology-patterns.md` 包含 4 种标准拓扑（Solo/Pipeline/Swarm/Hierarchy）的完整定义，每种含适用条件、权衡分析、不确定性×规模选型矩阵，可直接映射为 Story 4-1 中 `data/topology-rules.yaml` 的规则条目
2. **HIP 机制定义完整** — `human-intervention.md` 包含 HIP-1/2/3 三级模型的完整定义（含义、适用场景、决策链），动态调整机制（信任度积累降级、异常信号升级、新领域回到 HIP-2 以上），可直接映射为 Story 4-1 中 `steps/step-03-hip.md` 的配置逻辑
3. **上下文工程与 FR32 一致** — `context-engineering.md` 包含上下文四层次（项目/意图/历史/协作）、上下文质量评估模型（完整性/准确性/精简性/可发现性）、上下文金字塔、上下文最小化原则，与 FR32 上下文安全要求一致
4. **Agent 选型框架完整** — `agent-selection.md` 包含基于任务确定性和规模的选型决策树、Agent 能力卡标准（capability_domain, model_requirement, context_window_need, known_limitations, cost_profile, reliability），可直接映射为 Story 4-1 中 `steps/step-01-context.md` 和 `steps/step-02-topology.md` 的选型逻辑
5. **失败模式分类完整** — `failure-modes.md` 包含 5 种 AI 失败模式（幻觉生成、上下文遗失、偏见放大、能力越界、级联失败）的完整分类，每种含检测方式和缓解策略，可直接映射为 Story 4-1 编排方案中的 `failure_mode_plan` 部分
6. **理论与操作化数据一致性** — 所有文档的关键概念（拓扑选型矩阵、HIP 级别定义、上下文层次、能力卡字段、失败模式枚举）可直接映射为 Story 4-1 中的 step 文件和 data/templates YAML
7. **与已有 Schema/模板对齐** — 理论定义与 `schemas/orchestration-plan.schema.json` 的 topology enum、human_oversight enum、skill_chain 结构一致；与 `templates/orchestration-plan.yaml` 和 `docs/09-templates/orchestration-plan.yaml` 扩展模板的 O1-O5 结构对齐

## Tasks / Subtasks

- [x] Task 1: 完善 `docs/02-development-cycle/orchestrate/topology-patterns.md` (AC: #1, #6, #7)
  - [x] 1.1 定义 4 种标准拓扑的完整语义说明（Solo/Pipeline/Swarm/Hierarchy）——每种含定义、适用场景、优势、劣势、典型用例
  - [x] 1.2 构建不确定性×规模选型矩阵（对应 Architecture §编排拓扑选型 的规则表）
  - [x] 1.3 为每种拓扑定义与意图类型（Feature/Fix/Refactor/Exploration/Optimization）的推荐关联
  - [x] 1.4 撰写拓扑间升级/降级规则（运行时发现拓扑不适配时的调整策略）
  - [x] 1.5 撰写拓扑选型决策流程图（文字描述，便于 Story 4-1 操作化）
  - [x] 1.6 确保 4 种拓扑 enum 与 `schemas/orchestration-plan.schema.json` 的 topology enum 一致（solo/pipeline/swarm/hierarchy）
- [x] Task 2: 完善 `docs/02-development-cycle/orchestrate/human-intervention.md` (AC: #2, #6, #7)
  - [x] 2.1 定义 HIP-1/2/3 三级模型完整语义（HIP-1=异步知晓/全自主, HIP-2=同步审查/关键决策, HIP-3=人类主导/全程监督）
  - [x] 2.2 撰写 HIP 级别决策链：角色推荐值 → `.sand/config.yaml` 默认值 → 用户会话临时覆盖 → 最终值
  - [x] 2.3 撰写动态调整机制（信任度积累降级、异常信号升级、新领域回到 HIP-2+）
  - [x] 2.4 定义每 HIP 级别下的审查要求（什么内容需人类确认、响应时限、升级路径）
  - [x] 2.5 撰写与意图类型的 HIP 推荐关联表（从 intent-taxonomy.md §5 类型拉取）
  - [x] 2.6 确保 HIP enum 与 `schemas/orchestration-plan.schema.json` 的 human_oversight enum 一致（hip-1/hip-2/hip-3）
  - [x] 2.7 确保 HIP 方向一致：HIP-1=最低介入（全自主）, HIP-3=最高介入（全程监督）——与 PRD FR17 和 Story 2-0 Review Finding 统一
- [x] Task 3: 完善 `docs/02-development-cycle/orchestrate/context-engineering.md` (AC: #3, #6)
  - [x] 3.1 定义上下文四层次（项目上下文/意图上下文/历史上下文/协作上下文）的完整语义
  - [x] 3.2 撰写上下文金字塔模型（层次关系、信息传递方向）
  - [x] 3.3 撰写上下文质量评估模型（完整性/准确性/精简性/可发现性——对应扩展模板 `context_quality_check`）
  - [x] 3.4 撰写上下文最小化原则（与 FR32/FR33 对齐——默认不发送完整代码文件、脱敏规则）
  - [x] 3.5 定义上下文资产组织形态（与 `.sand/` 目录结构关联）
  - [x] 3.6 撰写上下文安全边界（从 Architecture §上下文安全 和 PRD FR32-FR33 提取）
- [x] Task 4: 完善 `docs/02-development-cycle/orchestrate/agent-selection.md` (AC: #4, #6)
  - [x] 4.1 定义基于任务确定性和规模的选型决策树
  - [x] 4.2 定义 Agent 能力卡标准字段（capability_domain, model_requirement, context_window_need, known_limitations, cost_profile, reliability）
  - [x] 4.3 撰写 SAND 三角色（问题域负责人/FDE+/变革催化师）的默认能力卡
  - [x] 4.4 撰写能力卡与拓扑模式的匹配逻辑（什么能力组合适合什么拓扑）
  - [x] 4.5 撰写外部 Agent 引入评估标准（为 Story 4-3 插件机制奠基）
  - [x] 4.6 对齐扩展模板 `agent_selection` 结构（agent_id, role_in_workflow, capability_card_ref）
- [x] Task 5: 完善 `docs/02-development-cycle/orchestrate/failure-modes.md` (AC: #5, #6)
  - [x] 5.1 定义 5 种 AI 失败模式完整语义（幻觉生成/上下文遗失/偏见放大/能力越界/级联失败）
  - [x] 5.2 每种失败模式含：定义、检测信号、缓解策略、影响评级
  - [x] 5.3 撰写失败模式与拓扑模式的关联矩阵（哪种拓扑更容易触发哪种失败）
  - [x] 5.4 撰写编排层的防御机制设计原则（早期检测、快速失败、优雅降级）
  - [x] 5.5 对齐扩展模板 `failure_mode_plan` 结构（failure_mode, detection_method, mitigation_strategy）
  - [x] 5.6 关联到 Validate 阶段——失败模式是三通道验证的设计理据之一
- [x] Task 6: 交叉验证一致性 (AC: #6, #7)
  - [x] 6.1 验证拓扑 enum（solo/pipeline/swarm/hierarchy）与 `schemas/orchestration-plan.schema.json` 一致
  - [x] 6.2 验证 HIP enum（hip-1/hip-2/hip-3）与 Schema 和 PRD FR17 一致
  - [x] 6.3 验证上下文安全要求与 PRD FR32-FR33 一致
  - [x] 6.4 验证能力卡字段与 Architecture §Agent Capability Card 一致
  - [x] 6.5 验证失败模式枚举与 `docs/09-templates/orchestration-plan.yaml` 的 failure_mode 注释一致
  - [x] 6.6 验证 5 个子过程（O1-O5）的理论定义与 `docs/02-development-cycle/orchestrate/README.md` 的概述一致
  - [x] 6.7 验证所有学术引用来自已验证来源清单（不可捏造）

### Review Findings

- [x] [Review][Decision] D1: `default_hip` vs `human_oversight` 能力卡字段歧义 — 选项 A：合并为 `default_hip`，移除 `human_oversight` 字段 [agent-selection.md] ✅ fixed
- [x] [Review][Decision] D2: 拓扑选型决策流程图未考虑不确定性维度 — 选项 A：在 Solo 推荐前增加不确定性评估步骤 + 矩阵复核步骤 [topology-patterns.md] ✅ fixed
- [x] [Review][Patch] F1: Karpathy 引用缺少 [待验证] 标记 — 添加 [待验证] 标记 [context-engineering.md:13] ✅ fixed
- [x] [Review][Patch] F2: CodeRabbit/Sherlock 引用缺少 [待验证] 标记 — 添加 [待验证] 标记 [failure-modes.md:17] ✅ fixed
- [x] [Review][Patch] F3: SASE 框架归属年份模糊 — 改为 "Hassan et al. (2026) 'Towards AI-Native SE (SE 3.0)'" [agent-selection.md:20] ✅ fixed
- [x] [Review][Patch] F4: "硬性约束" 措辞过强 — 改为"重要的经验性阈值（Google DeepMind 研究）" [agent-selection.md:202] ✅ fixed
- [x] [Review][Patch] F5: 失败模式枚举值未在章节标题中显式标注 — 在 5 个章节标题后追加 enum 值 [failure-modes.md] ✅ fixed
- [x] [Review][Patch] F6: 外部 Agent 风险评估引用 `requires` 字段未说明来源 — 改为"SKILL.md frontmatter 的 `requires` 字段" [agent-selection.md:184] ✅ fixed
- [x] [Review][Patch] F7: 上下文金字塔 Layer 2/3 排序原则混淆 — 澄清排序依据为"对当前任务的精确度"而非绝对寿命 [context-engineering.md] ✅ fixed
- [x] [Review][Patch] F8: HIP 覆盖链缺少向下覆盖保护 — 添加覆盖链保护规则：降级需显式人类确认 [human-intervention.md] ✅ fixed
- [x] [Review][Defer] W1: Schema (additionalProperties:false) 与扩展模板 O1-O5 结构不兼容 — 预先存在的设计差异，不在本 Story 范围
- [x] [Review][Defer] W2: context_quality_check 理论 4 维 vs 模板 3 字段（缺 discoverability） — 已记录，待 Story 4-1 模板更新
- [x] [Review][Defer] W3: 扩展模板 parent_intent (SAND-YYYY-NNNN) vs Schema intent_id (INT-YYYYMMDD-{seq}) 格式不兼容 — 预先存在
- [x] [Review][Defer] W4: Swarm/Hierarchy 最少 Agent 数量未定义（1 Agent Swarm 退化为 Pipeline） — Story 4-1 实现细节
- [x] [Review][Defer] W5: HIP 信任降级阈值 N 未量化 — 运行时配置参数，Story 4-1 操作化
- [x] [Review][Defer] W6: Domain-Reset 的"领域"定义未明确 — 运行时操作化定义
- [x] [Review][Defer] W7: FR 可追溯性跨 5 个文档不一致（部分文档引用 FR 编号，部分未引用） — 非阻塞一致性议题

## Dev Notes

### Story 本质

这是一个**纯文档撰写** Story——不涉及代码、Schema 或 Skill 文件。产出为 5 个 Markdown 文档（Orchestrate 阶段理论基础），目标是让后续 Story 4-1（sand-design-orchestration Skill 实现）有足够的理论基础来生成操作化数据文件（`data/topology-rules.yaml`）和步骤文件（`steps/step-01-context.md` 到 `step-04-plan.md`）。

### 当前文档状态

所有 5 个目标文件均为 STUB（标题 + 一句概念描述 + TODO 注释）：

| 文件 | 当前行数 | 目标 | 映射到 Story 4-1 |
|------|---------|------|-------------------|
| `docs/02-development-cycle/orchestrate/topology-patterns.md` | ~5 | 完善至 200-250 行 | `data/topology-rules.yaml` + `steps/step-02-topology.md` |
| `docs/02-development-cycle/orchestrate/human-intervention.md` | ~5 | 完善至 150-200 行 | `steps/step-03-hip.md` |
| `docs/02-development-cycle/orchestrate/context-engineering.md` | ~5 | 完善至 150-200 行 | `steps/step-01-context.md` |
| `docs/02-development-cycle/orchestrate/agent-selection.md` | ~5 | 完善至 150-200 行 | `steps/step-01-context.md` + `steps/step-02-topology.md` |
| `docs/02-development-cycle/orchestrate/failure-modes.md` | ~5 | 完善至 150-200 行 | `steps/step-04-plan.md` failure_mode_plan 部分 |

**README.md 已完成，无需修改。**

### STUB 文件精确内容

**topology-patterns.md:**
```
# Agent拓扑模式
4种标准拓扑：Solo（独奏）、Pipeline（流水线）、Swarm（蜂群）、Hierarchy（层级）。拓扑选择决策矩阵（不确定性×规模）。
<!-- TODO: 待撰写 -->
```

**agent-selection.md:**
```
# Agent选型决策框架
基于任务确定性和规模的选型决策树。Agent能力卡标准（capability_domain, model_requirement, context_window_need, known_limitations, cost_profile, reliability）。
<!-- TODO: 待撰写 -->
```

**human-intervention.md:**
```
# 三级人类介入模型
HIP-1异步知晓、HIP-2同步审查、HIP-3人类主导。动态调整机制：信任度积累可降级、异常信号可升级、新领域回到HIP-2以上。
<!-- TODO: 待撰写 -->
```

**context-engineering.md:**
```
# 上下文工程
上下文四层次（项目/意图/历史/协作）、上下文质量评估模型（完整性/准确性/精简性/可发现性）、上下文金字塔、上下文资产组织形态。
<!-- TODO: 待撰写 -->
```

**failure-modes.md:**
```
# AI失败模式分类学
5种失败模式：幻觉生成、上下文遗失、偏见放大、能力越界、级联失败。每种含检测方式和缓解策略。
<!-- TODO: 待撰写 -->
```

### 前序 Story 模式（从 Story 1-0、2-0、3-0 提取）

**文档编写规范：**
- 保留 STUB 原始标题和概念句，在其下方扩展内容
- 每个文档 150-250 行（中文叙述 + 技术术语英文原形）
- 使用结构化表格便于后续 YAML 操作化提取
- 每个主要章节末尾添加"对 SAND 的实践意义"段落
- 所有学术引用必须来自已验证来源清单（见下方）
- 交叉引用使用相对路径（如 `../../01-foundations/non-deterministic-paradigm.md`）

**已验证学术来源清单（本 Story 可用）：**

| 来源 | 核心论点 | 应用于 |
|------|---------|--------|
| Hassan et al. (2026) "Towards AI-Native SE (SE 3.0)" — ACM TOSEM | SE 3.0 演进路径，SASE 框架 ACE/AEE 双工作台，自主级别 Level 1-5 | agent-selection.md — Agent 自主级别与 HIP 对标 |
| Fowler et al. (2024-2026) | 非确定性范式、constraint engineering 双控制分类、人类审查不可缺失 | human-intervention.md — HIP 必要性的理论基础 |
| Debois (2025) Context Development Lifecycle (CDLC) | 上下文管道：Generate → Evaluate → Distribute → Observe | context-engineering.md — O1 上下文工程子过程的行业参考 |
| Multi-Agent 编排实证研究（arXiv 2601.13671, 2502.14743, 2501.06322） | Multi-Agent 事件响应 100% 可操作 vs 单 Agent 1.7%；协调税（4 Agent 饱和点） | topology-patterns.md — 拓扑选择的实证基础 |
| McKinsey (2025) "State of AI" | 65% AI 高绩效组织定义了 Human-in-the-Loop 流程 vs 23% 其他 | human-intervention.md — HIP 的市场验证 |
| Google DeepMind Agent Archetypes | 10 种 Agent 原型（Orchestrator, Planner, Executor 等）；协调税概念 | agent-selection.md — Agent 角色分类参考 |
| Mikkonen & Taivalsaari (2025) "Software Reuse in the Generative AI Era" | 生成式复用 = cargo cult 开发，AI 生成代码信任缺乏深度理解 | failure-modes.md — 幻觉生成和偏见放大的学术基础 |
| Beck, K. (2025) | Constraint engineering、augmented coding、"PR from dodgy collaborator" | failure-modes.md — AI 输出信任模型 |

**禁止行为：**
- 不得捏造学术引用（论文标题、作者、年份、期刊）
- 不得编造统计数据（如 "XX% 的团队..."）
- 如需引用未在验证清单中的来源，必须标注 "[待验证]"

### 关键架构约束

**sand-design-orchestration Skill 目录结构（Architecture 定义）：**
```
sand/skills/sand-design-orchestration/
├── SKILL.md
├── customize.toml
├── steps/
│   ├── step-01-context.md                   ← 收集意图范围与依赖信息
│   ├── step-02-topology.md                  ← 拓扑选型（规则 + 确认）
│   ├── step-03-hip.md                       ← HIP 级别配置
│   └── step-04-plan.md                      ← 输出编排方案
├── templates/
│   └── orchestration-plan.yaml
└── data/
    └── topology-rules.yaml                  ← Solo/Pipeline/Swarm/Hierarchy 选型规则
```

**编排方案输出路径（Schema 定义）：**
- `.sand/orchestration-plan.yaml` — 编排方案（从 `templates/orchestration-plan.yaml` 初始化）

**编排拓扑选型规则表（Architecture §编排拓扑选型）：**

| 意图特征 | 推荐拓扑 |
|---------|---------|
| 单一功能、无依赖 | Solo |
| 有顺序步骤（A → B → C） | Pipeline |
| 并行探索多个方案 | Swarm |
| 需要协调不同 Agent 类型 | Hierarchy |

MVP 用清晰规则表，不实现复杂推导引擎。用户最终确认或修改。

**HIP 级别决策链（Architecture 定义）：**
```
角色推荐值 → 被 .sand/config.yaml default_human_oversight 覆盖
           → 被用户本次会话临时覆盖
           → 最终值传递给执行引擎
```

**三角色 HIP 推荐值（Architecture 定义）：**

| 角色 | Skill 路径 | 推荐 HIP |
|------|-----------|---------|
| 问题域负责人 | sand-agent-domain-lead | HIP-2 |
| FDE+ | sand-agent-fde | HIP-2 |
| 变革催化师 | sand-agent-catalyst | HIP-3 |

**Schema 约束（schemas/orchestration-plan.schema.json）：**
- `plan_id`: string (required)
- `intent_id`: pattern `^INT-\d{8}-\d{3,}$` (required)
- `topology`: enum `["solo", "pipeline", "swarm", "hierarchy"]` (required)
- `human_oversight`: enum `["hip-1", "hip-2", "hip-3"]` (required)
- `skill_chain[].skill_name`: pattern `^sand-[a-z][a-z0-9-]*$`, `order`: integer >= 1
- `context_scope`: `include_files[]`, `exclude_patterns[]`
- `meta`: `created_at` (date-time), `topology_rationale` (string)
- `additionalProperties: false`

**扩展模板 O1-O5 结构（docs/09-templates/orchestration-plan.yaml）：**
```yaml
# O1: 上下文策略
context_strategy:
  project_context: []
  domain_context: []
  intent_context: []
  context_quality_check:
    completeness: ""
    accuracy: ""
    conciseness: ""

# O2: Agent 选型
agent_selection:
  - agent_id: ""
    role_in_workflow: ""
    capability_card_ref: ""

# O3: 拓扑设计
topology:
  pattern: solo
  rationale: ""
  agent_connections: []

# O4: 人类介入点
human_intervention_points:
  - point_id: "HIP-01"
    location: ""
    level: "HIP-2"
    reviewer: ""
    criteria: ""

# O5: 失败模式预案
failure_mode_plan:
  - failure_mode: ""
    detection_method: ""
    mitigation_strategy: ""
```

**每文档需对齐对应的 O 子过程：**
- `context-engineering.md` → O1: 上下文策略
- `agent-selection.md` → O2: Agent 选型
- `topology-patterns.md` → O3: 拓扑设计
- `human-intervention.md` → O4: 人类介入点
- `failure-modes.md` → O5: 失败模式预案

### 研究材料行号索引

**Multi-Agent 编排与拓扑模式：**
- `domain-ai-native-development-methodology-research-2026-05-11.md` §124-127 — 6 大框架概览
- `domain-ai-native-development-methodology-research-2026-05-11.md` §163-187 — SASE 框架 ACE/AEE 双工作台
- `domain-ai-native-development-methodology-research-2026-05-11.md` §249 — 拓扑对比表
- `technical-sand-tools-metrics-feasibility-research-2026-05-12.md` §176-188 — 四拓扑技术实现映射
- `technical-sand-tools-metrics-feasibility-research-2026-05-12.md` §246-265 — 6 种行业编排模式
- `technical-sand-tools-metrics-feasibility-research-2026-05-12.md` §266-279 — Google DeepMind 10 种 Agent 原型 + 协调税

**HIP 人类介入模型：**
- `domain-ai-native-development-methodology-research-2026-05-11.md` §184 — SASE 自主级别对标 HIP
- `domain-ai-native-development-methodology-research-2026-05-11.md` §202 — Fowler: 人类审查不可缺失
- `domain-ai-native-development-methodology-research-2026-05-11.md` §351 — McKinsey: 65% vs 23%
- `domain-ai-native-development-methodology-research-2026-05-11.md` §606 — Delegation Gap 研究
- `domain-foundations-deep-dive-2026-05-12.md` §218 — HAT 信任衰减研究 → HIP 设计

**上下文工程：**
- `domain-ai-native-development-methodology-research-2026-05-11.md` §119-122 — CDLC 框架
- `domain-ai-native-development-methodology-research-2026-05-11.md` §206-217 — 上下文工程时间线演进
- `technical-sand-tools-metrics-feasibility-research-2026-05-12.md` §853-875 — MECW 有效上下文窗口 + Lost in the Middle

**失败模式：**
- `domain-ai-native-development-methodology-research-2026-05-11.md` §83-84 — 加速鞭击效应（441% PR 审查时间增长）
- `domain-ai-native-development-methodology-research-2026-05-11.md` §372-375 — AI 代码治理实证数据
- `technical-sand-tools-metrics-feasibility-research-2026-05-12.md` §633-639 — AI 代码质量统计

**Agent 选型：**
- `technical-sand-tools-metrics-feasibility-research-2026-05-12.md` §159-221 — 6 框架 × 6 维度评估
- `technical-sand-tools-metrics-feasibility-research-2026-05-12.md` §499-519 — Agent Capability Card 标准设计
- `technical-sand-tools-metrics-feasibility-research-2026-05-12.md` §509 — human_oversight 映射

### PRD 功能需求对齐

**直接覆盖的 FR：**
- **FR15a-d:** 执行运行时——启动执行会话、按拓扑调用 Skill、输出链接、实时状态记录
- **FR16:** 引导式拓扑选型（Solo/Pipeline/Swarm/Hierarchy）
- **FR17:** HIP 级别配置（HIP-1/2/3）
- **FR18:** 外部 Skill 注册与自动发现
- **FR19:** Skill 骨架生成工具
- **FR20:** 外部 Skill 基础验证
- **FR21:** 编排方案中引入外部 Skill
- **FR22:** 输出编排方案到 `.sand/orchestration-plan.yaml`
- **FR32:** 上下文安全——默认不发送完整代码文件
- **FR33:** 数据脱敏规则

**本 Story 理论覆盖范围：** FR16-FR17 的理论基础（拓扑选型 + HIP）+ FR22 的输出格式理论 + FR32-FR33 的上下文安全理论。FR15a-d/FR18-FR21 的实现理论在 Story 4-1 到 4-3 中覆盖。

### 与前序 Story 的关系

**依赖关系：** Epic 1 完成（框架基础设施就绪）

**引用链（从已完善文档拉取）：**
- `topology-patterns.md` 引用 `../../01-foundations/non-deterministic-paradigm.md`（Story 1-0 已完善）中的不确定性概念
- `human-intervention.md` 引用 `../../01-foundations/cognitive-collaboration.md`（Story 2-0 已完善）中的认知协作理论和 HIP 方向定义
- `context-engineering.md` 引用 `../../01-foundations/non-deterministic-paradigm.md` 中的约束工程双控制分类
- `failure-modes.md` 引用 `../../01-foundations/generative-reuse-risk.md`（Story 3-0 已完善）中的 cargo cult 复用风险理论
- `agent-selection.md` 引用 `../../01-foundations/cognitive-collaboration.md` 中的 SE 3.0 SASE 框架

**HIP 方向关键约束（来自 Story 2-0 Review Finding）：**
- **HIP-1 = 最低介入/全自主** — 异步知晓即可
- **HIP-2 = 中度介入/关键决策审查** — 同步审查关键节点
- **HIP-3 = 最高介入/全程监督** — 人类主导全流程
- 此方向已在 PRD FR17、Story 2-0 Review、Architecture §HIP 中统一确认——**不可反转**

**与后续 Story 4-1 的关系：**
- 本 Story 产出的理论文档是 Story 4-1 实现 sand-design-orchestration Skill 的直接输入
- 拓扑选型矩阵 → `data/topology-rules.yaml` 的规则条目
- HIP 定义 → `steps/step-03-hip.md` 的配置逻辑
- 上下文模型 → `steps/step-01-context.md` 的收集逻辑
- Agent 选型 → `steps/step-01-context.md` + `steps/step-02-topology.md`
- 失败模式 → `steps/step-04-plan.md` 的 failure_mode_plan 生成

### Project Structure Notes

- 所有修改文件在 `docs/02-development-cycle/orchestrate/` 目录下
- 不创建新目录，仅扩展现有 5 个 STUB 文件
- 不修改 `docs/02-development-cycle/orchestrate/README.md`（已完成）
- 不修改 `schemas/` 或 `templates/`（Schema 和全局模板在 Story 1-1 已创建）
- 不修改 `docs/01-foundations/` 下的已完善文档（Story 1-0/2-0/3-0 产出）

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 4: sand-design-orchestration] — Story 定义和 BDD 验收标准（行 451-574）
- [Source: _bmad-output/planning-artifacts/architecture.md#Agent Roles & Orchestration Topology] — 编排拓扑选型规则、HIP 决策链、三角色推荐 HIP（行 412-441）
- [Source: _bmad-output/planning-artifacts/architecture.md#sand-design-orchestration] — Skill 目录结构定义（行 687-698）
- [Source: _bmad-output/planning-artifacts/architecture.md#Execution Runtime Model] — SandRuntime 模块架构（行 394-410）
- [Source: _bmad-output/planning-artifacts/prd.md#执行运行时 FR15a-d] — 执行会话功能需求（行 625-630）
- [Source: _bmad-output/planning-artifacts/prd.md#编排与插件生态 FR16-FR22] — 编排与插件功能需求（行 632-641）
- [Source: _bmad-output/planning-artifacts/prd.md#上下文安全 FR32-FR33] — 上下文安全需求（行 661-664）
- [Source: schemas/orchestration-plan.schema.json] — 编排方案 JSON Schema
- [Source: templates/orchestration-plan.yaml] — 编排方案基础模板
- [Source: docs/09-templates/orchestration-plan.yaml] — 编排方案扩展模板（O1-O5）
- [Source: docs/02-development-cycle/orchestrate/README.md] — Orchestrate 阶段概览
- [Source: _bmad-output/planning-artifacts/research/domain-ai-native-development-methodology-research-2026-05-11.md] — SASE、CDLC、Multi-Agent 编排研究
- [Source: _bmad-output/planning-artifacts/research/domain-foundations-deep-dive-2026-05-12.md] — HAT 信任研究、学术引用链
- [Source: _bmad-output/planning-artifacts/research/technical-sand-tools-metrics-feasibility-research-2026-05-12.md] — 框架评估、Agent 能力卡、MECW 有效上下文
- [Source: _bmad-output/implementation-artifacts/1-0-assess-theory-foundation.md] — Story 0 编写模式参照
- [Source: _bmad-output/implementation-artifacts/2-0-intent-theory-foundation.md] — Story 0 编写模式和 HIP 方向确认参照
- [Source: _bmad-output/implementation-artifacts/3-0-validate-theory-foundation.md] — Story 0 编写模式和交叉验证方法参照
- [Source: _bmad-output/implementation-artifacts/deferred-work.md] — 各 Story 遗留设计决策

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

N/A — documentation-only story, no runtime debugging required.

### Completion Notes List

- Task 1: Expanded `topology-patterns.md` from 5-line STUB to ~226 lines. Defined 4 standard topologies (Solo/Pipeline/Swarm/Hierarchy) with complete semantics (definition, use cases, advantages, disadvantages, typical examples). Built uncertainty×scale selection matrix aligned with Architecture §编排拓扑选型. Created intent type correlation table (5 types × topology recommendations). Documented upgrade/downgrade rules with trigger signals. Wrote decision flow pseudocode for Story 4-1 operationalization. Verified topology enum alignment with orchestration-plan.schema.json.
- Task 2: Expanded `human-intervention.md` from 5-line STUB to ~190 lines. Defined HIP-1/2/3 three-level model (HIP-1=asynchronous awareness/full autonomy, HIP-2=synchronous review, HIP-3=human-led). Direction confirmed: HIP-1=lowest intervention, HIP-3=highest. Documented 4-layer decision chain (role default → config → orchestration plan → session override). Defined 3 dynamic adjustment mechanisms (trust de-escalation, anomaly escalation, domain reset). Created review requirements matrix (6 dimensions × 3 HIP levels). Added intent type correlation table from intent-taxonomy.md.
- Task 3: Expanded `context-engineering.md` from 5-line STUB to ~225 lines. Defined 4 context levels (project/intent/historical/collaboration) with sources, lifecycles, security sensitivity. Built context pyramid model with bidirectional information flow. Created 4-dimension quality assessment model (completeness/accuracy/conciseness/discoverability) aligned with extended template `context_quality_check`. Documented minimization principles aligned with FR32-FR33 (default no full code files, synchronous redaction). Mapped context assets to `.sand/` directory structure. Documented MECW effective context window warnings.
- Task 4: Expanded `agent-selection.md` from 5-line STUB to ~212 lines. Built selection decision tree based on task certainty × scale. Defined 10-field Agent Capability Card standard (6 required fields from STUB + 4 additional). Created 3 default capability cards for SAND roles (Domain Lead, FDE+, Catalyst). Documented capability card to topology matching logic. Wrote external Agent admission criteria and risk classification for Story 4-3 foundation. Aligned with extended template `agent_selection` structure.
- Task 5: Expanded `failure-modes.md` from 5-line STUB to ~223 lines. Defined 5 AI failure modes (hallucination/context_loss/bias_amplification/capability_overflow/cascade_failure) with definition, detection signals, mitigation strategies, impact rating. Built failure mode × topology sensitivity matrix. Documented 3 defense design principles (early detection, fail fast, graceful degradation). Mapped failure modes to Validate stage three-channel verification. Aligned with extended template `failure_mode_plan` structure.
- Task 6: Full cross-validation passed all 7 items — topology enum alignment, HIP enum + direction alignment, FR32-FR33 alignment, capability card fields alignment, failure mode enum alignment, O1-O5 sub-process alignment, academic citation verification. One non-blocking note: context_quality_check theory defines 4 dimensions but template has 3 fields (missing discoverability) — deferred to Story 4-1 template update.

### Change Log

- 2026-05-14: Story implementation complete. 5 documents expanded from STUB, all 6 tasks done, cross-validation passed.
- 2026-05-14: Code review complete. 2 decision-needed + 8 patch findings resolved, 7 deferred. Fixes: merged capability card fields, added uncertainty to topology flow, added [待验证] to non-verified citations, clarified pyramid ordering, added HIP override protection, added failure mode enum values to headers, softened "hard constraint" wording, clarified SASE attribution, clarified `requires` source.

### File List

- docs/02-development-cycle/orchestrate/topology-patterns.md (MODIFIED — expanded from STUB, ~226 lines)
- docs/02-development-cycle/orchestrate/human-intervention.md (MODIFIED — expanded from STUB, ~190 lines)
- docs/02-development-cycle/orchestrate/context-engineering.md (MODIFIED — expanded from STUB, ~225 lines)
- docs/02-development-cycle/orchestrate/agent-selection.md (MODIFIED — expanded from STUB, ~212 lines)
- docs/02-development-cycle/orchestrate/failure-modes.md (MODIFIED — expanded from STUB, ~223 lines)
