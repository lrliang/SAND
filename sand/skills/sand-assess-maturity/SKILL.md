---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-assess-maturity"
version: "0.1.0"
description: "7 维度成熟度评估引导工作流"
sdc_phase: "assess"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - "{sand-root}/templates/maturity-assessment.yaml"
outputs:
  - ".sand/assessments/{timestamp}_{team_id}.yaml"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["assessment", "maturity", "radar-chart"]
---

# sand-assess-maturity

7 维度成熟度评估引导工作流——通过结构化对话诊断组织的 AI 原生成熟度，生成雷达图和可执行改进路径。

## 概述

`sand-assess-maturity` 是 SDC（SAND Development Cycle）Assess 阶段的核心 Skill。它引导技术负责人或变革催化师完成以下工作：

1. **确定评估范围**——团队级或组织级
2. **7 维度结构化对话**——基于 L1-L5 行为指标逐维度评估
3. **数据辅助采集**——可选的 Git/CI 信号辅助评级
4. **雷达图生成**——7 维可视化 + 颜色编码（红/黄/绿）
5. **改进路径推荐**——红色维度自动关联 SAND Skill + ROI 预期

## 使用方式

在 Claude Code 或 Cursor 中打开此文件，然后按以下步骤执行：

**[Step 1/5]** Read fully and follow `./steps/step-01-scope.md`

## 参考数据

- 评估量表：`./data/dimension-rubrics.yaml`
- 改进路径规则：`./data/pathway-rules.yaml`
- 输出模板：`{sand-root}/templates/maturity-assessment.yaml`
- 输出 Schema：`{sand-root}/schemas/maturity-assessment.schema.json`
