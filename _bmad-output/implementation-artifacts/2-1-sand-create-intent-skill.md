# Story 2.1: 实现 sand-create-intent Skill

Status: done

## Story

As a FDE+（陈雨角色）,
I want 通过结构化对话创建高质量的意图声明并自动生成执行契约,
so that AI 可以基于明确的契约进行认知协作而非被动执行。

## Acceptance Criteria

1. `sand/skills/sand-create-intent/SKILL.md` 存在且 frontmatter 通过 `sandskill.v1.schema.json` 验证，`sdc_phase = "intent"`，`requires` 包含 `file_read` 和 `file_write`
2. Skill 通过 4 步引导工作流（scope → draft → clear-check → contract）引导用户创建意图声明，不要求用户预先了解字段格式
3. `data/clear-checklist.yaml` 从 `docs/02-development-cycle/intent/clear-checklist.md` 操作化，包含 20 项检查项（C1-C5、L1-L4、E1-E5、A1-A3、R1-R3），每项含 pass/fail 判定标准和自动化级别
4. step-03-clear-check 运行 CLEAR 5 维检查，按 C→E→A→L→R 顺序执行，输出 ✓/⚠️/✗ 标记，⚠️ 和 ✗ 提供具体修改建议
5. step-04-contract 自动从意图声明生成执行契约，契约包含 must_pass/should_pass/must_not_violate 三级条目，输出到 `.sand/intents/contracts/{intent_id}.contract.yaml`
6. 意图声明输出到 `.sand/intents/{intent_id}.yaml`，状态为 Draft，包含 intent_id（格式 `INT-YYYYMMDD-{seq}`）和创建时间
7. `sand/schemas/intent-statement.schema.json` 和 `sand/templates/intent-statement.yaml` 更新为与 Story 2-0 理论文档结构一致（acceptance_criteria 结构化、constraints 三子域、context_references 结构化、meta 完整字段）
8. `customize.toml` 存在且 persistent_facts 引用 Intent 阶段理论文档
9. 所有新建文件遵循 Story 1-2（sand-assess-maturity）建立的文件模式和命名规范

## Tasks / Subtasks

