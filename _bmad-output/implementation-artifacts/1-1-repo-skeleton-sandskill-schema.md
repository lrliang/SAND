# Story 1.1: 框架仓库骨架 + sandskill.v1 契约 Schema

Status: review

## Story

As a SAND Skill 开发者,
I want 一个标准化的仓库结构和 Skill 契约定义,
so that 所有后续 Skill 开发有一致的基础设施和约束。

## Acceptance Criteria

1. 存在 `sand/skills/`、`schemas/`、`templates/`、`scripts/`、`examples/external-skills/` 目录结构
2. 存在 `.sand-version`（内容 `0.1.0`）、`CHANGELOG.md`、`LICENSE`（MIT）
3. 存在 `CLAUDE.md`（Claude Code Agent 入口配置）和 `CURSOR_RULES.md`（Cursor Agent 入口配置）
4. `.gitignore` 增加 `.sand/` 排除规则（保留现有规则不破坏）
5. `schemas/sandskill.v1.schema.json` 存在且可验证合规的 SKILL.md frontmatter——必填字段（sand_contract, name, version, description, sdc_phase, entry_point, requires, inputs, outputs）全部校验，可选字段允许缺省
6. `schemas/audit-event.schema.json` 存在且定义了 SandAuditEvent 完整结构（event_id, timestamp, sand_version, intent_id, execution_id, skill_name, skill_version, sdc_phase, step, actor, host, model_used, input_hash, output_hash, status, human_confirmations, error）
7. `schemas/` 下还存在 intent-statement、execution-contract、maturity-assessment、orchestration-plan 的 schema 文件
8. `templates/` 下存在 intent-statement.yaml、execution-contract.yaml、maturity-assessment.yaml、orchestration-plan.yaml、sand-config.yaml 模板文件，且模板符合对应 schema 结构
9. `sand/skills/` 下存在所有 Phase 1-3 Skill 的空目录占位（仅目录 + .gitkeep，不含实际文件）

## Tasks / Subtasks

