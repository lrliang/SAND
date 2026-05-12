---
stepsCompleted: ["step-01-init", "step-02-discovery", "step-02b-vision", "step-02c-executive-summary", "step-03-success", "step-04-journeys", "step-05-domain", "step-06-innovation", "step-07-project-type", "step-08-scoping", "step-09-functional", "step-10-nonfunctional", "step-11-polish", "step-12-complete"]
completedAt: "2026-05-12"
releaseMode: "phased"
classification:
  projectType: "methodology-framework"
  projectTypeDetail: "文档体系 + 可执行 Skill 架构 + 模板资产库 + 插件生态"
  domain: "ai-native-software-engineering"
  complexity: "high"
  projectContext: "brownfield"
inputDocuments:
  - "_bmad-output/planning-artifacts/research/domain-ai-native-development-methodology-research-2026-05-11.md"
  - "_bmad-output/planning-artifacts/research/domain-foundations-deep-dive-2026-05-12.md"
  - "_bmad-output/planning-artifacts/research/technical-sand-tools-metrics-feasibility-research-2026-05-12.md"
  - "_bmad-output/brainstorming/brainstorming-session-2026-05-11-02.md"
  - "docs/README.md"
  - "ref_docs/index.md"
documentCounts:
  briefs: 0
  research: 3
  brainstorming: 1
  projectDocs: 80
  referencesDocs: 20
workflowType: 'prd'
userRequirements:
  - "编排层（Orchestrate）支持插件式介入外部 Skill 库（superpower、bmad-method、design-frontend 等）"
  - "能够 Validate 外部 Skill 的有效性，只有通过验证的才能进入编排"
  - "以上两点需在工具能力体系中明确覆盖"
---

# Product Requirements Document - SAND

**Author:** Leon
**Date:** 2026-05-12

## Executive Summary

SAND（Scaled AI-Native Development）是一套面向软件开发组织 AI 原生转型的**可执行全景方法论框架**。它解决的核心问题不是"如何选择 AI 工具"，而是**"人如何与 AI 正确协作，并使这种协作可系统化、可审计、可渐进扩展"**。

2026 年的行业现实是一个深刻矛盾：85% 的开发者已在使用 AI 工具，AI 编码助手市场达 $128 亿——但 95% 的 AI 试点无法产生可衡量财务回报，PR 审查时间暴涨 441%，开发者对 AI 输出的信任从 70% 骤降至 29%。根本原因是**方法论缺位和组织信任赤字**——行业把 AI 原生转型错误地当作工具采纳问题，而忽视了方法论和组织结构的系统性重设计。

SAND 的目标用户覆盖三类角色：（1）**技术负责人/工程管理者**——需要从诊断到行动的可执行转型路径；（2）**FDE+/一线工程师**——需要意图驱动的结构化人-AI 协作工作流；（3）**合规/架构师**——需要每个 AI 决策都有可追溯的证据链来回答"为什么信任 AI 生成的代码"。

SAND 融合三大结构基因——SAFe 的全景图可视化、TOGAF 的标准化方法循环、bmad-method 的方法论即代码——形成"可执行的全景方法论"这一全新框架物种。其核心引擎 SDC（SAND Development Cycle）包含 7 阶段闭环（Assess → Intent → Orchestrate → Build → Validate → Operate → Learn）+ 治理中心轴，在 L1 个体到 L4 组织四层嵌套运转。框架理论基础建立在 5 大经过 2025-2026 年权威验证的学术理论之上（Hassan SE 3.0、Fowler 非确定性范式、SDD 意图驱动、Mikkonen 生成式复用风险、Agentic AI 治理理论）。

## What Makes This Special

**诊断即处方：** 成熟度评估不止于告诉你"哪里红了"——它直接生成可执行改进路径，每条路径指向具体的 Skill 和预期 ROI。评估和行动之间零摩擦。

**AI 主动协作：** 意图驱动的开发流中，AI 不是"你说我做"的被动执行者，而是主动识别你未预见的边界条件并请求澄清——这是"认知协作"而非"工具使用"。

**全链路审计：** 每个 AI 决策都有完整证据链——意图 ID → 执行的 Skill 版本 → 人工确认点 → 合规标准映射（EU AI Act / ISO 42001）。架构师终于能回答"为什么我们要信任 AI 生成的代码"。

**棕地友好的渐进注入：** 不要求团队停下来学新方法论。从一个红色维度开始，运行一个 Skill，看到效果，再扩展。侵入性最小的渐进式转型，而非大爆炸式组织重构。

**开放插件生态：** 编排层支持插件式接入外部 Skill 库（superpower、bmad-method、design-frontend 等），通过验证机制确保只有有效的 Skill 才能进入编排——形成一个活跃的方法论工具生态系统。

## Project Classification

| 维度 | 分类 |
|------|------|
| **产品类型** | 方法论框架（Methodology Framework）— 文档体系 + 可执行 Skill 架构 + 模板资产库 + 插件生态 |
| **领域** | AI 原生软件工程（AI-Native Software Engineering） |
| **复杂度** | 高（High）— 理论深度 + 组织变革 + 监管合规 + 技术生态快速变化 |
| **项目上下文** | 棕地（Brownfield）— 已有完整文档体系（80+ 文件）和理论基础，需要产品化和可执行化 |

## Success Criteria

### User Success

**P0 — 技术负责人"诊断即处方"顿悟：**
- 外部团队（非 SAND 开发者）在 **1 小时内**跑通 `sand-assess-maturity`
- 生成的 7 维雷达图与团队自评结果一致（偏差不超过 1 级）
- 团队主动采纳并执行至少 1 条"红→黄"改进路径，持续执行 **≥2 周**

**P0 — FDE+"意图驱动协作"顿悟：**
- 新用户（3 年+工程经验，未使用过 SAND）连续 3 天使用 `sand-create-intent` + 执行运行时
- 完成 **≥2 个完整 SDC 循环**
- 反馈中出现"AI 补充了我没想到的边界条件"类表述，且全程无需提示词工程技巧

**P1 — 架构师"审计证据链"顿悟：**
- 审计日志通过模拟 SOC2 检查
- 每个 AI 决策可追溯至：意图 ID → 执行的 Skill 版本 → 人工确认点
- 证据链完整性满足外部审计师审查标准

### Business Success

**北极星指标：生态采纳 + 价值证明**

**生态采纳：**
- **≥3 个外部团队**在生产环境中使用核心 Skill **≥4 周**
- **≥1 个外部贡献者**提交非 trivial Skill 并通过验证机制入库

**价值证明：**
- **≥1 份第三方案例报告**，定量对比 SAND 前后的关键指标（PR 事故率、审查时间、AI 信任度）
- 对标行业恶化趋势（PR 审查时间 +441%、事故率 +242.7%），方向性验证 SAND 可逆转趋势即可

**MVP 不追求：** GitHub Stars、咨询收入、认证体系营收

### Technical Success

