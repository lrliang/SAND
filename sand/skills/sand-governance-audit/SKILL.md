---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-governance-audit"
version: "0.1.0"
description: "审计追踪报告生成工作流——扫描审计事件、构建证据链、生成可导出报告"
sdc_phase: "governance"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - ".sand/audits/audit.jsonl"
  - ".sand/intents/INT-*.yaml"
  - ".sand/executions/EXE-*/deviations.json"
  - ".sand/executions/EXE-*/validation-report.yaml"
outputs:
  - ".sand/audits/reports/AUD-{date}-{seq}.yaml"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["governance", "audit", "compliance", "evidence-chain"]
---

# sand-governance-audit

审计追踪报告生成工作流——扫描 `.sand/audits/audit.jsonl` 中的审计事件，构建意图→Skill→决策证据链，生成可导出的审计追踪报告。

## 概述

`sand-governance-audit` 是 SDC（SAND Development Cycle）治理中心轴的核心 Skill。它自动生成审计追踪报告，展示 AI 决策的完整证据链——让外部审计师可以回答"AI 为什么做了这个决策"。

**理论基础：**

- **Mikkonen "人类审查不可削减"原则**——每段 AI 输出必须可追溯至原始意图和人类审查点（参见 [生成式复用风险](../../docs/01-foundations/generative-reuse-risk.md)）
- **Wang MI9 Agent 语义遥测**——运行时治理需要步骤级行为监控（参见 [Agentic AI 治理理论](../../docs/01-foundations/agentic-consensus.md)）
- **ISO 42001 A.7/A.9**——结构化记录控制和内部审计是可认证 AI 管理系统的基础
- **NIST AI RMF Govern/Detect 功能**——建立监督机制和异常检测（参见 [审计治理](../../docs/02-development-cycle/governance/audit-governance.md)）

## Usage

本 Skill 包含 3 个步骤，按顺序执行：

1. **[Step 1/3] 审计事件扫描** (`steps/step-01-scan.md`) — 扫描 `.sand/audits/audit.jsonl`，按时间范围和多维度筛选审计事件
2. **[Step 2/3] 证据链构建** (`steps/step-02-chain.md`) — 从扫描结果构建意图→执行→Skill→步骤→确认→验证的完整证据链
3. **[Step 3/3] 审计报告生成** (`steps/step-03-report.md`) — 从证据链生成结构化审计追踪报告，支持 JSON/CSV 导出

## 前置条件

- `.sand/audits/audit.jsonl` 必须存在且包含至少一条审计事件
- 审计事件由 SandRuntime 在 Skill 执行时自动记录（Skill 开发者无需手动记录）

## 辅助数据源（可选，用于丰富证据链）

- `.sand/intents/INT-*.yaml` — 意图声明（提取 purpose 摘要）
- `.sand/executions/EXE-*/deviations.json` — 偏差事件
- `.sand/executions/EXE-*/validation-report.yaml` — 验证结果

## 输出工件

- `.sand/audits/reports/AUD-YYYYMMDD-{seq}.yaml` — 审计追踪报告（YAML 格式）
- 可选导出：JSON（完整结构化数据）、CSV（扁平化摘要表）
