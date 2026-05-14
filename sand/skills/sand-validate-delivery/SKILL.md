---
# === 必填字段（固定顺序）===
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
outputs:
  - ".sand/executions/EXE-{session_id}/validation-report.yaml"
  - ".sand/executions/EXE-{session_id}/deviations.json"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["validation", "three-channel", "delivery", "security", "architecture"]
---

# sand-validate-delivery

三通道并行验证工作流——对交付物运行契约验证、安全合规验证和架构对齐验证，基于决策矩阵生成结构化验证决策。

## 概述

`sand-validate-delivery` 是 SDC（SAND Development Cycle）Validate 阶段的核心 Skill。它对 Build 阶段产出的交付物运行三通道并行验证，确保 AI 生成的代码在合并前有系统性的质量保障：

1. **契约验证**——逐条检查执行契约的 must_pass/should_pass/must_not_violate 条目
2. **安全合规验证**——检查注入漏洞、敏感数据泄露、依赖安全性、许可证合规等
3. **架构对齐验证**——检查命名规范、目录结构、依赖方向、架构模式一致性
4. **验证决策**——合并三通道结果，基于 14 行优先级判定表生成结构化决策

## 理论基础

三通道并行验证的设计源自两个理论基础：

- **Fowler 约束工程双控制分类**——计算控制（确定性检查）+ 推断控制（语义分析）的结合
- **Mikkonen Cargo Cult 理论**——单一代码审查在 AI 生成场景中存在系统性不足

详见 `docs/02-development-cycle/validate/` 下的理论文档。

## 使用方式

在 Claude Code 或 Cursor 中打开此文件，然后按以下步骤执行：

**[Step 1/4]** Read fully and follow `./steps/step-01-contract-check.md`

## 前置条件

- 意图声明已创建（`.sand/intents/{intent_id}.yaml`）
- 执行契约已生成（`.sand/intents/contracts/{intent_id}.contract.yaml`）
- Build 阶段已完成，交付物已提交

## 输出工件

- 验证报告：`.sand/executions/EXE-{session_id}/validation-report.yaml`
- 偏差事件：`.sand/executions/EXE-{session_id}/deviations.json`
