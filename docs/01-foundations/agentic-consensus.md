# Agentic AI 治理理论

> **定位说明**：本章节原引用"Wang等学者(2026)的Agentic Consensus范式"，经深度文献验证后未能在公开学术数据库中定位该精确引用。现将本章节重新定位为**多源治理理论综合**——从多个可验证来源构建 SAND 治理中心轴的理论基础。

## 核心主张

规模化 AI 开发需要一个贯穿全生命周期的治理机制——不是事后审计，而是设计阶段即内嵌的结构化治理能力。SAND 将此称为"治理中心轴"（Governance Backbone）。

## 理论来源

本章节的理论基础由三个可验证来源综合构建：

### 1. Mikkonen 的"人类审查不可削减"原则

Mikkonen & Taivalsaari (2025) 论证了 AI 辅助的生成式代码复用在概念上与 Cargo Cult 开发并无本质区别——开发者将信任置于 AI 生成的代码上，但对代码的理解与手写代码时根本不同。这建立了治理的第一性原理：**人类审查是不可削减的（non-reducible）**。

> 来源：Mikkonen, T. & Taivalsaari, A. (2025). "Software Reuse in the Generative AI Era: From Cargo Cult Towards Systematic Practices." *Internetware '25*. [ACM DL](https://dl.acm.org/doi/10.1145/3755881.3755981)

### 2. ISO/IEC 42001 AI 管理系统标准

ISO 42001 是全球首个可认证的 AI 管理系统标准，提供 38 项结构化控制措施、9 大治理领域，遵循 Plan-Do-Check-Act (PDCA) 循环。其核心要求——风险管理、AI 全生命周期管理、第三方监督、数据治理、技术文档——与 SAND 治理中心轴的设计天然对齐。

> 来源：[ISO/IEC 42001:2023](https://www.iso.org/standard/42001)

### 3. Wang 等人的 MI9 运行时治理框架

Charles L. Wang 等人 (2025) 提出了首个专为 Agentic AI 系统设计的集成运行时治理框架 MI9，包含六个核心组件：Agency 风险指数、Agent 语义遥测、持续授权监控、FSM 一致性引擎、目标条件漂移检测和分级遏制策略。MI9 的"委托图"（delegation graph）跟踪跨衍生 Agent 的权限继承链，提供了 Agent 治理的技术实现参照。

> 来源：Wang, C.L. et al. (2025). "MI9: An Integrated Runtime Governance Framework for Agentic AI." [arXiv:2508.03858](https://arxiv.org/abs/2508.03858)

### 4. NIST AI 风险管理框架 1.1

NIST AI RMF 与网络安全框架和隐私框架天然整合，2026 年 3 月发布的 1.1 版本和 Cyber AI Profile 将 AI 特定风险扩展到 Secure/Defend/Thwart 三个焦点领域。为 SAND 的治理中心轴提供了与既有企业风险管理体系对接的标准化路径。

> 来源：[NIST AI RMF](https://www.nist.gov/artificial-intelligence/risk-management-framework)

## 对 SAND 设计原则的贡献

本章节的四个理论来源共同支撑 SAND 的**可治理可审计原则**：

```
Mikkonen "人类审查不可削减" ——→ 治理的第一性原理
ISO 42001 PDCA 循环         ——→ 治理的结构化框架
Wang MI9 运行时治理         ——→ Agent 系统的技术治理实现
NIST AI RMF 1.1             ——→ 企业风险管理体系对接
```

<!-- TODO: 各来源的详细论述展开 -->
