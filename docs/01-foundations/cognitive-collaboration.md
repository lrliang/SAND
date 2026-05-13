# 认知协作与 SE 3.0

Ahmed E. Hassan 等学者提出的 Software Engineering 3.0——以意图为中心、对话式驱动的 AI 原生开发范式。SE 1.0→2.0→3.0 演变路径。

---

## 概述

"认知协作"（Cognitive Collaboration）是 SAND 框架的第二大理论基石，直接支撑 Intent 阶段的设计。它回答的核心问题是：**人与 AI 之间应该建立什么样的协作关系？**

传统的人-AI 交互模型是"工具使用"——人类发出指令，AI 执行任务。SAND 主张的认知协作模型截然不同：人类定义意图（What + Why），AI 不仅执行实现（How），还**主动参与认知过程**——识别未覆盖的边界条件、发现约束冲突、提出澄清请求。

本文档建立这一主张的理论基础，基于三条论证线索：

1. **Hassan SE 3.0 演进路径**——从工具辅助到认知协作的学术愿景
2. **SDD 行业验证**——意图驱动开发已成为工业实践
3. **认知科学理论**——分布式认知和互补性理论为人-AI 协作提供基础

---

## SE 1.0 → 2.0 → 3.0 演进路径

Hassan 等人在 ACM TOSEM 论文中提出了软件工程的三阶段演进：

| SE 版本 | 核心模式 | 人-AI 关系 | 确定性 |
|---------|---------|-----------|--------|
| **SE 1.0** | 人类写代码 | 无 AI | 确定性 |
| **SE 2.0** | 人类写代码 + FM 辅助补全 | AI 作为工具（Copilot 模式） | 基本确定性 |
| **SE 3.0** | 意图驱动、对话式 | AI 作为认知协作者 | 概率性 |

### SE 2.0 的固有局限

SE 2.0 以 GitHub Copilot 为代表，提升了开发者的编码效率，但暴露出三个固有局限：

- **认知过载**：开发者需要持续评估 AI 补全建议的正确性，反而增加了认知负担
- **低效率悖论**：AI 生成代码的速度远超人类审查速度，导致审查成为瓶颈
- **不可预测性**：AI 的非确定性输出使传统的质量保证方法失效（参见 [非确定性编程范式](./non-deterministic-paradigm.md)）

### SE 3.0 的认知协作愿景

SE 3.0 的核心主张是：AI 从"任务驱动的 copilot"进化为"**理解意图的智能协作者**"。这一跃迁体现在四个技术组件上：

- **Teammate.next**：自适应、个性化的 AI 伙伴关系——AI 了解开发者的风格和偏好
- **IDE.next**：意图中心、对话式开发环境——开发者表达"要什么"而非"怎么做"
- **Compiler.next**：多目标代码合成——从意图搜索最优实现方案
- **Runtime.next**：SLA 感知执行——运行时根据约束自适应

**SAND 的映射：** SE 3.0 的四组件可直接映射到 SDC 阶段：

| SE 3.0 组件 | SAND 对应 | 实践形式 |
|------------|----------|---------|
| Teammate.next | Agent 角色（FDE+、问题域负责人） | 角色化的人-AI 协作模式 |
| IDE.next | Intent 阶段 | 意图声明 7 字段 + 执行契约 |
| Compiler.next | Build 阶段 | AI 基于契约生成交付物 |
| Runtime.next | Operate 阶段 | 信号采集 + 持续验证 |

