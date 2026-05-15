# Story 6.1: 实现 sand-run-retrospective 基础版

Status: done

## Story

As a FDE+,
I want 通过引导式工作流完成 AI 复盘并输出结构化日志,
so that 每次 SDC 循环的经验可被捕获。

## Acceptance Criteria

1. **Skill 契约合规** — SKILL.md frontmatter 通过 `scripts/sand-skill-validate.sh` 验证（所有 checks PASS），`sdc_phase = "learn"`，`requires` 包含 file_read 和 file_write
2. **5 议题结构化引导** — 给定用户启动 sand-run-retrospective，当 Skill 进入 step-01-collect 时，按 5 个标准议题（意图质量回顾、编排有效性回顾、AI 杠杆分析、失败模式分析、资产化提名）依次引导结构化对话，每个议题基于 `docs/02-development-cycle/learn/ai-retrospective.md` 中定义的引导问题模板
3. **结构化日志输出** — 给定 5 个议题对话完成，当 Skill 生成输出时，输出结构化日志到 `.sand/retrospectives/{date}_retro.md`，日志格式与 `ai-retrospective.md` §复盘输出格式一致
4. **飞轮指标快照** — 给定结构化日志生成，日志末尾包含飞轮指标快照（资产复用率、意图首通率、循环周期压缩率），Phase 2 基础版数值由 AI 辅助计算 + 人类确认
5. **基础版范围限制** — 仅实现数据收集和结构化日志输出。不包含分析报告生成（趋势分析）和资产化入库建议（step-02-classify、step-03-register）——这些是 Story 6-2（Phase 3）范围

## Tasks / Subtasks

