# 质量指标

意图首通率、审查打回率、缺陷逃逸率、变更失败率——从"代码质量"转向"AI 协作质量"的度量体系。事故标签分类补充 AI 相关事故的根因追踪。

---

## 概述

传统代码质量度量（覆盖率、静态分析得分、Bug 数量）在 AI 辅助开发中面临系统性失效：AI 可以生成高覆盖率的测试但测试质量不确定，可以通过静态分析但存在语义级问题（参见 [非确定性编程范式 §失效度量分析](../01-foundations/non-deterministic-paradigm.md#失效度量分析)）。

SAND 的质量指标体系关注的不是"代码是否通过了检查"，而是：

1. **意图实现质量** — 从意图创建到验证通过，中间的摩擦和回退有多少？
2. **交付可靠性** — 变更进入生产后，引发问题的概率有多高？
3. **AI 风险可见性** — 生产事故中有多少与 AI 生成的代码有关？

---

## 意图首通率（Intent First-Pass Rate）

### 定义

> **意图首通率** = Draft → Validated 无回退的意图数 ÷ 总完成意图数

衡量意图声明的一次性质量——意图从创建到通过验证，无 CLEAR 检查失败回退、无验证打回重建。

### 度量层级

| 层级 | 度量维度 | 说明 |
|------|---------|------|
| L1 个体 | 个人意图首通率 | 个人编写的意图一次通过的比例 |

### 计算方法

```
intent_first_pass_rate = count(intents: Draft → Validated without rejection) / count(all_completed_intents)
```

"无回退"的判定：CLEAR 检查一次通过 + Validate 决策为 `pass` 或 `conditional_pass`。

### 数据源

| 数据 | 位置 | 采集方式 |
|------|------|---------|
| 意图状态转换 | `.sand/intents/INT-*.yaml` | 追踪 `meta.status` 转换历史 |
| 验证决策 | `.sand/executions/EXE-*/validation-report.yaml` | `decision` 字段 |

### 基准值

| 区间 | 状态 | 说明 |
|------|------|------|
| < 40% | 低 | 意图编写质量需系统性改善 |
| 40%-60% | 中 | 正在建立有效的意图编写实践 |
| ≥ 60% | 合格 | 达到 PRD Measurable Outcomes 目标 |
| 80%+ | 成熟 | 意图模式库有效运作 |

详见 [飞轮加速度量 §指标 2](../02-development-cycle/learn/flywheel-metrics.md#指标-2意图首通率)。

---

## 审查打回率（Review Rejection Rate）

### 定义

> **审查打回率** = Validate 阶段决策为 `reject_to_build` 或 `redirect_to_intent` 的次数 ÷ 总验证次数

衡量交付物在三通道验证中被打回的频率。打回率的变化趋势反映团队 Build 阶段的输出质量是否在改善。

### 度量层级

| 层级 | 度量维度 | 说明 |
|------|---------|------|
| L2 Pod | Pod 审查打回率 | 团队级别的验证通过效率 |

### 计算方法

```
review_rejection_rate = count(decisions: reject_to_build OR redirect_to_intent) / count(all_validations)
```

### 数据源

| 数据 | 位置 | 采集方式 |
|------|------|---------|
| 验证决策 | `.sand/executions/EXE-*/validation-report.yaml` | `decision` 字段统计 |

### 基准值

| 趋势 | 解读 |
|------|------|
| 持续下降 | Build 质量在改善——团队学习曲线正常 |
| 稳定在 10-20% | 健康——验证通道在有效拦截问题 |
| 持续上升 | 需干预——可能是任务复杂度上升或 AI 生成质量下降 |

---

## 缺陷逃逸率（Defect Escape Rate）

### 定义

> **缺陷逃逸率** = 通过验证但在生产环境中暴露的缺陷数 ÷ 验证阶段总检测缺陷数

衡量三通道验证的有效性——如果大量缺陷"逃逸"到生产环境，说明验证通道需要加强。

### 度量层级

| 层级 | 度量维度 | 说明 |
|------|---------|------|
| L3 产品 | 产品缺陷逃逸率 | 产品级别的验证覆盖效果 |

### 计算方法

```
defect_escape_rate = count(production_defects) / (count(validation_caught_defects) + count(production_defects))
```

### 数据源

| 数据 | 位置 | 采集方式 |
|------|------|---------|
| 验证拦截缺陷 | 验证报告中 `reject_to_build` 事件 | 审计事件统计 |
| 生产缺陷 | Incident tracking | 手动关联或事故标签分析 |

### 基准值

| 区间 | 解读 |
|------|------|
| < 5% | 验证通道高效 |
| 5%-15% | 正常范围——需持续改进验证规则 |
| > 15% | 验证通道存在系统性盲区——需审查三通道检查项 |

---

## 变更失败率（Change Failure Rate）

### 定义

> **变更失败率** = 导致生产环境服务降级或需要回滚的变更数 ÷ 总变更数

DORA 四关键度量之一。在 AI 时代仍然有效——它测量的是*结果*（生产是否出问题）而非*过程*（代码怎么写的），不受 AI 生产力膨胀影响。

### 度量层级

| 层级 | 度量维度 | 说明 |
|------|---------|------|
| L4 组织 | 组织变更失败率 | 组织级别的交付可靠性 |

### 计算方法

```
change_failure_rate = count(failed_changes) / count(all_changes)  # 最近 N 个部署周期
```

"失败变更"的判定：导致服务降级、需要回滚、或触发 P1/P2 级事故的变更。

### 数据源

| 数据 | 位置 | 采集方式 |
|------|------|---------|
| 部署事件 | CI/CD pipeline | CI API 获取 |
| 失败关联 | Incident tracking | 事故关联到触发变更 |

### 基准值（DORA 基准）

| 级别 | 变更失败率 |
|------|----------|
| Elite | 0-5% |
| High | 6-15% |
| Medium | 16-30% |
| Low | > 30% |

### sand-measure-light 采集

`ci-metrics.py` 通过 CI API 获取部署事件，关联事故记录计算失败变更占比。详见 [信号采集 §信号 4](../02-development-cycle/operate/signal-collection.md#信号-4变更失败率change-failure-rate)。

---

## 事故标签（Incident Labels）

### 定义

> **事故标签** = 生产事故按根因分类的标签统计，区分 AI 相关与非 AI 相关

这不是一个单一数值度量，而是一个**分类维度**——它为变更失败率和缺陷逃逸率提供根因归因，回答"问题出在 AI 生成的代码还是人类代码"。

### 分类方法

| 标签 | 定义 | 判定标准 |
|------|------|---------|
| `ai_related` | AI 生成代码为根因 | 事故根因追溯到 AI 辅助生成的代码段 |
| `non_ai` | 传统 bug | 事故根因为人类编写的代码或配置 |
| `mixed` | AI 和人类代码交互导致 | 事故由 AI 代码与人类代码的集成边界引发 |

### 度量层级

| 层级 | 度量维度 | 说明 |
|------|---------|------|
| L3 产品 | 产品 AI 事故占比 | AI 相关事故在总事故中的比例 |

### 数据源

| 数据 | 位置 | 采集方式 |
|------|------|---------|
| 事故记录 | Incident tracking（Jira/PagerDuty） | CI API 读取 |
| 手动标记 | CSV 文件 | FR36 fallback（无 API 时） |

### 健康范围

关注 `ai_related` 占比的趋势方向：

| 趋势 | 解读 | 行动 |
|------|------|------|
| 下降 | 约束工程有效——三通道验证在拦截 AI 相关问题 | 维持当前验证策略 |
| 稳定 | 问题可控但未改善 | 审查验证规则覆盖面 |
| 上升 | 约束不足——AI 生成代码质量需加强审查 | 加强验证通道 + 降低相关 OPS 级别 |

### sand-measure-light 采集

`ci-metrics.py` 从 incident tracking 系统读取事故标签；无 API 时接受 CSV 手动导入。详见 [信号采集 §信号 2](../02-development-cycle/operate/signal-collection.md#信号-2事故标签incident-labels)。

---

## 引用来源

- PRD §度量与洞察 FR34-FR37 — 5 个轻量信号功能需求
- PRD §Measurable Outcomes — 意图首通率 ≥60% 成功标准
- [非确定性编程范式 §失效度量分析](../01-foundations/non-deterministic-paradigm.md#失效度量分析) — 传统度量失效分析
- [信号采集](../02-development-cycle/operate/signal-collection.md) — 变更失败率和事故标签的采集方法
- [飞轮加速度量](../02-development-cycle/learn/flywheel-metrics.md) — 意图首通率的飞轮效应分析
- [度量指标体系 §度量-层级交叉矩阵](./README.md) — 质量指标在四层矩阵中的位置
- DORA State of DevOps Report (2024) — 变更失败率基准值
