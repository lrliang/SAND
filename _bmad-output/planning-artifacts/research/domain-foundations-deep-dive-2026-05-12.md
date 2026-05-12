---
stepsCompleted: [1]
workflowType: 'research-supplement'
research_type: 'domain-deep-dive'
research_topic: 'SAND框架核心章节理论引用链——专项深度研究'
parent_research: 'domain-ai-native-development-methodology-research-2026-05-11.md'
user_name: 'Leon'
date: '2026-05-12'
---

# 专项研究报告：SAND 框架核心理论引用链

**日期：** 2026-05-12
**作者：** Leon
**类型：** 补充深度研究（针对 `docs/01-foundations/` 存根文件的理论引用基础）

---

## 研究目的

当前 `docs/01-foundations/` 下的 7 个文件**全部为存根状态**，仅有一行概要和 TODO 标记。本专项研究为每个存根文件建立**可直接引用的完整论据链**，包括：原始出处 URL、核心论点精确表述、关键引用句、以及对 SAND 设计原则的推导关系。

---

## ⚠️ 重要发现：第五理论基石引用风险

**在深度搜索过程中发现：SAND 的第五大理论基石——"Wang 等学者(2026)的 Agentic Consensus 范式"——无法通过公开学术数据库验证。**

经过多轮精确搜索（含 arXiv、ACM DL、Google Scholar 覆盖），未找到任何以"Agentic Consensus"+"typed property graph"+"operational consensus layer"为核心概念的已发表论文。最接近的匹配是：

