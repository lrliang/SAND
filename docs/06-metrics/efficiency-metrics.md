# 效率指标

AI 杠杆率、意图吞吐量、PR 周期时间、AI 参与度、部署频率——从"产出量"转向"产出质量和节奏"的效率度量体系。

---

## 概述

传统效率度量（代码行数、PR 数量、commit 频率）在 AI 参与的开发中已经失效——AI 可以秒级生成数千行代码，这些数字不再反映真实的工程效能（参见 [非确定性编程范式 §失效度量分析](../01-foundations/non-deterministic-paradigm.md#失效度量分析)）。

SAND 的效率指标体系聚焦于两个维度：

1. **AI 协作效率** — 人机协作是否真正提升了工程产出的*质量和速度*（而非单纯的*数量*）
2. **交付节奏** — 团队的端到端交付能力是否在持续改善

---

## AI 杠杆率（AI Leverage Ratio）

### 定义

> **AI 杠杆率** = AI 辅助下完成同等工作量所需人类决策次数 ÷ 纯人工完成所需人类决策次数

衡量 AI 对人类决策负担的实际减轻程度。杠杆率 < 1.0 表示 AI 确实减少了人类的决策量。

### 度量层级

| 层级 | 度量维度 | 说明 |
|------|---------|------|
| L1 个体 | 个人 AI 杠杆率 | 单个开发者使用 AI 前后的决策量对比 |
| L4 组织 | 组织级 AI 杠杆率 | 组织整体的 AI 辅助效率提升程度 |

### 计算方法

MVP 阶段采用**主观评估法**（复盘时开发者自评 1-5 分，"AI 替你做了多少决策"）。Phase 4 引入基于审计事件的客观计算。

### 基准值

| 区间 | 解读 |
|------|------|
| **> 0.8** | AI 杠杆效果不显著——检查 AI 工具使用方式或任务适配性 |
| **0.5-0.8** | 中等杠杆——AI 减少了部分常规决策 |
| **< 0.5** | 高杠杆——AI 显著减少了人类决策负担（需警惕认知债务） |

---

## 意图吞吐量（Intent Throughput）

### 定义

> **意图吞吐量** = 单位时间内完成的意图数量（从 Draft 到 Validated）

衡量团队通过 SDC 循环交付意图的节奏。

### 度量层级

| 层级 | 度量维度 | 说明 |
|------|---------|------|
| L2 Pod | Pod 意图吞吐量 | 团队级别的意图完成频率 |
| L3 产品 | 投资假设验证速率 | 产品级别的价值验证效率 |

### 计算方法

```
intent_throughput = count(intents: status == "Validated") / time_window
```

### 数据源

| 数据 | 位置 | 采集方式 |
|------|------|---------|
| 意图状态记录 | `.sand/intents/INT-*.yaml` | 扫描 `meta.status == "Validated"` + `meta.updated_at` |
| 时间窗口 | 配置参数 | 默认按周统计 |

### 基准值

无绝对基准——关注趋势方向。吞吐量持续提升 + 意图首通率稳定 = 团队效率在真正改善。

---

## PR 周期时间（PR Cycle Time）

### 定义

> **PR 周期时间** = 从首次提交到合并的时长中位数

衡量团队的代码审查效率和交付流畅度。在 AI 时代，PR 产量激增使审查成为瓶颈——PR 周期时间捕捉了这个"快产出 vs 慢审查"的张力。

### 度量层级

| 层级 | 度量维度 | 说明 |
|------|---------|------|
| L2 Pod | Pod PR 审查效率 | 团队级别的 PR 流转速度 |

### 计算方法

```
pr_cycle_time = median(merge_timestamp - first_commit_timestamp)  # 最近 N 个 PR
```

### 数据源

| 数据 | 位置 | 采集方式 |
|------|------|---------|
| PR 创建时间 | Git / GitHub API | `git log --merges` 或 API 查询 |
| PR 合并时间 | Git / GitHub API | 合并提交时间戳 |

### 基准值

团队规模依赖，无绝对基准。关注趋势：

| 趋势 | 解读 |
|------|------|
| **持续增长** | 审查瓶颈——AI 产出速度超过人类审查能力 |
| **稳定** | 审查流程匹配当前产出速度 |
| **下降** | 审查效率提升（可能是三通道验证减轻了人工审查负担） |

### sand-measure-light 采集

`git-metrics.py` 通过 `git log --merges` 解析合并提交，计算 PR 创建到合并的时间差中位数。详见 [信号采集 §信号 1](../02-development-cycle/operate/signal-collection.md#信号-1pr-周期时间pr-cycle-time)。

---

## AI 参与度（AI Involvement Rate）

### 定义

> **AI 参与度** = 代码变更中 AI 辅助生成的占比

追踪团队的 AI 协作深度——既检测"AI 工具闲置"，也预警"过度依赖"导致的认知债务风险。

### 度量层级

| 层级 | 度量维度 | 说明 |
|------|---------|------|
| L1 个体 | 个人 AI 使用率 | 个人 commit 中 AI 辅助的比例 |
| L4 组织 | 组织级 AI 采纳度 | 组织整体的 AI 工具渗透程度 |

### 计算方法

```
ai_involvement_rate = count(ai_assisted_commits) / count(all_commits)  # 最近 N 天
```

AI 辅助 commit 的检测方法：commit message 特征（`Co-Authored-By: *AI*`、IDE 插件标记）或 author 标签。

### 数据源

| 数据 | 位置 | 采集方式 |
|------|------|---------|
| Commit 历史 | Git 仓库 | `git log` 扫描 commit message 特征 |

### 基准值

无绝对基准。关键是与**人类审查体系成熟度**联动解读：

| AI 参与度 | 审查体系 | 诊断 |
|----------|---------|------|
| 高 | L3+ | 健康——AI 深度参与且有结构化审查保障 |
| 高 | L1-L2 | 认知债务风险——AI 大量生成代码但缺乏审查 |
| 低 | 任意 | AI 工具采纳度不足——检查工具可用性和团队培训 |

### sand-measure-light 采集

`git-metrics.py` 扫描 commit message 中的 AI 特征标记，计算占比。详见 [信号采集 §信号 3](../02-development-cycle/operate/signal-collection.md#信号-3ai-参与度ai-involvement-rate)。

---

## 部署频率（Deployment Frequency）

### 定义

> **部署频率** = 向生产环境部署的频率（每天/每周/每月）

衡量团队的持续交付能力和交付节奏。DORA 四关键度量之一。

### 度量层级

| 层级 | 度量维度 | 说明 |
|------|---------|------|
| L3 产品 | 产品部署节奏 | 产品级别的交付频率 |

### 计算方法

```
deployment_frequency = count(deployments) / time_window  # 如每天/每周
```

### 数据源

| 数据 | 位置 | 采集方式 |
|------|------|---------|
| 部署事件 | CI/CD pipeline | CI API 获取部署时间线 |

### 基准值（DORA 基准）

| 级别 | 频率 |
|------|------|
| Elite | 按需 / 每天多次 |
| High | 每天 ~ 每周 |
| Medium | 每周 ~ 每月 |
| Low | 每月 ~ 每半年 |

### sand-measure-light 采集

`ci-metrics.py` 通过 CI API 获取部署事件时间线，统计指定时间窗口内的部署次数。无 API 时接受 CSV 手动导入（FR36）。详见 [信号采集 §信号 5](../02-development-cycle/operate/signal-collection.md#信号-5部署频率deployment-frequency)。

---

## 引用来源

- PRD §度量与洞察 FR34-FR37 — 5 个轻量信号功能需求
- [非确定性编程范式 §失效度量分析](../01-foundations/non-deterministic-paradigm.md#失效度量分析) — 传统度量失效分析
- [信号采集](../02-development-cycle/operate/signal-collection.md) — 5 个信号的采集方法和架构
- [度量指标体系 §度量-层级交叉矩阵](./README.md) — 效率指标在四层矩阵中的位置
- DORA State of DevOps Report (2024) — 部署频率基准值
