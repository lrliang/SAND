# Story 5.1: 实现 sand-governance-audit Skill

Status: done

## Story

As a 架构师（赵明角色）,
I want 自动生成审计追踪报告展示 AI 决策的完整证据链,
so that 我可以向外部审计师证明 AI 决策的合理性和可追溯性。

## Acceptance Criteria

1. **审计事件扫描** — 给定 `.sand/audits/audit.jsonl` 中存在审计事件，当运行 `sand-governance-audit` 时，扫描指定时间范围内的所有审计事件，支持按 `intent_id`、`skill_name`、`sdc_phase`、`status`、`actor` 筛选
2. **证据链构建** — 给定审计事件已扫描，当构建意图→Skill→决策证据链时，每个 `intent_id` 可追溯到执行的 Skill 版本和人工确认点，证据链无断裂
3. **审计报告生成** — 给定证据链已构建，当生成审计追踪报告时，报告包含：Intent ID、意图声明摘要、执行契约版本、Skill 调用链、人工确认点、验证结果，报告可导出为 JSON/CSV 格式（FR30）
4. **赵明旅程验证** — 给定报告已生成，当模拟 SOC2 检查场景时，审计师可从报告中回答"AI 为什么做了这个决策"
5. **Skill 契约合规** — SKILL.md frontmatter 通过 `scripts/sand-skill-validate.sh` 验证（22/22 checks PASS），`sdc_phase = "governance"`

## Tasks / Subtasks