- **MVP = Phase 1-3 完成**：核心 Skills（assess/intent/validate）+ 完整 SDC 工作流 + Agent 角色（问题域负责人/FDE+/变革催化师）
- **Phase 3 关键微调**：加入轻量度量层——从 Git/PR/CI 自动抓取 3-5 个信号（PR 周期时间、事故标签、AI 参与度），支撑 ROI 量化闭环
- **Phase 4（Post-MVP）**：完整 MCP 集成的度量自动化
- 零基础设施门槛：`git clone` 即可使用，无需运行 Server 进程

### Measurable Outcomes

| 指标 | MVP 目标 | 度量方式 |
|------|---------|---------|
| 首次评估完成时间 | ≤1 小时 | 从 `sand-assess-maturity` 启动到雷达图生成的端到端时间 |
| SDC 循环完成率 | ≥80%（启动的循环中） | Skill 工作流 frontmatter 状态追踪 |
| 意图首通率（Intent First-Pass Rate） | ≥60%（新用户 3 天后） | Intent 状态机：Created → Validated 无回退 |
| 外部团队留存 | ≥3 团队 ×4 周 | Skill 使用日志 + 用户访谈 |
| 配置到首次运行时间 | ≤2 小时 | 从 `git clone` 到第一个 Skill 成功执行 |

## User Journeys

### Journey 1：林涛的诊断——从混乱指标到可执行路径（技术负责人）

**人物：** 林涛，36 岁，某 B2B SaaS 公司工程 VP，管理 4 个开发团队（~30 人）。去年引入 Cursor + Claude Code，个人效率确实提升了，但组织指标全面恶化：PR 审查积压从 2 天涨到 9 天，上季度两次重大生产事故都与 AI 生成代码相关，CTO 开始质疑 AI 投入的 ROI。

**Opening Scene：** 周五下午，林涛盯着 Grafana 仪表盘，PR 审查中位时间又创新高。团队里没人说 AI 不好用——每个人都在用，产出确实多了——但系统性问题在积累。他需要向 CTO 交一份"AI 投入回报分析"，却发现自己连"哪里出了问题"都说不清楚。他搜索"AI development methodology"，在一篇对比 SAFe AI-Native 和 SAND 的文章中发现了 `sand-assess-maturity`。

**Rising Action：** 林涛 `git clone` SAND 仓库，在 Claude Code 中运行 `sand-assess-maturity`。Skill 没有让他填写 50 页问卷，而是通过结构化对话引导他回答 7 个维度的关键问题——有些可以从 Git/CI 数据自动采集，有些需要他的判断。**45 分钟后**，一张 7 维雷达图生成了。他看到"人类审查体系"和"学习与资产化"两个维度深红（L1），而"AI 工具采纳度"已经是 L4。

第一反应是"这我知道"。但他点击红色的"人类审查体系"维度时，SAND 没有给他一段说教文字，而是生成了 **3 条可执行改进路径**：

- **路径 A**（2 周见效）：引入三层审查策略（L1 自动化 lint/test → L2 AI 辅助代码审查 → L3 深度人工仅用于架构决策），预期 PR 审查中位时间 -40%
- **路径 B**（4 周见效）：部署 `sand-validate-delivery` 三通道并行验证，预期变更失败率 -30%
- **路径 C**（6 周见效）：启动 `sand-run-retrospective` 建立 AI 资产化循环，预期资产复用率从 0% 到 20%

每条路径都指向具体的 Skill，带有预期 ROI 和所需时间投入。

**Climax：** 林涛把雷达图和改进路径截图发给 CTO："这是我们的 AI 成熟度诊断，这是改进计划。先从审查体系开始，2 周后看效果。"CTO 没有问"这又是什么新框架"，因为林涛展示的不是一套方法论，而是一个**具体的、有 ROI 预期的行动方案**。

**Resolution：** 3 周后，林涛的团队 PR 审查中位时间从 9 天降到 4.5 天。不是因为他们"学了 SAND"，而是因为他们运行了一个 Skill，它告诉他们该做什么、怎么做、做到什么程度。林涛在下一次雷达图校准中看到"人类审查体系"从 L1 变成了 L2。他开始看下一个红色维度。

**阻力触点：** 团队中的高级工程师张磊最初拒绝"又一个流程工具"。但当他发现 SAND 没有要求他改变任何现有工具（同样的 Cursor、同样的 GitHub、同样的 CI），只是在他提交 PR 前多了一个 AI 辅助的结构化审查步骤时，阻力消失了。

---

### Journey 2：陈雨的第一次意图循环——从提示词工程到认知协作（FDE+）

**人物：** 陈雨，29 岁，全栈工程师，4 年经验，日常使用 Cursor + Claude Code。她很擅长 prompting——知道怎么写上下文、怎么分解任务、怎么让 AI 生成高质量代码。但她从没用过 SAND。

**Opening Scene：** 陈雨被要求试用公司刚引入的 SAND 工作流。她内心有点抵触——"我已经很会用 AI 了，为什么需要一个框架？"她的第一个任务是实现一个多租户权限隔离功能。按以前的习惯，她会直接在 Cursor 里写一段详细的 prompt，包含需求描述、技术约束和代码风格要求。

**Rising Action：** 她运行 `sand-create-intent`。Skill 没有让她写 prompt，而是通过结构化对话引导她定义一个**意图声明**——purpose、desired_outcome、acceptance_criteria、constraints、context_references、meta、intent_type——7 个字段。她发现自己被迫思考一些平时跳过的问题："这个功能的验收标准是什么？""不可违反的约束有哪些？"

CLEAR 质量检查在她写完后自动运行：**Complete** ✓、**Lean** ✓、**Executable** ⚠️（发现 acceptance_criteria 缺少性能基线）、**Assessable** ✓、**Reversible** ✓。她补充了性能基线后，意图声明转化为执行契约。

第一天：她完成了一个完整的 SDC 微循环。感觉比直接 prompting 多花了 15 分钟在意图定义上，但代码审查时几乎没有返工。

**Climax：** 第二天，第二个 SDC 循环。她定义了一个关于"租户数据迁移"的意图。执行过程中，AI 在生成迁移脚本时**主动暂停**，提出了三个她没想到的边界条件：

1. "当源租户和目标租户的 schema 版本不一致时，迁移脚本如何处理？"
2. "如果迁移过程中源租户产生新数据，是否需要增量同步？"
3. "回滚窗口应设为多长？当前执行契约未指定。"

这不是 AI 在"猜测她想要什么"——这是 AI 基于她定义的意图声明和执行契约，**主动识别了契约未覆盖的边界**，并请求人类澄清。她第一次感受到"认知协作"和"提示词工程"的根本区别：**前者基于结构化契约让 AI 成为思考伙伴，后者基于自然语言让 AI 成为执行工具。**

**Resolution：** 第三天结束时，陈雨完成了 3 个 SDC 循环。她不再觉得意图声明是"多余的步骤"，而是发现它让她的思考更完整，AI 的输出更可预测，审查时间几乎为零——因为验收标准在开始之前就已经定义清楚了。她在团队分享会上说："我以前以为自己很会用 AI。现在我觉得以前只是在用一个很聪明的搜索引擎。"

