# 生成式复用的 Cargo Cult 风险

Mikkonen 和 Taivalsaari (2025) 提出的 AI 辅助生成式代码复用中的 cargo cult 开发现象。为"人类审查不可削减"原则提供学术基础。

---

## 概述

软件复用（Software Reuse）是软件工程的基石之一。从子程序库到面向对象继承，从开源生态到微服务组合，每一代复用模式都提升了开发效率。2024-2025 年，AI 代码生成引入了一种全新的复用范式——**生成式复用（Generative Reuse）**：开发者不再手动选择和集成现有代码，而是由 AI 按需生成"等效代码"。

Mikkonen 和 Taivalsaari 在 2025 年的两篇论文中首次系统性地指出了这种新范式的根本风险：**AI 辅助的生成式代码复用在认知层面与 Cargo Cult 开发并无本质区别**。

本文档建立这一论断的理论基础，并推导出 SAND 框架"人类审查不可削减"原则的学术依据。这一原则直接支撑了 Validate 阶段的三通道并行验证架构设计——解释了为什么 AI 生成的交付物不能仅通过单一代码审查来验证。

---

## Cargo Cult 编程的经典定义

"Cargo Cult"概念源自人类学家对二战后太平洋岛屿原住民的观察：岛民模仿军事基地的外在形式（跑道、控制塔），期望飞机再次降落带来物资——复制了**表象**但不理解**因果机制**。物理学家 Richard Feynman 在 1974 年加州理工毕业演讲中将这一概念引入科学方法论，提出"Cargo Cult Science"批判缺乏严谨验证的伪科学实践。"Cargo Cult 编程"则是软件工程界对这一隐喻的进一步应用。

在软件工程中，Cargo Cult 编程指开发者复制代码片段并在自己的项目中使用，**不理解其工作原理或为什么有效**。经典场景包括：

- 从 Stack Overflow 复制代码但不理解其前置条件
- 沿用遗留代码中的"魔法数字"因为"删掉就报错"
- 在配置文件中保留不理解的参数"因为一直都这样"

关键区别在于：传统 Cargo Cult 编程中，开发者至少**选择了**要复制的代码。AI 生成式复用中，连选择过程都被移除了。

---

## Mikkonen & Taivalsaari 的核心论点

### 论文一：Cargo Cult 到系统化实践

> Mikkonen, T. & Taivalsaari, A. (2025). "Software Reuse in the Generative AI Era: From Cargo Cult Towards Systematic Practices." *Internetware '25*, ACM. DOI: [10.1145/3755881.3755981](https://dl.acm.org/doi/10.1145/3755881.3755981)

核心论点：

1. **信任与理解的断裂**：开发者对 AI 生成代码的信任建立在 AI 的"似乎正确的输出"之上，而非对代码本身的理解。这与 Cargo Cult 的信任结构相同——信任外在表象，不理解内在机制

2. **"Cult-Like Aura"**：AI 对非技术人员（甚至部分技术人员）具有一种"类似邪教的光环"——人们在 AI 看似神奇的能力面前投入信心，而不质疑其输出的可靠性

3. **复用分类学的扩展**：传统软件复用分为白盒复用（理解并修改源码）和黑盒复用（使用接口不看实现）。AI 生成式复用引入了第三种模式——**灰盒复用**：代码是可见的，但开发者对其生成过程和内部逻辑的理解程度不确定

### 论文二：AI 原生时代的复用未来

