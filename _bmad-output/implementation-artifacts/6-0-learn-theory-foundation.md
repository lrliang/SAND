# Story 6.0: 完善 Learn 阶段理论基础

Status: done

## Story

As a SAND 框架开发者,
I want Learn 阶段的理论文档完整且可操作化,
so that 后续 Story 6-1/6-2（sand-run-retrospective Skill 基础版与完整版）的 step 文件、`templates/retrospective.yaml` 和资产分类逻辑有坚实、可溯源的理论依据，且理论与操作化数据零偏差。

## Acceptance Criteria

1. **AI 复盘 5 议题完整定义** — `ai-retrospective.md` 已完善，5 个标准议题（意图质量回顾、编排有效性回顾、AI 杠杆分析、失败模式分析、资产化提名）有完整定义和引导脚本，可直接映射为 Story 6-1 中 `steps/step-01-collect.md` 的执行逻辑
2. **5 类 AI 资产分类可操作化** — `ai-asset-taxonomy.md` 已完善，5 类资产（上下文资产、意图模式、编排配方、验证规则、失败案例）有完整分类标准（定义 + 标准格式 + 来源阶段 + 消费阶段 + 示例），可直接映射为 Story 6-1 中 `steps/step-02-classify.md` 的分类逻辑
3. **资产化流程可执行** — `assetization-process.md` 已完善，4 步精炼流程（L2a 候选识别 → L2b 人工评审 → L2c 结构化 → L2d 注册入库）有明确的操作定义和判定标准，可直接映射为 Story 6-2 中 `steps/step-03-register.md` 的入库逻辑
4. **资产生命周期管理完整** — `asset-lifecycle.md` 已完善，衰减/刷新机制（置信度模型：使用+通过 +1，使用+不适用 -1，长期未用缓慢衰减）和版本化管理（创建来源、变更历史、使用记录、关联关系）有清晰定义
5. **飞轮加速度量可追踪** — `flywheel-metrics.md` 已完善，3 个核心指标（资产复用率 30%-70% 健康、意图首通率 >60% 合格 / 80%+ 成熟、循环周期压缩率 <1.0 表示加速）有计算方法、数据源和基准值定义，与 PRD FR40 对齐
6. **理论与操作化数据一致性** — 所有文档的关键概念（5 议题、5 类资产、4 步流程、3 个指标）可直接映射为 Story 6-1/6-2 中的 step 文件和 `templates/retrospective.yaml`
7. **与 Learn README 索引一致** — 5 个文档的核心概念与 `docs/02-development-cycle/learn/README.md` 已定义的 5 类资产表和飞轮机制描述一致

## Tasks / Subtasks