---

### Journey 3：赵明的审计难题——从"相信我"到"这是证据"（合规/架构师）

**人物：** 赵明，41 岁，金融科技公司首席架构师，负责技术合规。公司的产品涉及支付处理，受 PCI DSS 和即将全面执行的 EU AI Act 约束。上季度，外部审计师问了一个他无法回答的问题："你们 AI 生成的代码，决策依据是什么？谁审批的？版本记录在哪里？"

**Opening Scene：** 赵明知道团队用 AI 生成了大约 40% 的代码。他也知道这些代码通过了测试。但他无法证明**决策过程**——为什么选择这个实现方案？AI 生成时的上下文是什么？哪个人类审查了哪些关键决策？Git blame 只能告诉他谁提交的，不能告诉他谁做了什么决策以及为什么。

**Rising Action：** 公司技术负责人（林涛的角色）已经在团队中引入了 SAND 工作流。赵明最初不关心"方法论"——他只关心"我能不能过审计"。他打开 `sand-governance-audit` Skill。

Skill 扫描了过去 4 周使用 SAND 工作流产生的所有工件，自动生成了一份**审计追踪报告**。报告的结构让他眼前一亮：

| 字段 | 内容 |
|------|------|
| **Intent ID** | `INT-2026-0512-003` |
| **意图声明** | 实现多租户权限隔离——含完整 7 字段 |
| **执行契约版本** | `v1.2`（含 CLEAR 检查通过记录） |
| **编排方案** | Solo 拓扑，Claude Opus 4.6，HIP-2（关键决策人工审查） |
| **执行的 Skill** | `sand-create-intent@v0.3.1` → `sand-validate-delivery@v0.2.0` |
| **人工确认点** | 3 个（意图审查 ✓、边界条件澄清 ✓、交付验证 ✓） |
| **验证结果** | 契约验证 ✓、安全扫描 ✓、架构对齐 ✓ |

**Climax：** 赵明把这份报告展示给外部审计师。审计师的反应不是"通过"——而是"这是我见过的**第一个能回答'AI 为什么做了这个决策'**的系统。"赵明意识到，SAND 不只是帮他过了这次审计，而是为他建立了一个**持续合规的基础设施**——每次使用 SAND 工作流，审计证据就自动积累。

**Resolution：** 赵明开始要求所有涉及支付核心逻辑的开发必须走 SAND 工作流——不是因为"方法论好"，而是因为"这是我们唯一能在审计中证明 AI 决策合理性的方式"。他向 CTO 提交了一份 EU AI Act 合规差距分析，其中 SAND 的治理中心轴覆盖了 38 项 ISO 42001 控制措施中的 26 项。

---

### Journey 4：吴芳的变革战役——从一个红色维度撬动一个抵触的团队（变革催化师）

**人物：** 吴芳，34 岁，工程效能团队负责人，被指派为公司的 SAND 变革催化师。她的挑战：4 个开发团队，32 个工程师，已经"混乱但高产地"用 AI 开发了 2 年。没人觉得有问题——"我们的 feature 交付速度是行业平均的 3 倍"。但质量指标在恶化，只是还没有爆发到不可忽视的程度。

**Opening Scene：** 吴芳参加了 SAND 的 `sand-assess-maturity` 评估后，拿到了组织级的雷达图。结果确认了她的直觉：工具采纳度 L4（极高），但人类审查体系 L1（几乎没有）、学习与资产化 L1（每个团队在重复造轮子）。她的问题不是"做什么"，而是"怎么让一个不觉得自己有问题的团队接受改变"。

**Rising Action：** 吴芳没有召集全员大会宣布"我们要采用 SAND 方法论"。她选择了**最小切口策略**：

**第 1 周——用数据制造认知失调：** 她从 Git/CI 抓取了 5 个信号（SAND Phase 3 轻量度量），生成了一份简短报告展示给 4 个团队 Lead：
- "我们的 PR 合并量是去年的 3 倍（好事），但 PR 审查中位时间从 1.5 天涨到 7 天（坏事）"
- "上季度 3 次生产事故中，2 次的根因是 AI 生成的代码未经充分审查"
- "4 个团队各自开发了类似的认证中间件，没有任何复用"

**第 2 周——最小实验：** 她邀请最开放的一个团队（团队 A）做一个 2 周实验："只在 PR 审查环节加入 `sand-validate-delivery` 的三通道检查，其他一切不变。"

关键设计：**不需要改变任何现有工具**（同样的 IDE、同样的 Git、同样的 CI），只是在 PR 流程中增加一个 AI 辅助的结构化验证步骤。

**团队 A 内部的"被动参与者"反应：** 高级工程师王鹏最初翻白眼——"又多一个检查流程"。但第一次运行时，三通道验证在 3 分钟内发现了一个他的 PR 中的安全漏洞（一个未转义的用户输入拼接到了 SQL 查询中）。这个漏洞在之前的纯人工 review 中被漏掉了。王鹏没有表扬 SAND，但他也没有再抱怨了。

**Climax：** 2 周实验结束，团队 A 的数据：PR 审查时间 -35%，变更失败率 -50%（样本小，但方向明确）。吴芳没有拿着这个数据去"推广 SAND"。她把报告发给了另外 3 个团队 Lead，只附了一句话："团队 A 在试一个东西，效果不错，你们有兴趣看看吗？"

**第 3-4 周——自然扩散：** 团队 B 的 Lead 主动找吴芳要 `sand-validate-delivery`。团队 C 在看到团队 A/B 的审查效率提升后跟进。团队 D（最抵触的）在第 6 周才加入——触发点是他们自己的一次生产事故，事后发现如果用了三通道验证本可以拦截。

**Resolution：** 3 个月后，吴芳再次运行组织级 `sand-assess-maturity`。"人类审查体系"从 L1 升到了 L3。没有一次全员培训，没有一次"方法论迁移"会议，没有人被要求停下工作学习新框架。SAND 是通过**一个红色维度 → 一个 Skill → 一个团队 → 可见效果 → 自然扩散**的路径渗透进组织的。

---

### 次要角色：外部 Skill 贡献者（简化用户故事地图）

**人物：** 刘洋，某前端团队 Tech Lead，在 GitHub 发现 SAND，觉得缺少前端特有的 Skill。

| 阶段 | 用户行为 | SAND 系统行为 | 关键产出 |
|------|---------|-------------|---------|
| **发现** | 浏览 SAND 文档和 Skill 目录，发现缺少 `sand-design-frontend` | Skill 目录清晰展示已有 Skill 和扩展点 | 贡献意愿 |
| **开发** | 参照 Skill 开发指南，基于 `customize.toml` 标准创建前端设计 Skill | SAND 提供 Skill 脚手架模板和开发者文档 | Skill 初稿 |
| **提交** | 通过标准化 PR 流程提交 Skill | 自动化验证机制运行：结构检查 + 步骤完整性 + 模板格式 + 沙箱测试 | 验证报告 |
| **验证** | 根据验证反馈修改 | Skill 验证机制确认有效性后标记为"已验证" | 入库 |
| **生态** | 其他团队在编排层插件式引入该 Skill | 编排层自动发现已验证的外部 Skill | 生态扩展 |