- [x] Task 1: 创建 `sand/skills/sand-governance-audit/SKILL.md` (AC: #5)
  - [x] 1.1 编写 sandskill.v1 frontmatter（9 个必填字段固定顺序 + 可选字段字母序），`sdc_phase = "governance"`，`requires: [file_read, file_write]`
  - [x] 1.2 `inputs` 声明 `.sand/audits/audit.jsonl`（主输入）和 `.sand/intents/` + `.sand/executions/`（辅助输入用于丰富证据链上下文）
  - [x] 1.3 `outputs` 声明审计报告路径（使用动态路径如 `.sand/audits/reports/AUD-{date}.yaml`，避免固定路径覆盖）
  - [x] 1.4 编写 Skill body：概述（审计追踪报告生成工作流）、理论基础引用（4 个来源）、Usage 节（3 步链接）、前置条件（需要 audit.jsonl 存在）、输出工件描述
  - [x] 1.5 删除 `sand/skills/sand-governance-audit/.gitkeep`
- [x] Task 2: 创建 `sand/skills/sand-governance-audit/customize.toml` (AC: #1-#4)
  - [x] 2.1 标准 `[workflow]` 块（4 个标准键）
  - [x] 2.2 `persistent_facts` 引用 4 个 Governance 理论文档（`file:{sand-root}/docs/02-development-cycle/governance/audit-governance.md` 等）
- [x] Task 3: 创建 `sand/skills/sand-governance-audit/steps/step-01-scan.md` (AC: #1)
  - [x] 3.1 MANDATORY EXECUTION RULES 标准块（5 条规则，参照 sand-validate-delivery 模式）
  - [x] 3.2 YOUR TASK：扫描 `.sand/audits/audit.jsonl` 中的审计事件
  - [x] 3.3 EXECUTION SEQUENCE：
    - §1: 检查 `.sand/audits/audit.jsonl` 存在性，不存在则 HALT 并建议先运行 Skill 产生审计数据
    - §2: 提示用户输入时间范围（默认：过去 4 周），支持 ISO-8601 格式
    - §3: 逐行解析 JSONL，按 `timestamp` 筛选在范围内的事件
    - §4: 提供可选筛选维度（intent_id, skill_name, sdc_phase, status, actor）
    - §5: 输出扫描摘要（总事件数、时间范围、唯一 intent 数、唯一 Skill 数、失败事件数）
  - [x] 3.4 SUCCESS METRICS + FAILURE MODES + NEXT STEP 指向 step-02-chain.md
- [x] Task 4: 创建 `sand/skills/sand-governance-audit/steps/step-02-chain.md` (AC: #2)
  - [x] 4.1 MANDATORY EXECUTION RULES 标准块
  - [x] 4.2 YOUR TASK：从扫描到的事件构建意图→Skill→决策证据链
  - [x] 4.3 EXECUTION SEQUENCE：
    - §1: 按 `intent_id` 分组事件（无 intent_id 的事件归入"未关联"分组）
    - §2: 每个 intent 组内按 `execution_id` 分组
    - §3: 每个执行会话内按 `timestamp` 排序事件
    - §4: 提取每条链路的 Skill 调用链（`skill_name@skill_version` 按顺序）
    - §5: 汇总 `human_confirmations` 记录（跨所有事件合并）
    - §6: 从 `.sand/executions/EXE-*/deviations.json` 提取关联偏差事件（如存在），以及从 `.sand/executions/EXE-*/validation-report.yaml` 提取验证结果（跨数据源聚合，参见 Deferred Work W3）
    - §7: 检测证据链完整性——标记缺失的 intent_id（有 execution 但无 intent）、缺失的 human_confirmations（HIP-2/3 下）、断裂的链路
  - [x] 4.4 SUCCESS METRICS + FAILURE MODES + NEXT STEP 指向 step-03-report.md
- [x] Task 5: 创建 `sand/skills/sand-governance-audit/steps/step-03-report.md` (AC: #3, #4)
  - [x] 5.1 MANDATORY EXECUTION RULES 标准块
  - [x] 5.2 YOUR TASK：从证据链生成结构化审计追踪报告
  - [x] 5.3 EXECUTION SEQUENCE：
    - §1: 从 `templates/audit-report.yaml` 初始化报告结构
    - §2: 填充 `report_metadata`（report_id 格式 AUD-YYYYMMDD-{seq}、时间范围、sand_version、统计数据）
    - §3: 填充 `evidence_summary`（每个 intent 一行摘要，含 Skill 链、确认计数、整体状态）
    - §4: 填充 `intent_details`（每个 intent 展开完整链路，含事件明细和偏差记录）
    - §5: 填充 `anomalies`（failures、interruptions、missing_confirmations 高亮）
    - §6: 填充 `compliance_mapping`（MVP 仅输出预留结构，不填充行业映射）
    - §7: 输出报告到 `.sand/audits/reports/AUD-{date}.yaml`
    - §8: 提供 JSON/CSV 导出选项（JSON = 完整结构化数据，CSV = 扁平化 evidence_summary 表）
    - §9: 展示赵明旅程式摘要——对每个 intent，用一句话回答"AI 为什么做了这个决策"
  - [x] 5.4 SUCCESS METRICS + FAILURE MODES
- [x] Task 6: 创建 `sand/skills/sand-governance-audit/templates/audit-report.yaml` (AC: #3)
  - [x] 6.1 从 `docs/02-development-cycle/governance/audit-governance.md` 中定义的报告结构创建 YAML 模板
  - [x] 6.2 包含 5 个顶层节（report_metadata、evidence_summary、intent_details、anomalies、compliance_mapping）
  - [x] 6.3 所有字段使用占位符值，便于 step-03 填充
  - [x] 6.4 YAML 格式遵循 2 空格缩进、true/false 布尔值、null 空值规范
- [x] Task 7: 运行 `sand-skill-validate.sh` 验证 + 最终检查 (AC: #5)
  - [x] 7.1 运行 `bash scripts/sand-skill-validate.sh sand/skills/sand-governance-audit/` 确认全部检查 PASS
  - [x] 7.2 验证 step 文件命名规范（step-01-scan.md, step-02-chain.md, step-03-report.md）
  - [x] 7.3 验证 customize.toml persistent_facts 路径指向实际存在的文件
  - [x] 7.4 验证模板 YAML 格式正确（无语法错误）

### Review Findings

- [x] [Review][Patch] F1: 输出路径不一致 — 统一为 AUD-{date}-{seq}.yaml（SKILL.md outputs + step-03 §7 正文） [SKILL.md + step-03-report.md] ✅ fixed
- [x] [Review][Patch] F2: inputs 字段未声明辅助数据源 — 追加 3 个辅助源（intents、deviations.json、validation-report.yaml）到 SKILL.md inputs [SKILL.md] ✅ fixed
- [x] [Review][Patch] F3: report_metadata 缺少 total_interruptions — 追加到模板和 step-03 §2 [audit-report.yaml + step-03-report.md] ✅ fixed
- [x] [Review][Patch] F4: template intent_details 缺少 intent_purpose — 追加 NOTE 到模板注释 [audit-report.yaml] ✅ fixed
- [x] [Review][Patch] F5: CSV skill_chain 序列化格式 — 指定 pipe (`|`) 连接 [step-03-report.md §8] ✅ fixed
- [x] [Review][Defer] W1: human_confirmations 去重键不含 event_id — 同步同步同决策的理论碰撞，Schema 无 confirmation_id 字段。边缘情况
- [x] [Review][Defer] W2: .sand/audits/reports/ 子目录无架构文档先例 — 架构仅定义 .sand/audits/audit.jsonl，reports 子目录为新增约定
- [x] [Review][Defer] W3: human_oversight hip-2 硬编码 vs 运行时动态读取 — 所有 Skill 均硬编码默认值，运行时覆盖是标准模式

## Dev Notes

### Story 本质

这是一个 **Skill 创作** Story——产出为 6 个文件（SKILL.md + customize.toml + 3 个 step 文件 + 1 个模板），构成完整的 `sand-governance-audit` Skill。与前序 Story 5-0（纯文档）不同，本 Story 产出的 Skill 需要通过 `sand-skill-validate.sh` 验证，且 step 文件需要设计为 AI Agent 可执行的引导工作流。

### 前序 Story 5-0 关键产出

**本 Story 直接依赖的理论文档（全部已完善）：**

| 文档 | 关键内容 | 本 Story 如何使用 |
|------|---------|-------------------|
| `docs/02-development-cycle/governance/audit-governance.md` | 六层证据链模型、审计报告 YAML 模板结构、审计事件生命周期（5 阶段）、赵明旅程示例 | step-01/02/03 的执行逻辑直接映射 |
| `docs/02-development-cycle/governance/compliance-governance.md` | 合规标准映射框架（ISO 42001/EU AI Act/NIST） | step-03 报告中 `compliance_mapping` 节的结构 |
| `docs/02-development-cycle/governance/quality-governance.md` | 三层审查策略、质量门禁 | 报告中质量指标参考 |
| `docs/02-development-cycle/governance/decision-governance.md` | 决策记录标准（human_confirmations 结构）、决策升级机制 | step-02 证据链中 human_confirmations 汇总逻辑 |

**Story 5-0 Review 已修复的关键发现（影响本 Story）：**
- F4: audit-report.yaml 路径已明确为 Skill 内部 `sand/skills/sand-governance-audit/templates/audit-report.yaml`
- F5: 证据链层级表新增 Context 层（sand_version + host + model_used）
- D1: 赵明旅程场景表定位为"叙事视角"，不严格对应六层模型

### 关键架构约束

**sand-governance-audit Skill 目录结构（Architecture 定义）：**
```
sand/skills/sand-governance-audit/
├── SKILL.md                    ← sandskill.v1 frontmatter + Skill 入口
├── customize.toml              ← 3 层 merge 定制化配置
├── steps/
│   ├── step-01-scan.md         ← 扫描 .sand/audits/ 审计事件
│   ├── step-02-chain.md        ← 构建意图→Skill→决策证据链
│   └── step-03-report.md       ← 生成审计追踪报告
└── templates/
    └── audit-report.yaml       ← 审计报告 YAML 模板
```

**SKILL.md Frontmatter 模式（从 sand-validate-delivery 提取）：**
```yaml
---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-governance-audit"
version: "0.1.0"
description: "审计追踪报告生成工作流——扫描审计事件、构建证据链、生成可导出报告"
sdc_phase: "governance"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - ".sand/audits/audit.jsonl"
outputs:
  - ".sand/audits/reports/AUD-{date}.yaml"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["governance", "audit", "compliance", "evidence-chain"]
---
```

**SandAuditEvent Schema 字段（step-01/02 解析目标）：**

| 字段 | Required | 用途（本 Skill） |
|------|----------|----------------|
| `event_id` (uuid) | ✅ | 事件去重 |
| `timestamp` (ISO-8601) | ✅ | 时间范围筛选 |
| `sand_version` | ✅ | 报告中的框架版本 |
| `intent_id` (INT-YYYYMMDD-{seq}) | ❌ | 证据链分组键 |
| `execution_id` (EXE-*) | ❌ | 执行会话分组键 |
| `skill_name` (sand-*) | ✅ | Skill 调用链 |
| `skill_version` (SemVer) | ✅ | 版本锁定记录 |
| `sdc_phase` (8 enums) | ✅ | 阶段筛选 |
| `step` (step-NN-*) | ❌ | 步骤级精确定位 |
| `actor` (human/agent) | ✅ | 执行者筛选 |
| `host` (4 enums) | ✅ | 宿主环境 |
| `model_used` | ❌ | AI 模型记录 |
| `input_hash` (sha256:*) | ❌ | 完整性校验 |
| `output_hash` (sha256:*) | ❌ | 完整性校验 |
| `status` (success/failure/interrupted) | ✅ | 异常事件检测 |
| `human_confirmations[]` | ❌ | 人工确认记录 |
| `error` (string/null) | ❌ | 失败原因 |

**审计报告 YAML 模板结构（从 audit-governance.md 提取）：**
```yaml
report_metadata:
  report_id: "AUD-YYYYMMDD-{seq}"
  generated_at: "ISO-8601 UTC"
  time_range: { from: "", to: "" }
  sand_version: ""
  total_events: 0
  total_intents: 0
  total_failures: 0
evidence_summary: []       # intent 级摘要
intent_details: []         # intent 级明细（含事件和偏差）
anomalies:
  failures: []
  interruptions: []
  missing_confirmations: []
compliance_mapping:        # MVP 预留结构
  iso_42001: []
  eu_ai_act: []
  nist_ai_rmf: []
```

### Step 文件编写规范（从 sand-validate-delivery 提取的模式）

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

### 跨数据源聚合策略（Deferred Work W3）

step-02-chain 需要从多个数据源聚合证据链：

| 数据源 | 位置 | 提供什么 |
|--------|------|---------|
| 审计事件 | `.sand/audits/audit.jsonl` | Intent→Execution→Skill→Step 链路 + human_confirmations |
| 偏差记录 | `.sand/executions/EXE-*/deviations.json` | 验证偏差事件（如存在） |
| 验证报告 | `.sand/executions/EXE-*/validation-report.yaml` | 验证结果（通过/有条件/打回/重定向） |
| 意图声明 | `.sand/intents/INT-*.yaml` | 意图 purpose 摘要（用于报告的 `intent_purpose` 字段） |

**设计策略：** 审计事件 JSONL 是主数据源（必须存在）。其他数据源为辅助丰富——如果不存在，step-02 应优雅处理（标记为"数据不可用"而非报错）。

### PRD 功能需求对齐

- **FR28:** 自动记录审计事件 — 本 Skill 消费这些事件（不产生）
- **FR29:** 生成审计追踪报告 — step-03 核心功能
- **FR30:** 报告可导出 JSON/CSV — step-03 §8
- **FR31:** 记录人工确认点 — step-02 汇总 human_confirmations

### Deferred Work 相关条目

**来自 Story 5-0 code review：**
- W1: quality_gates TOML 块无 Schema — 本 Story 的 customize.toml 不包含 quality_gates（属于未来 Skill 消费者）
- W2: config.yaml 无 risk-level 字段 — 本 Skill 不读取 risk-level
- **W3: Validation Results 层无直接 Schema 字段** — step-02 需实现跨数据源聚合（从 deviations.json 和 validation-report.yaml 补充）

**来自 Story 4-2 code review：**
- W4: SHA-256 拼接顺序未定义 — 本 Skill 读取 hash 但不计算，无影响
- W6: session_id EXE- 前缀 — step-02 按 `execution_id` 分组时需处理 EXE- 前缀

### Project Structure Notes

- 创建 `sand/skills/sand-governance-audit/SKILL.md` (NEW)
- 创建 `sand/skills/sand-governance-audit/customize.toml` (NEW)
- 创建 `sand/skills/sand-governance-audit/steps/step-01-scan.md` (NEW)
- 创建 `sand/skills/sand-governance-audit/steps/step-02-chain.md` (NEW)
- 创建 `sand/skills/sand-governance-audit/steps/step-03-report.md` (NEW)
- 创建 `sand/skills/sand-governance-audit/templates/audit-report.yaml` (NEW)
- 删除 `sand/skills/sand-governance-audit/.gitkeep` (DELETED)
- 不修改已有 Skill、Schema、模板或文档

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 5-1] — BDD 验收标准（行 661-695）
- [Source: _bmad-output/planning-artifacts/architecture.md#sand-governance-audit] — Skill 目录结构（行 715-719）
- [Source: _bmad-output/planning-artifacts/architecture.md#Audit Event Architecture] — 审计层设计原则（行 315-349）
- [Source: _bmad-output/planning-artifacts/architecture.md#.sand/ Directory] — 审计日志存储位置（行 352-393）
- [Source: _bmad-output/planning-artifacts/prd.md#治理与审计 FR28-FR31] — 功能需求（行 656-659）
- [Source: _bmad-output/planning-artifacts/prd.md#Journey 3 赵明] — 审计难题用户旅程（行 173-195）
- [Source: schemas/audit-event.schema.json] — SandAuditEvent 完整 JSON Schema（16 字段）
- [Source: docs/02-development-cycle/governance/audit-governance.md] — 审计治理理论（六层证据链、报告结构、赵明示例）
- [Source: docs/02-development-cycle/governance/compliance-governance.md] — 合规标准映射框架
- [Source: docs/02-development-cycle/governance/decision-governance.md] — 决策记录标准（human_confirmations 结构）
- [Source: sand/skills/sand-validate-delivery/SKILL.md] — SKILL.md frontmatter 模式参照
- [Source: sand/skills/sand-validate-delivery/customize.toml] — customize.toml 模式参照
- [Source: sand/skills/sand-validate-delivery/steps/step-01-contract-check.md] — step 文件 6 段结构模式参照
- [Source: _bmad-output/implementation-artifacts/5-0-governance-theory-foundation.md] — 前序 Story（理论基础，已完成）
- [Source: _bmad-output/implementation-artifacts/deferred-work.md] — 遗留设计决策（W3 跨数据源聚合）
- [Source: scripts/sand-skill-validate.sh] — Skill 契约验证脚本

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

N/A — Skill authoring story (Markdown + YAML files), no runtime debugging required.

### Completion Notes List

- Task 1: Created SKILL.md (~65 lines). sandskill.v1 frontmatter with 9 required fields (fixed order) + 6 optional fields (alphabetical). sdc_phase="governance", requires=[file_read, file_write], inputs=[.sand/audits/audit.jsonl], outputs=[.sand/audits/reports/AUD-{date}.yaml]. Body includes overview, 4 theory source references (Mikkonen, Wang MI9, ISO 42001, NIST), 3-step Usage links, prerequisites, auxiliary data sources, output artifacts. Deleted .gitkeep.
- Task 2: Created customize.toml (~17 lines). Standard [workflow] block with 4 keys. persistent_facts references 4 governance theory docs (audit-governance.md, compliance-governance.md, quality-governance.md, decision-governance.md). All 4 paths verified to exist.
- Task 3: Created step-01-scan.md (~100 lines). 6-section structure (title, mandatory rules, task, execution sequence, success metrics, failure modes). 5 execution subsections: §1 audit.jsonl existence check with HALT, §2 time range input (4 options including custom ISO-8601), §3 JSONL line-by-line parsing with timestamp filtering, §4 optional multi-dimension filtering (6 fields), §5 scan summary statistics output. Menu-driven user interaction.
- Task 4: Created step-02-chain.md (~130 lines). 7 execution subsections: §1 intent_id grouping (with _unlinked fallback), §2 execution_id subgrouping, §3 timestamp ordering with continuity check, §4 Skill call chain extraction (name@version), §5 human_confirmations cross-event merge and dedup, §6 cross-data-source enrichment (intent purpose from .sand/intents/, deviations from deviations.json, validation results from validation-report.yaml — all graceful fallback if missing), §7 evidence chain integrity detection (5 anomaly types: missing intent, missing confirmations, chain gaps, failures, hash inconsistency).
- Task 5: Created step-03-report.md (~160 lines). 9 execution subsections covering full report generation pipeline: §1 template initialization, §2 report_metadata with auto-sequenced report_id (AUD-YYYYMMDD-{seq}), §3 evidence_summary per-intent, §4 intent_details with full event data, §5 anomalies highlighting, §6 compliance_mapping (MVP placeholder), §7 YAML output to .sand/audits/reports/, §8 JSON/CSV export options (FR30), §9 Zhao Ming journey-style executive summary answering "why did AI make this decision".
- Task 6: Created templates/audit-report.yaml (~50 lines). 5 top-level sections (report_metadata, evidence_summary, intent_details, anomalies, compliance_mapping). All fields use null/0/[] placeholder values. Includes inline comments documenting expected structure for each array item. YAML format: 2-space indent, null for empty values.
- Task 7: Validation complete. sand-skill-validate.sh: 23/23 PASS (0 warnings). Step file naming verified (step-01-scan.md, step-02-chain.md, step-03-report.md). All 4 persistent_facts paths verified to exist. YAML template indentation validated (consistent 2-space).

### Change Log

- 2026-05-14: Story implementation complete. 6 files created (SKILL.md + customize.toml + 3 step files + 1 template), 1 .gitkeep deleted, all 7 tasks done. sand-skill-validate.sh 23/23 PASS.

### File List

- sand/skills/sand-governance-audit/SKILL.md (NEW)
- sand/skills/sand-governance-audit/customize.toml (NEW)
- sand/skills/sand-governance-audit/steps/step-01-scan.md (NEW)
- sand/skills/sand-governance-audit/steps/step-02-chain.md (NEW)
- sand/skills/sand-governance-audit/steps/step-03-report.md (NEW)
- sand/skills/sand-governance-audit/templates/audit-report.yaml (NEW)
- sand/skills/sand-governance-audit/.gitkeep (DELETED)
