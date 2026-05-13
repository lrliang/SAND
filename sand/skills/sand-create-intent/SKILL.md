---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-create-intent"
version: "0.1.0"
description: "意图声明引导创建 + CLEAR 质量检查 + 执行契约生成"
sdc_phase: "intent"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - "{sand-root}/templates/intent-statement.yaml"
  - "{sand-root}/templates/execution-contract.yaml"
outputs:
  - ".sand/intents/{intent_id}.yaml"
  - ".sand/intents/contracts/{intent_id}.contract.yaml"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["intent", "clear-check", "execution-contract", "cognitive-collaboration"]
---

# sand-create-intent

意图声明引导创建工作流——通过结构化对话引导 FDE+ 创建高质量意图声明，自动运行 CLEAR 质量检查，并生成执行契约。

## 概述

`sand-create-intent` 是 SDC（SAND Development Cycle）Intent 阶段的核心 Skill。它引导 FDE+ 完成以下工作：

1. **确定意图范围**——选择意图类型，收集问题描述和业务关联
2. **7 字段意图声明草案**——通过结构化对话逐步完善意图声明
3. **CLEAR 5 维质量检查**——自动化检查（C/E/A）+ 引导式评估（L/R）
4. **执行契约生成**——从意图声明自动映射生成三级执行契约

## 使用方式

在 Claude Code 或 Cursor 中打开此文件，然后按以下步骤执行：

**[Step 1/4]** Read fully and follow `./steps/step-01-scope.md`

## 参考数据

- CLEAR 检查项定义：`./data/clear-checklist.yaml`
- 意图声明模板：`{sand-root}/templates/intent-statement.yaml`
- 执行契约模板：`{sand-root}/templates/execution-contract.yaml`