*完整旅程规划在 Phase 4（Post-MVP），随生态成熟度同步展开。*

---

### Journey Requirements Summary

| 旅程 | 揭示的核心能力需求 |
|------|-------------------|
| **林涛（技术负责人）** | 成熟度评估引擎、7 维雷达图生成、可执行改进路径推荐（Skill + ROI）、轻量度量采集（Git/CI 信号） |
| **陈雨（FDE+）** | 意图声明结构化创建（7 字段）、CLEAR 自动质量检查、执行契约生成、AI 主动边界条件识别、SDC 微循环运行时 |
| **赵明（架构师）** | 审计追踪报告自动生成、意图-Skill-决策证据链、合规标准映射（SOC2/ISO 42001/EU AI Act）、治理中心轴基础设施 |
| **吴芳（变革催化师）** | 最小切口策略支持（单维度 + 单 Skill 启动）、组织级 vs 团队级雷达图对比、数据驱动的认知失调报告、渐进扩散追踪 |
| **刘洋（贡献者）** | Skill 开发脚手架、开发者文档、自动化 Skill 验证机制、Skill 目录和发现机制、编排层插件接口 |

## Domain-Specific Requirements

### 领域特殊性定位

SAND 本身不是受监管的产品，但其用户在受监管环境中使用它。SAND 的领域约束本质上是**代理性约束**——框架必须帮助用户满足其行业合规要求，同时在快速变化的 AI 生态中保持稳定性和可采纳性。

### 领域约束矩阵

| 约束维度 | MVP 必须满足的最低要求 | 可延后到 Phase 4-5 |
|---------|----------------------|-------------------|
| **合规代理** | 通用审计日志（意图 ID、Skill 版本、人工确认点） | 行业模板映射（PCI DSS / HIPAA / EU AI Act 细化） |
| **AI 生态变化** | 模型无关 + Skill 契约版本（`sandskill.v1`，承诺 ≥18 个月向前兼容） | 多模型动态路由、自动适配 |
| **知识产权** | `sand-validate-delivery` 输出中增加非阻塞许可证警告提示 | 自动依赖扫描 + 许可证污染检测 |
| **术语竞争** | 内部统一术语 + 对外映射表（Intent Statement ↔ SDD、SDC ↔ Context Engineering 闭环、FDE+ ↔ Harness Engineering + AI 增强） | — |
| **渐进采纳** | 支持单 Skill 独立运行，不要求全栈部署 | 自动发现 Skill 间依赖关系 |
| **工作流嵌入** | 至少 CLI 或 IDE 插件方式运行（不强制 Web 仪表盘） | 深度集成 GitHub PR、Jira |
| **可干预性** | 至少一个环节的人工覆盖示例（HIP 机制） | 全流程可干预 UI |
| **数据隐私** | 架构支持数据流向配置（文档声明级别） | 本地模型接入、审计代理 |

### Compliance & Regulatory

**通用审计框架（MVP）：**
- 每个 SDC 循环产生的工件自动记录：意图 ID → Skill 版本 → 执行参数 → 人工确认点 → 验证结果
- 审计日志格式标准化，支持导出为 JSON/CSV
- 不绑定特定行业标准，但日志结构设计时预留行业映射扩展点

**行业合规映射（Phase 5）：**
- ISO 42001 38 项控制措施映射
- EU AI Act 高风险系统合规路径
- 行业垂直模板（金融 PCI DSS、医疗 HIPAA）

### Technical Constraints

**Skill 契约版本化：**
- 定义 `sandskill.v1` 契约标准，涵盖：激活协议、输入/输出格式、frontmatter 结构、customize.toml schema
- 承诺 ≥18 个月向前兼容——外部团队和贡献者可基于稳定契约开发 Skill
- 版本升级时提供迁移指南和兼容性检查工具

**模型无关性：**
- Skill 工作流不硬编码任何特定模型调用
- 通过 Agent 角色定义中的 `model_requirement` 字段声明能力需求（而非模型名称）
- 用户可在 `customize.toml` 中配置首选模型

**零基础设施约束：**
- `git clone` + 支持 Skill 的 IDE/CLI（Claude Code、Cursor、Codex CLI 等）即可运行
- 不要求安装额外运行时、数据库或后端服务
- 所有状态通过文件系统（frontmatter YAML、Markdown 工件）管理

### Integration Requirements

**MVP 集成面：**
- Git 仓库（读取提交历史、PR 数据用于轻量度量）
- CI/CD 管线（读取构建/测试结果用于度量信号）
- 现有 IDE Agent 生态（作为 Skill 宿主运行）

**不要求集成：**
- 不修改现有 CI 管线配置
- 不要求 IDE 插件安装（Skill 通过 IDE 内置的 Agent 能力运行）
- 不要求 Web 仪表盘部署

### Risk Mitigations

| 风险 | 影响 | 缓解策略 |
|------|------|---------|
| **框架疲劳**——团队拒绝"又一个方法论" | 采纳失败 | 渐进注入设计：单 Skill 可独立运行，无需理解全框架；变革催化师旅程验证此策略 |
| **AI 生态洗牌**——底层模型/框架被淘汰 | 技术锁定 | Skills 架构天然模型无关；Skill 契约版本化提供 18 个月稳定性窗口 |
| **术语被稀释**——行业术语标准化后 SAND 术语变成方言 | 认知负担 | 对外映射表 + 文档中明确注出行业关联；避免创造不必要的新词 |
| **过度工程化**——为合规/度量引入过重基础设施 | MVP 延期 | Skills-First 架构确保前 6 周零基础设施；MCP 仅在 Phase 4+ 引入 |
| **许可证污染**——AI 生成代码引入 copyleft 代码 | 法律风险 | MVP 提供手动检查提示；Phase 4+ 集成自动扫描工具 |

## Innovation & Novel Patterns

### Detected Innovation Areas

**创新一：可执行的全景方法论（Executable Panoramic Methodology）**

传统方法论框架（SAFe、TOGAF、Scrum）是"人读的文档"——团队需要培训、认证、教练才能落地。SAND 首次将方法论的三个层面统一为一个可执行系统：全景图层（What）定义组件和关系、方法循环层（How）标准化流程、可执行层（Run）通过 Skills 架构让方法论直接在 IDE/CLI 中运行。**这使得方法论的采纳从"组织变革项目"降维为"运行一个 Skill"。**

**创新二：诊断-处方零摩擦闭环**

现有的成熟度评估工具（DORA、DX Core 4、CMMI）产出的是报告——团队拿到报告后仍需自行规划改进路径。SAND 的 `sand-assess-maturity` 将评估和行动直接短路：雷达图上的每个红色维度自动关联到具体的 Skill + 预期 ROI + 所需时间投入。**评估即行动计划。**

