# AI 原生组织定义

AI 原生双层工程蓝图。AI 赋能 vs AI 优先 vs AI 原生的三级谱系。"移除 AI 测试"评估标准。

---

## 概述

"AI 原生"（AI-Native）不是一个精度术语——它在 2024-2026 年的行业语境中正在从模糊的营销口号演化为具有操作性定义的工程概念。SAND 框架需要一个**可操作化的定义**来支撑成熟度评估（Assess 阶段），使 `sand-assess-maturity` Skill 能够判断一个组织在 AI 采纳谱系上的位置。

本文档建立 SAND 对"AI 原生"的操作化定义，基于三条理论线索：

1. **行业共识**——从多个独立来源中涌现的 AI 采纳三级谱系
2. **学术框架**——Hassan 等人 SE 3.0 演进路径中对 AI 原生阶段的定义
3. **SAND 独有标准**——基于上述理论推导的"移除 AI 测试"和双层蓝图

---

## AI 采纳三级谱系

软件组织对 AI 的采纳可以沿一条**累进式谱系**描述。三个阶段不是互相替代，而是累进包含——AI 原生组织同时具备 AI 赋能和 AI 优先的所有特征，但其**设计重心**从根本上不同。

### AI 赋能（AI-Enabled）

> 在现有产品和流程中添加 AI 功能；核心价值在没有 AI 的情况下仍然存在。

**特征：**
- AI 作为"附加层"叠加到已有系统上（如在 IDE 中安装 Copilot）
- 开发流程不因 AI 的引入而改变
- AI 故障时系统降级但不崩溃
- 组织结构和角色不因 AI 而调整

**典型信号：** 团队使用 AI 编码助手提升个人效率，但代码审查、测试策略、部署流程与引入 AI 前完全一致。

**SAND Assess 映射：** 大多数 2026 年软件组织处于此阶段。`sand-assess-maturity` 的"AI 工具采纳度"维度在 L3-L4 通常意味着组织已充分 AI 赋能。

### AI 优先（AI-First）

> AI 处于产品决策和开发流程的中心，但系统并非从零开始基于 AI 构建。

**特征：**
- AI 深度嵌入核心业务逻辑（如推荐引擎、风控模型）
- 开发流程围绕 AI 能力重新设计（如 AI 辅助代码审查成为标准环节）
- 技术决策以"AI 能否增强此环节"为默认考量
- 部分角色和职责因 AI 而重新定义

**典型信号：** 技术负责人在做架构决策时**默认考虑 AI 参与**——不是"要不要用 AI"，而是"AI 在这里承担什么角色"。

**SAND Assess 映射：** "意图驱动成熟度"和"编排能力"两个维度在 L3+ 通常标志着 AI 优先阶段。

### AI 原生（AI-Native）

> 产品和开发流程完全构建在 AI 基础上；移除 AI = 产品/流程不工作。

**特征：**
- AI 不是"辅助"而是**核心运行时组件**——系统的认知能力依赖 AI
- 人与 AI 的协作是结构化的契约关系（意图声明 + 执行契约），而非自由格式的提示词交互
- 开发流程本身就是人-AI 认知协作的产物——方法论即代码
- 组织结构为人-AI 协作而设计（如 FDE+ 角色、Mission Pod 编制）

**典型信号：** 如果明天所有 AI 工具同时消失，团队的**工作方式**而非仅仅工作效率会根本性崩塌——不是"做得慢了"，而是"不知道怎么做了"。

**SAND Assess 映射：** 7 个维度全部 L4+ 时，组织进入 AI 原生状态。这也是为什么 SAND 的成熟度评估不以单一维度为标准——AI 原生是一个**系统性的组织状态**。

---

## "移除 AI 测试"（Remove AI Test）

这是判断产品或流程是否达到 AI 原生状态的**最简操作化标准**：

> **如果移除所有 AI 组件，系统是完全失败（AI 原生）、显著降级但可用（AI 优先）、还是基本不受影响（AI 赋能）？**

该测试可在三个层面应用：

| 层面 | 测试问题 | AI 原生标准 |
|------|---------|------------|
| **产品层** | 移除 AI 后产品是否仍然工作？ | 产品核心功能不可运行 |
| **流程层** | 移除 AI 后开发流程是否仍然运转？ | 关键流程环节缺失（如意图声明无法生成、编排方案无法设计） |
| **组织层** | 移除 AI 后角色和协作模式是否仍然有意义？ | 核心角色定义失效（如 FDE+ 的"认知协作"职责无法履行） |

**SAND 的自身定位：** SAND 框架本身应通过"移除 AI 测试"——SAND 的 Skills 是在 AI Agent 环境中运行的工作流，移除 AI 宿主后 Skills 无法执行。这使得 SAND 不仅是关于 AI 原生的方法论，其自身就是 AI 原生的产品。

---

## AI 原生双层工程蓝图

SAND 将 AI 原生能力分为两个相互依赖的层面。这一分层源自对行业实践的观察：许多组织在**个人层**已高度 AI 赋能（工程师人人用 Copilot），但在**组织层**几乎没有 AI 原生的流程设计——这种不对称正是 SAND 成熟度评估要诊断的核心问题。

### 个人层（Individual Layer）

个人层关注单个工程师与 AI 的协作模式和效能。