- [x] Task 1: 创建仓库目录结构 (AC: #1, #9)
  - [x] 1.1 创建 `sand/skills/` 及所有 Skill 子目录占位（.gitkeep）
  - [x] 1.2 创建 `schemas/` 目录
  - [x] 1.3 创建 `templates/` 目录
  - [x] 1.4 创建 `scripts/` 目录（Phase 2 占位，含 .gitkeep）
  - [x] 1.5 创建 `examples/external-skills/` 目录（Phase 2 占位，含 .gitkeep）
- [x] Task 2: 创建根目录配置文件 (AC: #2, #3, #4)
  - [x] 2.1 创建 `.sand-version`（内容 `0.1.0`）
  - [x] 2.2 创建 `CHANGELOG.md`（初始版本）
  - [x] 2.3 创建 `LICENSE`（MIT）
  - [x] 2.4 更新 `.gitignore`（追加 `.sand/` 和相关排除规则）
  - [x] 2.5 创建 `CLAUDE.md`（Claude Code Agent 入口）
  - [x] 2.6 创建 `CURSOR_RULES.md`（Cursor Agent 入口）
- [x] Task 3: 编写 sandskill.v1 契约 Schema (AC: #5)
  - [x] 3.1 编写 `schemas/sandskill.v1.schema.json`（必填字段 + 可选字段 + 枚举约束）
- [x] Task 4: 编写 SandAuditEvent Schema (AC: #6)
  - [x] 4.1 编写 `schemas/audit-event.schema.json`（完整事件结构）
- [x] Task 5: 编写其余 JSON Schema 集 (AC: #7)
  - [x] 5.1 编写 `schemas/intent-statement.schema.json`
  - [x] 5.2 编写 `schemas/execution-contract.schema.json`
  - [x] 5.3 编写 `schemas/maturity-assessment.schema.json`
  - [x] 5.4 编写 `schemas/orchestration-plan.schema.json`
- [x] Task 6: 创建 YAML 模板集 (AC: #8)
  - [x] 6.1 创建 `templates/intent-statement.yaml`
  - [x] 6.2 创建 `templates/execution-contract.yaml`
  - [x] 6.3 创建 `templates/maturity-assessment.yaml`
  - [x] 6.4 创建 `templates/orchestration-plan.yaml`
  - [x] 6.5 创建 `templates/sand-config.yaml`

## Dev Notes

### Story 本质

这是一个**基础设施搭建** Story——创建目录结构、JSON Schema 文件和 YAML 模板。不涉及 Skill 实现或可执行代码。所有产出是文件系统结构 + 声明式数据文件。

### 关键上下文：棕地项目

当前项目是一个**已有 80+ 文件**的棕地项目。关键现有资产：
- `docs/` — 方法论文档体系（已有 80+ 文件，Story 1-0 刚完善了部分）
- `.claude/skills/` — 包含 **50+ BMad 开发工具 Skill**（bmad-create-story、bmad-dev-story 等）。这些是**开发工具**，不是 SAND 框架的产品 Skill
- `.gitignore` — 已有规则（OS、IDE、环境变量、`.claude/`）
- `_bmad/` 和 `_bmad-output/` — BMad 开发基础设施

**关键区分：**
- `.claude/skills/bmad-*` = BMad 开发工具（用于构建 SAND 的工具链）
- `sand/skills/sand-*` = SAND 框架 Skills（正在构建的产品）

### .claude/skills/ 适配层注意事项

Architecture 设计目标是 `.claude/skills -> ../sand/skills`（symlink）。但当前 `.claude/skills/` 已包含 50+ BMad Skills。**本 Story 不修改 `.claude/skills/`**——symlink 适配留到框架发布时处理。SAND Skills 直接在 `sand/skills/` 下开发。

### 必须创建的 Skill 目录占位

以下目录需要在 `sand/skills/` 下创建（仅目录 + `.gitkeep`，不含实际文件）：

**Phase 1 Skills:**
- `sand-assess-maturity/`
- `sand-create-intent/`
- `sand-validate-delivery/`

**Phase 2 Skills:**
- `sand-design-orchestration/`
- `sand-run/`
- `sand-governance-audit/`
- `sand-run-retrospective/`

**Phase 3 Skills:**
- `sand-measure-light/`
- `sand-agent-domain-lead/`
- `sand-agent-fde/`
- `sand-agent-catalyst/`

### sandskill.v1 Schema 精确定义

从 Architecture §sandskill.v1 Contract Specification 提取。**必填字段**按以下固定顺序：

```yaml
sand_contract: "sandskill.v1"          # 固定值
name: "sand-{kebab-case}"             # 格式约束：sand- 前缀 + kebab-case
version: "0.1.0"                      # SemVer 格式
description: "一句话描述"              # 非空字符串
sdc_phase: "assess"                   # 枚举：assess|intent|orchestrate|build|validate|operate|learn|governance
entry_point: "SKILL.md"              # 相对路径
requires:                             # 宿主能力声明数组
  - file_read
  - file_write
inputs:                               # 输入声明数组（glob 或显式路径）
  - "{sand-root}/templates/..."
outputs:                              # 输出声明数组
  - ".sand/assessments/..."
```

**可选字段**（字母序，不受兼容承诺约束）：
- `author`: string
- `customize_schema`: string
- `dependencies`: array of strings（Phase 3）
- `human_oversight`: enum "hip-1"|"hip-2"|"hip-3"
- `license`: string
- `model_requirement`: object { reasoning: string, context_window: string }
- `sand_min_version`: string（SemVer）
- `tags`: array of strings

### SandAuditEvent Schema 精确定义

从 Architecture §Audit Event Architecture 提取：

| 字段 | 类型 | 必填 | 约束 |
|------|------|------|------|
| event_id | string | 是 | UUID v4 格式 |
| timestamp | string | 是 | ISO-8601 UTC |
| sand_version | string | 是 | SemVer |
| intent_id | string | 否 | 格式 INT-YYYYMMDD-{seq} |
| execution_id | string | 否 | 格式 EXE-{session_id} |
| skill_name | string | 是 | sand-{kebab-case} |
| skill_version | string | 是 | SemVer |
| sdc_phase | string | 是 | 枚举 8 值 |
| step | string | 否 | 格式 step-{NN}-{name} |
| actor | string | 是 | 枚举 human\|agent |
| host | string | 是 | 枚举 claude-code\|cursor\|codex-cli\|gemini-cli |
| model_used | string | 否 | 自由字符串 |
| input_hash | string | 否 | 格式 sha256:... |
| output_hash | string | 否 | 格式 sha256:... |
| status | string | 是 | 枚举 success\|failure\|interrupted |
| human_confirmations | array | 否 | 对象数组 { step, timestamp, decision } |
| error | string/null | 否 | 错误信息或 null |

### YAML 模板设计指导

每个模板应是"最小可用"的 YAML 文件，包含所有必填字段的占位值和注释说明。开发者可直接复制模板开始填写。

**格式规则**（Architecture §2 YAML Artifact Patterns）：
- 缩进：2 空格
- 布尔值：true/false
- 空值：null
- 数组：多行格式
- 编码：UTF-8，LF 换行

### CLAUDE.md 内容指导

CLAUDE.md 是 Claude Code 的 Agent 入口配置文件。应包含：
- SAND 框架简介（一段话）
- 可用的 SAND Skills 目录和简述
- 如何运行 Skill 的指令
- `{sand-root}` 路径解析说明
- 不应包含 BMad 相关内容

### CURSOR_RULES.md 内容指导

与 CLAUDE.md 类似，但针对 Cursor IDE 的规则格式。应包含：
- SAND 框架简介
- Skill 目录引用（`sand/skills/`）
- 运行指令
- 不应包含 BMad 相关内容

### .gitignore 追加规则

在现有 `.gitignore` 基础上追加：
```
# SAND Runtime Artifacts
.sand/
```

**不要修改或删除**现有的 `.gitignore` 规则（OS、IDE、环境变量、`.claude/`）。

### 不要做的事

- **不要**创建 Skill 的实际内容文件（SKILL.md、steps/、data/）——这些在后续 Story 中创建
- **不要**修改 `.claude/skills/` 下的任何 BMad Skill
- **不要**创建 `sand-skill-init.sh` 或 `sand-skill-validate.sh`——这些是 Phase 2 Story 4-3 的交付物
- **不要**创建 `docs/adr/` 下的 ADR 文件——留到后续 Story
- **不要**创建 `docs/skill-dev-guide.md`——Phase 2 交付物
- **不要**修改 `docs/` 下已有的 80+ 文件
- **不要**创建 `plugin-registry.schema.json`——Phase 2 交付物

### 前置 Story 完成情况

**Story 1-0（Assess 理论基础）**：已完成 ✅
- 完善了 5 个文档文件（ai-native-definition.md、non-deterministic-paradigm.md、maturity-framework.md、gap-analysis.md、assess-tools.md）
- Code Review 发现的所有问题已修复（Cao 引用移除、路径修正等）
- maturity-framework.md 中的 7 维度 × L1-L5 量表为本 Story 的 maturity-assessment.schema.json 和模板设计提供语义基础

### Project Structure Notes

新建文件和目录均在项目根目录下创建，不嵌套在任何已有目录中（除 `.gitignore` 的追加）。

完整创建清单：
```
sand/skills/sand-assess-maturity/.gitkeep
sand/skills/sand-create-intent/.gitkeep
sand/skills/sand-validate-delivery/.gitkeep
sand/skills/sand-design-orchestration/.gitkeep
sand/skills/sand-run/.gitkeep
sand/skills/sand-governance-audit/.gitkeep
sand/skills/sand-run-retrospective/.gitkeep
sand/skills/sand-measure-light/.gitkeep
sand/skills/sand-agent-domain-lead/.gitkeep
sand/skills/sand-agent-fde/.gitkeep
sand/skills/sand-agent-catalyst/.gitkeep
schemas/sandskill.v1.schema.json
schemas/audit-event.schema.json
schemas/intent-statement.schema.json
schemas/execution-contract.schema.json
schemas/maturity-assessment.schema.json
schemas/orchestration-plan.schema.json
templates/intent-statement.yaml
templates/execution-contract.yaml
templates/maturity-assessment.yaml
templates/orchestration-plan.yaml
templates/sand-config.yaml
scripts/.gitkeep
examples/external-skills/.gitkeep
.sand-version
CHANGELOG.md
LICENSE
CLAUDE.md
CURSOR_RULES.md
.gitignore (MODIFY — append only)
```

### References

- [Source: _bmad-output/planning-artifacts/architecture.md §sandskill.v1 Contract Specification]
- [Source: _bmad-output/planning-artifacts/architecture.md §Audit Event Architecture]
- [Source: _bmad-output/planning-artifacts/architecture.md §.sand/ Directory Structure & Data Flow]
- [Source: _bmad-output/planning-artifacts/architecture.md §Complete Project Directory Structure]
- [Source: _bmad-output/planning-artifacts/architecture.md §Implementation Patterns & Consistency Rules (8 域)]
- [Source: _bmad-output/planning-artifacts/architecture.md §Decision Impact Analysis]
- [Source: _bmad-output/planning-artifacts/prd.md §Skill 契约版本化]
- [Source: _bmad-output/planning-artifacts/prd.md §Template & Artifact Format Standards]
- [Source: _bmad-output/planning-artifacts/prd.md §Version Management Strategy]
- [Source: _bmad-output/planning-artifacts/epics.md §Story 1-1]
- [Source: docs/02-development-cycle/assess/maturity-framework.md §YAML 化提取指南（maturity-assessment 模板参考）]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

N/A — infrastructure story, no runtime debugging.

### Completion Notes List

- **Task 1:** Created 11 Skill directories under `sand/skills/` with `.gitkeep` files, plus `schemas/`, `templates/`, `scripts/`, `examples/external-skills/` directories. Total: 15 directories, 13 `.gitkeep` files.
- **Task 2:** Created `.sand-version` (0.1.0), `CHANGELOG.md` (Keep a Changelog format), `LICENSE` (MIT 2026), `CLAUDE.md` (Claude Code agent config), `CURSOR_RULES.md` (Cursor IDE rules). Updated `.gitignore` with `.sand/` exclusion (append only, existing rules preserved).
- **Task 3:** Created `schemas/sandskill.v1.schema.json` — 9 required fields, 8 optional fields, enum constraints for `sdc_phase` (8 values), `requires` (6 capabilities), `human_oversight` (3 HIP levels). Pattern validation for `name` (sand-kebab-case) and `version` (SemVer).
- **Task 4:** Created `schemas/audit-event.schema.json` — 9 required fields, 8 optional fields. Enum constraints for `status` (3 values), `actor` (2), `host` (4), `sdc_phase` (8). Pattern validation for `event_id` (UUID), `intent_id` (INT-YYYYMMDD-seq), `input_hash`/`output_hash` (sha256:hex64).
- **Task 5:** Created 4 additional schemas: intent-statement (7 required), execution-contract (5 required), maturity-assessment (5 required, dimensions array constrained to exactly 7 items), orchestration-plan (4 required, topology enum 4 values).
- **Task 6:** Created 5 YAML templates with comments linking to their schemas. All use 2-space indentation, multi-line arrays. maturity-assessment.yaml pre-populates all 7 dimension names in Chinese. sand-config.yaml is minimal (4 fields).

### Change Log

- 2026-05-13: Story 1.1 implemented. Created complete framework skeleton: 15 directories, 6 JSON Schemas, 5 YAML templates, 6 root config files, 1 .gitignore update.

### File List

- sand/skills/sand-assess-maturity/.gitkeep (NEW)
- sand/skills/sand-create-intent/.gitkeep (NEW)
- sand/skills/sand-validate-delivery/.gitkeep (NEW)
- sand/skills/sand-design-orchestration/.gitkeep (NEW)
- sand/skills/sand-run/.gitkeep (NEW)
- sand/skills/sand-governance-audit/.gitkeep (NEW)
- sand/skills/sand-run-retrospective/.gitkeep (NEW)
- sand/skills/sand-measure-light/.gitkeep (NEW)
- sand/skills/sand-agent-domain-lead/.gitkeep (NEW)
- sand/skills/sand-agent-fde/.gitkeep (NEW)
- sand/skills/sand-agent-catalyst/.gitkeep (NEW)
- schemas/sandskill.v1.schema.json (NEW)
- schemas/audit-event.schema.json (NEW)
- schemas/intent-statement.schema.json (NEW)
- schemas/execution-contract.schema.json (NEW)
- schemas/maturity-assessment.schema.json (NEW)
- schemas/orchestration-plan.schema.json (NEW)
- templates/intent-statement.yaml (NEW)
- templates/execution-contract.yaml (NEW)
- templates/maturity-assessment.yaml (NEW)
- templates/orchestration-plan.yaml (NEW)
- templates/sand-config.yaml (NEW)
- scripts/.gitkeep (NEW)
- examples/external-skills/.gitkeep (NEW)
- .sand-version (NEW)
- CHANGELOG.md (NEW)
- LICENSE (NEW)
- CLAUDE.md (NEW)
- CURSOR_RULES.md (NEW)
- .gitignore (MODIFIED — appended .sand/ rule)
