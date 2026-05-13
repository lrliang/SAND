# 非确定性编程范式

Martin Fowler 提出的 AI 对软件开发的范式冲击——从确定的世界进入非确定的世界。容差思维、幻觉即特征、Vibe Coding 的场景边界。

---

## 概述

软件工程的一个隐含假设从未被质疑过：**代码是确定性的**。给定相同输入，程序总是产出相同输出。所有工程实践——单元测试、代码审查、静态分析、覆盖率度量——都建立在这个假设之上。

2024-2026 年间，Martin Fowler、Birgitta Boeckeler、Rebecca Parsons 和 Kent Beck 等行业思想领袖从不同角度揭示了同一个现实：**LLM 的引入不只是提升了抽象层级，而是将软件开发横向推入了非确定性领域。** 这不是一个可以用更好的工具解决的技术问题，而是一个需要重新审视整个工程方法论的范式跃迁。

本文档为 SAND 框架建立非确定性编程范式的理论基础，直接支撑 Assess 阶段的成熟度评估——因为**一个组织对非确定性的容纳能力决定了它的 AI 原生成熟度**。

---

## 核心论点：范式跃迁的本质

### 纵向抽象 + 横向非确定性的双重移动

传统编程语言的演进（汇编 → C → Java → Python）是**纵向**的——每一代语言提升抽象层级，但保持确定性。LLM 的引入打破了这个单一维度的演进：

> "We're not just moving up the abstraction levels, we're moving sideways into non-determinism at the same time."
> — Birgitta Boeckeler（ThoughtWorks Distinguished Engineer），引自 Fowler (2025)

Fowler 将这一洞察展开为完整的论述：

> "The appearance of LLMs will change software development to a similar degree as the change from assembler to the first high-level programming languages... but with the distinction that it isn't just raising the level of abstraction, but also forcing us to consider what it means to program with non-deterministic tools."
> — Fowler, "LLMs bring new nature of abstraction" (2025)

**对 SAND 的意义：** 这解释了为什么简单地"给团队配备 AI 工具"不等于 AI 原生——工具层面的纵向升级不解决横向非确定性带来的方法论挑战。SAND 的 Assess 阶段需要评估组织是否**意识到并主动应对**了这种横向移动。

### 容差思维：从精确走向容错

传统软件工程不需要"容差"——代码要么正确，要么不正确。但 Fowler 指出，其他工程领域早已具备容差思维：

> "Other forms of engineering have to take into account the variability of the world. A structural engineer builds in tolerance for all the factors she can't measure... Software Engineering is unusual in that it works with deterministic machines."
> — Fowler, "Some thoughts on LLMs and Software Development" (2025)

当 AI 成为开发流程的一部分，软件工程首次需要像结构工程一样**内建容差**——不是假设 AI 的输出总是正确的，而是**假设它总有可能出错，并设计流程来容纳这种不确定性**。

**对 SAND 的意义：** 容差思维直接支撑了 SAND 的 Validate 阶段设计——三通道并行验证（契约验证、安全合规、架构对齐）本质上就是结构化的容差机制。"人类审查体系"成熟度维度评估的正是组织内建容差的系统性程度。

---

## 幻觉即特征（Hallucination as Feature）

### Parsons 的核心洞察

Rebecca Parsons（ThoughtWorks CTO Emerita）提出了一个反直觉但深刻的重新框定：

> "All an LLM does is produce hallucinations, it's just that we find some of them useful."
> — Rebecca Parsons, 引自 Fowler

这不是在为幻觉辩护，而是在重新定义问题边界：LLM 不是偶尔"出错"的逻辑引擎，而是始终在做概率性生成的概率引擎。我们认为"正确"的输出和"幻觉"的输出来自**同一个过程**——区别在于我们是否觉得输出有用。

### 风险矩阵方法

ThoughtWorks 在 2025 年提出了替代"始终验证"笼统规则的**风险矩阵方法**：根据错误答案的影响程度和幻觉概率来分级处理。

