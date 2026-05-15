---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-run-retrospective"
version: "0.1.0"
description: "AI 复盘引导工作流——5 议题结构化回顾 + 结构化日志输出（Phase 2 基础版）"
sdc_phase: "learn"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - ".sand/audits/audit.jsonl"
  - ".sand/intents/"
  - ".sand/executions/"
outputs:
  - ".sand/retrospectives/{date}_retro_{seq}.md"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["learn", "retrospective", "assetization", "flywheel"]
---

# sand-run-retrospective

AI 复盘引导工作流——按 5 个标准议题引导结构化回顾，输出结构化复盘日志到 `.sand/retrospectives/`。

## 概述

`sand-run-retrospective` 是 SDC（SAND Development Cycle）Learn 阶段的核心 Skill。它不是传统的"人的表现回顾"，而是**人-AI 协作系统效能的结构化复盘**——将每次 SDC 循环的经验转化为可追踪的学习信号和资产化候选。

**Phase 2 基础版范围：** 5 议题数据收集 + 结构化日志输出。分析报告生成和资产化入库建议在 Phase 3 完整版（Story 6-2）中实现。

**理论基础：**

- **Hassan SE 3.0 "认知协作"理论**——复盘聚焦人-AI 协作系统而非个人绩效（参见 [AI 复盘标准议程](../../docs/02-development-cycle/learn/ai-retrospective.md)）
- **Mikkonen "人类审查不可削减"原则**——资产化提名需人类判断，AI 自动提取的模式不可直接入库（参见 [资产化流程](../../docs/02-development-cycle/learn/assetization-process.md)）
- **飞轮效应度量**——3 指标（资产复用率、意图首通率、循环周期压缩率）追踪 Learn 阶段对 SDC 循环的加速贡献（参见 [飞轮加速度量](../../docs/02-development-cycle/learn/flywheel-metrics.md)）

## Usage

本 Skill Phase 2 基础版包含 1 个步骤：

1. **[Step 1/1] 5 议题结构化回顾** (`steps/step-01-collect.md`) — 按 5 个标准议题引导复盘对话，采集数据并输出结构化日志

Phase 3 完整版将追加：
- Step 2: 5 类 AI 资产分类（`steps/step-02-classify.md`）
- Step 3: 资产入库建议（`steps/step-03-register.md`）

## 前置条件

- **无硬性前置条件**——首次复盘可在 `.sand/` 目录为空时运行（冷启动模式：仅引导结构化问题，不提取数据摘要）
- **建议**：至少完成 1 轮完整 SDC 循环（sand-create-intent → sand-validate-delivery）以产生可分析的执行数据

## 数据源（可选，用于辅助数据采集）

| 数据源 | 路径 | 用途 |
|--------|------|------|
| 审计日志 | `.sand/audits/audit.jsonl` | 议题 4 失败模式分析 |
| 意图声明 | `.sand/intents/INT-*.yaml` | 议题 1 意图质量回顾 |
| 执行记录 | `.sand/executions/EXE-*/` | 议题 2 编排有效性回顾 |
| 偏差记录 | `.sand/executions/EXE-*/deviations.json` | 议题 4 失败模式细节 |

所有数据源均为可选——不存在时 Skill 切换到人工回忆模式。

## 输出工件

- `.sand/retrospectives/{YYYYMMDD}_retro_{seq}.md` — 结构化复盘日志（Markdown 格式，含 5 议题数据摘要 + 发现 + 飞轮指标快照）
