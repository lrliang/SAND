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

# sand-run

SDC 执行引擎——按编排方案自动串联执行多个 Skill，实现完整的 SDC 循环无需手动切换 Skill。自动记录审计事件，支持断点续传。

## 概述

`sand-run` 是 SDC（SAND Development Cycle）的执行引擎，定位为遵循 `sandskill.v1` 契约的**元 Skill**。它加载 `sand-design-orchestration` 产出的编排方案，按 Pipeline 拓扑顺序调用 Skill 链中的每个 Skill，并通过 SandRuntime 框架模块提供以下核心能力：

1. **AuditWriter** — 每步完成后自动追加审计事件到 `.sand/audits/audit.jsonl`（JSONL 格式，SHA-256 hash）
2. **Executor** — 解析目标 Skill 的 SKILL.md frontmatter，按步骤引导用户执行
3. **StateManager** — 在 `.sand/executions/EXE-{session_id}/execution.yaml` 中管理断点续传（steps_completed）
4. **HashComputer** — 对 Skill 声明的 inputs/outputs 文件计算 SHA-256，记入审计事件
5. **HostChecker** — 校验宿主是否满足目标 Skill 的 `requires` 声明

## MVP 限制

- 仅支持 **Pipeline 拓扑**（单链 A → B → C 顺序执行）
- Swarm（并行）和 Hierarchy（层级）拓扑在 Phase 3 支持
- 断点续传为步骤级恢复（单 Skill 内），跨 Skill 完整恢复在 Phase 3 支持

## 前置条件

- 已运行 `sand-design-orchestration` 并生成编排方案（`.sand/orchestration-plan.yaml`）
- 编排方案中引用的意图声明（`.sand/intents/{intent_id}.yaml`）已存在

## 使用方式

在 Claude Code 或 Cursor 中打开此文件，然后按以下步骤执行：

**[Step 1/3]** Read fully and follow `./steps/step-01-load-plan.md`

## 参考数据

- 编排方案 Schema：`{sand-root}/schemas/orchestration-plan.schema.json`
- 审计事件 Schema：`{sand-root}/schemas/audit-event.schema.json`
- 执行契约 Schema：`{sand-root}/schemas/execution-contract.schema.json`
- Skill 契约 Schema：`{sand-root}/schemas/sandskill.v1.schema.json`

## 输出工件

- `.sand/executions/EXE-{session_id}/execution.yaml` — 执行会话状态（含 steps_completed）
- `.sand/audits/audit.jsonl` — 审计事件日志（追加写入）
