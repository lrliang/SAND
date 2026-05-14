---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-design-orchestration"
version: "0.1.0"
description: "引导式编排方案设计——拓扑选型、HIP 配置、Skill 链构建"
sdc_phase: "orchestrate"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - ".sand/intents/{intent_id}.yaml"
  - ".sand/config.yaml"
outputs:
  - ".sand/orchestration-plan.yaml"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["orchestration", "topology", "hip", "context-engineering"]
---

# sand-design-orchestration

引导式编排方案设计工作流——通过 4 步引导式对话帮助 FDE+ 设计最优编排方案：拓扑选型、HIP 配置、Skill 链构建和失败模式预案。

## 概述

`sand-design-orchestration` 是 SDC（SAND Development Cycle）Orchestrate 阶段的核心 Skill。它引导 FDE+ 完成以下工作：

1. **上下文收集与质量评估**——加载意图声明，收集四层次上下文，评估质量并应用最小化原则
2. **拓扑选型**——基于意图特征和规则表推荐最适 Agent 拓扑（Solo/Pipeline/Swarm/Hierarchy），支持外部 Skill 引入
3. **HIP 级别配置**——通过 4 层决策链计算人类介入等级，支持用户覆盖（含降级保护）
4. **编排方案输出**——合并所有设计决策，生成失败模式预案，输出结构化编排方案

## 理论基础

编排设计源自 SAND Orchestrate 阶段的 5 个子过程（O1-O5）理论：

- **O1 上下文工程**——上下文四层次金字塔 + 质量评估模型（Debois CDLC 框架）
- **O2 Agent 选型**——能力卡标准 + 选型决策树（Hassan SE 3.0 SASE 框架）
- **O3 拓扑模式**——4 种标准拓扑 + 不确定性×规模选型矩阵（Multi-Agent 编排实证研究）
- **O4 人类介入**——HIP-1/2/3 三级模型 + 动态调整机制（Fowler 非确定性范式）
- **O5 失败模式**——5 种 AI 失败模式分类 + 拓扑敏感矩阵（Mikkonen Cargo Cult 理论）

详见 `docs/02-development-cycle/orchestrate/` 下的理论文档。

## 前置条件

- 已运行 `sand-create-intent` 并生成意图声明（`.sand/intents/{intent_id}.yaml`）
- `.sand/config.yaml` 已配置项目默认值（可选但推荐）

## 使用方式

在 Claude Code 或 Cursor 中打开此文件，然后按以下步骤执行：

**[Step 1/4]** Read fully and follow `./steps/step-01-context.md`

## 参考数据

- 拓扑选型规则：`./data/topology-rules.yaml`
- 编排方案模板：`./templates/orchestration-plan.yaml`
- 编排方案 Schema：`{sand-root}/schemas/orchestration-plan.schema.json`

## 输出工件

- `.sand/orchestration-plan.yaml` — 结构化编排方案（topology + HIP + skill_chain + context_scope）