**创新三：Skill 契约 + 插件生态 = 方法论的开源化**

传统方法论是封闭的——SAFe 的内容受版权保护，TOGAF 需要购买标准文档。SAND 通过 `sandskill.v1` 契约标准和编排层插件接口，首次让方法论具备了类似 npm/pip 的生态扩展模式：任何人可以开发 Skill、提交验证、供全生态使用。**方法论从"消费品"变为"平台"。**

**创新四：AI 决策审计证据链的结构化**

现有的 AI 治理工具关注的是模型层面的公平性、偏见和安全性。SAND 首次关注**开发过程中 AI 决策的可追溯性**——每个意图到执行到验证的完整证据链。这填补了从"模型治理"（ISO 42001）到"开发过程治理"之间的空白。

### Market Context & Competitive Landscape

| 创新维度 | SAND | 最接近的替代方案 | 差距 |
|---------|------|-----------------|------|
| 可执行方法论 | Skills 架构，`git clone` 即用 | SAFe（认证 + 教练驱动） | SAFe 需 $10K+ 认证投入，SAND 零成本 |
| 诊断即处方 | 雷达图 → Skill + ROI | DORA/DX（产出报告，不提供行动） | DORA 需额外咨询/规划才能行动 |
| 方法论生态 | 开放 Skill 契约 + 验证机制 | 无直接竞品 | 全新品类 |
| 开发过程审计 | 意图-Skill-决策证据链 | 无直接竞品（模型治理工具不覆盖） | 全新品类 |
| 三源融合 | SAFe + TOGAF + bmad-method | 各自独立存在 | 从未被组合 |

### Validation Approach

| 创新 | 验证方法 | 成功标准 | 对应 MVP 指标 |
|------|---------|---------|-------------|
| 可执行方法论 | 外部团队 `git clone` → 跑通 Skill | ≤2 小时首次运行 | 配置到首次运行时间 |
| 诊断即处方 | 技术负责人评估 → 采纳改进路径 | 1 小时内完成 + ≥1 条路径执行 ≥2 周 | 林涛顿悟场景 P0 |
| 方法论生态 | 外部贡献者提交 Skill | ≥1 个非 trivial Skill 通过验证 | 生态北极星指标 |
| 开发过程审计 | 模拟 SOC2 检查 | 审计师可追溯 AI 决策链 | 赵明顿悟场景 P1 |

### Innovation Risk Mitigation

| 创新风险 | 概率 | 影响 | 缓解策略 |
|---------|------|------|---------|
| "可执行方法论"概念过于新颖，市场不理解 | 中 | 高 | 不推销"方法论"——推销具体的痛点解决（"你的 PR 审查时间太长？运行这个 Skill"） |
| Skill 生态冷启动问题 | 高 | 中 | MVP 先验证核心 Skill 价值，生态扩展是 Phase 4+ 目标 |
| 审计证据链对非受监管行业无吸引力 | 中 | 低 | P1 优先级已正确反映；非受监管团队通过诊断和意图驱动路径进入 |
| 三源融合导致框架过重 | 中 | 高 | 渐进注入设计 + 单 Skill 独立运行确保最小采纳门槛 |

## Methodology Framework Specific Requirements

### Project-Type Overview

SAND 是一个方法论框架产品，其技术架构不同于传统的 SaaS 或开发者工具——它的"运行时"是用户的 IDE/CLI Agent 环境，"部署"是 `git clone`，"状态管理"是文件系统上的 YAML frontmatter。这种架构选择直接源自"零基础设施门槛"和"棕地友好"两个核心约束。

### Skill Host Compatibility

**MVP 验证矩阵：**

| 宿主 | MVP 状态 | 覆盖场景 | 最低版本要求 |
|------|---------|---------|------------|
| **Claude Code** | ✅ 主力验证 | CLI 重度用户、终端工作流 | `claude_code: >=1.0` |
| **Cursor** | ✅ 主力验证 | IDE 集成用户、编辑器内工作流 | `cursor: >=1.0`（待确认具体版本） |
| Codex CLI | 🏷️ 社区适配中 | — | — |
| Gemini CLI | 🏷️ 社区适配中 | — | — |
| VS Code + Copilot | 🏷️ 社区适配中 | — | — |

**Skill sandbox 声明标准：** 每个 Skill 的 `skill.yaml` 中必须包含 `host_requirements` 字段，声明所需宿主能力（如文件读写、Agent 子进程、MCP 支持等），以便在不支持的宿主上给出明确错误提示而非静默失败。

### Distribution & Installation

**MVP 分发机制：纯 Git 仓库**

```
git clone https://github.com/[org]/sand-framework.git
cd sand-framework
# 即可在 Claude Code / Cursor 中运行 Skill
```

- 不提供 npm/pip 包——避免发布、依赖、版本管理的复杂度
- 目标用户（技术负责人、FDE+）熟悉 `git clone`，采纳者为主动探索型
- 框架仓库与示例 Skill 仓库分开管理，示例 Skill 锁定在已知可工作的框架 commit

**未来分发路径（Phase 3-4）：**
- `npx sand-cli` 或 `pip install sand-framework`
- 优先级由用户反馈驱动

### Skill Development Guide

**MVP 最小可验证文档集：**

| 文件 | 内容 | 字数上限 |
|------|------|---------|
| `docs/skill-dev-guide.md` | Skill 目录结构、`skill.yaml` 字段说明、验证要求、提交流程 | ≤2000 字 |
| `examples/sample-external-skill/` | 一个完整可运行的外部 Skill 示例（如对接 Jira 的工作流 Skill） | — |
| `scripts/create-skill.sh` | 生成新 Skill 骨架的脚手架脚本 | — |

**充分性论证：** 满足"≥1 个外部贡献者提交非 trivial Skill"的北极星指标。初期贡献者大概率是深度合作方，通过示例 + 一对一协作即可完成提交。完整 SDK 文档留到 Phase 4。

### Template & Artifact Format Standards

**格式选择：人类可读 YAML + 基础 JSON Schema（可选）**

| 工件 | 格式 | JSON Schema | 运行时验证 |
|------|------|-------------|-----------|
| 意图声明（Intent Statement） | YAML | ✅ `schemas/intent.schema.json` | 必填字段检查 |
| 执行契约（Execution Contract） | YAML | ✅ `schemas/contract.schema.json` | 必填字段检查 |
| 成熟度评估报告 | YAML | ✅ `schemas/assessment.schema.json` | 必填字段检查 |
| 审计日志 | JSON/CSV | ⏳ Phase 3 | — |
| Skill 元数据（skill.yaml） | YAML | ✅ `schemas/skill.schema.json` | 结构检查 |

- JSON Schema 提供 IDE 补全和文档工具支持，成本低
- MVP 运行时仅做必填字段轻量校验（Python/TypeScript stdlib）
- 完全自动化严格验证（`sand validate --strict`）延后到 Phase 3