- **Charles L. Wang et al. (2025)**. "MI9: An Integrated Runtime Governance Framework for Agentic AI." [arXiv:2508.03858](https://arxiv.org/abs/2508.03858) —— 涉及 Agentic AI 治理和图基元素（delegation graph），但不涉及"operational consensus"或"typed property graph as world model"
- **arXiv:2510.19692** "Toward Agentic Software Engineering Beyond Code" — Wang 等人讨论了 agentic programming 的社会技术关切，但未提出 consensus 概念

**风险评估**：此引用可能源自原始 LLM 辅助概念设计时的"幻觉引用"。建议采取以下措施之一：
1. **替换**：用可验证的 MI9 (Wang 2025) 或其他治理框架论文替代
2. **重新定位**：将"可治理可审计原则"的理论来源改为 Mikkonen 的"人类审查不可削减" + ISO 42001 + NIST AI RMF 的组合
3. **降级**：从"五大理论基石"降为"设计参考"，保留概念但不作为核心理论引用

---

## 一、非确定性编程范式——完整引用链

### 核心文件：`docs/01-foundations/non-deterministic-paradigm.md`

### 1.1 Martin Fowler 的完整著作清单

| # | 标题 | 日期 | URL | 核心贡献 |
|---|------|------|-----|---------|
| F1 | "LLMs bring new nature of abstraction" | 2025/6 | [martinfowler.com](https://martinfowler.com/articles/2025-nature-abstraction.html) | **核心论文**：LLM 不只是提升抽象层级，而是横向滑入非确定性 |
| F2 | "Some thoughts on LLMs and Software Development" | 2025/8 | [martinfowler.com](https://martinfowler.com/articles/202508-ai-thoughts.html) | 容错类比："结构工程师建入容差来处理无法测量的因素" |
| F3 | "Harness engineering for coding agent users" | 2026/4 | [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html) | **2026 新贡献**：约束工程——计算控制（确定性）vs 推断控制（非确定性） |
| F4 | "Engineering Practices for LLM Application Development" | — | [martinfowler.com](https://martinfowler.com/articles/engineering-practices-llm.html) | LLM 应用开发的工程化实践 |
| F5 | "Emerging Patterns in Building GenAI Products" | — | [martinfowler.com](https://martinfowler.com/articles/gen-ai-patterns/) | GenAI 产品构建的涌现模式 |
| F6 | Fragments: 2026-02-09 | 2026/2 | [martinfowler.com](https://martinfowler.com/fragments/2026-02-09.html) | 认知债务：AI 大量生成代码时团队是否还在学习？ |
| F7 | Fragments: 2026-04-29 | 2026/4 | [martinfowler.com](https://martinfowler.com/fragments/2026-04-29.html) | 法律与非确定性的类比 |

### 1.2 可直接引用的核心论述（原文精确引用）

**论点一：范式跃迁的本质**
> "The appearance of LLMs will change software development to a similar degree as the change from assembler to the first high-level programming languages... but with the distinction that it isn't just raising the level of abstraction, but also forcing us to consider what it means to program with non-deterministic tools."
> — Fowler, "LLMs bring new nature of abstraction" (2025/6)

**论点二：抽象 + 非确定性的双重移动**（Birgitta Boeckeler 的精辟表述）
> "We're not just moving up the abstraction levels, we're moving sideways into non-determinism at the same time."
> — Birgitta Boeckeler, quoted in Fowler (2025/6)

**论点三：容错思维的工程类比**
> "Other forms of engineering have to take into account the variability of the world. A structural engineer builds in tolerance for all the factors she can't measure... Software Engineering is unusual in that it works with deterministic machines."
> — Fowler, "Some thoughts on LLMs" (2025/8)

**论点四：对 AI 输出的信任模型**
> "You've got to treat every slice as a [pull request] from a rather dodgy collaborator who's very productive in the lines-of-code sense of productivity, but you know you can't trust a thing that they're doing."
> — Fowler, Pragmatic Engineer interview (2025/11)

**论点五：约束工程的双分类**
> Computational controls（计算控制）: 确定性、快速、CPU 驱动——测试、lint、类型检查、结构分析
> Inferential controls（推断控制）: 语义分析、AI 代码审查、LLM-as-judge——更慢、更贵、更非确定性
> — Fowler, "Harness engineering" (2026/4)

### 1.3 Rebecca Parsons：幻觉即特性

**核心论述**
> "All an LLM does is produce hallucinations, it's just that we find some of them useful."
> — Rebecca Parsons (Thoughtworks CTO Emerita), quoted by Fowler

**Thoughtworks 专文**（2025/8）：[We need to treat AI hallucinations as a feature, not a bug](https://www.thoughtworks.com/en-us/insights/blog/generative-ai/we-need-to-treat-AI-hallucinations-as-a-feature-not-a-bug)
- LLM 不是逻辑引擎而是概率引擎
- "幻觉"是系统按设计运行的结果而非故障
- 提出**风险矩阵方法**（错误答案的影响 × 幻觉概率）替代"始终验证"的笼统规则

### 1.4 Birgitta Boeckeler 的贡献

- 身份：Thoughtworks Global Lead for AI-assisted Software Delivery, Distinguished Engineer
- 核心贡献：非确定性的"横向移动"隐喻
- 关键文章/演讲：
  - [Thoughtworks Podcast: AI-assisted coding](https://www.thoughtworks.com/insights/podcasts/technology-podcasts/ai-assisted-coding-experiences-perspectives)
  - [Dev Interrupted: Making Sense of Agentic AI](https://linearb.io/dev-interrupted/podcast/making-sense-of-agentic-AI)
  - [QCon London 2025 演讲](https://qconlondon.com/speakers/birgittabockeler)

### 1.5 Kent Beck：Augmented Coding

**与非确定性范式的关系**：Beck 从实践者角度回应了 Fowler 的理论框架。

**核心区分——Augmented Coding vs Vibe Coding**：
- **Vibe Coding**：不关心代码本身，只关心系统行为。出错时把错误反馈给 AI 期望修复
- **Augmented Coding**：关心代码、其复杂度、测试和覆盖率。价值观与手写代码相同——整洁且可运行的代码

**关键发现**（B+ Tree 实验项目）：
- AI 超越陈述要求，实现了 Beck "想要但未明说"的功能
- 但 AI 缺乏品味（taste）——例如可能向巨大函数再添加 20 行
- 开发者每小时做出更多重大决策，同时处理更少的常规任务

**来源：**
- [Augmented Coding: Beyond the Vibes](https://tidyfirst.substack.com/p/augmented-coding-beyond-the-vibes) (2025/6)
- [AI & Software Development](https://tidyfirst.substack.com/p/ai-and-software-development) (2024/4)
- [Pragmatic Engineer: TDD, AI agents and coding with Kent Beck](https://newsletter.pragmaticengineer.com/p/tdd-ai-agents-and-coding-with-kent) (2025/6)
- 播客 *Still Burning*（2026/3 启动）

### 1.6 → SAND 设计原则的推导

```
Fowler 范式跃迁论 + Boeckeler 横向非确定性 + Parsons 幻觉即特性
    ↓
SAND 设计原则 #1：非确定性容纳原则（Non-Determinism Accommodation）
    ↓
实践映射：
  - Validate 阶段的"意图对齐验证"而非传统"测试"
  - Build 阶段的"三层审查策略"
  - Fowler 的"约束工程"双分类 → SAND 的 L1/L2/L3 审查策略

Beck Augmented Coding → SAND FDE+ 角色的"裁决能力"
  - "做更多重大决策，处理更少常规任务"正是 FDE+ 的能力画像
```

---

## 二、认知协作模型——完整引用链

### 核心文件：`docs/01-foundations/cognitive-collaboration.md`

### 2.1 Hassan SE 3.0 论文——精确引用

**论文全称**：Hassan, A.E., Oliva, G.A., Lin, D., Chen, B., & Jiang, Z.M. (2026). "Towards AI-Native Software Engineering (SE 3.0): A Vision and a Challenge Roadmap." *ACM Transactions on Software Engineering and Methodology (TOSEM)*.

**DOI**: [10.1145/3807901](https://dl.acm.org/doi/10.1145/3807901)

**SE 演进路径精确定义**：
- **SE 1.0**：人类写代码，确定性
- **SE 2.0**：人类写代码 + FM 辅助补全（基本确定性），以 Copilot 为代表。局限：认知过载、低效率
- **SE 3.0**：意图驱动、对话式、AI 原生（概率性）——AI 从任务驱动 copilot 进化为理解意图的智能协作者

**技术栈四组件**：
- **Teammate.next**：自适应、个性化的 AI 伙伴关系
- **IDE.next**：意图中心、对话式开发环境
- **Compiler.next**：多目标代码合成
- **Runtime.next**：SLA 感知执行，支持边缘计算

**配套论文**：Cogo, F.R., Oliva, G.A., & Hassan, A.E. (2025). "Compiler.next: A Search-Based Compiler to Power the AI-Native Future of Software Engineering." [arXiv:2510.24799](https://arxiv.org/pdf/2510.24799)

### 2.2 SASE 框架——Hassan 团队的扩展

**论文**：Hassan, A.E. et al. (2025). "Agentic Software Engineering: Foundational Pillars and a Research Roadmap." [arXiv:2509.06216](https://arxiv.org/html/2509.06216v2)

**ICSE 2026 Technical Briefing**：基于 AIDev 数据集 + 567 个 Claude Code PR 的实证研究

**自治等级分类**：
| Level | 名称 | 对应 SE | 特征 |
|-------|------|--------|------|
| 0 | Manual | — | 人类完全手动 |
| 1 | Token Assistance | SE 1.5 | 代码补全 |
| 2 | Conversational | SE 2.0 | 对话式辅助 |
| 3 | Goal-Agentic | SE 3.0 | Agent 将目标映射为代码变更 |
| 4 | Project-level | SE 4.0 | 管理整个项目 |
| 5 | General Domain | SE 5.0 | 完全自主 |

### 2.3 人-AI 认知协作的学术基础

**分布式认知理论**（Distributed Cognition）：
- 认知过程不局限于单一个体，而是分布在人、工具、环境和时间之间
- 协作式 AI 概念与分布式认知理论天然契合
- 来源：[Collaborative AI Literacy and Metacognition](https://www.tandfonline.com/doi/full/10.1080/10447318.2025.2543997) (2025, Taylor & Francis)

**互补性理论**（Complementarity）：
- 人-AI 协作的理想结果是互补团队绩效（CTP）——双方单独无法达到的水平
- 目前 CTP 很少被观察到，说明对互补性原则的理解和应用不足
- 人类和 AI 会犯不同类型的错误，因此"组队"时可能实现更优结果
- 来源：[Complementarity in Human-AI Collaboration](https://www.tandfonline.com/doi/full/10.1080/0960085X.2025.2475962) (2025, EJIS)

**人-AI 组队（HAT）的关键挑战**（Schmutz et al., 2024）：
- 添加 AI 队友通常会降低协调性、沟通和信任
- 对 AI 的信任随时间下降——因为能力被初始高估
- 来源：[AI-Teaming: Redefining Collaboration](https://pubmed.ncbi.nlm.nih.gov/39024969/) (2024, Current Opinion in Psychology)

**元认知**（Metacognition）：
- 在 AI 交互过程中的自我调节思维对有效使用至关重要
- 来源：CMU NSF AI Institute 研究

**美国国家科学院 HAT 研讨会系列**（2025）：
- AI 从被动工具到主动协作者的转变
- AI 可扮演多种角色：导师、教练、助手或同伴
- 来源：[National Academies HAT Series](https://www.nationalacademies.org/event/45078_05-2025_future-trajectories-of-human-ai-collaboration-and-teaming)

### 2.4 → SAND 设计原则的推导

```
Hassan SE 3.0 意图驱动愿景 + 分布式认知理论 + 互补性理论
    ↓
SAND 设计原则 #2：意图驱动原则（Intent-Driven Principle）
    ↓
实践映射：
  - 意图声明 7 字段标准 ← SE 3.0 "intent-centric" 核心主张
  - 执行契约 ← SE 3.0 "conversation-oriented" 开发模式
  - FDE+ 角色 ← 认知互补性——人类定义意图，AI 处理实现

HAT 信任衰减研究 → SAND HIP-1/2/3 渐进式人类介入模型
  - 初始高信任 → 随暴露逐渐校准 → 需要结构化的信任框架
```

---

## 三、Agent 编排理论——完整引用链

### 核心文件：涉及 `docs/02-development-cycle/orchestrate/` 多个文件

### 3.1 多 Agent 系统编排——核心学术论文

**综合性综述**：
1. **"The Orchestration of Multi-Agent Systems: Architectures, Protocols, and Enterprise Adoption"** (Jan 2026)
   - [arXiv:2601.13671](https://arxiv.org/abs/2601.13671)
   - 统一架构框架：规划 + 策略执行 + 状态管理 + 质量运维
   - MCP（工具访问）与 A2A（Agent 间协调）双协议深度技术拆解
   - 编排逻辑 + 治理框架 + 可观测性机制的系统设计

2. **"Multi-Agent Coordination across Diverse Applications: A Survey"** (Feb 2025)
   - [arXiv:2502.14743](https://arxiv.org/html/2502.14743v2)
   - 30 年 MAS 研究综述，含 LLM 时代的新发展
   - 协调图、稀疏加权通信、群体智能

3. **"Multi-Agent Collaboration Mechanisms: A Survey of LLMs"** (Jan 2025)
   - [arXiv:2501.06322](https://arxiv.org/pdf/2501.06322)
   - 可扩展框架：按 actors、type（合作/竞争/共竞）、structure（点对点/集中/分布式）、strategy（角色/模型）分类

### 3.2 编排模式分类

**六大生产级编排模式**（学术+行业共识）：

| 模式 | 机制 | 适用场景 | SAND 对应 |
|------|------|---------|----------|
| **Orchestrator-Worker** | 一个 Agent 分解任务、分配给专家 Worker | 明确可分解的任务 | SAND Hierarchy 拓扑 |
| **Fan-Out / Fan-In** | 多 Agent 并行执行 → 收集器聚合 | 可独立并行的子任务 | SAND Swarm 拓扑 |
| **Dynamic Handoff** | 每个 Agent 评估当前任务决定是否转交 | 不确定性高的探索性任务 | — |
| **Pipeline / Sequential** | 线性传递，每步处理 | 严格顺序依赖 | SAND Pipeline 拓扑 |
| **Debate / Adversarial** | 多 Agent 辩论+裁判 | 需要多视角验证 | — |
| **Hierarchical** | 多层管理者+执行者 | 大规模复杂系统 | SAND Hierarchy 拓扑 |

**SAND 已定义的四种标准拓扑 vs 行业实践**：
- **Solo**：有学术基础，对应单 Agent 系统
- **Pipeline**：有充分学术基础
- **Swarm**：有充分学术基础（Fan-Out/Fan-In）
- **Hierarchy**：有充分学术基础（Orchestrator-Worker + 多层级）
- **⚠️ 缺失**：Dynamic Handoff 和 Debate/Adversarial 两种模式——建议补充

### 3.3 十大 Agent 原型（Google DeepMind / TDS 研究）

| 原型 | 职责 |
|------|------|
| Orchestrator | 总调度 |
| Planner | 任务规划 |
| Executor | 任务执行 |
| Evaluator | 结果评估 |
| Synthesiser | 信息综合 |
| Critic | 批判性审查 |
| Retriever | 信息检索 |
| Memory Keeper | 记忆管理 |
| Mediator | 冲突调解 |
| Monitor | 运行监控 |

**关键发现："协调税"（Coordination Tax）** —— 准确率增益在超过 4 个 Agent 后趋于饱和甚至波动，说明结构化拓扑（而非简单增加 Agent 数量）才是关键。

### 3.4 通信协议学术基础

**四大 Agent 通信协议**：
1. **MCP (Model Context Protocol)** — Agent-工具交互标准
2. **A2A (Agent-to-Agent Protocol)** — Google 提出的 Agent 间通信协议
3. **ACP (Agent Communication Protocol)** — 替代方案
4. **ANP (Agent Network Protocol)** — 网络层协议

### 3.5 → SAND 设计的推导

```
MAS 编排综述 + 六大编排模式 + 十大 Agent 原型
    ↓
SAND Orchestrate 阶段设计：
  - O2 Agent 选型 ← 十大原型分类学
  - O3 拓扑设计 ← 六大编排模式（建议从 4 种扩展到 6 种）
  - O4 介入点设计 ← "协调税"研究证明超过 4 Agent 需结构化拓扑
  - O5 失败模式 ← 级联失败研究（"Bag of Agents" 错误率 17x）

MCP + A2A 双协议 → SAND 工具体系基础
```

---

## 四、生成式复用风险——完整引用链

### 核心文件：`docs/01-foundations/generative-reuse-risk.md`

### 4.1 Mikkonen & Taivalsaari 论文——精确引用

**会议论文**：
> Tommi Mikkonen and Antero Taivalsaari. 2025. "Software Reuse in the Generative AI Era: From Cargo Cult Towards Systematic Practices." In *Proceedings of the 16th International Conference on Internetware (Internetware '25)*, Trondheim, Norway, June 20–22. ACM, 541–544.
> - ACM DL: [10.1145/3755881.3755981](https://dl.acm.org/doi/10.1145/3755881.3755981)
> - arXiv: [2506.17937](https://arxiv.org/abs/2506.17937)

**扩展论文**：
> Antero Taivalsaari, Tommi Mikkonen, and Cesare Pautasso. 2025. "On the Future of Software Reuse in the Era of AI Native Software Engineering." arXiv: [2508.19834](https://arxiv.org/abs/2508.19834)

**作者单位**：University of Jyväskylä, Finland (Mikkonen) + Nokia Technologies, Tampere (Taivalsaari)

**核心论点**：
- AI 辅助的生成式代码复用在概念上与 Cargo Cult 开发**并无本质区别**
- 开发者将信任置于 AI 生成的代码上，但对代码的理解与手写代码时不同
- AI 作为主题"确实具有类似邪教的追随和'全能光环'"——人们对 AI 几乎可以神奇地完成任何事情投入了大量信仰

### 4.2 → SAND 设计原则的推导

```
Mikkonen Cargo Cult 理论 → "人类审查不可削减"原则
    ↓
SAND 设计原则 #4（部分）：可治理可审计原则
    ↓
实践映射：
  - Build 阶段"三层审查策略"的学术依据
  - Validate 阶段存在的根本理由
  - Learn 阶段资产化流程中"人类评审"步骤的不可省略性
```

---

## 五、AI 原生定义——完整引用链

### 核心文件：`docs/01-foundations/ai-native-definition.md`

### 5.1 Cao 等人——需要进一步定位

SAND v1 引用"Cao 等学者的 AI 原生双层工程蓝图"和"106 篇论文的灰色文献综合"。该引用需要进一步验证其精确出处。建议搜索 Cao + "AI-native" + "grey literature" + "systematic mapping" 等关键词组合。

**行业替代来源（可验证）**：
- Intetics White Paper: [The State of AI-Native Software Engineering: 2026 Industry Analysis](https://intetics.com/white-papers/the-state-of-ai-native-software-engineering-2026-industry-analysis/)
- EPAM: [The Future of SDLC is AI-Native Development](https://www.epam.com/insights/ai/blogs/the-future-of-sdlc-is-ai-native-development)

### 5.2 AI-Native 光谱（可验证定义）

- **AI-Enabled**：在现有产品中添加 AI 功能；核心价值在没有 AI 的情况下仍然存在
- **AI-First**：AI 处于产品/决策中心，但并非从零开始基于 AI 构建
- **AI-Native**：产品完全构建在 AI 基础上；移除 AI = 产品不工作

**"移除 AI 测试"（Remove AI Test）**：产品在没有 AI 的情况下是否完全失败（而非仅仅降级）？

---

## 六、对 bibliography.md 的更新建议

当前 bibliography.md 仅有一行概要。建议更新为以下结构化引用：

### 核心理论论文

1. **Fowler, M.** (2025). "LLMs bring new nature of abstraction." martinfowler.com. URL: https://martinfowler.com/articles/2025-nature-abstraction.html
2. **Fowler, M.** (2025). "Some thoughts on LLMs and Software Development." martinfowler.com. URL: https://martinfowler.com/articles/202508-ai-thoughts.html
3. **Fowler, M.** (2026). "Harness engineering for coding agent users." martinfowler.com. URL: https://martinfowler.com/articles/harness-engineering.html
4. **Hassan, A.E., Oliva, G.A., Lin, D., Chen, B., & Jiang, Z.M.** (2026). "Towards AI-Native Software Engineering (SE 3.0): A Vision and a Challenge Roadmap." *ACM TOSEM*. DOI: 10.1145/3807901
5. **Hassan, A.E. et al.** (2025). "Agentic Software Engineering: Foundational Pillars and a Research Roadmap." arXiv:2509.06216
6. **Cogo, F.R., Oliva, G.A., & Hassan, A.E.** (2025). "Compiler.next: A Search-Based Compiler." arXiv:2510.24799
7. **Mikkonen, T. & Taivalsaari, A.** (2025). "Software Reuse in the Generative AI Era: From Cargo Cult Towards Systematic Practices." *Internetware '25*. ACM. DOI: 10.1145/3755881.3755981
8. **Taivalsaari, A., Mikkonen, T., & Pautasso, C.** (2025). "On the Future of Software Reuse in the Era of AI Native Software Engineering." arXiv:2508.19834

### 认知协作与组织理论

9. **Schmutz, J.B. et al.** (2024). "AI-Teaming: Redefining Collaboration in the Digital Era." *Current Opinion in Psychology*.
10. **Flathmann, C., McNeese, N.J., & O'Neill, T.A.** (2025). "Designing High-Impact Experiments for Human-AI Teaming." *Journal of Cognitive Engineering and Decision Making*.

### Agent 编排与治理

11. **arXiv:2601.13671** (2026). "The Orchestration of Multi-Agent Systems: Architectures, Protocols, and Enterprise Adoption."
12. **arXiv:2502.14743** (2025). "Multi-Agent Coordination across Diverse Applications: A Survey."
13. **Wang, C.L. et al.** (2025). "MI9: An Integrated Runtime Governance Framework for Agentic AI." arXiv:2508.03858

### 行业思想领袖

14. **Beck, K.** (2025). "Augmented Coding: Beyond the Vibes." tidyfirst.substack.com
15. **Parsons, R.** (2025). "We need to treat AI hallucinations as a feature, not a bug." Thoughtworks Blog.
16. **Boeckeler, B.** (2025). Various podcasts and articles on AI-assisted software delivery. Thoughtworks.

### 行业报告

17. **DORA** (2025). "State of AI-Assisted Software Development." Google Cloud.
18. **DORA** (2026). "ROI of AI-Assisted Software Development." Google Cloud.
19. **Anthropic** (2026). "2026 Agentic Coding Trends Report."
20. **Thoughtworks** (2026). "Technology Radar Vol. 34." April 2026.

---

## 七、存根文件更新优先级建议

| 优先级 | 文件 | 引用链完备度 | 建议行动 |
|--------|------|------------|---------|
| **P0** | `non-deterministic-paradigm.md` | ★★★★★ 完备 | 可立即撰写——7 篇 Fowler 文章 + Beck + Parsons + Boeckeler |
| **P0** | `cognitive-collaboration.md` | ★★★★★ 完备 | 可立即撰写——Hassan ACM 论文 + 认知科学文献 |
| **P1** | `generative-reuse-risk.md` | ★★★★★ 完备 | 可立即撰写——2 篇精确论文引用 |
| **P1** | `design-principles.md` | ★★★★ 高 | 可撰写——四大原则到理论的推导链完整 |
| **P2** | `ai-native-definition.md` | ★★★ 中 | Cao 引用需验证，但有替代行业来源 |
| **P2** | `agentic-consensus.md` | ★★ 低 | ⚠️ 引用验证失败——需要决定替代策略 |
| **P2** | `bibliography.md` | ★★★★ 高 | 可立即更新——上述 20 条完整引用 |
