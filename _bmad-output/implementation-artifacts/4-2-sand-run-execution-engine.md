# Story 4.2: sand-run 执行引擎（SandRuntime 基础版）

Status: done

## Story

As a FDE+,
I want 按编排方案自动串联执行多个 Skill,
so that 完整的 SDC 循环无需手动切换 Skill。

## Acceptance Criteria

1. **编排方案加载** — `step-01-load-plan.md` 加载 `.sand/orchestration-plan.yaml` 和关联的意图声明，验证 Schema 合规，创建执行会话目录 `.sand/executions/EXE-{session_id}/`
2. **单链 Skill 执行** — `step-02-execute.md` 按 Pipeline 拓扑顺序调用 `skill_chain` 中的 Skill（A → B → C），前一个 Skill 的 `outputs` 链接为后一个的 `inputs`，每步完成后记录到 `execution.yaml`
3. **断点续传** — 执行中断后重新启动 `sand-run` 时，从 `execution.yaml` 中 `steps_completed` 的最后完成步骤恢复，已完成步骤不重复执行
4. **审计事件自动记录** — 每个 Skill 步骤完成后，自动追加审计事件到 `.sand/audits/audit.jsonl`，事件符合 `audit-event.schema.json`，Skill 开发者无需手动记录
5. **Skill 契约合规** — `SKILL.md` frontmatter 通过 `sandskill.v1.schema.json` 验证，`sdc_phase` 合法（注意：`sand-run` 可跨阶段执行，其自身 `sdc_phase` 选 `build` 或 `orchestrate`），`requires` 包含 `file_read, file_write`

## Tasks / Subtasks

