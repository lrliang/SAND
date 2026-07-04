---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-measure-light"
version: "0.1.0"
description: "轻量度量采集工作流——从 Git/CI 采集 5 个信号，生成认知失调报告驱动渐进变革"
sdc_phase: "operate"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
  - shell_exec
inputs:
  - "Git 仓库（当前工作目录）"
  - ".sand/config.yaml（可选，度量采集配置）"
  - "CSV 文件（可选，FR36 手动 fallback）"
outputs:
  - ".sand/metrics/{date}_metrics.json"
  - ".sand/metrics/{date}_report.md"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["metrics", "measurement", "operate"]
---

# sand-measure-light

轻量度量采集工作流——从 Git/PR/CI 自动采集 5 个轻量信号（PR 周期时间、事故标签、AI 参与度、变更失败率、部署频率），生成数据驱动的认知失调报告。

## 概述

`sand-measure-light` 是 SDC（SAND Development Cycle）Operate 阶段的核心 Skill。基于 ADR-007"轻量度量"架构决策，它以 Skill 内嵌 Python 脚本实现零基础设施的度量采集——任何有 `git` + `python3` + `curl`（或手动 CSV）的环境即可运行。

**设计哲学：** 不测量"产出了多少"，而测量"产出的质量如何"——因为传统度量（LoC、覆盖率、PR 数量）在 AI 参与的开发中已经失效（参见 [信号采集理论](../../docs/02-development-cycle/operate/signal-collection.md)）。

**理论基础：**

- **ADR-007 轻量度量**——Skill 内嵌脚本，不引入独立采集服务
- **非确定性编程范式 §失效度量分析**——传统度量失效原因和 AI 原生替代信号（参见 [非确定性编程范式](../../docs/01-foundations/non-deterministic-paradigm.md)）
- **DORA 四关键度量**——变更失败率和部署频率的行业基准
- **认知失调驱动变革**——用数据揭示团队"自我感觉良好"与"客观数据恶化"之间的落差（参见 PRD §Journey 4 吴芳）

## Usage

本 Skill 包含 2 个步骤，按顺序执行：

1. **[Step 1/2] 信号采集** (`steps/step-01-collect.md`) — 运行 `git-metrics.py` 和 `ci-metrics.py` 采集 5 个轻量信号，输出到 `.sand/metrics/{date}_metrics.json`
2. **[Step 2/2] 认知失调报告** (`steps/step-02-report.md`) — 基于采集数据生成包含正向/负向指标、趋势分析和推荐行动的认知失调报告

## 前置条件

- 当前目录是 Git 仓库（`git rev-parse --git-dir` 成功）
- Python 3 可用（`python3 --version` 成功）
- 可选：CI API 端点可访问（否则使用 CSV fallback）

## 软依赖

| 依赖 | 用途 | 必需? |
|------|------|-------|
| Git CLI | PR 周期时间、AI 参与度采集 | 是 |
| Python 3 | 运行采集脚本 | 是 |
| cURL/HTTP | CI API 度量采集 | 否（CSV fallback） |

## 输出工件

- `.sand/metrics/{YYYYMMDD}_metrics.json` — 5 信号结构化数据（机器可读）
- `.sand/metrics/{YYYYMMDD}_report.md` — 认知失调报告（人类可读）
