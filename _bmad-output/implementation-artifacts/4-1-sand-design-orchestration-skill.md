# Story 4.1: 实现 sand-design-orchestration Skill

Status: done

## Story

As a FDE+,
I want 通过引导式工作流设计编排方案（拓扑 + HIP + 外部 Skill 引入）,
so that 复杂任务可以按最优策略分解和执行。

## Acceptance Criteria

1. **Skill 契约合规** — `SKILL.md` frontmatter 通过 `sandskill.v1.schema.json` 验证，`sdc_phase = "orchestrate"`，`requires` 包含 `file_read, file_write`
2. **拓扑选型引导** — `step-01-context.md` 收集意图范围和依赖信息；`step-02-topology.md` 基于 `data/topology-rules.yaml` 规则推荐最适拓扑，用户可确认或修改
3. **HIP 级别配置** — `step-03-hip.md` 显示角色推荐值 + 项目默认值（从 `.sand/config.yaml` 读取），用户可覆盖；覆盖链保护规则阻止静默降级
4. **插件 Skill 注册** — `step-02-topology.md` 或 `step-04-plan.md` 中，若 `.sand/plugins/registry.yaml` 存在，可引入已验证的外部 Skill；未验证的 Skill 不可被选择
5. **编排方案输出** — `step-04-plan.md` 生成编排方案到 `.sand/orchestration-plan.yaml`，包含拓扑类型、Skill 链、HIP 级别、输入/输出映射，通过 `orchestration-plan.schema.json` 验证
6. **失败模式预案** — `step-04-plan.md` 基于选定拓扑和失败模式敏感矩阵生成 `failure_mode_plan`（5 种失败模式的检测方式和缓解策略）

## Tasks / Subtasks