- [x] Task 1: 创建 `sand/skills/sand-run-retrospective/SKILL.md` (AC: #1)
  - [x] 1.1 编写 sandskill.v1 frontmatter（9 个必填字段固定顺序 + 可选字段字母序），`sdc_phase = "learn"`，`requires: [file_read, file_write]`
  - [x] 1.2 `inputs` 声明 `.sand/audits/audit.jsonl`（主输入——失败模式分析数据源）、`.sand/intents/`（意图质量回顾数据源）、`.sand/executions/`（编排有效性 + 失败模式辅助数据源）
  - [x] 1.3 `outputs` 声明 `.sand/retrospectives/{date}_retro.md`
  - [x] 1.4 编写 Skill body：概述（AI 复盘引导工作流，Phase 2 基础版）、理论基础引用（ai-retrospective.md、ai-asset-taxonomy.md）、Usage 节（step-01 链接）、前置条件说明、输出工件描述
  - [x] 1.5 删除 `sand/skills/sand-run-retrospective/.gitkeep`
- [x] Task 2: 创建 `sand/skills/sand-run-retrospective/customize.toml` (AC: #2)
  - [x] 2.1 标准 `[workflow]` 块（4 个标准键）
  - [x] 2.2 `persistent_facts` 引用 5 个 Learn 理论文档（`file:{sand-root}/docs/02-development-cycle/learn/ai-retrospective.md` 等）
- [x] Task 3: 创建 `sand/skills/sand-run-retrospective/steps/step-01-collect.md` (AC: #2, #3, #4)
  - [x] 3.1 MANDATORY EXECUTION RULES 标准块（5 条规则，参照 sand-governance-audit 模式）
  - [x] 3.2 YOUR TASK：引导用户完成 5 议题 AI 复盘并输出结构化日志
  - [x] 3.3 EXECUTION SEQUENCE：
    - §1: 检查数据源可用性——`.sand/audits/audit.jsonl` 和 `.sand/intents/` 存在性检查，不存在则警告（非 HALT——首次复盘可能无历史数据）
    - §2: 确认复盘类型——提示用户选择 micro/macro/deep（影响深度和时长），收集复盘元数据（SDC 循环 ID、参与者、时间范围）
    - §3: 议题 1「意图质量回顾」——从 `.sand/intents/` 扫描意图声明，计算 CLEAR 通过率和首通率（如数据可用），引导 3-4 个结构化问题，记录数据摘要 + 发现
    - §4: 议题 2「编排有效性回顾」——从 `.sand/executions/` 扫描执行数据（如可用），引导 3-4 个结构化问题，记录拓扑选型偏差和 HIP 评估
    - §5: 议题 3「AI 杠杆分析」——引导 4-5 个结构化问题（主要依赖人类观察，辅以审计数据），记录 AI 高/低价值介入点
    - §6: 议题 4「失败模式分析」——从 `.sand/audits/audit.jsonl` 扫描 status=failure/interrupted 事件（如可用），从 `.sand/executions/EXE-*/deviations.json` 提取偏差记录（如可用），分类为重复/新增/已缓解失败模式，计算 learning_signal 完整度
    - §7: 议题 5「资产化提名」——综合前 4 议题发现，引导用户提名资产化候选，每个候选标注 asset_type、source_topic、description、expected_reuse_frequency、confidence
    - §8: 飞轮指标快照——AI 辅助计算三指标（从 `.sand/` 数据推算，如数据不足则请求人工输入），用户确认数值
    - §9: 生成结构化日志——按 ai-retrospective.md §复盘输出格式 组装完整的复盘日志，初始化 `.sand/retrospectives/` 目录（如不存在），写入 `.sand/retrospectives/{YYYYMMDD}_retro.md`
  - [x] 3.4 SUCCESS METRICS + FAILURE MODES + 无 NEXT STEP（Phase 2 基础版仅此一个 step）
- [x] Task 4: 创建 `sand/skills/sand-run-retrospective/templates/retrospective.yaml` (AC: #3)
  - [x] 4.1 从 `ai-retrospective.md` §复盘输出格式 创建 YAML 模板——包含 metadata、5 个 topic 节、flywheel_metrics_snapshot
  - [x] 4.2 所有字段使用占位符值，便于 step-01 填充
  - [x] 4.3 YAML 格式遵循 2 空格缩进、true/false 布尔值、null 空值规范
- [x] Task 5: 运行 `sand-skill-validate.sh` 验证 + 最终检查 (AC: #1)
  - [x] 5.1 运行 `bash scripts/sand-skill-validate.sh sand/skills/sand-run-retrospective/` 确认全部检查 PASS
  - [x] 5.2 验证 step 文件命名规范（step-01-collect.md）
  - [x] 5.3 验证 customize.toml persistent_facts 路径指向实际存在的文件
  - [x] 5.4 验证模板 YAML 格式正确（无语法错误）

### Review Findings

- [x] [Review][Decision] D1: retrospective.yaml 模板为 YAML 但 step-01 输出 Markdown — 选项 2：删除 YAML 模板和 templates/ 目录（Phase 3 Story 6-2 定义自己需要的模板）[templates/retrospective.yaml] ✅ deleted
- [x] [Review][Patch] P1: §7 资产候选 YAML 新增 source_intent_id 字段（从 ai-retrospective.md 对齐）[step-01-collect.md] ✅ fixed
- [x] [Review][Patch] P2: §7 source_topic 枚举注释补充 assetization_nomination [step-01-collect.md] ✅ fixed
- [x] [Review][Patch] P3: §7 新增 suggested_by 字段（human/ai）+ 未经确认的 AI 建议不写入说明 [step-01-collect.md] ✅ fixed
- [x] [Review][Patch] P4: §9 Topic 4 输出新增 learning_signal 完整度独立行 [step-01-collect.md] ✅ fixed
- [x] [Review][Patch] P5: 文件名改为 `{YYYYMMDD}_retro_{seq}.md`（扫描已有文件取最大序号+1），同步更新 SKILL.md outputs [step-01-collect.md + SKILL.md] ✅ fixed
- [x] [Review][Patch] P6: 条件节改为 HTML 注释 `<!-- 仅 macro/deep 类型 -->` + 明确的子节标题，替代花括号包裹语法 [step-01-collect.md] ✅ fixed
- [x] [Review][Defer] W1: Topic 4 问题顺序与理论文档微调 — learning_signal 和已缓解模式的问题顺序与 ai-retrospective.md 略有交换，内容无遗漏 — 化妆品级差异
- [x] [Review][Defer] W2: inputs 使用裸目录路径而非 glob 模式 — `.sand/intents/` vs `.sand/intents/INT-*.yaml`，与 sand-governance-audit 约定不同。功能无影响，Phase 3 可统一
- [x] [Review][Defer] W3: step 内议题标签 [Step 1/5] 与 SKILL.md 的 [Step 1/1] 编号混淆 — 两级编号不矛盾但需 Phase 3 明确约定
- [x] [Review][Defer] W4: SKILL.md body 未直接引用 ai-asset-taxonomy.md — 通过 customize.toml persistent_facts 间接可用，但 body 仅引用 3 个理论来源

## Dev Notes

### Story 本质

这是一个 **Skill 创作** Story——产出为 4 个文件（SKILL.md + customize.toml + 1 个 step 文件 + 1 个模板），构成 `sand-run-retrospective` Skill 的 **Phase 2 基础版**。与 Story 5-1（sand-governance-audit）模式相同，但关键区别在于：

- **Phase 2 仅 1 个 step**：Architecture 定义了 3 个 step（collect/classify/register），但 Phase 2 基础版仅实现 step-01-collect.md
- **不创建 step-02 和 step-03**：资产分类和注册入库是 Story 6-2（Phase 3）范围
- **数据源可能不存在**：这是与 sand-governance-audit 的重大区别——首次复盘时 `.sand/` 中可能没有任何历史数据，step-01 必须优雅处理这种"冷启动"场景（警告但不 HALT）

### 前序 Story 6-0 关键产出

**本 Story 直接依赖的理论文档（全部已完善）：**

| 文档 | 关键内容 | 本 Story 如何使用 |
|------|---------|-------------------|
| `docs/02-development-cycle/learn/ai-retrospective.md` | 5 议题完整定义（目标 + 引导问题 + 产出格式 + 资产映射）、复盘频率、输出格式 | step-01-collect.md 的核心执行逻辑 |
| `docs/02-development-cycle/learn/ai-asset-taxonomy.md` | 5 类资产分类标准（定义 + YAML 格式 + 来源/消费阶段） | 议题 5 资产化提名的分类依据 |
| `docs/02-development-cycle/learn/flywheel-metrics.md` | 3 指标定义（计算方法 + 数据源 + 基准值） | step-01 §8 飞轮指标快照 |
| `docs/02-development-cycle/learn/assetization-process.md` | 4 步精炼流程（L2a-L2d） | Phase 2 仅执行 L2a（候选识别），完整流程留给 6-2 |
| `docs/02-development-cycle/learn/asset-lifecycle.md` | 置信度模型、衰减机制 | 资产候选的 confidence 初始值参考 |

**Story 6-0 Review 关键发现（影响本 Story）：**
- D1: 上下文资产消费阶段保持 Orchestrate only（飞轮图已修正）
- D2: .sand/assets/ 目录引用已移除（Phase 3 定义具体路径）
- P4: 意图首通率统一为"Draft → Validated"（flywheel-metrics.md 已修正）
- P5: 微循环复盘不含议题 5 资产候选（ai-retrospective.md 已修正）
- W1: source_topic 枚举需在本 Story 的 step-01 中定义完整映射

### 关键架构约束

**sand-run-retrospective Skill 目录结构（Architecture 定义 vs Phase 2 实际创建）：**

```
sand/skills/sand-run-retrospective/
├── SKILL.md                    ← NEW（本 Story）
├── customize.toml              ← NEW（本 Story）
├── steps/
│   ├── step-01-collect.md      ← NEW（本 Story）— 5 议题结构化回顾
│   ├── step-02-classify.md     ← Story 6-2 范围（Phase 3）
│   └── step-03-register.md     ← Story 6-2 范围（Phase 3）
└── templates/
    └── retrospective.yaml      ← NEW（本 Story）
```

**SKILL.md Frontmatter 模式（从 sand-governance-audit 提取 + 适配）：**
```yaml
---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-run-retrospective"
version: "0.1.0"
description: "AI 复盘引导工作流——5 议题结构化回顾 + 结构化日志输出（Phase 2 基础版）"
sdc_phase: "learn"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - ".sand/audits/audit.jsonl"
  - ".sand/intents/"
  - ".sand/executions/"
outputs:
  - ".sand/retrospectives/{date}_retro.md"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["learn", "retrospective", "assetization", "flywheel"]
---
```

**复盘输出 Markdown 模板（从 ai-retrospective.md §复盘输出格式提取）：**

```markdown
# AI 复盘日志 — {date}

## 元数据
- 复盘类型: micro / macro / deep
- SDC 循环 ID: {cycle_id}
- 参与者: {participants}
- 时间范围: {from} — {to}

## 议题 1: 意图质量回顾
### 数据摘要
{CLEAR 通过率表、首通率数值}
### 发现
{要点列表}
### 资产候选
{候选列表——仅 macro/deep 类型包含}

## 议题 2-5: {同上结构}

## 飞轮指标快照
- 资产复用率: {值}
- 意图首通率: {值}
- 循环周期压缩率: {值}
```

**数据源可用性矩阵（step-01 必须处理的场景）：**

| 数据源 | 路径 | 必须存在？ | 不存在时行为 |
|--------|------|-----------|-------------|
| 审计日志 | `.sand/audits/audit.jsonl` | 否 | 警告 + 议题 4 依赖人工回忆 |
| 意图声明 | `.sand/intents/INT-*.yaml` | 否 | 警告 + 议题 1 依赖人工回忆 |
| 执行记录 | `.sand/executions/EXE-*/` | 否 | 警告 + 议题 2 依赖人工回忆 |
| 偏差记录 | `.sand/executions/EXE-*/deviations.json` | 否 | 优雅降级——标记"数据不可用" |

**冷启动场景：** 首次使用 SAND 的团队运行复盘时，`.sand/` 可能完全为空。step-01 不能因此 HALT——必须切换到"全人工回忆模式"，仅引导结构化问题而不提取数据摘要。

### Step 文件编写规范（从 sand-governance-audit 提取的模式）

**6 段强制结构：**
1. `# Step {N}: {Title}` — 标题
2. `## MANDATORY EXECUTION RULES (READ FIRST):` — 5 条标准规则
3. `## YOUR TASK:` — 一句话目标
4. `## EXECUTION SEQUENCE:` — 编号子节（§1, §2, ...）
5. `## SUCCESS METRICS:` — ✅ 检查项
6. `## FAILURE MODES:` — ❌ 失败场景和处理

**标准 5 条执行规则（从现有 Skill 提取）：**
1. 读完整个步骤文件后再执行
2. 按顺序执行，不跳步
3. 遇到不确定性时请求人类确认（不猜测）
4. 每个子节完成后汇报进度
5. 失败时快速报错，不静默降级

### source_topic 完整枚举（解决 Deferred Work W1）

| 议题 | source_topic 值 |
|------|-----------------|
| 议题 1: 意图质量回顾 | `intent_quality` |
| 议题 2: 编排有效性回顾 | `orchestration_effectiveness` |
| 议题 3: AI 杠杆分析 | `ai_leverage` |
| 议题 4: 失败模式分析 | `failure_mode` |
| 议题 5: 资产化提名 | `assetization_nomination` |

### PRD 功能需求对齐

- **FR38:** FDE+ 可以通过引导式工作流完成 AI 复盘（5 议题标准），输出结构化日志 — step-01-collect.md 核心功能
- **FR40:** 系统可以追踪飞轮加速指标 — step-01 §8 飞轮指标快照（Phase 2 为手动/辅助计算）

**Phase 2 不实现的 FR（Story 6-2 范围）：**
- **FR39:** 基于复盘结果生成资产化入库建议 — step-02-classify + step-03-register

### 与前序 Story 的关系

**Dependencies:** Story 6-0（Learn 理论文档，已完成）

**引用链（customize.toml persistent_facts）：**
- `docs/02-development-cycle/learn/ai-retrospective.md` — 5 议题定义和引导问题
- `docs/02-development-cycle/learn/ai-asset-taxonomy.md` — 资产分类标准
- `docs/02-development-cycle/learn/flywheel-metrics.md` — 飞轮指标定义
- `docs/02-development-cycle/learn/assetization-process.md` — 候选识别逻辑
- `docs/02-development-cycle/learn/asset-lifecycle.md` — 置信度初始值参考

### Deferred Work 相关条目

**来自 Story 6-0 code review（直接影响本 Story）：**
- W1: source_topic 枚举不完整——**本 Story step-01 中定义完整枚举**（见上方表格）
- W5: 重复失败模式检测冷启动——**本 Story step-01 §6 需处理首轮无历史数据场景**

### Project Structure Notes

- 创建 `sand/skills/sand-run-retrospective/SKILL.md` (NEW)
- 创建 `sand/skills/sand-run-retrospective/customize.toml` (NEW)
- 创建 `sand/skills/sand-run-retrospective/steps/step-01-collect.md` (NEW)
- 创建 `sand/skills/sand-run-retrospective/templates/retrospective.yaml` (NEW)
- 删除 `sand/skills/sand-run-retrospective/.gitkeep` (DELETED)
- 不修改已有 Skill、Schema、模板或文档
- **不创建** step-02-classify.md 或 step-03-register.md（Story 6-2 范围）

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 6-1] — BDD 验收标准（行 737-759）
- [Source: _bmad-output/planning-artifacts/epics.md#Story 6-2] — Phase 3 完整版范围参照（行 763-792）
- [Source: _bmad-output/planning-artifacts/architecture.md#sand-run-retrospective] — Skill 目录结构定义（行 721-729）
- [Source: _bmad-output/planning-artifacts/architecture.md#.sand/ Directory Structure] — 复盘输出存储位置（行 380-381）
- [Source: _bmad-output/planning-artifacts/architecture.md#sandskill.v1 Contract] — 契约规范（行 264-300）
- [Source: _bmad-output/planning-artifacts/architecture.md#Step File Patterns] — step 文件 6 段结构（行 536-563）
- [Source: _bmad-output/planning-artifacts/prd.md#学习与资产化 FR38-FR40] — 功能需求（行 675-678）
- [Source: _bmad-output/planning-artifacts/prd.md#Phase 2 范围微调] — retrospective Phase 2/3 拆分（行 506-511）
- [Source: docs/02-development-cycle/learn/ai-retrospective.md] — 5 议题定义、引导问题、输出格式（Story 6-0 已完善）
- [Source: docs/02-development-cycle/learn/ai-asset-taxonomy.md] — 5 类资产分类标准（Story 6-0 已完善）
- [Source: docs/02-development-cycle/learn/flywheel-metrics.md] — 3 指标定义和基准值（Story 6-0 已完善）
- [Source: docs/02-development-cycle/learn/assetization-process.md] — L2a 候选识别逻辑（Story 6-0 已完善）
- [Source: sand/skills/sand-governance-audit/SKILL.md] — SKILL.md frontmatter 模式参照
- [Source: sand/skills/sand-governance-audit/customize.toml] — customize.toml 模式参照
- [Source: sand/skills/sand-governance-audit/steps/step-01-scan.md] — step 文件 6 段结构模式参照
- [Source: sand/skills/sand-governance-audit/templates/audit-report.yaml] — YAML 模板模式参照
- [Source: _bmad-output/implementation-artifacts/6-0-learn-theory-foundation.md] — 前序 Story（理论基础，已完成）
- [Source: _bmad-output/implementation-artifacts/5-1-sand-governance-audit-skill.md] — 同类型 Story 模式参照（Skill 创作）
- [Source: _bmad-output/implementation-artifacts/deferred-work.md] — W1 source_topic 枚举、W5 冷启动场景
- [Source: scripts/sand-skill-validate.sh] — Skill 契约验证脚本

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

N/A — Skill authoring story (Markdown + YAML files), no runtime debugging required.

### Completion Notes List

- Task 1: Created SKILL.md (~65 lines). sandskill.v1 frontmatter with 9 required fields (fixed order) + 6 optional fields (alphabetical). sdc_phase="learn", requires=[file_read, file_write], inputs=[.sand/audits/audit.jsonl, .sand/intents/, .sand/executions/], outputs=[.sand/retrospectives/{date}_retro.md]. Body includes overview (Phase 2 basic version scope), 3 theory source references (Hassan SE 3.0, Mikkonen, flywheel metrics), Usage section (1 step for Phase 2, noting Phase 3 additions), prerequisites (no hard requirements — cold start supported), data sources table (4 optional sources), output artifacts description. Deleted .gitkeep.
- Task 2: Created customize.toml (~18 lines). Standard [workflow] block with 4 keys. persistent_facts references 5 Learn theory docs (ai-retrospective.md, ai-asset-taxonomy.md, flywheel-metrics.md, assetization-process.md, asset-lifecycle.md). All 5 paths verified to exist.
- Task 3: Created step-01-collect.md (~220 lines). 6-section structure (title, mandatory rules, task, execution sequence, success metrics, failure modes). 9 execution subsections: §1 data source availability check (4 sources, graceful degradation to human recall mode), §2 retro type selection (micro/macro/deep) + metadata collection, §3-§6 topics 1-4 each with data extraction (if available) + guided questions (3-5 per topic) + structured output recording, §7 topic 5 asset nomination (skipped for micro type) with YAML candidate format + AI-assisted suggestions, §8 flywheel metrics snapshot (3 metrics with N/A fallback), §9 structured log generation to .sand/retrospectives/{YYYYMMDD}_retro.md. Cold start scenario: all data sources unavailable → human recall mode without HALT. Micro retro: topics 1-4 only, skip topic 5. source_topic enum fully defined (intent_quality, orchestration_effectiveness, ai_leverage, failure_mode, assetization_nomination).
- Task 4: Created templates/retrospective.yaml (~75 lines). Structured YAML template with metadata (retro_type, cycle_id, participants, time_range, data_sources, status), 5 topic sections (each with topic_id, name, source_topic, data_summary, findings, asset_candidates), learning_signal_completeness for topic 4, flywheel_metrics_snapshot (3 metrics + notes). All fields use null/0/[]/false placeholders. YAML: 2-space indent, null for empty values.
- Task 5: Validation complete. sand-skill-validate.sh: 23/23 PASS (0 warnings). Step file naming verified (step-01-collect.md). All 5 persistent_facts paths verified to exist. YAML template format validated.

### Change Log

- 2026-05-15: Story implementation complete. 4 files created (SKILL.md + customize.toml + 1 step file + 1 template), 1 .gitkeep deleted, all 5 tasks done. sand-skill-validate.sh 23/23 PASS.

### File List

- sand/skills/sand-run-retrospective/SKILL.md (NEW)
- sand/skills/sand-run-retrospective/customize.toml (NEW)
- sand/skills/sand-run-retrospective/steps/step-01-collect.md (NEW)
- sand/skills/sand-run-retrospective/templates/retrospective.yaml (NEW)
- sand/skills/sand-run-retrospective/.gitkeep (DELETED)
