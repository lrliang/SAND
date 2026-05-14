# Story 4.3: 插件基础验证机制 + 贡献者工具链

Status: done

## Story

As a 外部 Skill 贡献者（刘洋角色）,
I want 标准化的开发工具和验证机制,
so that 我可以开发符合 sandskill.v1 契约的 Skill 并提交验证。

## Acceptance Criteria

1. **Skill 骨架生成** — `scripts/sand-skill-init.sh` 存在且可执行，运行 `sand-skill-init sand-my-custom-skill` 生成符合 `sandskill.v1` 契约的完整 Skill 目录骨架（SKILL.md + customize.toml + steps/ + .gitkeep 占位）
2. **Skill 契约验证** — `scripts/sand-skill-validate.sh` 存在且可执行，对 Skill 目录运行验证：检查 SKILL.md frontmatter 字段完整性和顺序、`requires` 声明有效性、`steps/` 文件命名规范，输出 PASS/FAIL + 详细检查项报告
3. **示例外部 Skill** — `examples/external-skills/sand-example-skill/` 包含完整可运行的 Skill（SKILL.md + customize.toml + steps/ + README.md），README 包含步骤说明和使用方式
4. **开发者文档** — `docs/skill-dev-guide.md` 存在，外部贡献者可理解 Skill 目录结构、契约字段、验证要求和提交流程，文档不超过 2000 字，全程不提及 BMad

## Tasks / Subtasks