### Version Management Strategy

**框架版本：SemVer，MVP 期间 `0.x.x`**
- `0.x.x` 明确不承诺向前兼容——MVP 阶段允许 breaking changes
- `1.0.0` 在 MVP 验证完成且核心 API 稳定后发布

**Skill 契约版本：独立标识，与框架版本解耦**
- `sandskill.v1` 作为独立契约版本，承诺 ≥18 个月向前兼容
- Skill 契约版本变更（如 `sandskill.v2`）仅在 breaking change 时递增
- 框架可在不改变 Skill 契约的前提下迭代

**版本同步机制：**
- 每个可执行 Skill 根目录包含 `.sand-version` 文件，声明最低框架版本要求（如 `sand-framework >= 0.2.0`）
- CI 中增加 `version-check` 步骤（仅警告，不阻断）
- 框架仓库与外部 Skill 仓库分开管理

### Architecture Decision Records (ADR)

在 `docs/adr/` 中记录关键技术决策及其上下文：

| ADR 编号 | 决策 | 核心理由 |
|---------|------|---------|
| ADR-001 | MVP 仅验证 Claude Code + Cursor 两个宿主 | 覆盖 CLI + IDE 两类用户，其余社区适配 |
| ADR-002 | MVP 使用纯 Git 仓库分发，不提供包管理器 | 避免发布复杂度，目标用户熟悉 git |
| ADR-003 | Skill 开发者文档为最小可验证集 | 初期贡献者通过深度合作完成 |
| ADR-004 | YAML 格式 + 可选 JSON Schema | 人类可读优先，Schema 支持 IDE 补全 |
| ADR-005 | 框架 SemVer 0.x.x + Skill 契约独立版本 | 框架允许 breaking change，Skill 生态需要稳定性 |
| ADR-006 | Skills-First + MCP-When-Needed 架构策略 | 差异化价值是引导工作流而非外部系统集成 |
| ADR-007 | 轻量度量用 Skill 内嵌脚本实现 | 棕地集成低摩擦，无需额外服务 |

## Project Scoping & Phased Development

### MVP Strategy & Philosophy

**MVP 方法：Problem-Solving MVP** — 不追求完整平台体验，而是验证"SAND 能否解决 AI 原生开发中的方法论缺位问题"。MVP 成功的标志不是功能完备，而是**外部团队在真实环境中使用核心 Skill 并产生可度量的改善**。

**资源需求：** 1-2 人核心团队（框架设计 + Skill 开发），8 周全职投入。前 6 周纯 Markdown/YAML 编写，Phase 3 需要轻量脚本开发能力（Python/Shell）。

### Phase 1（0-3 周）：核心 Skills + 审计基础设施

**核心交付：**

| Skill/组件 | 类型 | 支撑的用户旅程 |
|-----------|------|-------------|
| `sand-assess-maturity` | 多步骤引导工作流 | 林涛（P0）、吴芳（P1） |
| `sand-create-intent` | 多步骤引导工作流 | 陈雨（P0） |
| `sand-validate-delivery` | 检查清单工作流 | 陈雨（P0）、吴芳（P1） |
| YAML 模板集 | 模板 | 全旅程 |
| JSON Schema 集 | 验证基础 | 全旅程 |
| `SandAuditEvent` schema + 空事件记录 | 审计基础设施 | 赵明（P1 前置准备） |

**审计基础设施前置（关键风险缓解）：**
- 定义 `SandAuditEvent` JSON Schema：`intentId`、`skillVersion`、`timestamp`、`actor`、`inputHash`、`outputHash`
- Phase 1 所有 Skill 在执行时记录审计事件到 `.sand/audits/`（占位级别，不验证完整性）
- 确保审计数据格式在前 3 周即被验证，Phase 2 只需叠加验证层

**模板集：**
- `schemas/intent.schema.json`、`schemas/contract.schema.json`、`schemas/assessment.schema.json`
- `schemas/skill.schema.json`、`schemas/audit-event.schema.json`
- `templates/intent-statement.yaml`、`execution-contract.yaml`、`maturity-assessment.yaml`

### Phase 2（3-6 周）：编排 + 治理 + 插件基础 + 贡献者工具链

**核心交付（优先级排序）：**

| 优先级 | Skill/组件 | 类型 | 支撑的用户旅程 |
|-------|-----------|------|-------------|
| **P0** | `sand-design-orchestration` | 决策引导工作流 | 全旅程（编排核心） |
| **P0** | 插件基础验证机制 + 贡献者工具链 | 基础设施 | 刘洋（贡献者） |
| **P1** | `sand-governance-audit` | 检查清单 + 报告 | 赵明（P1） |
| **P2** | `sand-run-retrospective`（基础版） | 数据收集 | — |

**范围微调（vs 原 Step 3 计划）：**

| 组件 | 原计划 | 调整后 | 理由 |
|------|--------|-------|------|
| `sand-run-retrospective` | Phase 2 完整版 | Phase 2 仅基础数据收集（结构化日志输出），分析报告生成移至 Phase 3 | 陈雨顿悟不依赖回顾分析；降低 Phase 2 密度 |
| Skill 间文件链接 | Phase 2 自动化闭环 | Phase 2 采用约定优于配置：标准目录结构，手动传递。自动发现移至 Phase 3 | 基础设施可延后，用户可接受约定路径 |
| 插件验证机制 | 完整验证 | 基础校验（manifest 格式 + Skill 入口存在 + 示例运行），不含依赖解析或沙箱 | 满足"第一个外部 Skill"的北极星指标即可 |

**插件基础验证 + 贡献者工具链（前置至 Phase 2）：**
- `scripts/sand-skill-init.sh`：生成新 Skill 骨架
- `scripts/sand-skill-validate.sh`：运行基础校验
- `examples/sample-external-skill/`：完整可运行的外部 Skill 示例
- 确保外部贡献者在 Phase 3 开始即可提交 Skill

**`sand-design-orchestration` 包含：**
- 拓扑选型引导（Solo/Pipeline/Swarm/Hierarchy）
- HIP 级别配置（HIP-1/2/3）
- 外部 Skill 插件注册接口：`.sand/plugins/` 目录 + 已验证 Skill 清单
- 编排方案输出到 `.sand/orchestration-plan.yaml`

**标准目录结构约定：**
```
.sand/
├── intents/        ← 意图声明和执行契约
├── audits/         ← 审计事件日志
├── metrics/        ← 轻量度量输出
├── plugins/        ← 外部 Skill 注册
├── assessments/    ← 成熟度评估结果
└── retrospectives/ ← 回顾数据
```

### Phase 3（6-8 周）：Agent 角色 + 度量 + 回顾完善 + 贡献者验证

**核心交付：**