| 能力域 | AI 赋能 | AI 优先 | AI 原生 |
|--------|---------|---------|---------|
| **编码** | 代码补全（Copilot 式） | 对话式代码生成（Cursor 式） | 意图驱动开发（Intent → Contract → Delivery） |
| **审查** | AI 辅助 lint/格式检查 | AI 生成审查建议 | 三通道并行验证（契约/安全/架构） |
| **决策** | 人类独立决策，AI 提供信息 | AI 参与决策建议 | 结构化人-AI 认知协作（HIP 机制） |
| **学习** | 个人使用 AI 搜索答案 | AI 辅助代码解释和知识获取 | 资产化循环（经验 → 结构化资产 → 复用） |

**对应 SAND 评估维度：** AI 工具采纳度、意图驱动成熟度

### 组织层（Organization Layer）

组织层关注团队和组织如何**系统性地**将 AI 嵌入开发流程和治理结构。

| 能力域 | AI 赋能 | AI 优先 | AI 原生 |
|--------|---------|---------|---------|
| **流程** | 在现有 Agile/Scrum 中使用 AI 工具 | 开发流程包含 AI 专用环节 | SDC 闭环——AI 参与从评估到学习的全周期 |
| **治理** | 无 AI 专项治理 | AI 输出需人工审批 | 结构化审计证据链（意图→Skill→决策→验证） |
| **编排** | 无编排概念 | 简单的 AI 工具链配置 | 拓扑化编排（Solo/Pipeline/Swarm/Hierarchy + HIP） |
| **度量** | 传统软件度量（行覆盖率等） | 增加 AI 相关度量（AI 参与度） | 7 维度成熟度雷达图 + 改进路径推荐 |
| **文化** | 个人自发使用 AI | 团队鼓励 AI 使用 | AI 协作内化为组织文化（最小切口→自然扩散） |

**对应 SAND 评估维度：** 编排能力、人类审查体系、学习与资产化、治理与合规、组织文化

---

## 与 Hassan SE 3.0 演进路径的对齐

Hassan 等人在 ACM TOSEM 论文 "Towards AI-Native Software Engineering (SE 3.0)" 中提出了软件工程的演进路径：

| SE 版本 | 特征 | SAND 谱系对应 |
|---------|------|-------------|
| **SE 1.0** | 人类写代码，确定性 | （前 AI 时代） |
| **SE 2.0** | 人类写代码 + FM 辅助补全，基本确定性 | AI 赋能 |
| **（SAND 扩展）** | AI 深度嵌入决策和流程，半概率性 | AI 优先 |
| **SE 3.0** | 意图驱动、对话式、AI 原生，概率性 | AI 原生 |

> **注：** Hassan 的原始 SE 演进路径不包含"AI 优先"这一中间阶段。SAND 的三级谱系将其作为 SE 2.0 到 SE 3.0 之间的过渡阶段引入，反映了行业实践中观察到的渐进转型现实。

Hassan 的 SE 3.0 技术栈四组件可直接映射到 SAND 的 SDC 阶段：

- **Teammate.next**（自适应 AI 伙伴）→ SAND Agent 角色（FDE+、问题域负责人、变革催化师）
- **IDE.next**（意图中心开发环境）→ SAND Intent 阶段（意图声明 + 执行契约）
- **Compiler.next**（多目标代码合成）→ SAND Build 阶段
- **Runtime.next**（SLA 感知执行）→ SAND Operate 阶段

> **参考文献：** Hassan, A.E., Oliva, G.A., Lin, D., Chen, B., & Jiang, Z.M. (2026). "Towards AI-Native Software Engineering (SE 3.0): A Vision and a Challenge Roadmap." *ACM Transactions on Software Engineering and Methodology (TOSEM)*. DOI: [10.1145/3807901](https://dl.acm.org/doi/10.1145/3807901)

---

## 对 SAND Assess 阶段的实践意义

1. **谱系定位是评估的第一步：** `sand-assess-maturity` 应首先帮助用户识别其组织在 AI 采纳谱系上的位置（AI 赋能 / AI 优先 / AI 原生），然后深入 7 维度评估
2. **双层不对称是核心诊断目标：** 大多数组织的个人层远超组织层——这种不对称正是 SAND 要诊断和修复的
3. **"移除 AI 测试"是校准工具：** 当评估结果有争议时，该测试提供一个简单的判断锚点
4. **改进路径指向组织层：** 由于个人层的 AI 采纳通常已充分，SAND 的改进路径推荐应聚焦于组织层的系统性提升

---

## 引用来源

- Hassan, A.E. et al. (2026). "Towards AI-Native Software Engineering (SE 3.0)." *ACM TOSEM*. DOI: [10.1145/3807901](https://dl.acm.org/doi/10.1145/3807901)
- Hassan, A.E. et al. (2025). "Agentic Software Engineering: Foundational Pillars and a Research Roadmap." [arXiv:2509.06216](https://arxiv.org/html/2509.06216v2)
- Intetics (2026). "The State of AI-Native Software Engineering: 2026 Industry Analysis." [White Paper](https://intetics.com/white-papers/the-state-of-ai-native-software-engineering-2026-industry-analysis/)
- EPAM (2025). "The Future of SDLC is AI-Native Development." [Insights](https://www.epam.com/insights/ai/blogs/the-future-of-sdlc-is-ai-native-development)