- [x] Task 1: 更新 Schema 和 Template 以对齐 Story 2-0 理论 (AC: #7)
  - [x] 1.1 更新 `schemas/intent-statement.schema.json`：acceptance_criteria 改为结构化对象数组（criterion+verification+priority），constraints 改为 technical/security/scope 三子域，context_references 改为结构化对象（5 字段），meta 补充 owner/priority/investment_hypothesis/estimated_ai_leverage/created
  - [x] 1.2 更新 `templates/intent-statement.yaml`：结构与 schema 对齐，使用 5 组分隔注释风格
  - [x] 1.3 修正 intent_id 格式：模板中改为 `INT-YYYYMMDD-001`（与 schema pattern 一致）
  - [x] 1.4 更新 `schemas/execution-contract.schema.json`：must_pass/should_pass 条目增加 criterion+source（required），must_not_violate 增加 constraint+source（required），增加 generated_at 顶层字段，条目 id 增加 pattern 约束
- [x] Task 2: 创建 SKILL.md (AC: #1)
  - [x] 2.1 编写 sandskill.v1 frontmatter（name=sand-create-intent, sdc_phase=intent, requires=[file_read, file_write], inputs 引用 templates/, outputs 指向 .sand/intents/）
  - [x] 2.2 编写激活入口正文（概述 + 4 步导航 + 参考数据区）
  - [x] 2.3 验证 frontmatter 符合 sandskill.v1.schema.json（9 必填字段全部存在，name 匹配 pattern）
- [x] Task 3: 创建 customize.toml (AC: #8)
  - [x] 3.1 编写 [workflow] 表，persistent_facts 引用 intent-statement.md、clear-checklist.md、execution-contract.md
- [x] Task 4: 创建 data/clear-checklist.yaml (AC: #3)
  - [x] 4.1 从 docs/02-development-cycle/intent/clear-checklist.md 提取 20 项检查项
  - [x] 4.2 YAML 结构：dimensions → items → 每项含 id、check、pass_criteria、fail_criteria、automation
  - [x] 4.3 包含 execution_order（C→E→A→L→R）和 pass_thresholds 规则
  - [x] 4.4 交叉验证：20 项检查项的 id/名称/判定标准与 clear-checklist.md 完全一致（grep 确认 20 项）
- [x] Task 5: 编写 steps/step-01-scope.md (AC: #2)
  - [x] 5.1 引导用户选择意图类型（[A]-[E] 五选一 + 不确定引导）
  - [x] 5.2 收集意图范围信息（问题描述、业务关联、预估范围）
  - [x] 5.3 确认意图边界（范围预检 + 分解建议）
  - [x] 5.4 遵循 step 文件标准结构（6 个标准 section 全部存在）
- [x] Task 6: 编写 steps/step-02-draft.md (AC: #2)
  - [x] 6.1 按 5 组顺序引导填写 7 字段
  - [x] 6.2 每字段提供引导问题（不要求用户了解格式）
  - [x] 6.3 生成 intent_id（INT-YYYYMMDD-{seq}）并创建 .sand/intents/ 目录
  - [x] 6.4 输出意图声明到 .sand/intents/{intent_id}.yaml，status=draft，记录审计事件
- [x] Task 7: 编写 steps/step-03-clear-check.md (AC: #4)
  - [x] 7.1 加载 data/clear-checklist.yaml
  - [x] 7.2 按 C→E→A→L→R 顺序执行 20 项检查
  - [x] 7.3 AI 自动维度（C/E/A）直接判定，人工维度（L/R）引导用户评估
  - [x] 7.4 输出 ✓/⚠️/✗ 标记，⚠️ 和 ✗ 附带具体修改建议
  - [x] 7.5 汇总规则：全 pass→继续，含 warn→用户选择，含 fail→必须修正
  - [x] 7.6 CLEAR 通过后，Draft→Reviewed（记录审计事件）
- [x] Task 8: 编写 steps/step-04-contract.md (AC: #5)
  - [x] 8.1 映射规则表：acceptance_criteria[must]→must_pass, [should]→should_pass, constraints→must_not_violate
  - [x] 8.2 生成条目 ID（MP-NNN, SP-NNN, MNV-NNN）
  - [x] 8.3 AI 补充条目（source: "ai_derived"），需用户确认
  - [x] 8.4 输出到 .sand/intents/contracts/{intent_id}.contract.yaml
  - [x] 8.5 用户审批后 Reviewed→Approved（记录审计事件）
- [x] Task 9: 验证一致性 (AC: #9)
  - [x] 9.1 SKILL.md frontmatter 9 必填字段全部存在，name/sdc_phase/requires 符合 schema
  - [x] 9.2 data/clear-checklist.yaml 精确 20 项，id/check/criteria 与 docs/ 一致
  - [x] 9.3 4 个 step 文件均含 6 个标准 section（MANDATORY RULES/YOUR TASK/EXECUTION SEQUENCE/SUCCESS/FAILURE/NEXT STEP）
  - [x] 9.4 schema acceptance_criteria 为结构化对象、constraints 为三子域、meta 含 owner/priority/status/created

### Review Findings

- [x] [Review][Patch] **execution-contract.yaml 模板未同步更新** — 已修复：模板字段改为 criterion+source（must_pass/should_pass）和 constraint+source（must_not_violate），新增 generated_at 顶层字段，增加三个子域示例条目 [templates/execution-contract.yaml]
- [x] [Review][Patch] **execution-contract schema generated_at 重复定义** — 已修复：从 meta 中移除 generated_at，仅保留顶层字段 [schemas/execution-contract.schema.json]
- [x] [Review][Patch] **A1 阈值逻辑表述不一致** — 已修复：step-03 统一为"≥80% 可自动化=✓, 50%-80% 可自动化=⚠️, <50% 可自动化=✗" [steps/step-03-clear-check.md]
- [x] [Review][Patch] **contract_id 缺少 pattern 约束** — 已修复：添加 pattern `^INT-\d{8}-\d{3,}-contract-v\d+\.\d+$` [schemas/execution-contract.schema.json]
- [x] [Review][Patch] **step-04 must_not_violate 示例不完整** — 已修复：增加 security 和 scope 子域映射示例 [steps/step-04-contract.md]
- [x] [Review][Patch] **step-04 退回后未要求 CLEAR 重检** — 已修复：明确标注退回后必须重走 step-03 CLEAR 检查 [steps/step-04-contract.md]
- [x] [Review][Defer] **must_not_violate 无 verification 字段** — 硬约束为二元判定（违反或不违反），不同于验收标准的多种验证方式 [schemas/execution-contract.schema.json] — deferred, 设计决策
- [x] [Review][Defer] **clear_check 用 boolean 建模三态结果** — 无法区分"通过"和"接受 warn 风险后放行" [schemas/execution-contract.schema.json] — deferred, schema 增强
- [x] [Review][Defer] **Architecture 指定 local templates/ 但未创建** — Story spec 明确禁止创建本地 templates/ [architecture.md vs story spec] — deferred, 架构文档更新
- [x] [Review][Defer] **审计事件格式与 SandAuditEvent schema 不兼容** — 已在 Story 2-0 deferred-work.md 中记录 [audit-event.schema.json] — deferred, 架构级统一
- [x] [Review][Defer] **用户中途取消无清理机制** — 可能产生幽灵 ID 或残留文件 [step files] — deferred, 运行时增强
- [x] [Review][Defer] **meta.status in_execution 与架构 kebab-case 规则不一致** — 早期阶段无现存数据影响 [schemas/intent-statement.schema.json] — deferred, 命名约定统一
- [x] [Review][Defer] **FR12 边界条件主动识别未在 sand-create-intent 中体现** — FR12 职责可能属于 sand-run 而非 sand-create-intent [PRD FR12] — deferred, 职责边界明确化
- [x] [Review][Defer] **version/generated_at 非 required + additionalProperties:false 限制扩展** — 可选字段 + 严格 schema 设计决策 [schemas/execution-contract.schema.json] — deferred, schema 演进
- [x] [Review][Defer] **constraints 子域无 minItems + 模板默认空数组** — CLEAR C5 在流程层面捕获 [schemas/intent-statement.schema.json] — deferred, DX 改善
- [x] [Review][Defer] **CLEAR 失败修正无最大重试次数** — 已在 Story 2-0 deferred 中记录类似问题 [step-03-clear-check.md] — deferred, 流程增强

## Dev Notes

### Story 本质

这是一个 **Skill 实现** Story——创建 `sand-create-intent` Skill 的全部文件（SKILL.md、customize.toml、4 个 step 文件、1 个 data 文件），并更新 Story 1-1 创建的 schema 和 template 使其与 Story 2-0 理论文档对齐。不涉及代码（Python/JS），所有产出为 Markdown + YAML + JSON。

### 关键前置工作：Schema/Template 与理论文档的差异

Story 1-1 创建 schema 和 template 时，Story 2-0 理论文档尚未完成。现存在以下**结构性差异必须修正**：

| 组件 | Story 1-1 当前结构 | Story 2-0 理论定义 | 需要改动 |
|------|-------------------|-------------------|---------|
| **acceptance_criteria** | 平面字符串数组 | 结构化对象数组（criterion + verification + priority） | Schema + Template |
| **constraints** | must_not_violate / should_respect | technical / security / scope 三子域 | Schema + Template |
| **context_references** | 平面字符串数组 | 结构化对象（architecture + domain_model + prior_decisions + related_intents + known_risks） | Schema + Template |
| **meta** | author / created_at / status / sdc_layer | owner / priority / investment_hypothesis / estimated_ai_leverage / created / status | Schema + Template |
| **intent_id 格式** | Template 用 `INT-YYYYMMDD-001`，docs/09-templates 用 `SAND-YYYY-NNNN` | Architecture 规定 `INT-YYYYMMDD-{seq}`，Schema 正确 `^INT-\d{8}-\d{3,}$` | docs/09-templates 中的格式（不在本 Story 范围，已在 deferred-work.md） |

**修正策略**：以 Story 2-0 理论文档为权威来源，更新 schema 和 template 使其一致。`docs/09-templates/intent-statement.yaml` 的 intent_id 格式修正已记录在 deferred-work.md 中，本 Story 不修改该文件。

### 已建立的 Skill 开发模式（从 Story 1-2 提取）

严格遵循 sand-assess-maturity 建立的模式：

**SKILL.md 结构：**
```
---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-create-intent"
version: "0.1.0"
...
---
# sand-create-intent
概述段（1-2 段）
## 步骤导航
**[Step 1/4]** Read fully and follow ./steps/step-01-scope.md
...
## 参考数据
- data/clear-checklist.yaml — CLEAR 检查项定义
```

**customize.toml 结构：**
```toml
[workflow]
activation_steps_prepend = []
activation_steps_append = []
persistent_facts = [
  "file:{sand-root}/docs/02-development-cycle/intent/intent-statement.md",
  "file:{sand-root}/docs/02-development-cycle/intent/clear-checklist.md",
  "file:{sand-root}/docs/02-development-cycle/intent/execution-contract.md",
]
on_complete = ""
```

**Step 文件标准结构：**
1. `# Step {N}: {Title}`
2. `## MANDATORY EXECUTION RULES (READ FIRST):` — 4 条标准规则
3. `## YOUR TASK:` — 一句话概述
4. `## EXECUTION SEQUENCE:` — 编号子章节，含详细指令、菜单提示（`[A]/[B]/[C]` 格式）
5. `## SUCCESS METRICS:` — ✅ 勾选项
6. `## FAILURE MODES:` — ❌ 项 + 回退指导
7. `## NEXT STEP:` — `Read fully and follow ./step-{N+1}-{name}.md`

**data/ 文件结构：**
- YAML 文件头注释：说明来源文档和用途
- 结构化数据，键名与理论文档对齐

### 文件创建清单

| 路径 | 操作 | 说明 |
|------|------|------|
| `sand/skills/sand-create-intent/SKILL.md` | NEW | sandskill.v1 frontmatter + 激活入口 |
| `sand/skills/sand-create-intent/customize.toml` | NEW | 定制化配置 |
| `sand/skills/sand-create-intent/data/clear-checklist.yaml` | NEW | 从 clear-checklist.md 操作化 |
| `sand/skills/sand-create-intent/steps/step-01-scope.md` | NEW | 需求收集 + 意图类型选择 |
| `sand/skills/sand-create-intent/steps/step-02-draft.md` | NEW | 7 字段意图声明草案引导 |
| `sand/skills/sand-create-intent/steps/step-03-clear-check.md` | NEW | CLEAR 5 维自动检查 |
| `sand/skills/sand-create-intent/steps/step-04-contract.md` | NEW | 执行契约生成 |
| `sand/schemas/intent-statement.schema.json` | UPDATE | 结构对齐理论文档 |
| `sand/templates/intent-statement.yaml` | UPDATE | 结构对齐理论文档 |
| `sand/schemas/execution-contract.schema.json` | UPDATE | 增加 source 字段 |
| `sand/skills/sand-create-intent/.gitkeep` | DELETE | 被实际文件替代 |

### 不要做的事

- **不要**修改 `docs/` 下的任何理论文档（Story 2-0 已完善且通过审查）
- **不要**修改 `docs/09-templates/intent-statement.yaml`（deferred-work 中的 intent_id 格式修正不在本 Story 范围）
- **不要**修改 `sand-assess-maturity` Skill 的任何文件
- **不要**创建 Skill 本地 `templates/` 子目录（遵循 Story 1-2 决策：使用全局 `sand/templates/`）
- **不要**修改 `sandskill.v1.schema.json`（Skill 契约 schema 在 Story 1-1 已固化）
- **不要**在 step 文件中编写可执行代码（Python/JS）——所有 step 文件都是 Markdown 指令，由 LLM 宿主解释执行

### 关键上下文：陈雨旅程

step 文件中的交互设计应体现 PRD Journey 2 陈雨的体验：
- **step-01**：陈雨被要求试用 SAND 工作流，内心抵触"我已经很会用 AI 了"→ Skill 不应让用户感到被"考试"
- **step-02**：通过结构化对话引导填写 7 字段，陈雨"被迫思考一些平时跳过的问题"→ 引导式对话而非表单填写
- **step-03**：CLEAR 检查发现 Executable ⚠️（缺少性能基线）→ 具体修改建议而非泛泛的"请完善"
- **step-04**：执行契约自动生成，后续 AI 基于契约主动识别 3 个边界条件 → 契约的结构要支撑 AI 的主动识别

### HIP 级别方向（Story 2-0 Review 修正后）

HIP 级别统一为 PRD 方向：
- **HIP-1** = 全自主（最低介入）
- **HIP-2** = 关键节点确认
- **HIP-3** = 全程监督（最高介入）

数字越大，人类介入越多。sand-create-intent 的 SKILL.md frontmatter 应设置 `human_oversight: "hip-2"`（FDE+ 的标准意图创建流程）。

### 审计事件记录

Step 文件中需要在关键状态变更时提示记录审计事件到 `.sand/audits/audit.jsonl`：
- step-03 CLEAR 通过时：`from_status: draft → to_status: reviewed`
- step-04 人工审批时：`from_status: reviewed → to_status: approved`

审计事件字段：event_id、timestamp、intent_id、from_status、to_status、trigger、actor、notes

### Project Structure Notes

- Skill 目录：`sand/skills/sand-create-intent/` — 当前仅有 `.gitkeep`，所有文件需新建
- Schema 目录：`sand/schemas/` — 已有 intent-statement.schema.json 和 execution-contract.schema.json，需 UPDATE
- Template 目录：`sand/templates/` — 已有 intent-statement.yaml 和 execution-contract.yaml，需 UPDATE
- 运行时目录：`.sand/intents/` 和 `.sand/intents/contracts/` — 由 Skill 执行时自动创建，不在本 Story 中创建

### References

- [Source: _bmad-output/planning-artifacts/prd.md §意图管理 FR9-FR14]
- [Source: _bmad-output/planning-artifacts/prd.md §Journey 2 陈雨]
- [Source: _bmad-output/planning-artifacts/architecture.md §sand-create-intent 目录结构]
- [Source: _bmad-output/planning-artifacts/architecture.md §sandskill.v1 Contract Specification]
- [Source: _bmad-output/planning-artifacts/architecture.md §.sand/ 目录结构]
- [Source: docs/02-development-cycle/intent/intent-statement.md §7 字段完整定义]
- [Source: docs/02-development-cycle/intent/clear-checklist.md §20 检查项]
- [Source: docs/02-development-cycle/intent/execution-contract.md §映射规则]
- [Source: docs/02-development-cycle/intent/intent-lifecycle.md §6 状态定义]
- [Source: docs/02-development-cycle/intent/intent-taxonomy.md §5 类型]
- [Source: sand/skills/sand-assess-maturity/ §Skill 开发模式参考]
- [Source: sand/schemas/intent-statement.schema.json §当前 schema（需更新）]
- [Source: sand/templates/intent-statement.yaml §当前模板（需更新）]
- [Source: _bmad-output/implementation-artifacts/1-2-sand-assess-maturity-skill.md §Skill 模式]
- [Source: _bmad-output/implementation-artifacts/deferred-work.md §intent_id 格式冲突]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

N/A — Markdown/YAML/JSON 文件创建，无代码执行。

### Completion Notes List

- **Task 1 (Schema/Template 更新):** 3 个文件更新。intent-statement.schema.json：acceptance_criteria 从平面字符串数组改为结构化对象数组（criterion/verification/priority required），constraints 从 must_not_violate/should_respect 改为 technical/security/scope 三子域，context_references 从字符串数组改为结构化对象（5 命名字段），meta 从 author/created_at/status/sdc_layer 改为 owner/priority/investment_hypothesis/estimated_ai_leverage/created/status（owner+status+created required）。intent-statement.yaml 模板完全重写，使用 5 组分隔注释风格。execution-contract.schema.json：must_pass/should_pass 条目 required 改为 [id,criterion,verification,source]，must_not_violate 改为 [id,constraint,source]，条目 id 增加 pattern 约束（MP/SP/MNV-NNN），新增顶层 generated_at 字段。
- **Task 2 (SKILL.md):** 从 sand-assess-maturity 模式创建。frontmatter 含 9 必填 + 6 可选字段，sdc_phase=intent，human_oversight=hip-2。激活正文含概述段 + 4 步导航 + 参考数据区。
- **Task 3 (customize.toml):** persistent_facts 引用 3 个 Intent 理论文档。
- **Task 4 (clear-checklist.yaml):** 从 clear-checklist.md 精确提取 20 项检查项。结构：dimensions(5) → items → {id, check, pass_criteria, fail_criteria}。含 execution_order 和 pass_thresholds 配置。C=5项、L=4项、E=5项、A=3项、R=3项。
- **Task 5 (step-01-scope):** 意图类型选择（5 类型 + 不确定引导）、范围信息收集（问题概要、业务关联、范围预估）、范围预检（大范围提醒分解）、.sand/ 目录初始化。
- **Task 6 (step-02-draft):** 按 5 组顺序引导式对话填写 7 字段。每字段通过提问引导而非表单填写。intent_id 自动生成（扫描已有文件 + 序号递增）。意图声明持久化到 .sand/intents/ + 创建审计事件。
- **Task 7 (step-03-clear-check):** C→E→A→L→R 顺序执行。C/E/A 由 AI 自动判定，L/R 引导用户 y/n 评估。结构化报告（维度×检查项表格）。三级汇总（pass/warn/fail）。warn 可修正或接受风险，fail 必须修正。通过后 Draft→Reviewed + 审计事件。
- **Task 8 (step-04-contract):** 自动映射（5 条规则 + source 追溯）。AI 补充建议（source=ai_derived）。条目 ID 格式（MP/SP/MNV-NNN）。用户审批后 Reviewed→Approved + 审计事件。完成总结含下一步建议。
- **Task 9 (验证):** SKILL.md frontmatter 9 必填字段验证。20 项检查项 grep 确认。4 step 文件 6 section 结构验证。Schema 字段结构与理论文档对齐验证。

### Change Log

- 2026-05-13: Story 2.1 实施完成。创建 sand-create-intent Skill 全部文件（7 NEW），更新 Schema 和 Template（3 UPDATE），删除占位符（1 DELETE）。

### File List

- schemas/intent-statement.schema.json (MODIFIED — 结构对齐 Story 2-0 理论)
- schemas/execution-contract.schema.json (MODIFIED — 增加 source/criterion/constraint required 字段)
- templates/intent-statement.yaml (MODIFIED — 结构对齐 Story 2-0 理论)
- sand/skills/sand-create-intent/SKILL.md (NEW)
- sand/skills/sand-create-intent/customize.toml (NEW)
- sand/skills/sand-create-intent/data/clear-checklist.yaml (NEW)
- sand/skills/sand-create-intent/steps/step-01-scope.md (NEW)
- sand/skills/sand-create-intent/steps/step-02-draft.md (NEW)
- sand/skills/sand-create-intent/steps/step-03-clear-check.md (NEW)
- sand/skills/sand-create-intent/steps/step-04-contract.md (NEW)
- sand/skills/sand-create-intent/.gitkeep (DELETED)