| 影响 × 概率 | 低幻觉概率 | 高幻觉概率 |
|-------------|-----------|-----------|
| **低影响** | 可直接使用 | 快速人工扫描 |
| **高影响** | 结构化审查 | 深度人类验证 |

**对 SAND 的意义：** 这直接支撑了 SAND 的 HIP（Human Intervention Protocol）三级机制：

- **HIP-1（全自主）**：低影响 × 低幻觉概率场景
- **HIP-2（关键决策审查）**：高影响或高幻觉概率场景
- **HIP-3（全程监督）**：高影响 × 高幻觉概率场景

> **参考文献：** Parsons, R. (2025). "We need to treat AI hallucinations as a feature, not a bug." [ThoughtWorks Insights](https://www.thoughtworks.com/en-us/insights/blog/generative-ai/we-need-to-treat-AI-hallucinations-as-a-feature-not-a-bug)

---

## Vibe Coding 的场景边界

### Beck 的关键区分

Kent Beck 在 2025 年提出了"Augmented Coding"和"Vibe Coding"的区分，为非确定性编程范式中的实践选择提供了边界：

- **Vibe Coding**：不关心代码本身，只关心系统行为。出错时把错误信息反馈给 AI 期望修复。"It vibes"——能跑就行
- **Augmented Coding**：关心代码质量、复杂度、测试和覆盖率。价值观与手写代码相同——整洁且可运行的代码。AI 是增强人类能力的工具，而非替代人类判断的代理

Beck 的实验发现：在 Augmented Coding 模式下，开发者**每小时做出更多重大决策，同时处理更少的常规任务**。但 AI 缺乏"品味"（taste）——可能向已经很大的函数再添加 20 行代码。

### Fowler 的信任模型

Fowler 对 AI 输出的信任提出了一个生动的类比：

> "You've got to treat every slice as a [pull request] from a rather dodgy collaborator who's very productive in the lines-of-code sense of productivity, but you know you can't trust a thing that they're doing."
> — Fowler, Pragmatic Engineer interview (2025)

### 场景边界表

| 维度 | Vibe Coding 适用 | Augmented Coding 必须 |
|------|-----------------|---------------------|
| **代码寿命** | 原型、实验、一次性脚本 | 生产代码、长期维护系统 |
| **安全影响** | 无安全后果的内部工具 | 任何涉及用户数据/支付/认证的系统 |
| **团队规模** | 个人项目 | 多人协作项目 |
| **合规要求** | 无合规约束 | 受监管行业（金融、医疗） |
| **可逆性** | 可以随时丢弃重做 | 回滚成本高或不可回滚 |

**对 SAND 的意义：** SAND 框架的设计前提是 **Augmented Coding 而非 Vibe Coding**。`sand-create-intent` 的意图声明 7 字段标准、CLEAR 质量检查、执行契约——这些结构化机制都基于"关心代码质量"的价值观。Beck 的"每小时做出更多重大决策"正是 FDE+ 角色的能力画像。

> **参考文献：** Beck, K. (2025). "Augmented Coding: Beyond the Vibes." [Tidy First? Substack](https://tidyfirst.substack.com/p/augmented-coding-beyond-the-vibes)

---

## 约束工程（Harness Engineering）

### Fowler 2026 年的新贡献

Fowler 在 2026 年提出了"约束工程"（Harness Engineering）概念，将非确定性环境下的控制机制分为两类：

| 控制类型 | 特征 | 例子 |
|---------|------|------|
| **计算控制（Computational Controls）** | 确定性、快速、CPU 驱动 | 测试、lint、类型检查、结构分析 |
| **推断控制（Inferential Controls）** | 语义分析、概率性判断 | AI 代码审查、LLM-as-judge、意图对齐验证 |

核心洞察：**非确定性环境需要两种控制的结合**——不能只依赖传统的计算控制（它们只能检查确定性属性），也不能只依赖推断控制（它们本身也是非确定性的）。约束工程就是系统性地设计这种组合。

**对 SAND 的意义：** 约束工程的双分类直接映射到 SAND 的验证策略：

- **计算控制** → Validate 阶段的契约验证通道（检查 must_pass/must_not_violate 等确定性条件）
- **推断控制** → Validate 阶段的架构对齐通道（AI 辅助语义审查）
- **两者结合** → SAND 三通道并行验证的设计原理

约束工程也支撑了 SAND 成熟度评估中"人类审查体系"维度的 L1-L5 等级设计——从"无约束"到"计算+推断双层结构化约束"的累进。

> **参考文献：** Fowler, M. (2026). "Harness engineering for coding agent users." [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html)

---

## 对传统软件度量的失效影响

非确定性范式对软件工程的影响不仅限于开发实践，还延伸到**度量体系**——许多传统度量在 AI 参与的开发中失去了原有的信号价值。

### 失效度量分析

| 传统度量 | 失效原因 | AI 原生替代信号 |
|---------|---------|--------------|
| **代码行数（LoC）** | AI 可以在几秒内生成数千行代码，LoC 不再反映工作量或价值 | 意图声明完成率、SDC 循环完成率 |
| **代码覆盖率** | AI 可以生成大量测试来提升覆盖率，但测试质量不确定 | 契约验证通过率（must_pass 条目） |
| **PR 数量/合并速度** | AI 加速了 PR 生产，但审查质量可能下降（行业报告显示 PR 审查时间显著增长） | 意图首通率（Intent First-Pass Rate） |
| **Bug 修复时间** | AI 快速"修复"可能引入新的隐性问题 | 变更失败率、偏差事件频率 |
| **静态分析得分** | AI 生成的代码可能通过静态分析但存在语义级问题 | 三通道验证决策分布（通过/有条件通过/打回） |

### Fowler 的认知债务警告

Fowler 在 2026 年提出了"认知债务"（Cognitive Debt）的概念：当 AI 大量生成代码时，团队是否还在学习？如果开发者不理解 AI 生成的代码，组织积累的不只是技术债——而是**认知债**：团队丧失了理解和维护系统的能力。

**对 SAND 的意义：** 这解释了 SAND 为什么将"学习与资产化"作为 7 个成熟度维度之一——它不是"锦上添花"的指标，而是防止认知债务积累的核心防线。`sand-run-retrospective` 的资产化流程正是将 AI 协作中的隐性知识显性化的机制。

---

## 与 SAND 设计原则的推导关系

```
Fowler 范式跃迁论 + Boeckeler 横向非确定性 + Parsons 幻觉即特征
    ↓
SAND 设计原则 #1：非确定性容纳原则（Non-Determinism Accommodation）
    ↓
实践映射：
  - Validate 阶段的三通道并行验证 ← 容差思维
  - Build 阶段的三层审查策略 ← 约束工程双分类
  - HIP-1/2/3 渐进式人类介入 ← 风险矩阵方法
  - Assess 阶段的"人类审查体系"维度 ← 约束工程成熟度

Beck Augmented Coding → SAND FDE+ 角色的核心能力画像
  - "做更多重大决策，处理更少常规任务"= FDE+ 的认知协作定位
```

---

## 引用来源

- Fowler, M. (2025). "LLMs bring new nature of abstraction." [martinfowler.com](https://martinfowler.com/articles/2025-nature-abstraction.html)
- Fowler, M. (2025). "Some thoughts on LLMs and Software Development." [martinfowler.com](https://martinfowler.com/articles/202508-ai-thoughts.html)
- Fowler, M. (2026). "Harness engineering for coding agent users." [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html)
- Beck, K. (2025). "Augmented Coding: Beyond the Vibes." [Tidy First? Substack](https://tidyfirst.substack.com/p/augmented-coding-beyond-the-vibes)
- Parsons, R. (2025). "We need to treat AI hallucinations as a feature, not a bug." [ThoughtWorks Insights](https://www.thoughtworks.com/en-us/insights/blog/generative-ai/we-need-to-treat-AI-hallucinations-as-a-feature-not-a-bug)
- Boeckeler, B. (2025). Various podcasts and articles on AI-assisted software delivery. ThoughtWorks.
- Parsons, D. (2025). "Non-Deterministic Software Development." Massey University.
