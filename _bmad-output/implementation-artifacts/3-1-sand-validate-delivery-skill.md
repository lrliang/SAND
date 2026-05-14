# Story 3.1: 实现 sand-validate-delivery Skill

Status: done

## Story

As a FDE+,
I want 对交付物运行三通道并行验证获得结构化验证决策,
so that AI 生成的代码在合并前有系统性的质量保障。

## Acceptance Criteria

1. **Skill 契约合规** — `SKILL.md` frontmatter 通过 `sandskill.v1.schema.json` 验证，`sdc_phase = "validate"`，`requires` 包含 `file_read, file_write`
2. **契约验证通道** — `step-01-contract-check.md` 逐条检查 must_pass/should_pass/must_not_violate，输出每条的通过/未通过状态
3. **安全合规通道** — `step-02-security.md` 检查常见安全风险（注入、XSS、敏感数据泄露等），包含非阻塞许可证警告提示（FR25）
4. **架构对齐通道** — `step-03-architecture.md` 检查交付物是否符合架构约束（命名规范、目录结构、依赖关系等）
5. **验证决策输出** — `step-04-decision.md` 基于决策矩阵生成结构化决策（pass/conditional_pass/reject_to_build/redirect_to_intent），输出验证报告到 `.sand/executions/EXE-{session_id}/validation-report.yaml`
6. **偏差记录** — 验证结果与意图声明存在偏差时，偏差事件记录到 `.sand/executions/EXE-{session_id}/deviations.json`，包含 deviation_type、severity、suggested_action

## Tasks / Subtasks