| Skill/组件 | 类型 | 说明 |
|-----------|------|------|
| `sand-agent-domain-lead` | Agent 角色 | 问题域负责人 |
| `sand-agent-fde` | Agent 角色 | FDE+ 交付工程师 |
| `sand-agent-catalyst` | Agent 角色 | 变革催化师 |
| `sand-measure-light` | Skill 内嵌脚本 | 轻量度量采集（Git/PR/CI 5 个信号） |
| `sand-run-retrospective`（完整版） | 引导式工作流 | 回顾分析报告 + 资产化入库建议 |
| Skill 间自动文件发现 | 基础设施 | glob 模式自动链接 `.sand/` 子目录 |
| `docs/skill-dev-guide.md` | 文档 | ≤2000 字开发者指南 |
| 组织级 `customize.toml` 指南 | 文档 | 3 层 TOML merge 定制化说明 |

**轻量度量层实现（ADR-007）：**
- Skill 内嵌脚本（Python/Shell），不引入独立采集服务
- `sand-measure-light` 运行 `git log` + CI API 调用，输出 JSON 到 `.sand/metrics/`
- Fallback：CI 无法暴露 API 时接受手动 CSV
- 棕地集成低摩擦——任何有 `git` + `curl` 的环境即可运行

**外部贡献者验证窗口：**
- Phase 3 开始即向合作方开放 Skill 提交（Phase 2 工具链已就绪）
- 2 周窗口完成：贡献者开发 → 提交 → 验证通过 → 入库

### Post-MVP Features

**Phase 4（8-14 周）：度量自动化**
- 度量采集 MCP Server（完整效率+质量指标自动化）
- 复用现有 MCP 生态（GitHub/Grafana/Jira MCP Server）
- Grafana 仪表盘（L1-L4 交叉矩阵可视化）
- 资产库管理系统（Git + 向量数据库索引）
- 完整 SDK 文档 + 包管理器分发

**Phase 5（14-20 周）：企业就绪**
- MCP Gateway（审计/合规——多团队场景）
- 供应商管理框架
- ISO 42001 / EU AI Act 合规映射
- 行业垂直合规指南
- 高级插件验证（依赖解析、沙箱、版本兼容性）

### Risk Mitigation Strategy

**Technical Risks：**

| 风险 | 概率 | 缓解策略 |
|------|------|---------|
| Phase 2 密度仍然过高 | 中 | retrospective 降为 P2，可安全滑入 Phase 3 前期 |
| 审计验证层失败 | 低 | Phase 1 前置 Schema + 空事件；Phase 2 仅叠加验证逻辑 |
| 轻量度量无法获取 CI 数据 | 中 | 手动 CSV fallback |

**Market Risks：**

| 风险 | 概率 | 缓解策略 |
|------|------|---------|
| 外部团队不愿试用 | 中 | "最小切口"策略——从一个 Skill 开始 |
| 无外部贡献者 | 中 | Phase 2 前置工具链，Phase 3 给合作方 2 周窗口 |
| "可执行方法论"概念不被理解 | 中 | 推销痛点解决，不推销方法论 |

**Resource Risks：**

| 风险 | 概率 | 缓解策略 |
|------|------|---------|
| 团队规模不足 | 中 | Phase 1-2 纯 Markdown/YAML，1 人可完成 |
| 外部团队协调成本高 | 低 | 2 个核心宿主减少适配工作 |

## Functional Requirements

### 成熟度评估与诊断

- **FR1:** 技术负责人可以通过结构化对话完成 7 维度成熟度评估，无需填写传统问卷
- **FR2:** 系统可以从 Git/CI 数据自动采集部分评估维度的量化信号（PR 周期时间、事故标签、AI 参与度等）
- **FR3:** 系统可以生成 7 维雷达图，展示各维度的成熟度等级（L1-L5）
- **FR4:** 系统可以根据雷达图红色维度自动生成可执行改进路径，每条路径关联具体 Skill 和预期 ROI
- **FR5:** 技术负责人可以对比多次评估结果，查看维度变化趋势（如"L1→L2"的进展）
- **FR6:** 变革催化师可以分别运行团队级和组织级评估，查看聚合雷达图
- **FR7:** 系统可以将每次评估结果（原始回答 + 雷达图 JSON）持久化到 `.sand/assessments/{timestamp}_{team_id}.json`，支持按团队、时间范围查询历史评估
- **FR8:** 系统可以生成组织级聚合雷达图（取各维度中位数或加权平均），并可下钻到单个团队的雷达图

### 意图管理

- **FR9:** FDE+ 可以通过引导式对话创建符合 7 字段标准的意图声明（purpose、desired_outcome、acceptance_criteria、constraints、context_references、meta、intent_type）
- **FR10:** 系统可以对意图声明自动运行 CLEAR 质量检查（Complete/Lean/Executable/Assessable/Reversible），标记未通过项并提示修正
- **FR11:** FDE+ 可以从已验证的意图声明自动生成执行契约（must_pass/should_pass/must_not_violate 三级结构）
- **FR12:** 系统可以在执行过程中基于意图声明和执行契约主动识别未覆盖的边界条件，并请求人类澄清
- **FR13:** FDE+ 可以查看意图的生命周期状态（Draft → Reviewed → Approved → In Execution → Validated → Archived）
- **FR14:** 系统可以按意图类型分类管理（Feature/Fix/Refactor/Exploration/Optimization）

### 执行运行时

- **FR15:** 系统可以根据已验证的意图声明和编排方案，启动执行会话（`sand-run`），依次调用所选 Agent 拓扑中的 Skill（内部或外部），将每个 Skill 的输出链接到下一个 Skill 的输入，并实时记录执行状态到 `.sand/executions/`

### 编排与插件生态

- **FR16:** FDE+ 可以通过引导式工作流选择 Agent 编排拓扑（Solo/Pipeline/Swarm/Hierarchy）
- **FR17:** FDE+ 可以为编排方案配置人类介入等级（HIP-1 全自主 / HIP-2 关键决策审查 / HIP-3 全程监督）
- **FR18:** 系统可以通过 `.sand/plugins/` 目录注册外部 Skill，编排层自动发现已验证的 Skill
- **FR19:** 外部贡献者可以使用脚手架工具（`sand-skill-init`）生成符合 `sandskill.v1` 契约的 Skill 骨架
- **FR20:** 系统可以对提交的外部 Skill 运行基础验证（manifest 格式、Skill 入口存在、示例运行通过）
- **FR21:** FDE+ 可以在编排方案中插件式引入已验证的外部 Skill 库（superpower、bmad-method、design-frontend 等）
- **FR22:** 系统可以输出结构化编排方案到 `.sand/orchestration-plan.yaml`

### 交付验证

- **FR23:** 系统可以对交付物运行三通道并行验证（契约验证、安全合规、架构对齐）
- **FR24:** 系统可以生成结构化验证决策（通过/有条件通过/打回 Build/重定向 Intent）
- **FR25:** 系统可以在验证输出中包含非阻塞许可证警告提示，建议手动检查工具
- **FR26:** FDE+ 可以查看验证结果与意图声明的对齐度分析

### 意图偏差追踪