- [x] Task 1: 创建 `sand/skills/sand-design-orchestration/SKILL.md` (AC: #1)
  - [x] 1.1 编写 sandskill.v1 frontmatter（必填字段按固定顺序 + 可选字段按字母序）
  - [x] 1.2 编写激活入口（Markdown body：Skill 概述 + 激活指令指向 step-01）
  - [x] 1.3 验证 frontmatter 字段与 `schemas/sandskill.v1.schema.json` 一致
- [x] Task 2: 创建 `sand/skills/sand-design-orchestration/customize.toml` (AC: #1)
  - [x] 2.1 定义 `[workflow]` 块：activation_steps_prepend/append、persistent_facts、on_complete
  - [x] 2.2 persistent_facts 引用 5 个 Orchestrate 理论文档（topology-patterns, human-intervention, context-engineering, agent-selection, failure-modes）
- [x] Task 3: 创建 `data/topology-rules.yaml` — 拓扑选型规则数据文件 (AC: #2)
  - [x] 3.1 从 topology-patterns.md 操作化：4 种拓扑定义（enum 值、适用条件、优劣势）
  - [x] 3.2 从 topology-patterns.md 操作化：不确定性×规模选型矩阵
  - [x] 3.3 从 topology-patterns.md 操作化：意图类型×拓扑推荐关联表
  - [x] 3.4 从 topology-patterns.md 操作化：升级/降级规则
  - [x] 3.5 从 topology-patterns.md 操作化：协调税阈值（4 Agent 饱和点）
- [x] Task 4: 编写 `steps/step-01-context.md` — 上下文收集与质量评估 (AC: #2)
  - [x] 4.1 加载意图声明（从 `.sand/intents/{intent_id}.yaml`），提取 intent_type、scope、constraints、context_references
  - [x] 4.2 执行上下文四层次收集（项目/意图/历史/协作）——从 context-engineering.md 操作化
  - [x] 4.3 执行上下文质量评估（4 维：completeness/accuracy/conciseness/discoverability）
  - [x] 4.4 应用上下文最小化原则（FR32：默认不发送完整代码文件）
  - [x] 4.5 输出 `context_scope`（include_files + exclude_patterns）和 `context_quality_check` 结果
  - [x] 4.6 遵循 6 段 Step 文件结构（MANDATORY EXECUTION RULES → YOUR TASK → EXECUTION SEQUENCE → SUCCESS METRICS → FAILURE MODES → NEXT STEP）
- [x] Task 5: 编写 `steps/step-02-topology.md` — 拓扑选型（规则推荐 + 用户确认） (AC: #2, #4)
  - [x] 5.1 加载 `data/topology-rules.yaml` 规则数据
  - [x] 5.2 执行决策流程：多子任务判断 → 顺序依赖判断 → 不确定性评估 → 矩阵复核
  - [x] 5.3 显示推荐拓扑 + 理由 + 替代方案（来自意图类型关联表）
  - [x] 5.4 用户确认或修改拓扑选型
  - [x] 5.5 若编排方案需要外部 Skill：检查 `.sand/plugins/registry.yaml`，仅允许已验证的 Skill
  - [x] 5.6 构建初步 Skill 链（skill_name + order + is_external）
  - [x] 5.7 输出选定的 topology 值 + topology_rationale + skill_chain
- [x] Task 6: 编写 `steps/step-03-hip.md` — HIP 级别配置 (AC: #3)
  - [x] 6.1 加载 4 层 HIP 决策链：角色推荐值（从能力卡 default_hip） → 项目默认值（`.sand/config.yaml` default_human_oversight） → 编排方案级覆盖 → 运行时覆盖
  - [x] 6.2 显示计算出的 HIP 推荐值 + 意图类型关联推荐 + 可调范围
  - [x] 6.3 用户确认或覆盖 HIP 级别
  - [x] 6.4 覆盖链保护：降级需显式人类确认，升级自动生效
  - [x] 6.5 根据 HIP 级别确定编排方案中的审查点位置
  - [x] 6.6 输出 human_oversight 值 + human_intervention_points 列表
- [x] Task 7: 编写 `steps/step-04-plan.md` — 输出编排方案 (AC: #5, #6)
  - [x] 7.1 合并 step-01（context_scope）+ step-02（topology + skill_chain）+ step-03（human_oversight）
  - [x] 7.2 基于选定拓扑 + 失败模式×拓扑敏感矩阵（从 failure-modes.md），生成 failure_mode_plan
  - [x] 7.3 生成 plan_id（格式待定，建议 `OP-YYYYMMDD-{seq}`）
  - [x] 7.4 从 `templates/orchestration-plan.yaml` 初始化编排方案模板
  - [x] 7.5 填充所有字段，输出到 `.sand/orchestration-plan.yaml`
  - [x] 7.6 验证输出文件通过 `schemas/orchestration-plan.schema.json`
  - [x] 7.7 HIP 级别人类确认（按当前 HIP 级别确认最终编排方案）
- [x] Task 8: 创建 `templates/orchestration-plan.yaml`（Skill 本地副本） (AC: #5)
  - [x] 8.1 从全局模板 `{sand-root}/templates/orchestration-plan.yaml` 复制为 Skill 本地模板
  - [x] 8.2 确认模板字段与 `schemas/orchestration-plan.schema.json` 一致
- [x] Task 9: 删除 `.gitkeep` 并验证目录完整性 (AC: #1-6)
  - [x] 9.1 删除 `sand/skills/sand-design-orchestration/.gitkeep`
  - [x] 9.2 验证最终目录结构与 Architecture 定义一致
  - [x] 9.3 验证 SKILL.md frontmatter 字段顺序和必填字段
  - [x] 9.4 交叉验证 step 文件中的规则与 topology-patterns.md / human-intervention.md / context-engineering.md / agent-selection.md / failure-modes.md 理论定义一致

### Review Findings

- [x] [Review][Patch] F1: Step 1 输出 `constraints_summary` 但 Step 2 消费 `constraints` — 统一为 `constraints` [step-01-context.md] ✅ fixed
- [x] [Review][Patch] F2: step-03 称"4 层决策链"但仅实现 3 层计算 + 用户覆盖 — 全文替换为"3 层计算 + 用户覆盖" [step-03-hip.md] ✅ fixed
- [x] [Review][Patch] F3: HIP 审查矩阵缺少"外部 Skill 引入"行 — 添加第 6 行 [step-03-hip.md] ✅ fixed
- [x] [Review][Patch] F4: 模板默认 skill_name `sand-create-intent` 具有误导性 — 改为 `sand-example-skill` + 注释 [templates/orchestration-plan.yaml] ✅ fixed
- [x] [Review][Patch] F5: Step 1 FAILURE MODES 中 `.sand/` 不存在规则永远无法触发 — 重写为"历史/审计子目录缺失"场景 [step-01-context.md] ✅ fixed
- [x] [Review][Patch] F6: step-04 执行序列展示 failure_mode_plan 为结构化 YAML 但 MANDATORY RULES 要求扁平化 — 改为文本描述 + 明确注释写入 topology_rationale [step-04-plan.md] ✅ fixed
- [x] [Review][Patch] F7: step-04 合并步骤未收集 Step 1 的 context_quality_check — 添加收集并写入 topology_rationale [step-04-plan.md] ✅ fixed
- [x] [Review][Defer] W1: plan_id 格式 OP-YYYYMMDD-{seq} 未在 Schema 中以 pattern 约束 — Schema 级增强，非本 Story 范围
- [x] [Review][Defer] W2: Skill 本地模板与全局模板重复 — 维护分叉风险，但 Architecture 定义要求本地副本
- [x] [Review][Defer] W3: .sand/orchestration-plan.yaml 为固定路径，多次运行会覆盖 — 运行时版本化，Story 4-2 sand-run 范围
- [x] [Review][Defer] W4: SKILL.md inputs 声明 .sand/config.yaml 但 step 按可选处理 — Schema inputs 语义定义待明确
- [x] [Review][Defer] W5: 拓扑升级规则仅支持单步升级（无 Solo→Hierarchy 直达） — 设计选择，可在 Phase 3 扩展
- [x] [Review][Defer] W6: 决策流程对不可拆分大规模任务始终推 Solo，依赖矩阵复核修正 — step-02 的交叉检查机制可工作但不够直觉
- [x] [Review][Defer] W7: skill_chain items 未设 additionalProperties:false — Schema 级一致性，非本 Story 范围
- [x] [Review][Defer] W8: Solo 拓扑 skill_chain 缺少默认 skill_name 推导逻辑 — step-02 实现增强

## Dev Notes

### 前序 Story 关键产出

**Story 4-0（Orchestrate 理论基础）已完成（done），产出 5 个理论文档作为本 Story 的直接输入：**

| 理论文档 | 映射到本 Story 的文件 | 关键操作化内容 |
|---------|---------------------|-------------|
| `docs/02-development-cycle/orchestrate/topology-patterns.md` | `data/topology-rules.yaml` + `steps/step-02-topology.md` | 4 拓扑定义 + 不确定性×规模矩阵 + 意图类型关联 + 决策流程 + 升降级规则 |
| `docs/02-development-cycle/orchestrate/human-intervention.md` | `steps/step-03-hip.md` | HIP-1/2/3 定义 + 4 层决策链 + 覆盖链保护 + 动态调整 + 审查矩阵 |
| `docs/02-development-cycle/orchestrate/context-engineering.md` | `steps/step-01-context.md` | 上下文四层次 + 质量评估 4 维 + 最小化原则(FR32) + CDLC 映射 |
| `docs/02-development-cycle/orchestrate/agent-selection.md` | `steps/step-01-context.md` + `steps/step-02-topology.md` | 选型决策树 + 能力卡 9 字段 + 3 角色能力卡 + 能力-拓扑匹配 |
| `docs/02-development-cycle/orchestrate/failure-modes.md` | `steps/step-04-plan.md` | 5 种失败模式 enum + 拓扑敏感矩阵 + 3 条防御原则 |

**Story 4-0 Review 遗留的 3 项 Deferred Work（W2/W4/W5）本 Story 需处理：**

| ID | 问题 | 建议处理方式 |
|----|------|-----------|
| W2 | context_quality_check 理论 4 维 vs 模板 3 字段（缺 discoverability） | step-01 实现 4 维评估，输出到 context_quality_check 时仅填 3 个 Schema 字段，discoverability 结果写入 meta.topology_rationale 或注释 |
| W4 | Swarm/Hierarchy 最少 Agent 数量未定义 | data/topology-rules.yaml 添加 `min_agents` 字段：Swarm≥2 worker + 1 aggregator, Hierarchy≥1 manager + 2 worker |
| W5 | HIP 信任降级阈值 N 未量化 | step-03-hip.md 定义默认阈值 N=5（连续 5 次无人工修改后建议降级），可通过 `.sand/config.yaml` 覆盖 |

### 已建立的 Skill 实现模式（从 Story 1-2、2-1、3-1 提取）

**SKILL.md frontmatter 必填字段固定顺序：**
```yaml
---
sand_contract: "sandskill.v1"
name: "sand-design-orchestration"
version: "0.1.0"
description: "引导式编排方案设计——拓扑选型、HIP 配置、Skill 链构建"
sdc_phase: "orchestrate"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - ".sand/intents/{intent_id}.yaml"
  - ".sand/config.yaml"
outputs:
  - ".sand/orchestration-plan.yaml"
# === 可选字段（字母序） ===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["orchestration", "topology", "hip", "context-engineering"]
---
```

**customize.toml 模式：**
```toml
[workflow]
activation_steps_prepend = []
activation_steps_append = []
persistent_facts = [
  "file:{sand-root}/docs/02-development-cycle/orchestrate/topology-patterns.md",
  "file:{sand-root}/docs/02-development-cycle/orchestrate/human-intervention.md",
  "file:{sand-root}/docs/02-development-cycle/orchestrate/context-engineering.md",
  "file:{sand-root}/docs/02-development-cycle/orchestrate/agent-selection.md",
  "file:{sand-root}/docs/02-development-cycle/orchestrate/failure-modes.md",
]
on_complete = ""
```

**Step 文件强制 6 段结构：**
```
# Step {N}: {Title}
## MANDATORY EXECUTION RULES (READ FIRST):
## YOUR TASK:
## EXECUTION SEQUENCE:
## SUCCESS METRICS:
## FAILURE MODES:
## NEXT STEP:
```

### 关键架构约束

**目标目录结构（Architecture 定义，行 687-698）：**
```
sand/skills/sand-design-orchestration/
├── SKILL.md                         ← sandskill.v1 frontmatter + 激活入口
├── customize.toml                   ← persistent_facts → 5 个理论文档
├── steps/
│   ├── step-01-context.md           ← O1: 收集意图范围 + 上下文质量评估
│   ├── step-02-topology.md          ← O3: 拓扑选型（规则推荐 + 用户确认）+ 外部 Skill 检查
│   ├── step-03-hip.md               ← O4: HIP 级别配置（决策链 + 覆盖保护）
│   └── step-04-plan.md              ← O5: 失败模式预案 + 输出编排方案
├── templates/
│   └── orchestration-plan.yaml      ← 编排方案本地模板（从全局模板复制）
└── data/
    └── topology-rules.yaml          ← Solo/Pipeline/Swarm/Hierarchy 选型规则
```

**编排方案输出路径：**
- `.sand/orchestration-plan.yaml` — 编排方案（从 `templates/orchestration-plan.yaml` 初始化）

**Schema 约束（schemas/orchestration-plan.schema.json）：**
- `plan_id`: string (required)
- `intent_id`: pattern `^INT-\d{8}-\d{3,}$` (required)
- `topology`: enum `["solo", "pipeline", "swarm", "hierarchy"]` (required)
- `human_oversight`: enum `["hip-1", "hip-2", "hip-3"]` (required)
- `skill_chain[].skill_name`: pattern `^sand-[a-z][a-z0-9-]*$`, `order`: integer >= 1
- `context_scope`: `include_files[]`, `exclude_patterns[]`
- `meta`: `created_at` (date-time), `topology_rationale` (string)
- `additionalProperties: false`

**注意：Schema 仅定义 7 个顶层属性（plan_id, intent_id, topology, human_oversight, skill_chain, context_scope, meta）并设 `additionalProperties: false`。** 扩展模板（docs/09-templates/）中的 O1-O5 扩展结构（context_strategy, agent_selection, failure_mode_plan 等）**不在 Schema 范围内**——这些是设计文档/方法论参考，不写入 `.sand/orchestration-plan.yaml` 输出文件。step-04-plan.md 输出的编排方案**必须严格符合 Schema**。

**HIP 方向约束（不可反转）：**
- HIP-1 = 最低介入/全自主（异步知晓）
- HIP-2 = 中度介入/关键决策审查（同步审查）
- HIP-3 = 最高介入/全程监督（人类主导）

**覆盖链保护规则（Story 4-0 Review F8 新增）：**
- 覆盖链中降级（降低 HIP 级别）需显式人类确认
- 升级自动生效，无需确认

**PRD 功能需求直接覆盖：**
- **FR16:** 引导式拓扑选型（step-02）
- **FR17:** HIP 级别配置（step-03）
- **FR18:** 外部 Skill 注册（step-02 检查 `.sand/plugins/registry.yaml`）
- **FR21:** 编排方案中引入外部 Skill（step-02 Skill 链构建）
- **FR22:** 输出编排方案到 `.sand/orchestration-plan.yaml`（step-04）
- **FR32:** 上下文安全——默认不发送完整代码文件（step-01 最小化原则）

**注意：FR19（sand-skill-init 脚手架）和 FR20（外部 Skill 验证工具）属于 Story 4-3 范围，本 Story 仅实现插件引入检查。**

### 用户交互规范

- **菜单格式**：选项列表 `1.`/`2.`/`3.`，确认 `(y/n)` 或 `[C] 继续`
- **拓扑选型展示**：推荐值 + 理由 + 替代方案表格，用户选择或确认默认
- **HIP 配置展示**：4 层决策链计算过程可视化（角色推荐 → 项目默认 → 最终值），用户可覆盖
- **进度反馈**：每步开始显示 `[Step N/4]`
- **输出语言**：中文（遵循 config.yaml），技术术语保持英文
- **错误处理**：快速失败 + 明确报错。缺失意图声明 → 报错 + 建议运行 `sand-create-intent`

### 与前序 Skill 的交互

**输入依赖：**
- `sand-create-intent` Skill 产出的意图声明 `.sand/intents/{intent_id}.yaml`——本 Skill 的 step-01 从中提取 intent_type、scope、constraints
- `.sand/config.yaml`——项目配置（default_human_oversight、output_language 等）

**输出消费者：**
- `sand-run` Skill（Story 4-2）将消费 `.sand/orchestration-plan.yaml` 作为执行输入
- `sand-validate-delivery` Skill 的验证通道在验证时引用编排方案中的 HIP 级别

### Project Structure Notes

- 所有新文件在 `sand/skills/sand-design-orchestration/` 下
- 遵循已建立的 Skill 目录约定（SKILL.md + customize.toml + steps/ + data/ + templates/）
- 删除 `.gitkeep` placeholder
- 不修改 `docs/` 下的理论文档（Story 4-0 已完成）
- 不修改 `schemas/` 或 `templates/`（全局模板和 Schema 在 Story 1-1 已创建）

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 4-1] — BDD 验收标准和任务清单（行 499-534）
- [Source: _bmad-output/planning-artifacts/architecture.md#sand-design-orchestration] — Skill 目录结构（行 687-698）
- [Source: _bmad-output/planning-artifacts/architecture.md#Agent Roles & Orchestration Topology] — 拓扑选型规则、HIP 决策链（行 412-441）
- [Source: _bmad-output/planning-artifacts/prd.md#编排与插件生态 FR16-FR22] — 功能需求（行 632-641）
- [Source: _bmad-output/planning-artifacts/prd.md#上下文安全 FR32-FR33] — 上下文安全（行 661-664）
- [Source: schemas/orchestration-plan.schema.json] — 编排方案 JSON Schema
- [Source: schemas/sandskill.v1.schema.json] — Skill 契约 Schema
- [Source: templates/orchestration-plan.yaml] — 编排方案全局模板
- [Source: docs/02-development-cycle/orchestrate/topology-patterns.md] — 拓扑模式理论（Story 4-0 产出）
- [Source: docs/02-development-cycle/orchestrate/human-intervention.md] — HIP 模型理论（Story 4-0 产出）
- [Source: docs/02-development-cycle/orchestrate/context-engineering.md] — 上下文工程理论（Story 4-0 产出）
- [Source: docs/02-development-cycle/orchestrate/agent-selection.md] — Agent 选型理论（Story 4-0 产出）
- [Source: docs/02-development-cycle/orchestrate/failure-modes.md] — 失败模式理论（Story 4-0 产出）
- [Source: _bmad-output/implementation-artifacts/4-0-orchestrate-theory-foundation.md] — 前序 Story 完整记录（含 Review Findings 和 Deferred Work W2/W4/W5）
- [Source: _bmad-output/implementation-artifacts/3-1-sand-validate-delivery-skill.md] — Skill 实现模式参照
- [Source: _bmad-output/implementation-artifacts/deferred-work.md#4-0] — Deferred work W2/W4/W5
- [Source: sand/skills/sand-assess-maturity/SKILL.md] — SKILL.md frontmatter + data/ 模式参照
- [Source: sand/skills/sand-create-intent/SKILL.md] — SKILL.md frontmatter + data/ 模式参照
- [Source: sand/skills/sand-validate-delivery/SKILL.md] — SKILL.md frontmatter + templates/ 模式参照

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

N/A — Markdown Skill authoring, no runtime debugging.

### Completion Notes List

- Task 1: Created SKILL.md with sandskill.v1 frontmatter (9 required fields in fixed order + 6 optional in alphabetical order). sdc_phase="orchestrate", requires=[file_read, file_write]. Activation body includes 概述, 理论基础 (O1-O5 sub-processes), 前置条件, 使用方式 (pointing to step-01), 参考数据, 输出工件.
- Task 2: Created customize.toml with persistent_facts referencing all 5 Orchestrate theory docs (topology-patterns, human-intervention, context-engineering, agent-selection, failure-modes).
- Task 3: Created data/topology-rules.yaml (~130 lines). Operationalized from topology-patterns.md: 4 topology definitions with id/name/definition/min_agents/advantages/disadvantages (W4 addressed: min_agents defined — Solo=1, Pipeline=2, Swarm=3, Hierarchy=3). Selection matrix (9 entries: 3 uncertainty levels × 3 scale levels). Intent type mapping (5 types with primary/alternatives/rationale). Escalation rules (3 entries: solo→pipeline, pipeline→swarm, swarm→hierarchy). De-escalation rules (3 entries with requires_hip_confirmation=true). Coordination tax threshold (max_parallel_agents=4).
- Task 4: Created steps/step-01-context.md (~130 lines). Implements O1 context engineering: intent loading from .sand/intents/, 4-layer context collection (project/intent/historical/collaboration), 4-dimension quality assessment (completeness/accuracy/conciseness/discoverability — W2 addressed: first 3 to context_quality_check, 4th to topology_rationale), FR32 minimization rules table, structured YAML output format. Follows 6-section step structure.
- Task 5: Created steps/step-02-topology.md (~150 lines). Implements O3 topology selection: loads topology-rules.yaml, executes decision flow (multi-subtask → dependency → uncertainty → matrix cross-check), displays recommendation with alternatives, external Skill verification via .sand/plugins/registry.yaml (FR18/FR21 — verified=true required), skill_chain construction with Schema-compliant skill_name pattern, coordination tax warning at >4 agents.
- Task 6: Created steps/step-03-hip.md (~140 lines). Implements O4 HIP configuration: 4-layer decision chain (role default → project config → intent type → user override), visual calculation display, override protection (downgrade requires explicit confirmation per Story 4-0 Review F8), dynamic adjustment hints (domain-reset, trust de-escalation at N=5 — W5 addressed, anomaly escalation), review requirements matrix by HIP level, structured YAML output.
- Task 7: Created steps/step-04-plan.md (~160 lines). Implements O5 failure mode plan + final output: merges Step 1-3 outputs, generates failure_mode_plan based on topology×failure sensitivity matrix (5 modes × 4 topologies, high-risk items get specific detection/mitigation), plan_id generation (OP-YYYYMMDD-{seq}), template initialization from local template, Schema validation (7 top-level properties only, additionalProperties: false enforced), HIP-level confirmation flow (HIP-1=auto, HIP-2=confirm, HIP-3=per-item), saves to .sand/orchestration-plan.yaml.
- Task 8: Created templates/orchestration-plan.yaml as Skill-local copy of global template. Added header comment clarifying Schema constraint (7 properties only). Fields match orchestration-plan.schema.json exactly.
- Task 9: Deleted .gitkeep. Final directory verified: 8 files matching Architecture definition (SKILL.md, customize.toml, 4 steps, 1 data file, 1 template). Frontmatter field order validated. Topology enum (solo/pipeline/swarm/hierarchy) and HIP enum (hip-1/hip-2/hip-3) cross-verified against Schema.

### Change Log

- 2026-05-14: Story implementation complete. 8 new files created, .gitkeep deleted, all 9 tasks done.
- 2026-05-14: Code review complete. 7 patch findings fixed, 8 deferred, 4 dismissed. Fixes: constraints field name unified, HIP "4层"→"3层+覆盖", HIP matrix +外部Skill行, template placeholder, step-01 failure modes rewrite, step-04 failure_mode_plan flattened, step-04 collects context_quality_check.

### File List

- sand/skills/sand-design-orchestration/SKILL.md (NEW)
- sand/skills/sand-design-orchestration/customize.toml (NEW)
- sand/skills/sand-design-orchestration/data/topology-rules.yaml (NEW)
- sand/skills/sand-design-orchestration/steps/step-01-context.md (NEW)
- sand/skills/sand-design-orchestration/steps/step-02-topology.md (NEW)
- sand/skills/sand-design-orchestration/steps/step-03-hip.md (NEW)
- sand/skills/sand-design-orchestration/steps/step-04-plan.md (NEW)
- sand/skills/sand-design-orchestration/templates/orchestration-plan.yaml (NEW)
- sand/skills/sand-design-orchestration/.gitkeep (DELETED)