> **参考文献：** Hassan, A.E., Oliva, G.A., Lin, D., Chen, B., & Jiang, Z.M. (2026). "Towards AI-Native Software Engineering (SE 3.0): A Vision and a Challenge Roadmap." *ACM Transactions on Software Engineering and Methodology (TOSEM)*. DOI: [10.1145/3807901](https://dl.acm.org/doi/10.1145/3807901)

---

## SASE 框架：结构化 Agentic 软件工程

Hassan 团队在 SE 3.0 基础上进一步提出 SASE（Structured Agentic Software Engineering）框架，定义了人-AI 协作的结构化形式：

### 双模态协作

- **SE for Humans (SE4H)**：人类担任"Agent Coach"角色，聚焦意图定义、战略指导和质量裁决
- **SE for Agents (SE4A)**：Agent 在结构化环境中执行任务，遇到不确定性时**主动上报**人类

### 结构化工件

| 工件 | 方向 | 用途 | SAND 对应 |
|------|------|------|----------|
| **CRP**（Consultation Request Pack） | Agent → 人类 | Agent 咨询时的结构化请求包 | AI 边界条件澄清请求 |
| **MRP**（Merge-Readiness Pack） | Agent → 人类 | 可合并交付物的证据包 | Validate 阶段验证报告 |
| **VCR**（Version Controlled Resolution） | 人类 → Agent | 可审计的决议工件 | HIP 确认记录 |

### 自治等级

| 等级 | 名称 | 对应 SE | SAND HIP 映射 |
|------|------|--------|-------------|
| Level 1 | Token Assistance | SE 1.5 | — |
| Level 2 | Conversational | SE 2.0 | — |
| Level 3 | Goal-Agentic | SE 3.0 | HIP-1 ~ HIP-3 |
| Level 4 | Project-level | SE 4.0 | 未来扩展 |
| Level 5 | General Domain | SE 5.0 | 未来扩展 |

SAND 的目标用户主要处于 Level 2→3 的跃迁阶段——从对话式辅助到目标驱动的 Agentic 协作。

> **参考文献：** Hassan, A.E. et al. (2025). "Agentic Software Engineering: Foundational Pillars and a Research Roadmap." [arXiv:2509.06216](https://arxiv.org/abs/2509.06216)

---

## SDD：意图驱动开发的行业验证

Spec-Driven Development（SDD）是 SAND "意图驱动"核心理念的行业验证——它证明了"规格说明作为首要工件"的开发模式已从学术愿景走向工业实践。

### SDD 光谱

SDD 从轻到重分为三个层级：

| 层级 | 名称 | 核心主张 | SAND 对应 |
|------|------|---------|----------|
| **Spec-First** | 规格优先 | 编码前先写意图，引导初始构建 | Intent 阶段 → 意图声明草案 |
| **Spec-Anchored** | 规格锚定 | 规格与代码共演，通过测试和契约强制执行 | **Intent + Execution Contract + Validate** |
| **Spec-as-Source** | 规格即源码 | 规格即系统，人类永不编辑生成代码 | 未来愿景（SE 4.0+） |

SAND 的 Intent Statement（意图声明）+ Execution Contract（执行契约）体系正是 **SDD Spec-Anchored 层级的理论形式化**：

- 意图声明 = SDD 的结构化规格
- 执行契约 = SDD 的契约强制执行机制
- CLEAR 检查清单 = SDD 的规格质量验证框架

### 行业采纳

SDD 工作流已被主流开发工具嵌入：GitHub Spec Kit（2025 末）、AWS Kiro IDE、JetBrains Planning Mode、Cursor 均支持规格驱动的开发流程。这验证了 SAND 的核心假设——**结构化意图表达是 AI 原生开发的必要基础设施**。

### 与 Vibe Coding 的关系

SDD 与 Vibe Coding 互补而非对立：

- **Vibe Coding**：用于探索和原型，高容错，快速验证想法
- **SDD**：用于硬化和交付，低容错，确保质量和可追溯性

SAND 在 [意图类型学](../02-development-cycle/intent/intent-taxonomy.md) 中将 Exploration 类型映射到较轻的验证流程，Feature/Fix 类型映射到完整的 SDD 流程，体现了这一互补关系。

> **来源：** [Augment Code SDD Guide](https://www.augmentcode.com/guides/what-is-spec-driven-development), [DeepLearning.AI Course](https://www.deeplearning.ai/short-courses/spec-driven-development-with-coding-agents), [CGI Blog](https://www.cgi.com/en/blog/artificial-intelligence/spec-driven-development)

---

## 认知科学理论基础

### 分布式认知理论

分布式认知理论（Distributed Cognition）认为，认知过程不局限于单一个体，而是**分布在人、工具、环境和时间之间**。协作式 AI 概念与分布式认知理论天然契合——当 AI 参与意图声明的质量检查（CLEAR）或主动识别边界条件时，认知工作在人与 AI 之间形成了分布式协作。

**对 SAND 的意义：** 意图声明的 7 字段结构本质上是一种**认知脚手架**——它将分布式认知过程结构化为可操作的字段，使人类和 AI 都能在同一认知框架内协作。

> **来源：** Collaborative AI Literacy and Metacognition (2025, Taylor & Francis). [DOI](https://www.tandfonline.com/doi/full/10.1080/10447318.2025.2543997)

### 互补性理论

互补性理论（Complementarity）指出：

- 人-AI 协作的理想结果是**互补团队绩效**（Complementary Team Performance, CTP）——双方单独无法达到的水平
- 目前 CTP 很少被观察到，说明对互补性原则的理解和应用**不足**
- 关键洞察：**人类和 AI 会犯不同类型的错误**——人类容易遗漏边界条件和一致性检查，AI 容易产生幻觉和上下文理解偏差

**对 SAND 的意义：** 执行契约的三级结构（must_pass/should_pass/must_not_violate）正是为实现 CTP 而设计的——人类定义验收标准和约束（人类擅长的"What"），AI 在执行过程中识别人类遗漏的边界条件（AI 擅长的系统性检查），两者互补产生更优结果。

> **来源：** Complementarity in Human-AI Collaboration (2025, EJIS). [DOI](https://www.tandfonline.com/doi/full/10.1080/0960085X.2025.2475962)

### 人-AI 组队的信任挑战

Schmutz 等人的研究发现：

- 添加 AI 队友通常会**降低**团队的协调性、沟通和信任
- 对 AI 的信任随时间**下降**——因为能力被初始高估，暴露缺陷后信任急剧回落
- 结论：需要**结构化的信任框架**来管理人-AI 协作中的信任校准

**对 SAND 的意义：** 这直接解释了 SAND 为什么需要 HIP（Human Intervention Point）渐进式介入机制：

| HIP 级别 | 人类介入程度 | 适用场景 | 信任前提 |
|---------|-----------|---------|---------|
| **HIP-1** | 最低介入（全自主） | 低风险任务、已验证流程 | 高信任 / 成熟协作 |
| **HIP-2** | 中等介入（关键节点确认） | 标准开发任务、中等复杂度 | 中等信任 / 建立默契 |
| **HIP-3** | 最高介入（全程监督） | 高风险任务、首次使用 | 低信任 / 首次协作 |

HIP 数字越大，人类介入越多。新团队或高风险场景从 HIP-3 开始，随着信任校准逐步降级到 HIP-1。HIP 机制永远保留人类介入的结构化入口。

> **来源：** Schmutz, J.B. et al. (2024). "AI-Teaming: Redefining Collaboration in the Age of Artificial Intelligence." *Current Opinion in Psychology*. [PubMed](https://pubmed.ncbi.nlm.nih.gov/39024969/)

---

## 认知协作 vs 提示词工程

这是理解 SAND Intent 阶段设计的关键区分：

| 维度 | 提示词工程（Prompt Engineering） | 认知协作（Cognitive Collaboration） |
|------|-------------------------------|----------------------------------|
| **核心活动** | 优化自然语言指令 | 定义结构化意图 + 执行契约 |
| **AI 角色** | 被动执行工具 | 主动认知伙伴 |
| **质量保障** | 事后审查输出 | 事前定义验收标准（CLEAR + 契约） |
| **边界条件** | 人类自行预见 | AI 基于契约主动识别未覆盖边界 |
| **可审计性** | 无（自然语言无结构） | 完整证据链（意图→契约→验证→审计） |
| **可复用性** | 低（prompt 高度场景化） | 高（意图模式 + 编排配方可资产化） |
| **信任模型** | 隐式（凭经验判断） | 显式（HIP 级别 + 结构化验证） |

**操作化区分标准：** 判断一个开发流程是"提示词工程"还是"认知协作"，可以问一个问题：

> **AI 是否有能力和机制在执行过程中主动暂停，提出人类未预见的问题？**

如果 AI 只能按指令执行并返回结果——这是提示词工程。如果 AI 可以基于结构化契约主动识别边界条件并请求人类澄清——这是认知协作。SAND 的执行契约机制正是为后者设计的。

---

## SAND 设计原则 #2 的推导

综合上述理论，SAND 的**意图驱动原则**（Intent-Driven Principle）的推导链条如下：

```
Hassan SE 3.0 意图驱动愿景
  + 分布式认知理论（认知分布在人-工具-环境之间）
  + 互补性理论（人-AI 犯不同类型错误 → 组队可实现 CTP）
    ↓
SAND 设计原则 #2：意图驱动原则
    ↓
实践映射：
  - 意图声明 7 字段标准 ← SE 3.0 "intent-centric" 核心主张
  - 执行契约三级结构 ← SE 3.0 "conversation-oriented" 开发模式
  - CLEAR 质量检查 ← SDD 规格质量验证的 SAND 形式化
  - FDE+ 角色定义 ← 认知互补性（人类定义意图，AI 处理实现）
  - HIP 渐进式介入 ← HAT 信任衰减研究（需结构化信任框架）
```

---

## 对 SAND Intent 阶段的实践意义

1. **意图声明不是 prompt**：意图声明的 7 字段结构是认知协作的脚手架，不是更精细的 prompt。它的目的是让 AI 成为思考伙伴，而非更精确的执行工具
2. **执行契约是信任基础设施**：三级契约结构（must_pass/should_pass/must_not_violate）为 AI 提供了"主动暂停并提问"的结构化依据
3. **CLEAR 是 SDD 的 SAND 实现**：CLEAR 质量检查清单是 SDD 规格质量验证的具体操作化，确保意图声明达到 Spec-Anchored 级别的严谨度
4. **HIP 是信任校准工具**：HIP 级别应随团队对 AI 的信任校准而渐进调整，而非固定不变
5. **SAND 定位**：Intent Statement + Execution Contract = SDD Spec-Anchored 层级的形式化。SAND 不是在发明新概念，而是在**系统化已有的行业最佳实践**

---

## 引用来源

- Hassan, A.E. et al. (2026). "Towards AI-Native Software Engineering (SE 3.0)." *ACM TOSEM*. DOI: [10.1145/3807901](https://dl.acm.org/doi/10.1145/3807901)
- Hassan, A.E. et al. (2025). "Agentic Software Engineering: Foundational Pillars and a Research Roadmap." [arXiv:2509.06216](https://arxiv.org/abs/2509.06216)
- Collaborative AI Literacy and Metacognition (2025). *Taylor & Francis*. [DOI](https://www.tandfonline.com/doi/full/10.1080/10447318.2025.2543997)
- Complementarity in Human-AI Collaboration (2025). *EJIS*. [DOI](https://www.tandfonline.com/doi/full/10.1080/0960085X.2025.2475962)
- Schmutz, J.B. et al. (2024). "AI-Teaming: Redefining Collaboration." *Current Opinion in Psychology*. [PubMed](https://pubmed.ncbi.nlm.nih.gov/39024969/)
- SDD 行业来源: [Augment Code](https://www.augmentcode.com/guides/what-is-spec-driven-development), [DeepLearning.AI](https://www.deeplearning.ai/short-courses/spec-driven-development-with-coding-agents), [CGI](https://www.cgi.com/en/blog/artificial-intelligence/spec-driven-development)