- [x] Task 1: 创建 `sand/skills/sand-validate-delivery/SKILL.md` (AC: #1)
  - [x] 1.1 编写 sandskill.v1 frontmatter（必填字段按固定顺序 + 可选字段按字母序）
  - [x] 1.2 编写激活入口（Markdown body：Skill 概述 + 激活指令指向 step-01）
  - [x] 1.3 验证 frontmatter 字段与 `schemas/sandskill.v1.schema.json` 一致
- [x] Task 2: 创建 `sand/skills/sand-validate-delivery/customize.toml` (AC: #1)
  - [x] 2.1 定义 `[workflow]` 块：activation_steps_prepend/append、persistent_facts、on_complete
  - [x] 2.2 persistent_facts 引用三个 Validate 理论文档（three-channel.md、decision-matrix.md、deviation-tracking.md）
- [x] Task 3: 编写 `steps/step-01-contract-check.md` — 契约验证通道 (AC: #2)
  - [x] 3.1 加载执行契约（从 `.sand/intents/contracts/{intent_id}.contract.yaml`）
  - [x] 3.2 加载交付物清单（Build 阶段产出）
  - [x] 3.3 逐条验证 must_pass 条目（计算控制：每条标记 pass/fail）
  - [x] 3.4 逐条验证 should_pass 条目（计算控制：未通过记录为 warning）
  - [x] 3.5 逐条检查 must_not_violate 约束（计算控制 + 推断控制）
  - [x] 3.6 验收标准覆盖率检查（每条 acceptance_criteria 至少有一个验证结果）
  - [x] 3.7 意图对齐度分析（FR26：推断控制，AI 分析交付物与 purpose/desired_outcome 的语义对齐度）
  - [x] 3.8 输出通道结果（PASS/PASS_WITH_WARNINGS/FAIL）+ 逐条检查结果列表
- [x] Task 4: 编写 `steps/step-02-security.md` — 安全合规通道 (AC: #3)
  - [x] 4.1 注入漏洞检查（SQL/NoSQL/Command/XSS）
  - [x] 4.2 敏感数据泄露检查（日志/错误信息/响应体）
  - [x] 4.3 认证/授权边界检查（最小权限原则）
  - [x] 4.4 依赖安全性检查（新增依赖无已知高危 CVE）
  - [x] 4.5 许可证合规检查（FR25：非阻塞 warning，建议手动检查工具）
  - [x] 4.6 密钥/凭证硬编码检查
  - [x] 4.7 上下文安全检查（FR32：若意图授权发送完整代码文件，验证审计事件已记录）
  - [x] 4.8 输出通道结果 + 逐条检查结果列表
- [x] Task 5: 编写 `steps/step-03-architecture.md` — 架构对齐通道 (AC: #4)
  - [x] 5.1 命名规范一致性检查（warning 级别）
  - [x] 5.2 目录结构规范检查（blocking 级别）
  - [x] 5.3 依赖方向检查（blocking 级别）
  - [x] 5.4 架构模式一致性检查（warning 级别）
  - [x] 5.5 API 契约一致性检查（blocking 级别）
  - [x] 5.6 代码复用检查（anti-Cargo Cult，warning 级别）
  - [x] 5.7 输出通道结果 + 逐条检查结果列表
- [x] Task 6: 编写 `steps/step-04-decision.md` — 验证决策矩阵 (AC: #5, #6)
  - [x] 6.1 合并三通道结果（PASS/PASS_WITH_WARNINGS/FAIL）
  - [x] 6.2 应用 14 行优先级判定表生成决策（pass/conditional_pass/reject_to_build/redirect_to_intent）
  - [x] 6.3 pass 决策：生成验证报告，标记交付物已验证
  - [x] 6.4 conditional_pass 决策：生成验证报告 + tech_debt_items 列表
  - [x] 6.5 reject_to_build 决策：生成修复指引 fix_guidance + other_channel_warnings
  - [x] 6.6 redirect_to_intent 决策：生成意图修正建议 intent_correction
  - [x] 6.7 记录偏差事件到 `.sand/executions/EXE-{session_id}/deviations.json`
  - [x] 6.8 HIP 级别人类确认（按 hip_level 确认决策结果）
  - [x] 6.9 输出完整验证报告到 `.sand/executions/EXE-{session_id}/validation-report.yaml`
- [x] Task 7: 创建 `templates/validation-report.yaml` (AC: #5)
  - [x] 7.1 定义验证报告 YAML 模板（session_id、intent_id、overall_result、channels breakdown、decision）
- [x] Task 8: 删除 `.gitkeep` 并验证目录完整性 (AC: #1-6)
  - [x] 8.1 删除 `sand/skills/sand-validate-delivery/.gitkeep`
  - [x] 8.2 验证最终目录结构与 Architecture 定义一致
  - [x] 8.3 验证 SKILL.md frontmatter 字段顺序和必填字段
  - [x] 8.4 交叉验证 step 文件中的检查项与 `three-channel.md` 理论定义一致

### Review Findings

- [x] [Review][Patch] F1: Session ID 双前缀风险 — step-01 改为生成无 EXE- 前缀的 ID，路径保持 EXE-{session_id} [step-01:27] ✅ fixed
- [x] [Review][Patch] F2: overall_result 计算逻辑缺失 — step-04 section 6 添加显式合并逻辑说明 [step-04] ✅ fixed
- [x] [Review][Patch] F3: Template 缺少 channels_summary — decision 块增加 channels_summary 字段 [template] ✅ fixed
- [x] [Review][Patch] F4: auto_resolved 不在理论枚举中 — step-04 添加注释说明实现扩展 [step-04] ✅ fixed
- [x] [Review][Patch] F5: execution.yaml phantom input — 从 SKILL.md inputs 移除 [SKILL.md] ✅ fixed
- [x] [Review][Patch] F6: step-03 判定逻辑与输出状态词汇不一致 — 伪代码改用 "warning" 匹配 + 添加注释说明 [step-03] ✅ fixed
- [x] [Review][Patch] F7: fix_guidance 缺少 revalidation_required — step-04 section 3c 添加字段 [step-04] ✅ fixed
- [x] [Review][Defer] D1: 空 must_pass 数组产生空 PASS — deferred, 运行时输入验证
- [x] [Review][Defer] D2: Session ID seq 碰撞无防护 — deferred, 运行时文件系统扫描
- [x] [Review][Defer] D3: verification method 无工具降级路径 — deferred, 运行时降级策略
- [x] [Review][Defer] D4: 零依赖项目 CVE 检查未定义 — deferred, 添加 not_applicable 状态
- [x] [Review][Defer] D5: 无法检测前序 step 部分完成 — deferred, 运行时状态管理
- [x] [Review][Defer] D6: 重复运行 deviations.json 覆盖 — deferred, 幂等性设计
- [x] [Review][Defer] D7: 扁平项目依赖方向检查误报 — deferred, 检查适用性判断
- [x] [Review][Defer] D8: FR32 假设 audit.jsonl 存在 — deferred, 文件存在性检查

## Dev Notes

### 前序 Story 关键产出

**Story 3-0（Validate 理论基础）已完成，产出 4 个理论文档作为本 Story 的直接输入：**

| 理论文档 | 映射到本 Story 的文件 | 关键操作化内容 |
|---------|---------------------|-------------|
| `docs/02-development-cycle/validate/three-channel.md` | step-01, step-02, step-03 | 三通道检查项表格（每通道含控制类型、判定标准、阻塞级别）+ 通道判定伪代码 |
| `docs/02-development-cycle/validate/decision-matrix.md` | step-04 | 14 行显式优先级判定表 + 四种决策输出格式（YAML） |
| `docs/02-development-cycle/validate/deviation-tracking.md` | step-04（偏差记录部分） | 12 字段偏差事件结构 + deviations.json 持久化格式 |
| `docs/02-development-cycle/validate/validation-assets.md` | N/A（Phase 3 拉动） | 不在本 Story 范围 |

**Story 3-0 Review 遗留的 6 项 Deferred Work（D1-D6）本 Story 需处理：**

| ID | 问题 | 建议处理方式 |
|----|------|-----------|
| D1 | 意图偏差信号在非 contract-FAIL 场景下未定义 | step-04 中明确：意图偏差信号仅在 contract=FAIL 且 security/architecture 非 FAIL 时参与判定（已在修正后的 14 行判定表中体现） |
| D2 | 三通道无 ERROR/TIMEOUT 状态 | 每个 step 文件增加"FAILURE MODE"段落：若通道执行出错，默认按 FAIL 处理并在 deviation 中记录 source 为执行错误 |
| D3 | source_channel 单值，跨通道偏差不可表示 | 同一底层问题在多通道触发时，创建多条偏差事件各归属所在通道，共享 `description` 中的交叉引用说明 |
| D4 | info 级偏差自动 resolved 无法重新分类 | step-04 中 info 偏差仍输出到 deviations.json，标记 `resolution: "auto_resolved"`，FDE+ 可在后续复盘中手动覆盖 |
| D5 | learning_signal 可选导致飞轮退化 | step-04 偏差记录时提示 AI 生成 learning_signal 建议，标记为"AI 建议，待人类确认" |
| D6 | 通道内计算/推断控制冲突 | step 文件中明确：计算控制结果优先（确定性），推断控制结果作为补充信息附加到 warning/info |

### 已建立的 Skill 实现模式（从 Story 1-2 和 2-1 提取）

**SKILL.md frontmatter 必填字段固定顺序：**
```yaml
---
sand_contract: "sandskill.v1"
name: "sand-validate-delivery"
version: "0.1.0"
description: "三通道并行验证工作流——契约验证、安全合规、架构对齐"
sdc_phase: "validate"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - ".sand/intents/contracts/{intent_id}.contract.yaml"
  - ".sand/executions/EXE-{session_id}/execution.yaml"
outputs:
  - ".sand/executions/EXE-{session_id}/validation-report.yaml"
  - ".sand/executions/EXE-{session_id}/deviations.json"
# === Optional (alphabetical) ===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["validation", "three-channel", "delivery"]
---
```

**customize.toml 模式：**
```toml
[workflow]
activation_steps_prepend = []
activation_steps_append = []
persistent_facts = [
  "file:{sand-root}/docs/02-development-cycle/validate/three-channel.md",
  "file:{sand-root}/docs/02-development-cycle/validate/decision-matrix.md",
  "file:{sand-root}/docs/02-development-cycle/validate/deviation-tracking.md",
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

**目标目录结构（Architecture 定义）：**
```
sand/skills/sand-validate-delivery/
├── SKILL.md                         ← sandskill.v1 frontmatter + 激活入口
├── customize.toml                   ← persistent_facts → 3 个理论文档
├── steps/
│   ├── step-01-contract-check.md    ← 契约验证通道（must_pass/should_pass/must_not_violate）
│   ├── step-02-security.md          ← 安全合规通道（7 检查项）
│   ├── step-03-architecture.md      ← 架构对齐通道（6 检查项）
│   └── step-04-decision.md          ← 决策矩阵 + 偏差记录 + 报告生成
└── templates/
    └── validation-report.yaml       ← 验证报告 YAML 模板
```

**注意：不创建 data/ 目录。** 与 sand-assess-maturity（data/dimension-rubrics.yaml）和 sand-create-intent（data/clear-checklist.yaml）不同，sand-validate-delivery 的检查项直接写在 step 文件中——因为验证检查是上下文敏感的（依赖交付物内容），不适合静态 YAML 数据文件。

**输出路径：**
- `.sand/executions/EXE-{session_id}/validation-report.yaml` — 验证报告（从 templates/validation-report.yaml 初始化）
- `.sand/executions/EXE-{session_id}/deviations.json` — 偏差事件（JSON 格式）

**验证报告 YAML 结构（从 three-channel.md 操作化）：**
```yaml
validation_report:
  session_id: "EXE-{session_id}"
  intent_id: "INT-YYYYMMDD-{seq}"
  timestamp: "ISO-8601"
  overall_result: "pass | pass_with_warnings | fail"
  channels:
    contract:
      result: "pass | pass_with_warnings | fail"
      must_pass_results: [{ id: "MP-001", status: "pass|fail", evidence: "..." }]
      should_pass_results: [{ id: "SP-001", status: "pass|fail", evidence: "..." }]
      must_not_violate_results: [{ id: "MNV-001", status: "pass|violated", evidence: "..." }]
      intent_alignment_score: null
    security:
      result: "pass | pass_with_warnings | fail"
      check_results: [{ check: "injection", status: "pass|fail", detail: "..." }]
      license_warnings: [{ dependency: "...", license: "...", compatible: true|false }]
    architecture:
      result: "pass | pass_with_warnings | fail"
      check_results: [{ check: "naming_convention", status: "pass|fail|warning", detail: "..." }]
  decision:
    result: "pass | conditional_pass | reject_to_build | redirect_to_intent"
    timestamp: "ISO-8601"
    next_action: "operate | build | intent"
    tech_debt_items: []
    fix_guidance: null
    other_channel_warnings: []
    intent_correction: null
    human_confirmation:
      required: true
      hip_level: "hip-2"
      confirmed_by: null
      confirmed_at: null
  deviations: []
  human_review_required: true
  hip_level: "hip-2"
```

**偏差事件 JSON 结构（从 deviation-tracking.md 操作化）：**
```json
{
  "session_id": "EXE-{session_id}",
  "intent_id": "INT-YYYYMMDD-{seq}",
  "validation_timestamp": "ISO-8601",
  "total_deviations": 0,
  "severity_summary": { "blocking": 0, "warning": 0, "info": 0 },
  "deviations": []
}
```

**14 行决策矩阵优先级表（从 decision-matrix.md 操作化，step-04 必须严格遵循）：**

| # | 契约 | 安全 | 架构 | 意图偏差 | 决策 |
|---|------|------|------|---------|------|
| 1 | PASS | PASS | PASS | — | pass |
| 2 | PASS | PASS_W | PASS | — | conditional_pass |
| 3 | PASS | PASS | PASS_W | — | conditional_pass |
| 4 | PASS_W | PASS | PASS | — | conditional_pass |
| 5 | PASS | PASS_W | PASS_W | — | conditional_pass |
| 6 | PASS_W | PASS | PASS_W | — | conditional_pass |
| 7 | PASS_W | PASS_W | PASS | — | conditional_pass |
| 8 | PASS_W | PASS_W | PASS_W | — | conditional_pass |
| 9 | — | FAIL | — | — | reject_to_build |
| 10 | — | — | FAIL | — | reject_to_build |
| 11 | FAIL | PASS/W | PASS/W | 有 | redirect_to_intent |
| 12 | FAIL | PASS/W | PASS/W | 无 | reject_to_build |
| 13 | FAIL | FAIL | — | — | reject_to_build |
| 14 | FAIL | — | FAIL | — | reject_to_build |

### 用户交互规范

- **菜单格式**：主菜单 `[A]`/`[P]`/`[C]`，选项列表 `1.`/`2.`/`3.`，确认 `(y/n)` 或 `[C] 继续`
- **进度反馈**：每步开始显示 `[Step N/4]`，长操作前告知用户
- **输出语言**：遵循 `.sand/config.yaml` 中 `output_language`，技术术语保持英文
- **错误处理**：快速失败 + 明确报错 + 不静默降级。缺失输入 → 报错 + 建议运行哪个 Skill 生成

### 与 execution-contract.schema.json 的对齐

step-01 加载的执行契约需匹配以下结构：
- `contract_id`: 格式 `INT-{8digit}-{seq}-contract-v{major}.{minor}`
- `must_pass[]`: 每条含 `id`(MP-NNN)、`criterion`、`verification`、`source`
- `should_pass[]`: 每条含 `id`(SP-NNN)、`criterion`、`verification`、`source`
- `must_not_violate[]`: 每条含 `id`(MNV-NNN)、`constraint`、`source`
- `clear_check`: 5 boolean（complete/lean/executable/assessable/reversible）

### Project Structure Notes

- 所有新文件在 `sand/skills/sand-validate-delivery/` 下
- 遵循已建立的 Skill 目录约定（SKILL.md + customize.toml + steps/ + templates/）
- 删除 `.gitkeep` placeholder
- 不修改 `docs/` 下的理论文档（Story 3-0 已完成）
- 不修改 `schemas/` 或 `templates/`（全局模板在 Story 1-1 已创建）

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 3-1] — BDD 验收标准和任务清单
- [Source: _bmad-output/planning-artifacts/architecture.md#sand-validate-delivery] — Skill 目录结构
- [Source: _bmad-output/planning-artifacts/prd.md#FR23-FR27b] — 功能需求
- [Source: docs/02-development-cycle/validate/three-channel.md] — 三通道检查项定义（Story 3-0 产出）
- [Source: docs/02-development-cycle/validate/decision-matrix.md] — 14 行决策矩阵（Story 3-0 产出）
- [Source: docs/02-development-cycle/validate/deviation-tracking.md] — 偏差事件结构（Story 3-0 产出）
- [Source: schemas/sandskill.v1.schema.json] — Skill 契约 Schema
- [Source: schemas/execution-contract.schema.json] — 执行契约 Schema
- [Source: sand/skills/sand-assess-maturity/SKILL.md] — SKILL.md frontmatter 模式参照
- [Source: sand/skills/sand-create-intent/SKILL.md] — SKILL.md frontmatter 模式参照
- [Source: _bmad-output/implementation-artifacts/3-0-validate-theory-foundation.md#Review Findings D1-D6] — 遗留设计决策
- [Source: _bmad-output/implementation-artifacts/deferred-work.md#3-0] — Deferred work 清单

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

N/A — Markdown Skill authoring, no runtime debugging.

### Completion Notes List

- Task 1: Created SKILL.md with sandskill.v1 frontmatter (9 required fields in fixed order + 6 optional in alphabetical order). sdc_phase="validate", requires=[file_read, file_write]. Activation body includes overview, theory references, usage instructions, prerequisites, output artifacts.
- Task 2: Created customize.toml with persistent_facts referencing three Validate theory docs (three-channel.md, decision-matrix.md, deviation-tracking.md).
- Task 3: Created step-01-contract-check.md (~170 lines). Implements contract verification channel: session initialization, contract loading, must_pass/should_pass/must_not_violate verification, coverage check, intent alignment analysis (FR26). Includes D2 (error→FAIL fallback) and D6 (computational control priority) handling.
- Task 4: Created step-02-security.md (~140 lines). Implements 7 security checks: injection (4 sub-checks), sensitive data, auth/authz, dependency CVE, license (FR25 non-blocking warning), credentials, context security (FR32). D6 control priority applied.
- Task 5: Created step-03-architecture.md (~130 lines). Implements 6 architecture checks: naming (warning), directory structure (blocking), dependency direction (blocking), pattern consistency (warning), API contract (blocking), code reuse/anti-Cargo-Cult (warning).
- Task 6: Created step-04-decision.md (~240 lines). Implements 14-row priority decision table, 4 decision types with output formats, deviation event recording (12 fields, D1-D6 all addressed), HIP-2 human confirmation, validation-report.yaml and deviations.json output.
- Task 7: Created templates/validation-report.yaml (~80 lines). Complete template with channels breakdown, decision structure, human confirmation, deviation references.
- Task 8: Deleted .gitkeep. Final directory verified: 7 files matching Architecture definition. Frontmatter validated against sandskill.v1.schema.json. Step check items cross-validated against three-channel.md theory.

### Change Log

- 2026-05-13: Story implementation complete. 7 new files created, .gitkeep deleted, all 8 tasks done, cross-validation passed.

### File List

- sand/skills/sand-validate-delivery/SKILL.md (NEW)
- sand/skills/sand-validate-delivery/customize.toml (NEW)
- sand/skills/sand-validate-delivery/steps/step-01-contract-check.md (NEW)
- sand/skills/sand-validate-delivery/steps/step-02-security.md (NEW)
- sand/skills/sand-validate-delivery/steps/step-03-architecture.md (NEW)
- sand/skills/sand-validate-delivery/steps/step-04-decision.md (NEW)
- sand/skills/sand-validate-delivery/templates/validation-report.yaml (NEW)
- sand/skills/sand-validate-delivery/.gitkeep (DELETED)