- [x] Task 1: 创建 `sand/skills/sand-run/SKILL.md` (AC: #5)
  - [x] 1.1 编写 sandskill.v1 frontmatter（sdc_phase 选 `orchestrate`——sand-run 是编排阶段的执行引擎）
  - [x] 1.2 inputs 声明 `.sand/orchestration-plan.yaml` 和 `.sand/intents/{intent_id}.yaml`
  - [x] 1.3 outputs 声明 `.sand/executions/EXE-{session_id}/execution.yaml`
  - [x] 1.4 编写激活入口（概述 SandRuntime 5 模块 + 指向 step-01）
- [x] Task 2: 创建 `sand/skills/sand-run/customize.toml` (AC: #5)
  - [x] 2.1 persistent_facts 可为空（sand-run 从编排方案动态加载上下文，不依赖固定理论文档）
- [x] Task 3: 编写 `steps/step-01-load-plan.md` — 加载编排方案 + 创建执行会话 (AC: #1, #3)
  - [x] 3.1 加载 `.sand/orchestration-plan.yaml`，验证通过 `orchestration-plan.schema.json`
  - [x] 3.2 从编排方案提取 `intent_id`，加载关联的意图声明 `.sand/intents/{intent_id}.yaml`
  - [x] 3.3 生成 session_id（格式 `YYYYMMDD-{seq}`，扫描 `.sand/executions/` 确定序号）
  - [x] 3.4 创建执行会话目录 `.sand/executions/EXE-{session_id}/`
  - [x] 3.5 初始化 `execution.yaml`（session_id, plan_id, intent_id, topology, status=running, steps_completed=[], started_at）
  - [x] 3.6 **断点续传检测**：如果 `.sand/executions/` 下已有同 plan_id 的未完成会话（status=running 或 interrupted），提示用户选择：恢复 / 创建新会话 / 取消
  - [x] 3.7 加载 `context_scope`（include_files / exclude_patterns），准备上下文环境
  - [x] 3.8 遵循 6 段 Step 文件结构
- [x] Task 4: 编写 `steps/step-02-execute.md` — 按拓扑执行 Skill 链 (AC: #2, #3, #4)
  - [x] 4.1 从 `execution.yaml` 加载 `skill_chain` 和 `steps_completed`
  - [x] 4.2 **HostChecker**：对每个 Skill 验证宿主满足其 `requires` 声明
  - [x] 4.3 **Executor**：按 `order` 顺序执行每个 Skill（解析 SKILL.md → 指引用户按步骤执行）
  - [x] 4.4 **StateManager**：每步完成后更新 `execution.yaml` 的 `steps_completed` + 记录 `output_artifacts`
  - [x] 4.5 **状态传递**：前一个 Skill 的 `outputs` 通过 `input_mapping` 链接为后一个的 `inputs`（字符串模板替换）
  - [x] 4.6 **AuditWriter**：每步完成后追加审计事件到 `.sand/audits/audit.jsonl`（事件符合 `audit-event.schema.json`）
  - [x] 4.7 **HashComputer**：对 Skill 声明的 inputs/outputs 文件计算 SHA-256（记入审计事件的 input_hash/output_hash）
  - [x] 4.8 **HIP 审查**：根据 `human_oversight` 级别在适当位置暂停等待人类确认
  - [x] 4.9 **断点续传**：跳过 `steps_completed` 中已完成的 Skill，从下一个未完成 Skill 开始
  - [x] 4.10 **异常处理**：Skill 执行失败 → 记录 status=failure 到 execution.yaml 和 audit.jsonl → 提示用户选择：重试 / 跳过 / 中止
  - [x] 4.11 MVP 限制：仅支持 Pipeline 拓扑（单链顺序执行），Swarm/Hierarchy 显示"Phase 3 支持"提示
- [x] Task 5: 编写 `steps/step-03-summary.md` — 执行摘要 + 偏差汇总 (AC: #2)
  - [x] 5.1 从 `execution.yaml` 生成执行摘要（总步骤数、成功/失败数、总耗时）
  - [x] 5.2 汇总所有步骤的审计事件（从 audit.jsonl 过滤当前 session_id）
  - [x] 5.3 更新 `execution.yaml` 的 status 为 `completed` 或 `partial`
  - [x] 5.4 如果存在偏差事件（deviations.json），汇总显示
  - [x] 5.5 提示下一步：运行 `sand-validate-delivery` 进行交付验证
- [x] Task 6: 删除 `.gitkeep` 并验证目录完整性 (AC: #1-5)
  - [x] 6.1 删除 `sand/skills/sand-run/.gitkeep`
  - [x] 6.2 验证最终目录结构与 Architecture 定义一致（SKILL.md + customize.toml + 3 steps，无 data/ 或 templates/）
  - [x] 6.3 验证 SKILL.md frontmatter 字段顺序和必填字段

### Review Findings

- [x] [Review][Patch] F1: 审计事件 `step` 字段值不匹配 Schema pattern — 改为 `step-{order:02d}-{skill_name}` 格式 [step-02-execute.md:3e] ✅ fixed
- [x] [Review][Patch] F2: 审计事件 hash 为 null 违反 Schema 类型 — 改为"省略此字段"而非设 null [step-02-execute.md:3d,3e] ✅ fixed
- [x] [Review][Patch] F3: `human_confirmations` 始终为空数组 — HIP-2 流程添加回填指令（含 JSON 结构示例） [step-02-execute.md:3f] ✅ fixed
- [x] [Review][Patch] F4: SKILL.md 缺少"参考数据"章节 — 添加 4 个 Schema 引用 [SKILL.md] ✅ fixed
- [x] [Review][Patch] F5: Skill 被跳过时审计事件处理 — 明确：跳过时不发审计事件 + 理由 [step-02-execute.md:3a] ✅ fixed
- [x] [Review][Defer] W1: `skill_chain` 非 Schema required 字段——plan 可能完全无此属性 — Schema 级增强，step-01 增加防御检查注释
- [x] [Review][Defer] W2: `context_scope` 和 `meta` 为 Schema 可选属性但 step-01 无条件读取 — 增加防御注释
- [x] [Review][Defer] W3: execution.yaml `failure` 状态在 step-03 定义但 step-02 无产生路径 — 所有失败均产生 `partial` 或 `interrupted`，`failure` 为未来保留
- [x] [Review][Defer] W4: SHA-256 拼接顺序未定义（不同文件顺序产生不同 hash） — 建议按声明顺序拼接，实现细节
- [x] [Review][Defer] W5: 断点恢复时 step-01 第 5-7 节仍会执行（创建新会话逻辑与恢复逻辑混合） — 设计注释：恢复时跳过第 5 节创建，直接进入 step-02
- [x] [Review][Defer] W6: session_id 中 EXE- 前缀可能双重叠加 — execution.yaml 内 session_id 字段已含 EXE- 前缀，与目录名一致，但需统一语义
- [x] [Review][Defer] W7: deviations.json 在 sand-run 阶段通常不存在 — step-03 已优雅处理（显示"无偏差"），属正常设计
- [x] [Review][Defer] W8: 并发 session_id 碰撞——无文件锁机制 — 单用户场景下低概率，Phase 3 多 Agent 场景需解决

## Dev Notes

### Story 本质

这是 SAND 框架**最复杂的 Skill**——它是 SandRuntime 执行引擎的 Markdown 操作化实现。虽然仍然是 Markdown Skill（不涉及可运行代码），但它需要定义 5 个 SandRuntime 模块的行为协议，使 AI Agent 在运行此 Skill 时能够正确协调 Skill 链执行。

### 前序 Story 关键产出

**Story 4-1（sand-design-orchestration Skill）已完成（done），产出编排方案作为本 Story 的直接输入：**

| 工件 | 路径 | 本 Story 如何使用 |
|------|------|-------------------|
| 编排方案 | `.sand/orchestration-plan.yaml` | step-01 加载并解析 |
| 编排方案 Schema | `schemas/orchestration-plan.schema.json` | step-01 验证输入 |
| 意图声明 | `.sand/intents/{intent_id}.yaml` | step-01 加载关联意图 |
| 审计事件 Schema | `schemas/audit-event.schema.json` | step-02 AuditWriter 生成事件 |
| 执行契约 | `.sand/intents/contracts/{intent_id}.contract.yaml` | step-02 传递给后续 Skill |

**Story 4-1 Review Deferred W3（显式指定本 Story 处理）：**

| ID | 问题 | 处理方式 |
|----|------|---------|
| W3 | `.sand/orchestration-plan.yaml` 为固定路径，多次运行会覆盖 | step-01 断点续传检测：发现同 plan_id 未完成会话时提示恢复，而非覆盖。新会话使用唯一 session_id 隔离 |

### SandRuntime 5 模块行为协议

sand-run 作为"元 Skill"，其 step 文件需要定义以下 5 个概念模块的行为——注意这些不是代码模块，而是 AI Agent 执行 step 文件时需要遵循的行为协议：

| 模块 | 职责 | 操作化方式 |
|------|------|----------|
| **AuditWriter** | JSONL 追加写入，步骤级触发 | step-02 每步完成后构造 `audit-event.schema.json` 合规的 JSON 对象，追加写入 `.sand/audits/audit.jsonl` |
| **Executor** | 步骤级 Skill 包装器 | step-02 解析目标 Skill 的 SKILL.md frontmatter，按其 entry_point 指引用户执行 |
| **StateManager** | 断点续传 + 输入输出链接 | step-01 初始化 execution.yaml，step-02 每步后更新 steps_completed |
| **HashComputer** | SHA-256 计算 | step-02 对 Skill 的 inputs/outputs 声明的文件计算 SHA-256，记入审计事件 |
| **HostChecker** | 宿主能力校验 | step-02 对每个 Skill 的 `requires` 字段与当前宿主能力对比 |

### 已建立的 Skill 实现模式

**SKILL.md frontmatter（与前序 Skill 一致）：**
```yaml
---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-run"
version: "0.1.0"
description: "SDC 执行引擎——按编排方案串联执行 Skill 链，自动审计记录"
sdc_phase: "orchestrate"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - ".sand/orchestration-plan.yaml"
  - ".sand/intents/{intent_id}.yaml"
outputs:
  - ".sand/executions/EXE-{session_id}/execution.yaml"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["execution", "runtime", "pipeline", "audit"]
---
```

**Step 文件强制 6 段结构（与 Story 4-1 一致）：**
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

**目标目录结构（Architecture 定义，行 744-752）：**
```
sand/skills/sand-run/
├── SKILL.md                         ← sandskill.v1 frontmatter + 激活入口
├── customize.toml                   ← persistent_facts 可为空
└── steps/
    ├── step-01-load-plan.md         ← 加载编排方案 + 创建执行会话
    ├── step-02-execute.md           ← 按拓扑执行 Skill 链（SandRuntime 核心）
    └── step-03-summary.md           ← 执行摘要 + 偏差汇总
```

**注意：sand-run 无 `data/` 和 `templates/` 目录**——执行引擎不持有静态数据或模板，所有数据来自动态加载的编排方案和意图声明。

**execution.yaml 结构（StateManager 管理）：**
```yaml
session_id: "EXE-{YYYYMMDD}-{seq}"
plan_id: "{从编排方案提取}"
intent_id: "{从编排方案提取}"
topology: "{从编排方案提取}"
human_oversight: "{从编排方案提取}"
status: "running"  # running | completed | partial | interrupted | failure
started_at: "{ISO-8601}"
completed_at: null
steps_completed:
  - skill_name: "sand-{name}"
    order: 1
    status: "success"  # success | failure | skipped
    started_at: "{ISO-8601}"
    completed_at: "{ISO-8601}"
    output_artifacts:
      - "{Skill 产出的文件路径}"
steps_remaining:
  - skill_name: "sand-{name}"
    order: 2
```

**审计事件结构（AuditWriter，符合 audit-event.schema.json）：**
```json
{
  "event_id": "UUID-v4",
  "timestamp": "ISO-8601",
  "sand_version": "0.1.0",
  "intent_id": "INT-YYYYMMDD-{seq}",
  "execution_id": "EXE-{session_id}",
  "skill_name": "sand-{name}",
  "skill_version": "0.1.0",
  "sdc_phase": "{phase}",
  "step": "step-{NN}-{name}",
  "actor": "agent",
  "host": "{当前宿主}",
  "model_used": "{当前模型}",
  "input_hash": "sha256:{64hex}",
  "output_hash": "sha256:{64hex}",
  "status": "success",
  "human_confirmations": [],
  "error": null
}
```

**MVP 限制（Architecture D7）：**
- **仅支持 Pipeline 拓扑**（单链 A → B → C 顺序执行）
- Swarm（并行）和 Hierarchy（层级）拓扑执行在 Phase 3 支持
- **状态传递**：基于 `outputs`/`inputs` 契约匹配，路径替换用简单字符串模板
- **断点续传**：步骤级恢复，仅支持单 Skill 内恢复（D8）

**HIP 执行时行为：**
- **HIP-1**：全自主执行，完成后输出摘要
- **HIP-2**：每个 Skill 完成后暂停显示结果，等待用户 `[C] 继续 / [S] 跳过 / [A] 中止`
- **HIP-3**：每个 Skill 的每个 step 都需用户确认

### PRD 功能需求直接覆盖

- **FR15a:** 根据意图声明和编排方案启动执行会话（step-01）
- **FR15b:** 按拓扑依次调用 Skill（step-02，MVP 仅 Pipeline）
- **FR15c:** Skill 输出链接为下一个 Skill 的输入（step-02 状态传递）
- **FR15d:** 实时状态记录到 `.sand/executions/`（step-02 StateManager）

### 与前后 Skill 的交互

**输入依赖：**
- `sand-design-orchestration` → `.sand/orchestration-plan.yaml`（编排方案）
- `sand-create-intent` → `.sand/intents/{intent_id}.yaml`（意图声明）
- `sand-create-intent` → `.sand/intents/contracts/{intent_id}.contract.yaml`（执行契约，传递给验证 Skill）

**输出消费者：**
- `sand-validate-delivery` → 消费 `.sand/executions/EXE-{session_id}/` 下的执行产物
- 回顾 Skill（Story 6-1） → 消费 `.sand/audits/audit.jsonl` 审计链

### Project Structure Notes

- 所有新文件在 `sand/skills/sand-run/` 下
- 仅 SKILL.md + customize.toml + 3 个 step 文件（无 data/ 无 templates/）
- 删除 `.gitkeep`
- 不修改已有 Skill 或 Schema
- `.sand/executions/` 和 `.sand/audits/` 目录由 step 文件在运行时创建（如不存在）

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 4-2] — BDD 验收标准（行 538-574）
- [Source: _bmad-output/planning-artifacts/architecture.md#Execution Runtime Model] — SandRuntime 模块架构（行 394-410）
- [Source: _bmad-output/planning-artifacts/architecture.md#sand-run] — Skill 目录结构（行 744-752）
- [Source: _bmad-output/planning-artifacts/architecture.md#D6-D8] — 执行引擎设计决策（行 232-250）
- [Source: _bmad-output/planning-artifacts/prd.md#执行运行时 FR15a-d] — 功能需求（行 625-630）
- [Source: schemas/orchestration-plan.schema.json] — 编排方案 Schema（sand-run 的输入契约）
- [Source: schemas/audit-event.schema.json] — 审计事件 Schema（sand-run 的输出契约）
- [Source: schemas/execution-contract.schema.json] — 执行契约 Schema（Skill 间传递）
- [Source: schemas/sandskill.v1.schema.json] — Skill 契约 Schema
- [Source: sand/skills/sand-design-orchestration/SKILL.md] — 编排方案产出 Skill（sand-run 的上游）
- [Source: sand/skills/sand-validate-delivery/SKILL.md] — 验证 Skill（sand-run 的下游）
- [Source: _bmad-output/implementation-artifacts/4-1-sand-design-orchestration-skill.md] — 前序 Story（含 Review Deferred W3）
- [Source: _bmad-output/implementation-artifacts/deferred-work.md#4-1] — Deferred W3: orchestration-plan.yaml 版本化

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

N/A — Markdown Skill authoring, no runtime debugging.

### Completion Notes List

- Task 1: Created SKILL.md with sandskill.v1 frontmatter (9 required fields in fixed order + 6 optional in alphabetical order). sdc_phase="orchestrate", requires=[file_read, file_write]. inputs declare orchestration-plan.yaml and intent declaration. outputs declare execution.yaml. Activation body includes SandRuntime 5-module overview (AuditWriter, Executor, StateManager, HashComputer, HostChecker), MVP limitations, prerequisites, usage pointing to step-01, and output artifacts.
- Task 2: Created customize.toml with empty persistent_facts (sand-run dynamically loads context from orchestration plan, no fixed theory docs needed).
- Task 3: Created steps/step-01-load-plan.md (~155 lines). Implements: orchestration plan loading with Schema validation (7 properties, additionalProperties:false), topology compatibility check (solo/pipeline supported, swarm/hierarchy show Phase 3 message), intent declaration loading via intent_id, checkpoint/resume detection (scan .sand/executions/ for same plan_id with status running/interrupted, offer Resume/New/Cancel), session_id generation (YYYYMMDD-{seq}), execution.yaml initialization (session_id, plan_id, intent_id, topology, human_oversight, status=running, steps_completed=[], steps_remaining from skill_chain), context_scope loading, execution plan display with user confirmation. W3 deferred work addressed: checkpoint detection prevents blind overwrite.
- Task 4: Created steps/step-02-execute.md (~230 lines). Core SandRuntime implementation. Implements all 5 modules as behavioral protocols: (3a) HostChecker — validates each Skill's requires against host capabilities, skip/abort on mismatch; (3b) Executor — reads target SKILL.md frontmatter, performs input_mapping template substitution, guides user execution with [D]one/[F]ail/[S]kip; (3c) StateManager — updates execution.yaml steps_completed after each Skill, records output_artifacts, handles failure (retry/skip/abort) and interrupted states; (3d) HashComputer — SHA-256 of concatenated input/output files, format sha256:{64hex}, null if file missing; (3e) AuditWriter — constructs audit-event.schema.json compliant JSON object with all required fields (event_id UUID-v4, timestamp, sand_version, intent_id, execution_id, skill_name, skill_version, sdc_phase, step, actor, host, model_used, input_hash, output_hash, status, human_confirmations, error), appends as single-line JSONL to .sand/audits/audit.jsonl; (3f) HIP review — HIP-1 auto-continue, HIP-2 pause after each Skill with [C]ontinue/[A]bort, HIP-3 per-step human confirmation. Checkpoint resume: skips steps_completed entries. Final status: completed/partial/interrupted.
- Task 5: Created steps/step-03-summary.md (~110 lines). Implements: execution summary from execution.yaml (total/success/failure/skipped counts, duration), audit event rollup filtered by execution_id, deviation check (deviations.json if exists), final status update (completed/partial/interrupted/failure), next-step guidance (sand-validate-delivery for completed, retry for partial, resume hint for interrupted).
- Task 6: Deleted .gitkeep. Final directory verified: 5 files matching Architecture definition (SKILL.md, customize.toml, 3 step files, no data/ no templates/). Frontmatter field order and required fields validated.

### Change Log

- 2026-05-14: Story implementation complete. 5 new files created, .gitkeep deleted, all 6 tasks done.
- 2026-05-14: Code review complete. 5 patch findings fixed (2 High: audit step pattern + null hash type), 8 deferred, 4 dismissed. Fixes: step field→step-{NN}-{name} format, hash null→omit field, human_confirmations populated from HIP-2, SKILL.md +参考数据 section, skipped Skills no audit event.

### File List

- sand/skills/sand-run/SKILL.md (NEW)
- sand/skills/sand-run/customize.toml (NEW)
- sand/skills/sand-run/steps/step-01-load-plan.md (NEW)
- sand/skills/sand-run/steps/step-02-execute.md (NEW)
- sand/skills/sand-run/steps/step-03-summary.md (NEW)
- sand/skills/sand-run/.gitkeep (DELETED)