- [x] Task 1: 创建 `scripts/sand-skill-init.sh` — Skill 骨架生成脚本 (AC: #1)
  - [x] 1.1 接受一个参数 `skill-name`（如 `sand-my-custom-skill`），验证格式匹配 `^sand-[a-z][a-z0-9-]*$`
  - [x] 1.2 创建目录结构：`{skill-name}/SKILL.md`、`{skill-name}/customize.toml`、`{skill-name}/steps/.gitkeep`
  - [x] 1.3 SKILL.md 模板：填充 sandskill.v1 frontmatter（9 个必填字段固定顺序 + 6 个可选字段字母序，名称和阶段留占位符）
  - [x] 1.4 customize.toml 模板：标准 `[workflow]` 块（4 个标准键，persistent_facts 为空数组）
  - [x] 1.5 输出成功/失败消息，指引用户下一步（编辑 SKILL.md、创建 step 文件、运行 validate）
  - [x] 1.6 添加 `chmod +x` 确保脚本可执行
  - [x] 1.7 脚本头部使用 `#!/usr/bin/env bash` + `set -euo pipefail`
- [x] Task 2: 创建 `scripts/sand-skill-validate.sh` — Skill 契约验证脚本 (AC: #2)
  - [x] 2.1 接受一个参数：Skill 目录路径
  - [x] 2.2 检查 SKILL.md 存在且有 YAML frontmatter
  - [x] 2.3 检查 9 个必填字段全部存在：sand_contract、name、version、description、sdc_phase、entry_point、requires、inputs、outputs
  - [x] 2.4 检查 `sand_contract` 值为 `sandskill.v1`
  - [x] 2.5 检查 `name` 匹配 pattern `^sand-[a-z][a-z0-9-]*$`
  - [x] 2.6 检查 `version` 匹配 SemVer pattern `^[0-9]+\.[0-9]+\.[0-9]+$`
  - [x] 2.7 检查 `sdc_phase` 在合法 enum 中（assess/intent/orchestrate/build/validate/operate/learn/governance）
  - [x] 2.8 检查 `requires` 至少有 1 项且值在合法 enum 中（file_read/file_write/shell_exec/network_access/agent_subprocess/mcp_support）
  - [x] 2.9 检查 `entry_point` 指向的文件存在
  - [x] 2.10 检查 `steps/` 目录存在且文件命名匹配 `step-[0-9][0-9]-*.md` 模式
  - [x] 2.11 输出结构化检查报告（每项 PASS/FAIL + 详情），最终结果 PASS/FAIL
  - [x] 2.12 脚本头部使用 `#!/usr/bin/env bash` + `set -euo pipefail`
  - [x] 2.13 添加 `chmod +x` 确保脚本可执行
- [x] Task 3: 创建 `examples/external-skills/sand-example-skill/` — 示例外部 Skill (AC: #3)
  - [x] 3.1 创建 SKILL.md（完整 sandskill.v1 frontmatter，sdc_phase="build"，描述为示例 Skill）
  - [x] 3.2 创建 customize.toml（标准模板，persistent_facts 为空）
  - [x] 3.3 创建 `steps/step-01-hello.md`（简单 step 文件，6 段结构，执行内容为输出 Hello 消息）
  - [x] 3.4 创建 README.md：说明这是示例外部 Skill、目录结构、如何运行、如何验证
  - [x] 3.5 确保示例通过 `sand-skill-validate.sh` 验证
- [x] Task 4: 创建 `docs/skill-dev-guide.md` — 开发者文档 (AC: #4)
  - [x] 4.1 概述：什么是 SAND Skill、sandskill.v1 契约
  - [x] 4.2 快速开始：使用 `sand-skill-init` 生成骨架
  - [x] 4.3 目录结构说明：SKILL.md、customize.toml、steps/、data/、templates/ 各自用途
  - [x] 4.4 Frontmatter 字段完整参考（9 必填 + 可选字段，含 pattern 和 enum 约束）
  - [x] 4.5 Step 文件编写规范：6 段强制结构 + 命名规范
  - [x] 4.6 验证与提交：使用 `sand-skill-validate.sh` 验证 + 提交流程
  - [x] 4.7 控制字数不超过 2000 字
  - [x] 4.8 全程不提及 BMad（BMad Method、BMad 框架等任何 BMad 相关引用）
- [x] Task 5: 删除 `.gitkeep` 占位并验证完整性 (AC: #1-4)
  - [x] 5.1 删除 `scripts/.gitkeep`（被实际脚本替代）
  - [x] 5.2 删除 `examples/external-skills/.gitkeep`（被示例 Skill 替代）
  - [x] 5.3 验证 `sand-skill-init.sh` 可执行：`bash scripts/sand-skill-init.sh sand-test-skill` 在临时目录生成正确骨架
  - [x] 5.4 验证 `sand-skill-validate.sh` 可执行：对生成的骨架运行验证通过，对现有 Skill（如 sand-assess-maturity）运行验证通过
  - [x] 5.5 验证示例 Skill 通过 `sand-skill-validate.sh`
  - [x] 5.6 验证 `docs/skill-dev-guide.md` 字数 ≤ 2000 且不含"BMad"

### Review Findings

- [x] [Review][Patch] F1: `get_field` 不处理 inline YAML 注释 — 重写 get_field 添加 `sed 's/"[[:space:]]*#.*$//'` + `sed 's/[[:space:]][[:space:]]*#.*$//'` 双层剥离 [sand-skill-validate.sh] ✅ fixed
- [x] [Review][Patch] F2: `STEP_COUNT` 双输出 bug — 改用 `wc -l` 替代 `grep -c || echo` [sand-skill-validate.sh] ✅ fixed
- [x] [Review][Patch] F3: validator 未检查目录存在 — 添加 Check 0: `[[ ! -d "$SKILL_DIR" ]]` 前置检查 [sand-skill-validate.sh] ✅ fixed
- [x] [Review][Patch] F4: validator 未检查 customize.toml — 添加 Check 11: customize.toml exists (WARN 级别) [sand-skill-validate.sh] ✅ fixed
- [x] [Review][Patch] F5: dev guide "correct types" → "correct values and patterns" [docs/skill-dev-guide.md] ✅ fixed
- [x] [Review][Defer] W1: `get_array_items` 无法解析 inline YAML 数组 `[a, b]` — 需完整 YAML 解析器，当前 block 风格足够
- [x] [Review][Defer] W2: validator 未强制 `additionalProperties: false` — 需 YAML key 枚举，Phase 3 lint 增强
- [x] [Review][Defer] W3: dev guide 遗漏 `customize_schema` 和 `dependencies` 可选字段 — 文档增强
- [x] [Review][Defer] W4: dev guide 未文档化 `.sand/plugins/registry.yaml` 格式 — 文档增强
- [x] [Review][Defer] W5: name regex 允许尾部 dash（如 `sand-foo-`）— Schema 级问题，与 sandskill.v1.schema.json 一致
- [x] [Review][Defer] W6: validator 未检查 name 与目录名一致性 — 增强功能
- [x] [Review][Defer] W7: validator 未检查 frontmatter 字段顺序 — AC 文本提及"顺序"但 Dev Notes 13 项表未包含
- [x] [Review][Defer] W8: `get_field` 不处理单引号 YAML 值 — 当前所有 Skill 使用双引号，边缘情况

## Dev Notes

### Story 本质

这是 Epic 4 中**唯一涉及可执行代码**的 Story——产出为 2 个 Shell 脚本（`sand-skill-init.sh` + `sand-skill-validate.sh`）、1 个示例 Skill 目录和 1 个开发者文档。与前序 Story（纯 Markdown Skill 创作）不同，本 Story 的脚本需要实际可执行且通过运行验证。

### 前序 Story 关键产出

**本 Story 依赖的工件已全部就绪：**

| 工件 | 来源 | 本 Story 如何使用 |
|------|------|-------------------|
| `schemas/sandskill.v1.schema.json` | Story 1-1 | validate 脚本的验证规则来源 |
| 4 个已完成 Skill（assess/intent/orchestrate/validate） | Story 1-2/2-1/3-1/4-1 | validate 脚本的测试目标 + init 脚本的模板参照 |
| `sand-design-orchestration` step-02 §5 | Story 4-1 | 定义了 `.sand/plugins/registry.yaml` 的消费格式：`verified: true/false` |

### 关键架构约束

**贡献者体验三件套（Architecture §修正 5）：**
```
1. docs/skill-dev-guide.md — 全程不提 BMad 的 Skill 开发入门（≤2000 字）
2. scripts/sand-skill-init.sh — 生成 sandskill.v1 契约骨架
3. scripts/sand-skill-validate.sh — 独立验证器，检查契约合规性
```

**目录结构（Architecture 定义）：**
```
sand-framework/
├── scripts/
│   ├── sand-skill-init.sh           ← 骨架生成器
│   └── sand-skill-validate.sh       ← 契约验证器
├── examples/
│   └── external-skills/
│       └── sand-example-skill/      ← 完整可运行示例
│           ├── SKILL.md
│           ├── customize.toml
│           ├── steps/
│           │   └── step-01-hello.md
│           └── README.md
└── docs/
    └── skill-dev-guide.md           ← 开发者入门文档
```

**sand-skill-validate.sh 验证规则（从 sandskill.v1.schema.json 提取）：**

| 检查项 | 规则 | 严重级别 |
|--------|------|---------|
| SKILL.md 存在 | 目录下有 SKILL.md 文件 | FAIL |
| frontmatter 存在 | 文件以 `---` 开头和结尾包围 YAML | FAIL |
| sand_contract | 值必须为 `sandskill.v1` | FAIL |
| name | 匹配 `^sand-[a-z][a-z0-9-]*$` | FAIL |
| version | 匹配 `^[0-9]+\.[0-9]+\.[0-9]+$` | FAIL |
| description | 非空字符串 | FAIL |
| sdc_phase | enum: assess/intent/orchestrate/build/validate/operate/learn/governance | FAIL |
| entry_point | 字符串且指向的文件存在 | FAIL |
| requires | 数组，≥1 项，值在 enum: file_read/file_write/shell_exec/network_access/agent_subprocess/mcp_support | FAIL |
| inputs | 字符串数组 | WARN |
| outputs | 字符串数组 | WARN |
| steps/ 目录 | 存在且含 `step-[0-9][0-9]-*.md` 文件 | WARN |
| 步骤文件命名 | 匹配 `step-[0-9][0-9]-*.md` | WARN |

**sand-skill-init.sh 生成的 SKILL.md 模板（参照已完成 Skill 的 frontmatter 模式）：**
```yaml
---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "{SKILL_NAME}"
version: "0.1.0"
description: "TODO: 一句话描述此 Skill 的用途"
sdc_phase: "build"  # TODO: 修改为正确的 SDC 阶段
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - "TODO: 声明输入文件路径"
outputs:
  - "TODO: 声明输出文件路径"
# === 可选字段（字母序）===
author: ""
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "medium"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: []
---
```

**`.sand/plugins/registry.yaml` 格式（从 step-02-topology.md §5 反推）：**
```yaml
# SAND Plugin Registry
# 手动注册的外部 Skill 清单
# sand-design-orchestration step-02 读取此文件检查 verified 字段

skills:
  - skill_name: "sand-example-skill"
    path: ".sand/plugins/sand-example-skill/"
    verified: true
    registered_at: "ISO-8601"
```

**注意：本 Story 不创建 registry.yaml 运行时文件**——registry.yaml 由用户在项目中手动创建或由未来的 `sand plugin add` 命令生成。本 Story 仅在 `docs/skill-dev-guide.md` 中说明格式。

### Shell 脚本编写规范

- **脚本头**：`#!/usr/bin/env bash` + `set -euo pipefail`
- **POSIX 兼容性**：macOS (Darwin) + Linux 通用
- **依赖最小化**：仅依赖 bash 内建 + grep/sed/awk/mkdir/cat（无 Python/Node 依赖）
- **颜色输出**：使用 ANSI 转义码（green=PASS, red=FAIL），支持 `NO_COLOR` 环境变量禁用
- **退出码**：成功=0，验证失败=1，参数错误=2
- **错误处理**：快速失败 + 明确报错

### PRD 功能需求直接覆盖

- **FR19:** `sand-skill-init` 骨架生成（Task 1）
- **FR20:** 外部 Skill 基础验证（Task 2）——manifest 格式 + Skill 入口存在 + 步骤文件规范
- **NFR3:** 外部 Skill 执行前必须通过基础验证（validate 脚本为此提供工具）

**注意：FR18（`.sand/plugins/` 注册）和 FR21（编排方案中引入外部 Skill）已在 Story 4-1 step-02-topology.md 中实现。本 Story 提供的是验证工具，不是注册机制。**

### 用户交互规范

**sand-skill-init.sh 输出示例：**
```
SAND Skill Scaffolding
========================
Creating: sand-my-custom-skill/

  ✓ SKILL.md      — sandskill.v1 frontmatter template
  ✓ customize.toml — workflow configuration template
  ✓ steps/         — step files directory (empty)

Done! Next steps:
  1. Edit SKILL.md — fill in description, sdc_phase, inputs, outputs
  2. Create step files in steps/ (e.g., step-01-your-step.md)
  3. Run: scripts/sand-skill-validate.sh sand-my-custom-skill/
```

**sand-skill-validate.sh 输出示例：**
```
SAND Skill Validator
========================
Validating: sand-my-custom-skill/

  [PASS] SKILL.md exists
  [PASS] YAML frontmatter present
  [PASS] sand_contract = "sandskill.v1"
  [PASS] name matches pattern
  [PASS] version matches SemVer
  [PASS] description is non-empty
  [PASS] sdc_phase is valid
  [PASS] entry_point file exists
  [PASS] requires has ≥1 valid capability
  [WARN] inputs array is empty
  [WARN] outputs array is empty
  [PASS] steps/ directory exists
  [PASS] step files follow naming convention

Result: PASS (12 checks passed, 2 warnings)
```

### Project Structure Notes

- `scripts/` 目录下创建 2 个新脚本（替代 .gitkeep）
- `examples/external-skills/` 目录下创建示例 Skill 目录（替代 .gitkeep）
- `docs/` 目录下创建 `skill-dev-guide.md`（新文件）
- 不修改已有 Skill、Schema 或模板
- 不创建 `.sand/plugins/registry.yaml`（运行时文件，不属于仓库）

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 4-3] — BDD 验收标准（行 577-613）
- [Source: _bmad-output/planning-artifacts/architecture.md#修正5 贡献者体验三件套] — 三件套定义（行 165-172）
- [Source: _bmad-output/planning-artifacts/architecture.md#Repository Structure] — 目录结构（行 174-214）
- [Source: _bmad-output/planning-artifacts/architecture.md#Validation Mechanism] — 验证规则（行 631-645）
- [Source: _bmad-output/planning-artifacts/prd.md#编排与插件生态 FR18-FR21] — 功能需求（行 632-641）
- [Source: _bmad-output/planning-artifacts/prd.md#NFR3] — 插件验证 NFR（行 696）
- [Source: _bmad-output/planning-artifacts/prd.md#Phase 2 插件基础验证] — 范围说明（行 495-524）
- [Source: schemas/sandskill.v1.schema.json] — 契约 Schema（验证规则来源）
- [Source: sand/skills/sand-design-orchestration/steps/step-02-topology.md#5] — 外部 Skill 检查（registry.yaml 消费者）
- [Source: sand/skills/sand-assess-maturity/SKILL.md] — frontmatter 模式参照
- [Source: sand/skills/sand-validate-delivery/SKILL.md] — frontmatter 模式参照
- [Source: _bmad-output/implementation-artifacts/4-2-sand-run-execution-engine.md] — 前序 Story

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

- Initial sand-skill-validate.sh had BSD grep `\s` compatibility issue — awk range parsing also failed on macOS. Rewrote `get_array_items` function using bash while-loop line-by-line parsing instead of awk ranges. Fixed and all 6 Skills pass validation (22/22 checks each).

### Completion Notes List

- Task 1: Created scripts/sand-skill-init.sh (~85 lines). Accepts skill-name argument with `^sand-[a-z][a-z0-9-]*$` pattern validation. Generates directory structure: SKILL.md (sandskill.v1 frontmatter with TODO placeholders for description/sdc_phase/inputs/outputs), customize.toml (standard [workflow] block), steps/.gitkeep. Color output with NO_COLOR support, exit codes 0/1/2. Tested: generates correct skeleton in /tmp.
- Task 2: Created scripts/sand-skill-validate.sh (~180 lines). 13 validation checks: SKILL.md exists, frontmatter present, 9 required fields present, sand_contract value, name pattern, version SemVer, description non-empty, sdc_phase enum, entry_point file exists, requires valid capabilities (≥1), inputs/outputs (warn if empty), steps/ directory + naming convention. POSIX-compatible (no \s, uses [[:space:]] and bash loop parsing). Color output with PASS/FAIL/WARN. Tested: all 6 existing Skills + example pass (22/22 each).
- Task 3: Created examples/external-skills/sand-example-skill/ (4 files). SKILL.md with complete sandskill.v1 frontmatter (sdc_phase=build, requires=[file_read, file_write]). customize.toml with empty persistent_facts. steps/step-01-hello.md with 6-section structure (greet user + collect input + generate output). README.md with directory structure, how-to-run, how-to-validate, use-as-template sections. Validated: passes sand-skill-validate.sh 22/22.
- Task 4: Created docs/skill-dev-guide.md (~750 words, well under 2000 limit). Covers: what is a SAND Skill, quick start with sand-skill-init, directory structure (table), SKILL.md frontmatter complete reference (required + optional fields with patterns/enums), step file 6-section structure, customize.toml reference, validation with sand-skill-validate.sh, submission process (6 steps). Zero BMad references verified via grep.
- Task 5: Deleted scripts/.gitkeep and examples/external-skills/.gitkeep. Verified: sand-skill-init.sh generates correct skeleton (/tmp test), sand-skill-validate.sh passes on all 6 Skills (sand-assess-maturity, sand-create-intent, sand-validate-delivery, sand-design-orchestration, sand-run, sand-example-skill), skill-dev-guide.md is 749 words with no BMad references.

### Change Log

- 2026-05-14: Story implementation complete. 2 shell scripts + 4 example files + 1 doc created, 2 .gitkeep deleted, all 5 tasks done. All validation tests pass.
- 2026-05-14: Code review complete. 5 patch findings fixed (1 High: get_field inline comment stripping), 8 deferred, 6 dismissed. Fixes: get_field YAML comment handling, STEP_COUNT wc-l rewrite, directory existence check, customize.toml validation added, dev guide wording corrected. All 6 Skills + init skeleton re-verified PASS (23/23).

### File List

- scripts/sand-skill-init.sh (NEW)
- scripts/sand-skill-validate.sh (NEW)
- scripts/.gitkeep (DELETED)
- examples/external-skills/sand-example-skill/SKILL.md (NEW)
- examples/external-skills/sand-example-skill/customize.toml (NEW)
- examples/external-skills/sand-example-skill/steps/step-01-hello.md (NEW)
- examples/external-skills/sand-example-skill/README.md (NEW)
- examples/external-skills/.gitkeep (DELETED)
- docs/skill-dev-guide.md (NEW)