> Taivalsaari, A., Mikkonen, T., & Pautasso, C. (2025). "On the Future of Software Reuse in the Era of AI Native Software Engineering." arXiv: [2508.19834](https://arxiv.org/abs/2508.19834)

这篇扩展论文进一步分析了生成式复用的长期影响：

1. **语义漂移风险**：AI 生成的代码可能在表面上满足需求，但在语义层面与开发者的真实意图存在微妙偏差。这种偏差在短期内不可见，但随着系统复杂度增长会累积为技术债

2. **系统化实践路径**：论文提出了从 Cargo Cult 走向系统化生成式复用的路径——需要**结构化的验证机制**、**意图对齐检查**和**持续的人类认知参与**

---

## 与 Fowler 非确定性范式的连接

Mikkonen 的 Cargo Cult 理论与 Fowler 的非确定性编程范式（参见 [非确定性编程范式](./non-deterministic-paradigm.md)）形成互补的理论闭环：

| 理论 | 关注的风险 | 提出的应对 |
|------|-----------|----------|
| **Fowler 非确定性范式** | AI 输出的概率性——同一输入不保证同一输出 | 约束工程（Harness Engineering）：计算控制 + 推断控制 |
| **Mikkonen Cargo Cult** | 开发者对 AI 输出的认知断裂——信任不基于理解 | 系统化复用实践：结构化验证 + 意图对齐 |

两者的交叉点揭示了一个更深层的问题：**非确定性 + 认知断裂 = 系统性风险放大**。

- 如果 AI 的输出是确定性的，即使开发者不完全理解代码，至少可以通过重复测试建立可靠性信心
- 如果开发者完全理解 AI 的输出，即使输出是非确定性的，也可以通过人类判断筛选质量

但当两个条件同时存在时——**AI 输出不确定，且开发者不理解输出**——传统的质量保证手段（测试、审查、静态分析）都会系统性失效。

Fowler 在 2026 年提出的约束工程双控制分类为此提供了解决框架：

- **计算控制（Computational Controls）**：确定性检查，捕获可机器验证的违规（测试、lint、类型检查）
- **推断控制（Inferential Controls）**：语义分析，捕获需要上下文理解的偏差（AI 代码审查、意图对齐验证）

> **参考文献：** Fowler, M. (2026). "Harness engineering for coding agent users." [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html)

---

## "人类审查不可削减"原则

综合 Mikkonen 和 Fowler 的理论，SAND 推导出一个核心原则：

> **人类审查不可削减**（Human Review is Irreducible）：在 AI 参与代码生成的任何场景中，人类对交付物的审查不能被 AI 审查完全替代——即使 AI 审查的效率和覆盖面更高。

这一原则的理论依据包括三个层面：

### 1. 认知层面（Mikkonen）

AI 生成的代码可能通过所有自动化测试，但开发者对其工作原理缺乏理解。没有人类审查，团队积累的是"认知债务"（Cognitive Debt）——系统在运行，但没有人真正知道为什么。

### 2. 非确定性层面（Fowler）

AI 的推断控制本身也是非确定性的——用一个概率系统去验证另一个概率系统的输出。人类审查提供了概率链中唯一的确定性锚点。

### 3. 审计层面（治理需求）

外部审计师需要回答"谁对这个决策负责"。AI 生成 + AI 审查的闭环中没有人类责任锚点。人类审查在治理层面提供了不可替代的**责任归属**。

**对 SAND 的实践意义：** 这一原则解释了 SAND 为什么在 Validate 阶段设计了 HIP（Human Intervention Point）机制——即使在最高自动化级别（HIP-1），人类仍然保留对验证结果的最终确认权。完全无人类参与的验证流程在 SAND 框架中是不被支持的。

---

## 为什么需要三通道而非单一代码审查

传统的代码审查是**单通道**的：人类审查者阅读代码、检查逻辑、发现问题。在 AI 原生开发中，单通道审查面临三个系统性不足：

### 不足一：Cargo Cult 盲区

根据 Mikkonen 的理论，审查者自身也可能不完全理解 AI 生成的代码。单一的代码审查假设审查者的理解水平高于代码生产者——但在 AI 生成场景中，这个假设不成立。

### 不足二：维度覆盖不足

代码审查聚焦于"代码正确性"，但 AI 生成的交付物可能在以下维度存在问题而代码审查无法覆盖：

- **安全合规**：AI 可能引入不明显的安全漏洞（如不安全的依赖、隐式的数据泄露路径）
- **架构对齐**：AI 可能以功能正确但架构不一致的方式实现需求（命名规范、目录结构、依赖关系）
- **意图对齐**：代码可能"技术上正确"但"意图上偏离"——实现了不是用户真正想要的东西

### 不足三：非确定性累积

在概率系统中，单一验证点的可靠性不足以保障整体质量。约束工程的核心洞察是：**多个独立验证通道的组合比单一通道可靠得多**——即使每个通道本身都不完美。

因此，SAND 的 Validate 阶段设计了**三通道并行验证**（参见 [三通道并行验证架构](../02-development-cycle/validate/three-channel.md)）：

| 通道 | 对应的 Cargo Cult 风险 | 对应的约束类型 |
|------|---------------------|-------------|
| **契约验证** | 功能正确性缺乏验证 → 隐性 bug | 计算控制（确定性检查） |
| **安全合规** | AI 引入不可见的安全/合规风险 | 计算控制 + 推断控制（混合） |
| **架构对齐** | 代码正确但语义偏离架构意图 | 推断控制（语义分析） |

三通道各有独立否决权，确保任何单一维度的问题都不会被其他维度的"通过"所掩盖。

---

## SAND 设计原则 #4 的推导（部分）

综合上述理论，Cargo Cult 风险理论对 SAND 可治理可审计原则的推导链条：

```
Mikkonen Cargo Cult 理论（信任与理解的断裂）
  + Fowler 约束工程（双控制分类）
  + 认知债务概念（不理解的系统不可维护）
    ↓
SAND 原则：人类审查不可削减
    ↓
实践映射：
  - Validate 三通道并行验证 ← 三维度独立否决
  - HIP 机制 ← 人类审查始终保留
  - 审计证据链 ← 人类责任归属锚点
  - Learn 阶段资产化 ← 对抗认知债务的知识显性化
```

---

## 引用来源

- Mikkonen, T. & Taivalsaari, A. (2025). "Software Reuse in the Generative AI Era: From Cargo Cult Towards Systematic Practices." *Internetware '25*, ACM. DOI: [10.1145/3755881.3755981](https://dl.acm.org/doi/10.1145/3755881.3755981). arXiv: [2506.17937](https://arxiv.org/abs/2506.17937)
- Taivalsaari, A., Mikkonen, T., & Pautasso, C. (2025). "On the Future of Software Reuse in the Era of AI Native Software Engineering." arXiv: [2508.19834](https://arxiv.org/abs/2508.19834)
- Fowler, M. (2025). "Some thoughts on LLMs and Software Development." [martinfowler.com](https://martinfowler.com/articles/202508-ai-thoughts.html)
- Fowler, M. (2026). "Harness engineering for coding agent users." [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html)
- [非确定性编程范式](./non-deterministic-paradigm.md) — SAND Foundations 文档
- [认知协作与 SE 3.0](./cognitive-collaboration.md) — SAND Foundations 文档