- [x] Task 1: 完善 `docs/02-development-cycle/learn/ai-retrospective.md` (AC: #1, #6)
  - [x] 1.1 定义 AI 复盘与传统复盘的根本区别——AI 复盘聚焦人-AI 协作系统效能（不是个人绩效），从 STUB 中"core concept"扩展
  - [x] 1.2 定义 5 个标准议题的完整结构：每个议题含目标（why）、引导问题模板（3-5 个结构化问题）、期望产出（标准化输出格式）、对应的 AI 资产类型（映射到 ai-asset-taxonomy.md）
  - [x] 1.3 议题 1「意图质量回顾」：复盘意图声明质量——CLEAR 通过率、首通率趋势、常见返修原因分类
  - [x] 1.4 议题 2「编排有效性回顾」：复盘拓扑选型准确性——选型偏差率、HIP 覆盖充分性、Skill 链执行中断率
  - [x] 1.5 议题 3「AI 杠杆分析」：复盘 AI 参与度与产出质量的关系——AI 生成代码占比、AI 主动边界识别频率、人工覆盖率
  - [x] 1.6 议题 4「失败模式分析」：从 `.sand/audits/audit.jsonl` 中 status=failure/interrupted 事件提取失败模式分类——重复失败模式、新增失败模式、已缓解的失败模式
  - [x] 1.7 议题 5「资产化提名」：基于前 4 个议题提名可资产化的候选——每个候选标注资产类型、来源 Intent ID、预期复用频率
  - [x] 1.8 定义复盘频率建议——每个 SDC 循环末尾（微循环）、每 Sprint 末尾（宏循环）、里程碑后（深度复盘）
  - [x] 1.9 定义复盘输出格式——结构化日志模板（`.sand/retrospectives/{date}_retro.md`），与 Architecture .sand/ 目录结构对齐
- [x] Task 2: 完善 `docs/02-development-cycle/learn/ai-asset-taxonomy.md` (AC: #2, #6, #7)
  - [x] 2.1 定义 AI 资产的形式化定义——区分"AI 资产"与"文档/代码/配置"的本质差异：AI 资产是可机器消费的、经验证的、有版本的知识结晶
  - [x] 2.2 类型 1「上下文资产」：定义 + 标准格式（YAML 结构）+ 来源阶段（全循环）+ 消费阶段（Orchestrate）+ 示例（团队技术栈描述、项目架构摘要、领域术语表）
  - [x] 2.3 类型 2「意图模式」：定义 + 标准格式 + 来源阶段（Intent + Validate）+ 消费阶段（Intent）+ 示例（高通过率意图声明模板、常见约束集、验收标准模式）
  - [x] 2.4 类型 3「编排配方」：定义 + 标准格式 + 来源阶段（Orchestrate + Build）+ 消费阶段（Orchestrate）+ 示例（特定任务类型的最优拓扑、HIP 配置模板、Skill 链组合）
  - [x] 2.5 类型 4「验证规则」：定义 + 标准格式 + 来源阶段（Validate）+ 消费阶段（Validate）+ 示例（领域特定安全检查项、架构约束检查项、常见偏差修复模式）
  - [x] 2.6 类型 5「失败案例」：定义 + 标准格式 + 来源阶段（全循环）+ 消费阶段（Orchestrate）+ 示例（已知失败模式 + 根因 + 预防策略）
  - [x] 2.7 与 README 的 5 类资产表交叉验证——确保名称、来源阶段、消费阶段完全一致
- [x] Task 3: 完善 `docs/02-development-cycle/learn/assetization-process.md` (AC: #3, #6)
  - [x] 3.1 定义资产化流程的设计原则——为什么是 4 步而非直接入库（质量门控、人类判断不可省略——引用 Mikkonen 生成式复用风险理论）
  - [x] 3.2 步骤 L2a「候选识别」：AI 自动扫描复盘日志和执行数据，识别可资产化候选——扫描维度（重复出现的模式、高效率片段、失败模式）、输出候选清单格式
  - [x] 3.3 步骤 L2b「人工评审」：人类审查 AI 识别的候选——评审标准（准确性、通用性、时效性）、评审决策（接受/拒绝/修改后接受）、不可省略性论证
  - [x] 3.4 步骤 L2c「结构化」：将接受的候选转化为标准格式资产——标准元数据字段（asset_id、asset_type、source_intent、confidence、tags、created_at、expires_at）、内容格式化规范
  - [x] 3.5 步骤 L2d「注册入库」：将结构化资产注册到资产库——版本化策略（SemVer）、过期审查周期、关联关系建立
  - [x] 3.6 定义资产化流程与 SDC 其他阶段的触发关系——何时触发（Learn 阶段末尾）、由谁触发（sand-run-retrospective Skill）、输出到哪里（`.sand/` 资产目录）
- [x] Task 4: 完善 `docs/02-development-cycle/learn/asset-lifecycle.md` (AC: #4, #6)
  - [x] 4.1 定义资产生命周期状态机——Candidate → Active → Deprecated → Archived，状态转换条件和触发者
  - [x] 4.2 定义置信度模型——初始置信度（创建时基于来源质量评分）、使用反馈机制（使用+通过 → +1，使用+不适用 → -1，长期未用 → 缓慢衰减）、置信度阈值（低于阈值触发审查）
  - [x] 4.3 定义衰减/刷新机制——时间衰减曲线（资产类型不同衰减速度不同）、主动刷新触发条件（技术栈变更、框架升级、新失败模式发现）
  - [x] 4.4 定义版本化管理——创建来源追踪（source_intent_id、source_retro_date）、变更历史（修改原因、修改者、diff 摘要）、使用记录（引用次数、最近引用时间、引用结果）、关联关系（依赖的其他资产、被依赖的资产）
  - [x] 4.5 定义资产质量评估框架——准确性（验证通过率）、时效性（最近更新时间 vs 领域变化速度）、通用性（跨项目/跨团队适用度）、可发现性（元数据和标签完整度）
- [x] Task 5: 完善 `docs/02-development-cycle/learn/flywheel-metrics.md` (AC: #5, #6)
  - [x] 5.1 定义飞轮效应在 SAND 中的具体含义——Learn 产出 → Assess 降低评估成本 + Orchestrate 提高编排效率 → 更快的循环 → 更多的 Learn 产出
  - [x] 5.2 指标 1「资产复用率」：计算方法（复用已有 AI 资产的意图数 ÷ 总意图数）、数据源（`.sand/intents/` 引用追踪）、基准值（30%-70% 健康，<30% 资产库不够丰富，>70% 可能过度复用）、MVP 采集方式
  - [x] 5.3 指标 2「意图首通率」：计算方法（Intent Created → Validated 无回退的比率）、数据源（意图状态机记录）、基准值（新用户 3 天后 ≥60%，成熟团队 80%+）、与 PRD 成功指标对齐
  - [x] 5.4 指标 3「循环周期压缩率」：计算方法（本轮 SDC 周期时长 ÷ 前轮周期时长）、数据源（SDC 循环起止时间戳）、基准值（持续 <1.0 表示加速）、与 sand-measure-light 关系
  - [x] 5.5 定义飞轮健康度综合判断——三指标同步改善才是真正的飞轮加速、单指标改善但其他退化需预警、飞轮停滞的诊断路径
  - [x] 5.6 定义 MVP 度量实现策略——Phase 2 基础版仅记录数据（fly-by-wire）、Phase 3 完整版自动计算和趋势分析、Phase 4 可视化和预警
- [x] Task 6: 交叉验证一致性 (AC: #6, #7)
  - [x] 6.1 验证 5 类资产名称和来源/消费阶段与 README.md 资产表完全一致
  - [x] 6.2 验证复盘议题→资产类型的映射关系闭合（每类资产至少有一个议题可产出该类型候选）
  - [x] 6.3 验证飞轮指标与 PRD FR40（资产复用率、意图首通率、循环周期压缩率）一致
  - [x] 6.4 验证资产化流程 L2b 人工评审步骤与 Mikkonen "人类审查不可削减" 理论对齐（引用 `docs/01-foundations/generative-reuse-risk.md`）
  - [x] 6.5 验证复盘输出路径与 Architecture .sand/ 目录结构对齐（`.sand/retrospectives/{date}_retro.md`）
  - [x] 6.6 验证所有学术引用来自已验证来源清单（不可捏造）

### Review Findings

- [x] [Review][Decision] D1: 上下文资产消费阶段不一致 — 选项 1：保持 Orchestrate only，飞轮图修改为"Orchestrate 提高编排效率（上下文资产 + 编排配方 + 失败案例减少试错）"，移除 Assess 行 [flywheel-metrics.md] ✅ fixed
- [x] [Review][Decision] D2: .sand/assets/ 目录不在架构定义中 — 选项 1：移除 .sand/assets/ 引用，改为"Git 仓库中的资产目录，Phase 3 实现时定义具体路径" [assetization-process.md] ✅ fixed
- [x] [Review][Decision] D3: 失败案例消费阶段限于 Orchestrate — 选项 1：保持 Orchestrate only，prevention_strategy 为跨阶段参考内容，主消费阶段不变 — 无需修改
- [x] [Review][Patch] P1: 初始置信度范围不一致 — assetization-process.md 对齐到 asset-lifecycle.md 权威定义（0.5-0.7, 0.7-0.9）[assetization-process.md] ✅ fixed
- [x] [Review][Patch] P2: 状态机图标签"置信度归零"→"置信度低于阈值"，状态表 Active 退出条件同步修改 [asset-lifecycle.md] ✅ fixed
- [x] [Review][Patch] P3: 负调整添加"（下限 0.0）"标注，长期未用改为"按类型衰减（见下方衰减表）" [asset-lifecycle.md] ✅ fixed
- [x] [Review][Patch] P4: 意图首通率定义统一为"Draft → Validated" [flywheel-metrics.md] ✅ fixed
- [x] [Review][Patch] P5: 微循环复盘产出改为"结构化日志（议题 1-4 数据摘要 + 发现，不含议题 5 资产候选）" [ai-retrospective.md] ✅ fixed
- [x] [Review][Patch] P6: STUB 保留句更新为"+0.05/-0.10"并添加"置信度范围 0.0-1.0，低于 0.4 触发审查" [asset-lifecycle.md:3] ✅ fixed
- [x] [Review][Patch] P7: 通用衰减率改为"按类型衰减（见下方衰减表）"，与 per-type 表对齐 [asset-lifecycle.md] ✅ fixed
- [x] [Review][Patch] P8: _bmad-output 内部路径替换为 ai-native-definition.md 引用 [flywheel-metrics.md] ✅ fixed
- [x] [Review][Patch] P9: 新增 ai-native-definition.md 交叉引用到引用来源节 [flywheel-metrics.md] ✅ fixed
- [x] [Review][Defer] W1: source_topic 枚举不完整——仅展示 intent_quality 值，其余 4 个议题的映射值未定义 — Skill 实现时定义完整枚举
- [x] [Review][Defer] W2: Phase 2/3 边界条件——L2b-L2d 的触发机制未明确定义 — Phase 3 Story 6-2 范围
- [x] [Review][Defer] W3: learning_signal 字段可选性导致数据饥饿风险——deviation-tracking.md 定义为 nullable — Deferred Work D5 已追踪
- [x] [Review][Defer] W4: 飞轮指标采集依赖团队主动在意图中引用资产——无强制机制 — Skill 运行时实现增强
- [x] [Review][Defer] W5: 重复失败模式检测需要历史资产存在——冷启动场景 — MVP 首轮循环预期为空
- [x] [Review][Defer] W6: 资产过期审查触发频率和流程未定义——谁触发、多久触发一次 — 运行时实现细节
- [x] [Review][Defer] W7: asset_type 编程值（如 intent_pattern）未在总览表中展示 — Skill 实现时定义完整映射表

## Dev Notes

### Story 本质

这是一个**纯文档撰写** Story——不涉及代码、Schema 或 Skill 文件。产出为 5 个 Markdown 文档（Learn 阶段 5 个 STUB 文档完善），目标是让后续 Story 6-1（sand-run-retrospective 基础版）和 Story 6-2（完整版）有足够的理论基础来生成步骤文件（`steps/step-01-collect.md`、`steps/step-02-classify.md`、`steps/step-03-register.md`）和模板（`templates/retrospective.yaml`）。

### 当前文档状态

| 文件 | 当前行数 | 状态 | 目标 | 映射到 Story 6-1/6-2 |
|------|---------|------|------|----------------------|
| `docs/02-development-cycle/learn/ai-retrospective.md` | 5 | STUB（标题 + 一行概念 + TODO） | 150-200 行 | `steps/step-01-collect.md`（5 议题引导） |
| `docs/02-development-cycle/learn/ai-asset-taxonomy.md` | 6 | STUB（标题 + 一行概念 + TODO） | 150-200 行 | `steps/step-02-classify.md`（5 类资产分类） |
| `docs/02-development-cycle/learn/assetization-process.md` | 5 | STUB（标题 + 一行概念 + TODO） | 150-200 行 | `steps/step-03-register.md`（资产入库建议） |
| `docs/02-development-cycle/learn/asset-lifecycle.md` | 5 | STUB（标题 + 一行概念 + TODO） | 150-200 行 | 资产管理运行时逻辑 |
| `docs/02-development-cycle/learn/flywheel-metrics.md` | 5 | STUB（标题 + 一行概念 + TODO） | 150-200 行 | 飞轮度量输出 + sand-measure-light 协同 |

**README.md（28 行）已完成，无需修改。** 5 类资产框架和飞轮核心机制已定义。

### STUB 文件精确内容

**ai-retrospective.md:**
```
# AI复盘标准议程
5议题（意图质量回顾、编排有效性回顾、AI杠杆分析、失败模式分析、资产化提名）。复盘聚焦人-AI协作系统效能，而非个人绩效。
<!-- TODO: 待撰写 -->
```

**ai-asset-taxonomy.md:**
```
# AI资产分类学
5类资产（上下文资产、意图模式、编排配方、验证规则、失败案例），每类定义标准格式、来源阶段、消费阶段。
<!-- TODO: 待撰写 -->
```

**assetization-process.md:**
```
# 资产化流程
4步精炼流程：L2a候选识别（AI自动扫描）→ L2b人工评审 → L2c结构化（标准格式+元数据） → L2d注册入库（版本化+过期审查周期）。
<!-- TODO: 待撰写 -->
```

**asset-lifecycle.md:**
```
# 资产质量与生命周期
衰减/刷新机制的置信度模型（使用+通过 +1，使用+不适用 -1，长期未用缓慢衰减），版本化管理（创建来源、变更历史、使用记录、关联关系）。
<!-- TODO: 待撰写 -->
```

**flywheel-metrics.md:**
```
# 飞轮加速度量
3个核心指标：资产复用率（30-70%健康）、意图首通率（>60%合格/成熟80%+）、循环压缩率（<1.0表示加速）。真正的飞轮加速需要三指标同步改善。
<!-- TODO: 待撰写 -->
```

### 前序 Story 模式（从 Story 1-0 至 5-0 提取）

**文档编写规范：**
- 保留 STUB 原始标题和概念句，在其下方扩展内容
- 每个文档 150-200 行（中文叙述 + 技术术语英文原形）
- 使用结构化表格便于后续 YAML 操作化提取
- 每个主要章节末尾添加"对 SAND 的实践意义"段落
- 所有学术引用必须来自已验证来源清单（见下方）
- 交叉引用使用相对路径（如 `../../01-foundations/generative-reuse-risk.md`）

**已验证学术来源清单（本 Story 可用）：**

| 来源 | 核心论点 | 应用于 |
|------|---------|--------|
| Mikkonen & Taivalsaari (2025) "Software Reuse in the Generative AI Era" — Internetware '25 | 生成式复用 = cargo cult 开发，人类审查不可削减 | assetization-process.md — L2b 人工评审不可省略的理论依据 |
| Hassan et al. (2026) "Towards AI-Native SE (SE 3.0)" — ACM TOSEM | SE 3.0 演进路径、SASE 框架、自主级别 | ai-retrospective.md — AI 复盘聚焦系统效能的理论基础 |
| Fowler et al. (2024-2026) | 非确定性范式、constraint engineering | asset-lifecycle.md — 资产衰减机制的非确定性基础 |

**禁止行为：**
- 不得捏造学术引用（论文标题、作者、年份、期刊）
- 不得编造统计数据
- 如需引用未在验证清单中的来源，必须标注 "[待验证]"

### 关键架构约束

**sand-run-retrospective Skill 目录结构（Architecture 定义）：**
```
sand/skills/sand-run-retrospective/
├── SKILL.md
├── customize.toml
├── steps/
│   ├── step-01-collect.md      ← 5 议题结构化回顾
│   ├── step-02-classify.md     ← 5 类 AI 资产分类
│   └── step-03-register.md     ← 资产入库建议
└── templates/
    └── retrospective.yaml
```

**复盘输出位置（Architecture .sand/ 目录结构）：**
```
.sand/retrospectives/
    └── {date}_retro.md         ← 结构化复盘日志
```

**与其他 Skill 的数据流关系：**
```
[Build] → .sand/executions/     ← 失败模式分析数据源
[Validate] → .sand/executions/EXE-*/deviations.json  ← 偏差数据
[Audit] → .sand/audits/audit.jsonl  ← 审计事件（含 status=failure/interrupted）
[Intent] → .sand/intents/      ← 意图质量回顾数据源
[Learn] → .sand/retrospectives/{date}_retro.md  ← 复盘输出
```

**sandskill.v1 契约字段（sand-run-retrospective）：**
```yaml
---
sand_contract: "sandskill.v1"
name: "sand-run-retrospective"
sdc_phase: "learn"
requires:
  - file_read
  - file_write
inputs:
  - ".sand/audits/audit.jsonl"
  - ".sand/executions/"
  - ".sand/intents/"
outputs:
  - ".sand/retrospectives/{date}_retro.md"
---
```

### PRD 功能需求对齐

**直接覆盖的 FR：**
- **FR38:** FDE+ 可以通过引导式工作流完成 AI 复盘（5 议题标准），输出结构化日志 — ai-retrospective.md 定义 5 议题和引导脚本
- **FR39:** 系统可以基于复盘结果生成资产化入库建议（5 类 AI 资产） — ai-asset-taxonomy.md + assetization-process.md 定义分类和流程
- **FR40:** 系统可以追踪飞轮加速指标（资产复用率、意图首通率、循环周期压缩率） — flywheel-metrics.md 定义指标

**间接支撑的 FR：**
- **FR7/FR35:** 雷达图校准和度量输出 — flywheel-metrics.md 与 sand-measure-light 的协同关系
- **FR28:** 审计事件自动记录 — ai-retrospective.md 议题 4 从 audit.jsonl 提取失败模式

**Story 6-1（Phase 2 基础版）范围限制：**
- 仅实现 `step-01-collect.md`（5 议题数据收集）和结构化日志输出
- **不包含** step-02-classify（资产分类）和 step-03-register（入库建议）——这些是 Story 6-2（Phase 3）范围
- 因此本 Story 理论文档需同时支持 6-1 和 6-2

**Story 6-2（Phase 3 完整版）范围：**
- 分析报告生成（复盘趋势、模式识别、改进建议）
- 资产化入库建议（5 类 AI 资产）
- 飞轮指标追踪

### 与前序 Story 的关系

**Dependencies:** 无（可独立开发）

**引用链（从已完善文档拉取）：**
- `assetization-process.md` 引用 `../../01-foundations/generative-reuse-risk.md`（Story 3-0 已完善）中的"人类审查不可削减"理论——论证 L2b 人工评审不可省略
- `ai-retrospective.md` 引用 `../validate/deviation-tracking.md`（Story 3-0 已完善）中的偏差事件追踪——复盘数据来源
- `ai-retrospective.md` 引用 `../governance/audit-governance.md`（Story 5-0 已完善）中的审计事件生命周期——失败模式分析的数据源
- `flywheel-metrics.md` 引用 `../../01-foundations/ai-native-definition.md`（Story 1-0 已完善）中的 AI 原生成熟度定义——飞轮效应的理论基础
- `asset-lifecycle.md` 引用 `../../01-foundations/non-deterministic-paradigm.md`（Story 1-0 已完善）中的非确定性范式——资产衰减的理论依据

**与后续 Story 的关系：**
- 本 Story 理论文档是 Story 6-1 和 Story 6-2 实现 sand-run-retrospective Skill 的直接输入
- 5 议题定义 → `steps/step-01-collect.md` 的引导对话逻辑
- 5 类资产分类 → `steps/step-02-classify.md` 的分类逻辑
- 4 步资产化流程 → `steps/step-03-register.md` 的入库建议逻辑
- 复盘输出格式 → `templates/retrospective.yaml` 的模板设计
- 3 个飞轮指标 → Story 6-2 趋势分析和 Story 7-1 sand-measure-light 协同

### 最新技术情报

**Learn 阶段不涉及外部库/框架——纯方法论文档。** 不需要版本追踪或 API 研究。

**已有研究中的 Learn 阶段相关发现（来自 technical-research）：**

| 指标 | 定义 | 采集方案 | 健康基准 |
|------|------|---------|---------|
| 资产复用率 | 复用已有 AI 资产的意图数 ÷ 总意图数 | 资产库索引 + 意图声明引用追踪 | 30-70% |
| 意图首通率 | Created → Validated 无回退的比率 | 意图状态机记录 | ≥60%（新用户），80%+（成熟） |
| 循环周期压缩率 | 本轮 SDC 周期时长 ÷ 前轮周期时长 | SDC 循环起止时间戳 | 持续 <1.0 |

**MVP 资产管理策略（ADR-007 精神延伸）：**
- Phase 2: 结构化日志输出（`.sand/retrospectives/`），无自动分类
- Phase 3: 资产分类 + 入库建议（结构化 YAML，Git 仓库存储）
- Phase 4+: 向量数据库索引 + 自动相似度检索（Post-MVP）

### Deferred Work 相关条目

**来自 Story 3-0 code review（与 Learn 相关）：**
- D5: `learning_signal` 可选导致飞轮静默退化——无完整度指标追踪 learning_signal 填充率。**本 Story 应在 flywheel-metrics.md 中定义 learning_signal 完整度追踪方法。**

**来自已有文档体系（潜在关联）：**
- 成熟度评估维度中"学习与资产化"维度（L1-L5）已在 `data/dimension-rubrics.yaml` 中定义——本 Story 理论文档应与该维度的 L1-L5 行为指标对齐
- PRD 成功指标中"意图首通率 ≥60%"——与 flywheel-metrics.md 的基准值必须一致

### 已完善的相关文档索引

| 文档 | Story | 与本 Story 的关系 |
|------|-------|-------------------|
| `docs/01-foundations/generative-reuse-risk.md` | 3-0 | 资产化流程——人类审查不可削减理论 |
| `docs/01-foundations/ai-native-definition.md` | 1-0 | 飞轮指标——AI 原生成熟度基础 |
| `docs/01-foundations/non-deterministic-paradigm.md` | 1-0 | 资产衰减——非确定性环境下知识时效性 |
| `docs/02-development-cycle/validate/deviation-tracking.md` | 3-0 | 复盘数据——偏差事件追踪定义 |
| `docs/02-development-cycle/governance/audit-governance.md` | 5-0 | 复盘数据——审计事件生命周期 |
| `docs/02-development-cycle/governance/quality-governance.md` | 5-0 | 质量门禁——Learn 阶段的资产质量评估 |
| `sand/skills/sand-assess-maturity/data/dimension-rubrics.yaml` | 1-2 | "学习与资产化"维度 L1-L5 行为指标 |

### Project Structure Notes

- 修改 `docs/02-development-cycle/learn/ai-retrospective.md`（从 5 行 STUB 扩展到 ~150-200 行）
- 修改 `docs/02-development-cycle/learn/ai-asset-taxonomy.md`（从 6 行 STUB 扩展到 ~150-200 行）
- 修改 `docs/02-development-cycle/learn/assetization-process.md`（从 5 行 STUB 扩展到 ~150-200 行）
- 修改 `docs/02-development-cycle/learn/asset-lifecycle.md`（从 5 行 STUB 扩展到 ~150-200 行）
- 修改 `docs/02-development-cycle/learn/flywheel-metrics.md`（从 5 行 STUB 扩展到 ~150-200 行）
- **不修改** `docs/02-development-cycle/learn/README.md`（已完成，28 行）
- **不修改** `schemas/` 或 `templates/`
- **不修改** 其他已完善的文档
- **不创建** `sand/skills/sand-run-retrospective/` 下的任何文件（Story 6-1/6-2 范围）

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 6: sand-run-retrospective] — Story 定义和 BDD 验收标准（行 699-731）
- [Source: _bmad-output/planning-artifacts/epics.md#Story 6-1] — 后续基础版 Skill 实现 Story（行 737-759）
- [Source: _bmad-output/planning-artifacts/epics.md#Story 6-2] — 后续完整版 Skill 实现 Story（行 763-792）
- [Source: _bmad-output/planning-artifacts/architecture.md#sand-run-retrospective] — Skill 目录结构定义（行 721-729）
- [Source: _bmad-output/planning-artifacts/architecture.md#.sand/ Directory Structure] — 复盘输出存储位置（行 352-393）
- [Source: _bmad-output/planning-artifacts/architecture.md#Data Flow] — SDC 循环数据流中 Learn 阶段位置（行 868-903）
- [Source: _bmad-output/planning-artifacts/prd.md#学习与资产化 FR38-FR40] — 功能需求（行 675-678）
- [Source: _bmad-output/planning-artifacts/prd.md#Journey 4 吴芳] — 变革催化师旅程中飞轮效应描述（行 197-221）
- [Source: _bmad-output/planning-artifacts/prd.md#Phase 2 范围微调] — retrospective Phase 2/3 拆分策略（行 506-511）
- [Source: _bmad-output/planning-artifacts/prd.md#Measurable Outcomes] — 意图首通率 ≥60% 成功标准（行 117）
- [Source: _bmad-output/planning-artifacts/research/technical-sand-tools-metrics-feasibility-research-2026-05-12.md#B3] — 学习指标技术采集方案和飞轮健康度判断（行 657-675）
- [Source: docs/02-development-cycle/learn/README.md] — 5 类资产框架和飞轮核心机制（已完成）
- [Source: docs/01-foundations/generative-reuse-risk.md] — Mikkonen 生成式复用风险理论（Story 3-0 已完善）
- [Source: docs/01-foundations/ai-native-definition.md] — AI 原生成熟度定义（Story 1-0 已完善）
- [Source: docs/01-foundations/non-deterministic-paradigm.md] — 非确定性范式（Story 1-0 已完善）
- [Source: docs/02-development-cycle/validate/deviation-tracking.md] — 偏差事件追踪定义（Story 3-0 已完善）
- [Source: docs/02-development-cycle/governance/audit-governance.md] — 审计证据链和事件生命周期（Story 5-0 已完善）
- [Source: _bmad-output/implementation-artifacts/5-0-governance-theory-foundation.md] — 前序 Story 0 模式参照
- [Source: _bmad-output/implementation-artifacts/5-1-sand-governance-audit-skill.md] — 最近完成的 Story（前序上下文）
- [Source: _bmad-output/implementation-artifacts/deferred-work.md] — D5: learning_signal 完整度追踪议题

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

N/A — documentation-only story, no runtime debugging required.

### Completion Notes List

- Task 1: Expanded `ai-retrospective.md` from 5-line STUB to ~225 lines. Defined AI retrospective vs traditional agile retrospective distinction (system performance vs individual performance, referencing Hassan SE 3.0). Created 5 standard topics with unified structure (goal, guided questions 3-5 per topic, expected outputs with tables, asset type mapping). Topic 1: Intent quality review (CLEAR pass rates, first-pass rate trends, rework cause classification). Topic 2: Orchestration effectiveness (topology selection accuracy, HIP adequacy, Skill chain interruption rate). Topic 3: AI leverage analysis (AI value points, weak points, override frequency, FR12 boundary detection stats). Topic 4: Failure mode analysis (data from audit.jsonl + deviations.json, categorized as repeated/new/mitigated, learning_signal completeness tracking). Topic 5: Assetization nomination (candidate list YAML format with candidate_id, asset_type, source_topic, confidence). Defined 3-tier retrospective frequency (micro/macro/deep). Defined structured output format aligned with `.sand/retrospectives/{date}_retro.md`.
- Task 2: Expanded `ai-asset-taxonomy.md` from 6-line STUB to ~265 lines. Defined formal AI asset definition (machine-consumable + human-verified + version-managed knowledge crystallization). Created standard metadata structure (asset_id with type_code, version, confidence, source tracking, usage tracking). Defined 5 asset types each with: definition, source/consumption phases, shelf life, standard YAML format, typical examples. Type codes: CTX/INT/ORC/VAL/FAI. Created summary table matching README.md exactly. Cross-validated all 5 types against README asset table — names and source/consumption phases match.
- Task 3: Expanded `assetization-process.md` from 5-line STUB to ~226 lines. Established 4-step rationale (quality gate + human review irreducibility, citing Mikkonen Cargo Cult theory via generative-reuse-risk.md). L2a: AI auto-scan with 3 dimensions (recurring patterns, high-efficiency segments, failure modes) + candidate output YAML format. L2b: Human review with 3 criteria (accuracy, generality, timeliness) + 3 decisions (accepted/rejected/accepted_with_changes) + irreducibility argument. L2c: Structuring with standard metadata filling rules + YAML formatting requirements. L2d: Registration with SemVer versioning + per-type expiry periods (90-365 days) + relationship establishment. Defined Phase 2→3 evolution path.
- Task 4: Expanded `asset-lifecycle.md` from 5-line STUB to ~219 lines. Defined 6-state lifecycle state machine (Candidate → Active → Under Review → Deprecated → Archived, plus Rejected terminal state) with ASCII diagram. Defined confidence model: initial confidence 0.3-1.0 based on evidence quality, usage feedback (+0.05 success, -0.10 not applicable, -0.15 caused deviation), time decay (-0.005 to -0.03/week by type), thresholds (≥0.7 normal, 0.4-0.7 warning, <0.4 review trigger, ≤0.0 deprecated). Defined per-type decay rates (context fastest, failure cases slowest). Defined 5 active refresh triggers. Defined version management with provenance, change history, usage log, and relationship tracking YAML structures. Created 4-dimension quality assessment framework (accuracy, timeliness, generality, discoverability).
- Task 5: Expanded `flywheel-metrics.md` from 5-line STUB to ~218 lines. Defined flywheel mechanism with Learn→Assess+Intent+Orchestrate+Validate feedback loop diagram. Metric 1 Asset Reuse Rate: formula, data sources (.sand/intents/ reference tracking), baselines (30-70% healthy), MVP collection strategy. Metric 2 Intent First-Pass Rate: formula (Draft→Validated without rejection), baselines (≥60% PRD target, 80%+ mature), explicit PRD alignment verification. Metric 3 Cycle Compression Rate: formula (current/previous duration), data sources (execution timestamps), baselines (<1.0 accelerating), sand-measure-light relationship. Defined 5-scenario joint analysis matrix (accelerating, spinning, false acceleration, asset decay, single-dimension breakthrough). Defined stagnation diagnostic path (4-step). Added learning_signal completeness tracking (addressing Deferred Work D5 from Story 3-0). Defined 3-phase MVP implementation strategy.
- Task 6: Full cross-validation passed all 6 items — asset names/phases match README (5/5), topic→asset mapping closed (all 5 types covered), flywheel metrics match FR40 (3/3), L2b references Mikkonen theory, output path matches Architecture, all citations from validated source list.

### Change Log

- 2026-05-15: Story implementation complete. 5 documents expanded from STUB (5-6 lines each) to full content (218-265 lines each, total 1153 lines). All 6 tasks done, cross-validation 6/6 passed.

### File List

- docs/02-development-cycle/learn/ai-retrospective.md (MODIFIED — expanded from 5-line STUB to ~225 lines)
- docs/02-development-cycle/learn/ai-asset-taxonomy.md (MODIFIED — expanded from 6-line STUB to ~265 lines)
- docs/02-development-cycle/learn/assetization-process.md (MODIFIED — expanded from 5-line STUB to ~226 lines)
- docs/02-development-cycle/learn/asset-lifecycle.md (MODIFIED — expanded from 5-line STUB to ~219 lines)
- docs/02-development-cycle/learn/flywheel-metrics.md (MODIFIED — expanded from 5-line STUB to ~218 lines)