- **FR27:** 系统在验证结果与意图声明出现偏差时（包括但不限于：验收条件未完全满足、安全合规警告、架构约束冲突），自动记录偏差事件到 `.sand/executions/{session_id}/deviations.json`，包含偏差类型、严重程度、关联的验收条款、以及建议的修正动作。FDE+ 可在复盘时查看偏差清单并将其标记为"已解决/接受风险/打回重建"

### 治理与审计

- **FR28:** 系统可以在每个 Skill 执行时自动记录审计事件（intentId、skillVersion、timestamp、actor、inputHash、outputHash）到 `.sand/audits/`
- **FR29:** 架构师可以运行治理审计 Skill 生成审计追踪报告，展示意图→Skill→决策的完整证据链
- **FR30:** 审计报告可以导出为 JSON/CSV 格式，支持外部审计师审查
- **FR31:** 系统可以记录每个人工确认点的时间戳、确认人和确认内容

### 上下文安全与数据隐私

- **FR32:** 在意图创建和执行时，系统默认仅将签名化的接口契约、依赖关系摘要、以及用户显式标记的上下文片段发送给 AI 模型。完整代码文件默认不上传，除非用户在 constraints 中明确授权并记录审计事件
- **FR33:** 系统支持用户配置数据脱敏规则（如替换敏感字符串、移除内部路径），并在发送前自动应用

### 度量与洞察

- **FR34:** 系统可以通过内嵌脚本从 Git/PR/CI 自动采集 5 个轻量信号（PR 周期时间、事故标签、AI 参与度、变更失败率、部署频率）
- **FR35:** 技术负责人可以查看度量输出（`.sand/metrics/` JSON 文件），用于雷达图校准和改进路径 ROI 计算
- **FR36:** 系统可以接受手动提供的 CSV 作为度量数据 fallback（当 CI API 不可访问时）
- **FR37:** 变革催化师可以生成数据驱动的"认知失调报告"（展示好消息 vs 坏消息的对比）

### 学习与资产化

- **FR38:** FDE+ 可以通过引导式工作流完成 AI 复盘（5 议题标准），输出结构化日志
- **FR39:** 系统可以基于复盘结果生成资产化入库建议（5 类 AI 资产：上下文资产、意图模式、编排配方、验证规则、失败案例）
- **FR40:** 系统可以追踪飞轮加速指标（资产复用率、意图首通率、循环周期压缩率）

### 框架基础设施

- **FR41:** 用户可以通过 `git clone` 获取 SAND 框架，在 Claude Code 或 Cursor 中直接运行 Skill
- **FR42:** 组织可以通过 3 层 TOML merge（base → team → user）定制 Skill 行为，无需修改 Skill 源码
- **FR43:** 每个 Skill 可以通过 `.sand-version` 文件声明最低框架版本要求
- **FR44:** 系统可以在运行时对 YAML 工件执行必填字段轻量校验（基于 JSON Schema）
- **FR45:** 每个 Skill 可以通过 `skill.yaml` 中的 `host_requirements` 字段声明所需宿主能力，在不支持的宿主上给出明确错误提示
- **FR46:** 系统可以通过 `.sand/` 标准目录结构（intents/、audits/、metrics/、plugins/、assessments/、retrospectives/、executions/）管理所有工件状态
- **FR47:** 系统可以通过 glob 模式自动发现并链接 `.sand/` 子目录中的 Skill 工件（Phase 3 实现；Phase 2 采用约定路径手动传递）
- **FR48:** 3 个 Agent 角色（问题域负责人、FDE+、变革催化师）可以通过菜单分发机制引导用户选择合适的工作流入口

## Non-Functional Requirements

### 安全与隐私

- **NFR1:** 所有通过 SAND Skill 发送给 AI 模型的上下文数据必须经过 FR44 定义的最小化处理——默认不发送完整代码文件，仅发送接口契约和用户显式标记的片段
- **NFR2:** 审计日志（`.sand/audits/`）中的每条记录必须包含 `inputHash` 和 `outputHash`，确保事后可验证数据完整性（不可篡改）
- **NFR3:** 外部 Skill 插件在执行前必须通过基础验证（FR17），未验证的 Skill 不可被编排层调用
- **NFR4:** 用户配置的脱敏规则（FR45）必须在数据离开本地环境前同步应用，不存在"先发送后脱敏"的时间窗口
- **NFR5:** `.sand/` 目录中的所有工件文件遵循最小权限原则——默认不含可执行代码，仅为声明式数据文件（YAML/JSON/CSV）

### 兼容性与可移植性

- **NFR6:** 所有核心 Skill 必须在 Claude Code 和 Cursor 两个宿主上产出一致的结果（给定相同输入，输出的 YAML 工件结构相同；AI 生成内容的非确定性变化不计入一致性要求）
- **NFR7:** Skill 工作流不依赖任何宿主特有功能——如果使用了宿主特有能力，必须通过 `host_requirements` 声明并提供降级路径
- **NFR8:** 所有 YAML/JSON 工件文件使用 UTF-8 编码，兼容 macOS/Linux/Windows 文件系统
- **NFR9:** `sand-measure-light` 的度量采集脚本必须在任何有 `git` + `curl`（或手动 CSV fallback）的环境中运行，不依赖特定 CI 平台 SDK

### 可维护性与演进

- **NFR10:** `sandskill.v1` 契约在发布后 ≥18 个月内保持向前兼容——在此期间，基于 v1 契约开发的外部 Skill 无需修改即可运行
- **NFR11:** 框架版本（SemVer `0.x.x`）允许 breaking changes，但每次 breaking change 必须在 CHANGELOG 中记录迁移路径
- **NFR12:** 每个 ADR 必须包含：决策、上下文、备选方案、理由、日期——支持后续基于用户反馈的快速调整
- **NFR13:** Skill 的 3 层 TOML 定制化（base → team → user）不能引入版本漂移——team/user 层的 override 仅覆盖声明的字段，未声明字段继承 base 默认值

### 可靠性

- **NFR14:** Skill 工作流中断（用户中断、宿主崩溃、网络断开）后可从最后完成的步骤恢复——通过 frontmatter `stepsCompleted` 数组实现断点续传
- **NFR15:** 任何 Skill 执行失败不得损坏已有的 `.sand/` 工件——失败时工件保持上一个一致状态（写入操作应为原子性或使用临时文件 + 重命名）
- **NFR16:** 审计事件记录（FR24）必须在 Skill 执行成功和失败两种情况下都写入——失败的执行同样需要审计追踪

### 性能

- **NFR17:** `sand-assess-maturity` 的完整评估流程（含 Git/CI 数据采集）在典型规模项目（≤100K 行代码、≤500 个 PR/月）上可在 1 小时内完成
- **NFR18:** `sand-measure-light` 的度量采集在典型规模 Git 仓库上可在 5 分钟内完成
- **NFR19:** Skill 步骤文件加载和 frontmatter 解析延迟 ≤2 秒——用户不应感知到"框架开销"
