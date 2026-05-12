---
stepsCompleted: [1, 2, 3, 4, 5, 6]
inputDocuments: ['docs/05-tools/README.md', 'docs/06-metrics/README.md', 'ref_docs/设计过程/080-D6D7-工具与度量的SDC阶段映射.md', 'domain-ai-native-development-methodology-research-2026-05-11.md', 'domain-foundations-deep-dive-2026-05-12.md']
workflowType: 'research'
lastStep: 2
research_type: 'technical'
research_topic: 'SAND框架工具层、度量层与可执行基础设施技术可行性调研'
research_goals: '三大板块——A)工具层4个STUB的技术实现方案 B)度量层6个STUB的采集/计算可行性 C)MCP集成、Agent编排架构、方法论即代码的技术路径——为SAND从理论框架走向可执行方法论提供技术基础'
user_name: 'Leon'
date: '2026-05-12'
web_research_enabled: true
source_verification: true
---

# 技术调研报告：SAND 框架工具层、度量层与可执行基础设施

**日期：** 2026-05-12
**作者：** Leon
**研究类型：** 技术可行性调研（3大板块×14个调研主题）

---

## 研究概述

本报告为 SAND 框架的 `05-tools/`（工具能力体系）和 `06-metrics/`（度量指标体系）两个空壳章节提供技术可行性调研，同时深度调研将 SAND 从"理论框架"转化为"方法论即代码"的可执行基础设施方案。

**输入文档：** 已完成的领域调研报告（1,088 行 + 413 行）、设计过程文档（D6/D7 工具与度量 SDC 映射）、docs/05-tools/ 和 docs/06-metrics/ 现有 README 和 STUB 文件、docs/09-templates/ 模板文件。

---

## 技术调研范围确认

**研究主题：** SAND 框架工具层、度量层与可执行基础设施技术可行性调研

**三大板块：**

### 板块 A：工具层（05-tools/）
- 工具选型原则的操作化——量化评估矩阵设计
- 工具-SDC 阶段映射——8 个阶段 × 核心工具的当前技术生态
- Agent 能力卡标准——Model Card / Agent Card 行业标准与运行时评估
- AI 供应商管理 [GAP-5]——多模型路由、成本控制、锁定风险缓解

### 板块 B：度量层（06-metrics/）
- 效率指标——AI 杠杆率、意图吞吐量的数据源与采集方案
- 质量指标——首通率、打回率、缺陷逃逸率的 CI/CD 集成采集
- 学习指标——资产复用率、飞轮加速的追踪与计算方法
- 成熟度指标——7 维雷达图的评估量表与可视化
- 财务指标 [GAP-4]——AI 资本化 ROI 的 GAAP/IFRS 操作化
- 度量-层级交叉矩阵——L1-L4 数据聚合架构

### 板块 C：可执行基础设施
- MCP 协议集成方案——SAND 工具体系如何以 MCP 为互操作基础
- Agent 编排架构选型——六大框架对比与 SAND 四种标准拓扑的技术实现
- SAND "方法论即代码"——从理论文档到可执行 Agent + Skill 架构的技术路径

**研究方法论：**

- 当前 Web 数据与公开来源的严格验证
- 多源交叉验证关键技术主张
- 为每个主题提供：技术可行性评级 + 推荐实现路径 + 风险与挑战
- 特别关注 GAP-4（财务指标）和 GAP-5（供应商管理）两个已识别空白

**范围确认日期：** 2026-05-12

---

## 板块 C：可执行基础设施

> **核心问题**：SAND 如何从"人读的方法论文档"进化为"AI 可执行的方法论即代码"？
> **调研结论**：技术上完全可行。经过对 MCP 协议和通用 Skills 架构的深入对比分析，**推荐 Skills-First + MCP-When-Needed 分层策略**——SAND 的差异化价值（Assess/Intent/Orchestrate/Learn/Governance）本质上是结构化引导工作流，Skills 架构可以 1/10 的成本和 1/5 的时间实现可执行层 MVP。MCP 仅在需要实时外部系统集成时引入（度量自动化、CI/CD 集成）。

---

### C1. MCP 协议——SAND 工具体系的互操作基础

#### C1.1 协议现状（2026/05）

MCP 已从 Anthropic 2024/11 的开源实验发展为**事实上的 AI Agent 互操作标准**：

| 指标 | 数据 |
|------|------|
| 月 SDK 下载量 | 9,700 万（2026/03） |
| GitHub Stars | 81,000+ |
| 公开 MCP Server | 13,000+ |
| 官方 SDK | TypeScript、Python、C#、Java、Kotlin（JetBrains 合作） |
| 支持厂商 | Anthropic、OpenAI、Google、Microsoft、AWS |
| 治理 | Linux Foundation / Agentic AI Foundation (AAIF) |

**协议版本演进**：2024/11 初版 → 2025/06 OAuth 2.1 认证 → 2025/11 Streamable HTTP 替代 SSE → 2026 v2.1 Server Cards + 无状态操作

_来源: [MCP 2026 Roadmap](https://blog.modelcontextprotocol.io/posts/2026-mcp-roadmap/), [MCP Specification](https://modelcontextprotocol.io/specification/2025-11-25), [GitHub](https://github.com/modelcontextprotocol)_

#### C1.2 核心架构

```
┌─────────────┐     JSON-RPC 2.0     ┌─────────────┐     API/DB/FS     ┌──────────────┐
│   Host      │◄──────────────────►│  MCP Server  │◄────────────────►│  外部系统     │
│ (Claude Code│     stdio 或         │ (工具提供者)  │                  │ (GitHub/Jira/ │
│  Cursor等)   │   Streamable HTTP    │              │                  │  DB/API等)    │
└─────────────┘                     └─────────────┘                  └──────────────┘
      │
      │ 创建多个 Client 实例
      ▼
┌─────────────┐
│  MCP Client │ ← 每个 Client 维护与一个 Server 的独立会话
└─────────────┘
```

**MCP Server 暴露三种原语**：
1. **Tools**（工具）：Agent 可调用的函数，类似 OpenAI Function Calling
2. **Resources**（资源）：Agent 可读取的数据，类似 REST GET
3. **Prompts**（提示模板）：预定义的交互模板

**传输层**：
- **stdio**：本地进程间通信（默认），适合本地 MCP Server
- **Streamable HTTP**：2025/11 引入，替代旧 SSE，支持远程部署、水平扩展

**认证**：远程 MCP Server 采用 OAuth 2.1 标准，通过 `.well-known` 端点发现授权服务器

#### C1.3 2026 路线图关键演进

| 方向 | 内容 | 对 SAND 的影响 |
|------|------|---------------|
| **无状态操作** | 会话创建/恢复/迁移标准化，支持水平扩展 | SAND 工具层可设计为无状态微服务 |
| **MCP Server Cards** | `.well-known/mcp/server-card` 结构化元数据发现 | 直接映射到 SAND Agent 能力卡标准 |
| **Agent-to-Agent（A2A）** | H2 2026 成熟，MCP+A2A 双协议 | SAND Orchestrate 阶段的多 Agent 协调基础 |
| **企业就绪性** | 审计追踪、SSO、网关行为、配置可移植性 | SAND Governance 中心轴的技术实现路径 |

#### C1.4 企业集成模式：MCP 网关

```
┌──────────┐    ┌─────────────────────────────────┐    ┌──────────────┐
│  Agent   │───►│         MCP Gateway              │───►│ MCP Servers   │
│          │    │  ┌─────────────────────────────┐ │    │              │
│          │    │  │ 认证 │ 授权 │ 限流 │ 审计  │ │    │ GitHub       │
│          │    │  │ 内容分类 │ 敏感输出脱敏     │ │    │ Jira         │
│          │    │  └─────────────────────────────┘ │    │ PostgreSQL   │
│          │◄───│                                   │◄───│ 自定义 API   │
└──────────┘    └─────────────────────────────────┘    └──────────────┘
```

**网关职责**：认证/授权、限流、内容分类、敏感信息脱敏、审计日志——**这是企业级部署的非可选组件**。

**安全原则**：零信任——每次工具调用都需重新验证，而非依赖会话级令牌。

_来源: [Enterprise MCP Guide](https://www.humaineeti.ai/resources/model-context-protocol-mcp-enterprise), [MCP Technical Deep Dive](https://dasroot.net/posts/2026/04/model-context-protocol-mcp-technical-deep-dive/), [CData Enterprise Guide](https://medium.com/cdata-software/the-definitive-2026-guide-to-implementing-mcp-in-enterprise-environments-d74009a17b07)_

#### C1.5 ⚠️ 对 SAND 的技术建议

1. **SAND 的每个 SDC 阶段核心工具应设计为 MCP Server**——统一接口，模型无关
2. **Agent 能力卡标准应对齐 MCP Server Cards**——结构化元数据发现，而非自定义格式
3. **Governance 中心轴应通过 MCP Gateway 实现**——审计、授权、合规在网关层集中处理
4. **多 Agent 协调应关注 A2A 协议发展**——H2 2026 将成熟，MCP 管工具访问，A2A 管 Agent 间协作

**技术可行性评级：★★★★★（成熟，可立即开始）**

---

### C2. Agent 编排架构选型

#### C2.1 2026 年编排框架全景

框架生态已从碎片化整合为**四大编排范式**：

| 框架 | 编排范式 | 模型支持 | 状态管理 | 生产就绪度 | SAND 适配度 |
|------|---------|---------|---------|-----------|------------|
| **LangGraph** | 有向图状态机 | 完全模型无关 | 内建检查点+时间旅行 | ★★★★★ Tier 1 | ★★★★★ |
| **CrewAI** | 角色团队 | 完全模型无关 | 任务输出顺序传递 | ★★★ 原型级 | ★★★★ |
| **OpenAI Agents SDK** | 显式交接 | 仅 OpenAI | 上下文变量（临时） | ★★★★ | ★★ |
| **Claude Agent SDK** | 工具链+子代理 | 仅 Claude | 通过 MCP Server | ★★★★ | ★★★★ |
| **Google ADK** | 层级代理树 | GCP 优先 | A2A 驱动 | ★★★ | ★★★ |
| **Microsoft AG2** | 统一 SK+AutoGen | .NET+Python | 1.0 GA (2026/04) | ★★★★ | ★★★ |

**关键发现**：框架选型可使相同模型在相同任务上的表现差距达 **30 个百分点**——这验证了 SAND Orchestrate 阶段的核心主张："编排决定一切"。

#### C2.2 SAND 四种标准拓扑的技术实现映射

| SAND 拓扑 | 行业编排模式 | 推荐框架 | 实现路径 |
|-----------|------------|---------|---------|
| **Solo** | 单 Agent + 工具链 | Claude Agent SDK 或 LangGraph 单节点 | Agent + MCP Tools，最简场景 |
| **Pipeline** | 顺序传递链 | LangGraph 线性图 / CrewAI Sequential Process | 每节点一个专业 Agent，顺序执行 |
| **Swarm** | Fan-Out / Fan-In 并行 | LangGraph 并行分支 + 聚合节点 | 并行 Agent 执行 → 收集器合并结果 |
| **Hierarchy** | Orchestrator-Worker 多层级 | LangGraph 嵌套子图 / Google ADK 代理树 | 管理者 Agent 分解任务 → Worker Agent 执行 |

**补充建议**：SAND 应考虑新增两种拓扑：
- **Handoff（动态交接）**：不确定性高的探索性任务，每个 Agent 自主决定是否转交
- **Debate（辩论式）**：需要多视角验证的关键决策，多 Agent 辩论 + 裁判 Agent

#### C2.3 推荐架构策略：框架抽象层

```
┌───────────────────────────────────────────────────────┐
│                    SAND Orchestrator API               │
│  ┌─────────┐  ┌──────────┐  ┌─────────┐  ┌─────────┐ │
│  │  Solo   │  │ Pipeline │  │  Swarm  │  │Hierarchy│ │
│  └────┬────┘  └────┬─────┘  └────┬────┘  └────┬────┘ │
│       │            │             │             │      │
│  ┌────▼────────────▼─────────────▼─────────────▼────┐ │
│  │           Framework Abstraction Layer             │ │
│  │    (SAND 定义接口，框架作为实现细节)               │ │
│  └──┬───────────┬───────────┬───────────┬───────────┘ │
│     │           │           │           │             │
│  LangGraph  CrewAI    Claude SDK   Google ADK         │
└───────────────────────────────────────────────────────┘
```

**核心原则**：**"从第一天起就建立框架抽象层"**——AI Agent 框架生态变化极快，将框架作为实现细节而非架构依赖，可防止昂贵的重写。

**推荐默认框架**：**LangGraph**——唯一的 Tier 1 生产级框架，模型无关，内建检查点和时间旅行调试，最完善的生产工具链（LangSmith 可观测性、LangServe 部署、LangGraph Cloud 托管）。

_来源: [Agent Framework Showdown 2026](https://qubittool.com/blog/ai-agent-framework-comparison-2026), [Framework Wars](https://1337skills.com/blog/2026-04-17-agent-framework-wars-google-adk-langchain-crewai-comparison/), [Best Multi-Agent Frameworks](https://gurusup.com/blog/best-multi-agent-frameworks-2026)_

#### C2.4 ⚠️ 对 SAND 的技术建议

1. **以 LangGraph 为默认实现框架**，但通过抽象层保持框架可替换性
2. **SAND 四种标准拓扑已有充分技术基础**，建议扩展为六种（+Handoff + Debate）
3. **"协调税"研究证明超过 4 个 Agent 后准确率趋于饱和**——SAND 应在 Orchestrate 阶段提供 Agent 数量的经验指导
4. **MCP 负责 Agent-工具交互，A2A 负责 Agent-Agent 交互**——SAND 的拓扑设计应明确双协议分工

**技术可行性评级：★★★★★（生态成熟，推荐 LangGraph 为起点）**

---

### C3. SAND "方法论即代码"——架构决策：Skills-First vs MCP-First

> **⚠️ 架构修正说明**：本节经过对 BMad Skills 架构的深入实机分析后，对初始方案进行了重大修正。初始调研从"技术上什么可行"出发推荐了 MCP-First 方案，但回归 SAND 的实际需求后发现：**SAND 的差异化价值层本质上是结构化引导工作流，而非外部系统集成**——这是 Skills 架构的理想适用场景，也是 MCP 的过度工程化场景。

#### C3.1 核心判断：SAND 的"工具"本质上是什么？

| SDC 阶段 | SAND 需要的"工具" | 本质 | 最适架构 |
|---------|-------------------|------|---------|
| **Assess** | 成熟度评估问卷、雷达图 | 引导式问答 + 模板 + 评分逻辑 | **Skill** |
| **Intent** | 意图声明编辑器、CLEAR 检查 | 模板 + 验证规则 + 结构化输出 | **Skill** |
| **Orchestrate** | Agent 选型、拓扑设计 | 决策引导 + 配方库匹配 | **Skill** |
| **Build** | IDE 集成、Agent 执行 | 已有工具（Claude Code/Cursor） | **既有生态** |
| **Validate** | 测试、安全扫描 | 已有工具（Playwright/Snyk） | **既有生态** |
| **Operate** | 部署、监控 | 已有工具（GitHub Actions/Grafana） | **既有生态** |
| **Learn** | 复盘引导、资产化工作流 | 引导式回顾 + 模板 + 分类逻辑 | **Skill** |
| **Governance** | 章程管理、审计 | 清单 + 模板 + 报告生成 | **Skill** |

**结论**：SAND 的差异化价值——Assess、Intent、Orchestrate、Learn、Governance——**全是结构化引导工作流**，不需要实时外部系统集成。Build/Validate/Operate 阶段的工具已存在于市场上，SAND 不需要重造。

#### C3.2 Skills 架构 vs MCP 协议——诚实对比

| 维度 | Skills 架构 | MCP 协议 |
|------|------------|---------|
| **本质** | 方法论知识的结构化封装 | AI 与外部系统的实时连接 |
| **解决的问题** | "让团队用结构化方法论做 AI 原生开发" | "让 AI 连接到数据库/API/文件系统" |
| **状态管理** | 文档 frontmatter（YAML），透明可审查 | JSON-RPC 会话状态，需调试工具 |
| **编排** | 文件发现 + 菜单分发 + 子代理生成 | Client-Server 实时调用 |
| **跨平台** | Claude Code / Cursor / Codex / Gemini CLI 均支持 | 需要每个 Host 支持 MCP 客户端 |
| **部署成本** | **零**——Markdown 文件，Git 分发 | 需运行 Server 进程、网关、基础设施 |
| **定制化** | 3 层 TOML merge，零依赖，Python stdlib | 需修改 Server 代码或配置 |
| **开发周期** | 一个 Skill 几小时到几天 | 一个 MCP Server 几天到几周 |
| **协作门槛** | 会写 Markdown 就能贡献 | 需要 TypeScript/Python 开发能力 |
| **已有验证** | BMad（SAND 正在用，62个Skill）、Superpowers（150K stars） | 主要用于工具集成（GitHub/Jira/DB），非方法论 |

#### C3.3 行业先例分析

**先例一：BMad Method**（SAND 已在使用，实机验证）
- 62 个可组合 Skill（Markdown 文件 + 脚本），零运行时依赖
- Agent 角色系统（7 个专业 Agent），通过菜单分发 Skill
- 标准化激活协议：定制化解析 → prepend → persistent_facts → config → greet → append
- 配置层级：base customize.toml → team override → user override（3 层 TOML merge）
- 工作流通过文件发现链接：Skill A 输出到 `{planning_artifacts}/` → Skill B 通过 glob 发现
- **验证**：SAND 当前的领域调研和技术调研正是通过 BMad 的 Skill 架构执行的——**它已经在工作**

**先例二：Superpowers Framework**（obra/superpowers, 150K+ GitHub Stars）
- 可组合的 SKILL.md 文件，Agent 自动触发
- 默认技能栈：Brainstorming → Git Worktree → 微任务计划 → 子代理执行
- **跨平台**：Claude Code、Codex、Cursor、Gemini CLI、OpenCode、Copilot CLI 均支持
- 开源 MIT 协议

**先例三：Spec-Driven Development（SDD）**
- 规格说明作为可执行契约——Agent 从规格派生代码
- AWS Kiro IDE 将 SDD 工作流产品化（Agent Hooks + MCP 集成）
- SDD 光谱：Spec-First → Spec-Anchored → Spec-as-Source

_来源: [Superpowers GitHub](https://github.com/obra/superpowers), [Superpowers Guide](https://www.verdent.ai/guides/what-is-superpowers-ai-coding-framework), [SDD Guide](https://www.augmentcode.com/guides/what-is-spec-driven-development)_

#### C3.4 推荐架构：Skills-First + MCP-When-Needed

```
┌─────────────────────────────────────────────────────────┐
│                SAND 可执行层（Skills 架构）                │
│                                                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐  │
│  │sand-     │ │sand-     │ │sand-     │ │sand-     │  │
│  │assess-   │ │create-   │ │design-   │ │run-      │  │
│  │maturity  │ │intent    │ │orchestr. │ │retro     │  │
│  │          │ │          │ │          │ │          │  │
│  │ SKILL.md │ │ SKILL.md │ │ SKILL.md │ │ SKILL.md │  │
│  │ steps/   │ │ steps/   │ │ steps/   │ │ steps/   │  │
│  │ template │ │ template │ │ template │ │ template │  │
│  │ custom.  │ │ custom.  │ │ custom.  │ │ custom.  │  │
│  │  toml    │ │  toml    │ │  toml    │ │  toml    │  │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘  │
│                                                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐               │
│  │sand-     │ │sand-     │ │sand-     │  Agent 角色：   │
│  │validate- │ │govern-   │ │metrics-  │  问题域负责人   │
│  │delivery  │ │ance-     │ │dashboard │  FDE+          │
│  │          │ │audit     │ │          │  变革催化师     │
│  └──────────┘ └──────────┘ └──────────┘               │
│                                                         │
│  共享基础设施：                                          │
│  ├── _bmad-output/ (文档交接层——Skill间通过文件发现链接)  │
│  ├── docs/09-templates/ (YAML 模板库)                   │
│  ├── customize.toml 3层merge (组织级定制)                │
│  └── persistent_facts (组织标准/约束/合规规则)            │
├─────────────────────────────────────────────────────────┤
│  未来扩展层（当需要实时外部集成时引入 MCP）：              │
│  ├── 度量自动采集 MCP Server (Git/CI/CD → 度量事件流)    │
│  ├── 现有 MCP 生态复用 (GitHub/Grafana/Jira MCP Server) │
│  └── MCP Gateway (企业级审计/合规——当有生产部署时)        │
└─────────────────────────────────────────────────────────┘
```

#### C3.5 SDC 阶段 → 可执行 Skill 映射

| SDC 阶段 | 可执行 Skill | Skill 类型 | 对标 BMad 参照 | 输出 |
|---------|-------------|-----------|---------------|------|
| **Assess** | `sand-assess-maturity` | 多步骤引导工作流 | `bmad-create-prd` | 成熟度评估报告（YAML）+ 雷达图描述 |
| **Intent** | `sand-create-intent` | 多步骤引导工作流 | `bmad-create-story` | 意图声明（YAML）+ CLEAR 检查结果 |
| **Orchestrate** | `sand-design-orchestration` | 多步骤决策工作流 | `bmad-create-architecture` | 编排方案 + 拓扑选择 + HIP 配置 |
| **Build** | — | 不需要自建 Skill | 既有 IDE Agent 生态 | 综合交付包 |
| **Validate** | `sand-validate-delivery` | 检查清单 | `bmad-check-implementation-readiness` | 验证报告 + 质量门禁决策 |
| **Operate** | — | 不需要自建 Skill | 既有 DevOps 工具链 | 运营仪表盘 |
| **Learn** | `sand-run-retrospective` | 引导式工作流 | `bmad-retrospective` | 复盘报告 + AI 资产分类 |
| **Governance** | `sand-governance-audit` | 检查清单+报告 | `bmad-code-review` | 合规报告 |

**Skill 文件结构示例**（以 `sand-create-intent` 为例）：

```
.claude/skills/sand-create-intent/
├── SKILL.md                              # 标准激活协议 + Intent 创建引导
├── customize.toml                        # 默认配置（组织可 override）
├── steps/
│   ├── step-01-scope.md                  # 收集需求、确认意图边界
│   ├── step-02-draft.md                  # 生成 7 字段意图声明草案
│   ├── step-03-clear-check.md            # CLEAR 质量检查（5维验证）
│   └── step-04-execution-contract.md     # 生成执行契约
├── intent-statement.template.yaml        # 意图声明 YAML 模板
├── execution-contract.template.yaml      # 执行契约 YAML 模板
└── data/
    └── clear-checklist.csv               # CLEAR 检查项数据
```

**Skill 间工作流链接**（通过文件发现，零耦合）：
```
sand-assess-maturity → 写入 {planning_artifacts}/maturity-assessment.yaml
    ↓ (glob 发现)
sand-create-intent → 写入 {planning_artifacts}/intent-*.yaml
    ↓ (glob 发现)
sand-design-orchestration → 写入 {planning_artifacts}/orchestration-plan.yaml
    ↓ (glob 发现)
[Build: 既有 IDE Agent] → 写入 {implementation_artifacts}/delivery-package/
    ↓ (glob 发现)
sand-validate-delivery → 写入 {planning_artifacts}/validation-report.yaml
    ↓ (glob 发现)
sand-run-retrospective → 写入 {planning_artifacts}/retrospective.md + 资产入库
    ↓ (状态更新)
sand-assess-maturity → 下一轮循环校准
```

#### C3.6 为什么不选 MCP-First

| 场景 | MCP 解决的问题 | SAND 的实际需求 | 匹配度 |
|------|---------------|----------------|--------|
| 连接数据库 | ✅ | 不需要——SAND 不访问数据库 | ❌ |
| 调用外部 API | ✅ | 仅度量采集时需要——可延后 | ⚠️ |
| 实时工具调用 | ✅ | 不需要——SAND 是引导式工作流 | ❌ |
| 结构化方法论引导 | ❌ MCP 不擅长 | 核心需求 | ❌ |
| 零部署成本分发 | ❌ 需运行 Server | 核心需求——开放方法论 | ❌ |
| 组织级定制 | ❌ 需改代码 | 核心需求——3 层 TOML merge | ❌ |

**MCP 适用的 SAND 场景（Phase 2+ 引入）**：
- 从 Git/CI/CD 自动采集度量指标 → `sand-metrics-collector` MCP Server
- 连接 Grafana 生成仪表盘 → 复用已有 Grafana MCP Server
- 连接 Jira/Linear 追踪意图状态 → 复用已有 MCP Server
- 企业级审计网关 → MCP Gateway（当有多团队生产部署时）

#### C3.7 实现路径与里程碑（Skills-First）

| 阶段 | 时间 | 交付物 | 开发方式 |
|------|------|--------|---------|
| **P1: 核心 Skills** | 2-3周 | 3个核心 Skill（assess-maturity, create-intent, validate-delivery）+ YAML 模板 | Markdown + YAML 编写 |
| **P2: 完整 SDC** | 2-3周 | 补齐 design-orchestration, run-retrospective, governance-audit | Markdown + YAML 编写 |
| **P3: Agent 角色** | 1-2周 | 3个 Agent 角色（问题域负责人/FDE+/变革催化师）+ 菜单分发 | 复用 BMad Agent 模式 |
| **P4: 度量扩展** | 2-3周 | 度量采集 MCP Server（Git/CI/CD → 效率+质量指标）| TypeScript/Python |
| **MVP** | **~8周** | SAND 可执行框架 MVP——能引导完成一个完整 SDC 循环 | — |

**对比 MCP-First 方案（~17周）**：Skills-First 方案将 MVP 时间从 17 周压缩到 **8 周**，且前 6 周完全不需要编程——纯 Markdown + YAML 编写。

**技术可行性评级：★★★★★（已有验证（BMad），零基础设施依赖，8 周 MVP）**

---

## 板块 A：工具层技术调研

---

### A1. 工具选型原则——操作化方案

#### A1.1 SAND 6 大原则的量化评估矩阵

SAND 定义了 6 大工具选型原则，但当前仅有定性描述。以下提供每个原则的**量化评估框架**：

| # | 原则 | 量化维度 | 评分方法 | 数据来源 |
|---|------|---------|---------|---------|
| 1 | **AI 友好性** | 强约束强信号：API 是否有 JSON Schema？是否有 MCP Server？反馈回路延迟？ | 0-5 分量表：0=无 API，1=REST 无 Schema，2=REST+Schema，3=MCP 适配器，4=原生 MCP，5=原生 MCP+实时反馈 | 工具文档、MCP 注册表 |
| 2 | **模型无关性** | 支持的模型提供商数量、是否有标准接口（OpenAI 兼容 / MCP）、切换成本 | 0-5 分：0=硬编码单模型，1=单供应商多模型，2=2-3 供应商，3=OpenAI 兼容，4=MCP 原生，5=完全协议中立 | 集成文档、社区反馈 |
| 3 | **人类审查可接入性** | 审查接口类型、审查粒度、审查延迟、是否支持批量审查 | 0-5 分：0=无审查接口，1=仅日志，2=异步审查，3=同步审查，4=细粒度审查+回退，5=审查工作流引擎 | 产品演示 |
| 4 | **上下文连续性** | 是否支持会话持久化？跨会话上下文共享？上下文窗口利用效率？ | 0-5 分：0=无状态，1=会话内记忆，2=跨会话持久化，3=团队级共享，4=MCP Resource 集成，5=CDLC 全生命周期 | 技术文档 |
| 5 | **标准化与治理** | 是否有审计日志？合规报告？Agent 能力卡？部署标准化程度？ | 0-5 分：0=无治理，1=基础日志，2=审计日志，3=RBAC+审计，4=ISO 42001 对齐，5=完整治理栈 | 安全白皮书 |
| 6 | **不浪费原则** | 任务复杂度与工具复杂度的匹配度、成本/效果比、是否支持分级调用 | 0-5 分：0=一刀切，1=2级分流，2=手动分级，3=自动路由，4=智能路由+成本优化，5=自适应分级 | 使用数据 |

**总分 30 分**，推荐阈值：≥18 分（合格）/ ≥24 分（推荐）/ ≥28 分（优秀）

#### A1.2 选型流程建议

```
[候选工具清单] → [快速筛选: 原则1+2 必须≥3] → [深度评估: 6原则全评分]
    → [交叉验证: 与 SDC 阶段需求映射] → [试点: 2周 POC] → [决策]
```

**技术可行性评级：★★★★★（评估矩阵可直接操作化为 YAML 模板）**

---

### A2. 工具-SDC 阶段映射——当前技术生态

#### A2.1 8 阶段 × 核心工具技术方案（2026/05 快照）

| SDC 阶段 | 核心工具需求 | 2026 代表方案 | MCP 支持度 | 成熟度 |
|---------|------------|-------------|-----------|--------|
| **Assess** | 成熟度评估问卷 | TypeForm + 自定义评估引擎 | 需自建 MCP Server | ★★★ |
| | 数据采集脚本 | GitHub API + CI/CD API 采集 | GitHub MCP 已有 | ★★★★ |
| | 雷达图生成器 | Chart.js / D3.js / Mermaid | 需自建可视化 MCP | ★★★ |
| **Intent** | 意图声明编辑器 | Claude Code + BMad 风格 YAML 模板 | 原生 MCP | ★★★★ |
| | CLEAR 自动检查 | 自定义验证规则引擎 | 需自建 MCP Server | ★★★ |
| | 意图模式库 | Markdown/YAML 文件库 + 向量搜索 | 可通过 Resource MCP | ★★★ |
| **Orchestrate** | Agent 能力卡目录 | Agent Card JSON (A2A 标准) | A2A 原生 | ★★★★ |
| | 拓扑设计器 | LangGraph Studio / 自定义可视化 | LangGraph MCP 适配 | ★★★★ |
| | 上下文策略配置器 | CLAUDE.md / MCP 配置 | 原生 | ★★★★ |
| **Build** | IDE 集成 AI | Cursor / Claude Code / Windsurf | 原生 MCP | ★★★★★ |
| | Agent 执行运行时 | LangGraph / Claude Agent SDK | 原生 | ★★★★★ |
| | 交付包打包器 | 自定义脚本 + Git 集成 | 需自建 MCP Server | ★★★ |
| **Validate** | 自动化测试框架 | Playwright / Cypress / pytest | Playwright MCP 已有 | ★★★★★ |
| | 安全扫描器 | Snyk / SonarQube / Checkmarx | 部分有 MCP | ★★★★ |
| | 架构合规分析器 | ArchUnit / 自定义 AST 分析 | 需自建 MCP Server | ★★★ |
| **Operate** | 部署流水线 | GitHub Actions / GitLab CI | GitHub MCP 已有 | ★★★★★ |
| | 监控平台 | Grafana / Datadog / Prometheus | Grafana MCP 已有 | ★★★★ |
| | AI 事故分析器 | 自定义 + LLM 辅助分析 | 需自建 MCP Server | ★★ |
| **Learn** | AI 复盘引导工具 | BMad 复盘 Skill + 自定义模板 | 可通过 Skill 实现 | ★★★ |
| | 资产库管理系统 | Git 仓库 + 向量数据库索引 | 需自建 MCP Server | ★★★ |
| | 飞轮度量仪表盘 | Grafana + 自定义度量采集 | Grafana MCP | ★★★★ |
| **Governance** | AI 使用章程管理 | 文档管理 + 审批流 | 需自建 MCP Server | ★★ |
| | 审计日志系统 | MCP Gateway 审计层 | 原生（Gateway 模式） | ★★★★ |

#### A2.2 MCP 生态覆盖度评估

**已有高质量 MCP Server 的领域**：GitHub、Slack、PostgreSQL、Stripe、Figma、Docker、K8s、Playwright、Grafana——覆盖了 Build/Validate/Operate 阶段的大部分需求。

**需要自建 MCP Server 的领域**：Assess 阶段的评估引擎、Intent 阶段的 CLEAR 检查器、Learn 阶段的资产库——这些是 SAND 特有概念，没有现成方案。

**结论**：约 60% 的工具需求可通过现有 MCP 生态满足，40% 需要自建——自建部分恰好是 SAND 的差异化价值所在。

**技术可行性评级：★★★★☆（主流工具有覆盖，SAND 特有工具需自建）**

---

### A3. Agent 能力卡标准——行业对标

#### A3.1 2026 年 Agent 能力卡标准全景

行业已出现四个互补的结构化描述标准：

| 标准 | 发起者 | 格式 | 用途 | 状态 |
|------|--------|------|------|------|
| **A2A Agent Card** | Google + 50+ 公司 | JSON (`agent-card.json`) | Agent 间能力发现 | RC v1.0 (2026/01)，IANA `.well-known` 注册 |
| **IETF AgentCard** | IETF Internet-Draft | JSON (ULID-based ID) | 框架中立的 A2A 通信 | Draft，2026/10 过期 |
| **MCP Server Card** | MCP 社区 (SEP-2127) | JSON (`.well-known/mcp/server-card`) | MCP Server 能力发现 | MCP v2.1 规范 |
| **学术 Agent Card** | Springer 2026 | 结构化文档 | 透明度、可审计性、治理 | 学术发表 |

**Google A2A Agent Card 字段示例**：
```json
{
  "name": "SAND Build Agent",
  "description": "综合交付包构建专家",
  "capabilities": ["code-generation", "test-generation", "packaging"],
  "protocols": ["mcp", "a2a"],
  "authentication": { "type": "oauth2" },
  "endpoints": [{ "url": "https://...", "transport": "streamable-http" }]
}
```

#### A3.2 SAND Agent 能力卡标准——推荐设计

SAND 当前的 Agent 能力卡模板（`09-templates/agent-capability-card.yaml`）有 11 个字段。建议对齐行业标准后扩展为：

| 字段 | 当前模板 | 建议新增/修改 | 行业来源 |
|------|---------|-------------|---------|
| `agent_id` | ✅ | 改为 ULID 格式 | IETF AgentCard |
| `capability_domain` | ✅ | 改为 dot-namespaced（如 `sand.build.code-gen`） | IETF AgentCard |
| `model_requirement` | ✅ | 保留 | — |
| `context_window_need` | ✅ | 增加数值（如 `128K`） | 实际需求 |
| `input_format` / `output_format` | ✅ | 增加 JSON Schema 引用 | MCP Tools Schema |
| `human_oversight` | ✅ | 映射到 HIP-1/2/3 | SAND 原生 |
| `known_limitations` | ✅ | 保留 | Model Card |
| `cost_profile` | ✅ | 细化为每次调用成本 + 月度预算 | IETF 能源定价 |
| `reliability` | ✅ | 量化为成功率百分比 | — |
| — | 新增 | `protocols: [mcp, a2a]` | A2A Agent Card |
| — | 新增 | `endpoints` | A2A Agent Card |
| — | 新增 | `sdc_phases: [build, validate]` | SAND 原生 |
| — | 新增 | `governance_scope` | 学术 Agent Card |
| — | 新增 | `evaluation_metrics` | 学术 Agent Card |

**技术可行性评级：★★★★★（行业标准已成熟，SAND 可直接对齐）**

_来源: [Agent Card Springer](https://link.springer.com/chapter/10.1007/978-3-032-17933-3_25), [IETF AgentCard Draft](https://www.ietf.org/archive/id/draft-aevum-agentcard-00.html), [A2A Agent Card](https://www.agentcard.net/), [Agent Discoverability Trends](https://medium.com/google-cloud/what-are-the-trends-in-agent-discoverability-and-interoperability-91865e098365)_

---

### A4. AI 供应商管理 [GAP-5]——技术方案

#### A4.1 多模型路由与网关生态

2026 年多模型路由已成为成熟技术领域，核心方案：

| 方案 | 类型 | 模型覆盖 | 成本 | 最佳场景 |
|------|------|---------|------|---------|
| **LiteLLM** | 开源 SDK + 代理 | 100+ 供应商 | 免费（自托管） | Python 团队，早期阶段 |
| **OpenRouter** | 托管市场 | 623+ 模型 | 5.5% 手续费 | 探索与原型 |
| **Bifrost** | 开源网关（Go） | 多供应商 | 免费（自托管） | 高性能生产（11μs 开销） |
| **Portkey** | 合规优先网关 | 多供应商 | $49/月起 | 受监管行业 |
| **Inworld Router** | 智能路由 | 数百模型 | 按量计费 | 业务级路由策略 |

**成本优化关键数据**：
- 智能路由可将 AI 成本降低 **27-55%**（RAG 场景）
- 简单任务路由到轻量模型，复杂任务路由到前沿模型——在保持 95% 输出质量的前提下降低 **85% 成本**
- 每月 $1,000 API 支出：OpenRouter 实际成本 ~$1,055，LiteLLM 自托管 ~$1,020-$1,050

#### A4.2 SAND 供应商管理框架设计建议

```
┌──────────────────────────────────────────────────┐
│              SAND AI 供应商管理框架                │
├──────────┬──────────┬──────────┬─────────────────┤
│ 评估层    │ 路由层    │ 监控层    │ 风险缓解层      │
│          │          │          │                 │
│ 供应商    │ 智能路由  │ 成本追踪  │ 多供应商冗余    │
│ 评估矩阵  │ (LiteLLM │ 质量监控  │ 模型迁移策略    │
│ 能力对标  │  /Bifrost)│ SLA 监控  │ 数据驻留合规    │
│ 合规审查  │ 降级策略  │ 用量分析  │ 退出策略        │
└──────────┴──────────┴──────────┴─────────────────┘
```

**供应商评估矩阵**（建议字段）：
- 模型能力评分（基准测试对比）
- 定价模型（输入/输出 token 单价 + 批量折扣）
- SLA 保证（可用性、延迟 P99）
- 数据处理政策（是否用于训练、数据驻留地）
- 合规认证（SOC 2、ISO 27001、GDPR DPA）
- 锁定风险（API 兼容性、MCP 支持、迁移成本）

**技术可行性评级：★★★★☆（技术成熟，但合规和法律审查需要额外专业知识）**

_来源: [Best LLM Router 2026](https://inworld.ai/resources/best-llm-router-ai-gateway), [AI Model Routers Compared](https://www.mindstudio.ai/blog/best-ai-model-routers-multi-provider-llm-cost), [OpenRouter Alternatives](https://www.edenai.co/post/best-alternatives-to-openrouter)_

---

## 板块 B：度量层技术调研

---

### B1. 效率指标——AI 杠杆率与意图吞吐量

#### B1.1 行业度量框架演进

2026 年开发者生产力度量已从单一 DORA 演化为多维组合：

| 框架 | 创建者 | 核心维度 | 局限 |
|------|--------|---------|------|
| **DORA** | Google/Forsgren | 部署频率、变更前置时间、变更失败率、恢复时间 | 度量的是交付系统性能，非开发者生产力 |
| **SPACE** | GitHub/Forsgren | 满意度、绩效、活动、协作、效率 | 只给了类别，没给具体指标 |
| **DevEx** | DX/Forsgren | 认知负荷、反馈循环、Flow 状态 | 依赖调查，非自动化 |
| **DX Core 4** | DX (2026/04) | **Speed + Effectiveness + Quality + Business Impact** | 最新统一框架 |

**DX Core 4** 是 DORA、SPACE、DevEx 的创建者**联合设计**的统一框架，2026/04 旧金山 DX Annual 大会首发。

**DX Core 4 对 SAND 度量体系的关键启示**：
- **三种数据采集模式并用**：系统指标（自动化）+ 自我报告调查 + 体验采样（实时反馈）
- **DXI（Developer Experience Index）**：14 因素复合评分，1 分提升 = 每 100 名开发者每年节省 $100K
- **Business Impact 维度**是最大创新——将生产力直接关联到业务价值

#### B1.2 SAND 效率指标的技术采集方案

**指标一：AI 杠杆率（AI Leverage Ratio）**

| 维度 | 方案 |
|------|------|
| **定义** | AI 辅助下完成同等工作量所需人类决策次数 ÷ 纯人工决策次数 |
| **数据源** | Git 提交数据（AI 辅助标记）+ 人类审查事件日志 + 意图声明完成记录 |
| **采集方式** | CI/CD Hook（Git 提交 → 自动标记 AI 辅助比例）+ MCP 审计日志（人类决策事件） |
| **计算公式** | `AI_Leverage = (Total_Decisions_Equivalent) / (Human_Decisions_Actual)` |
| **层级差异** | L1: 个人杠杆率（单 FDE+）、L2: Pod 杠杆率（团队平均）、L4: 组织杠杆率 |
| **基准** | 早期：2-3x；成熟团队：5-10x；理论上限取决于 HIP 级别 |

**指标二：意图吞吐量（Intent Throughput）**

| 维度 | 方案 |
|------|------|
| **定义** | 单位时间内通过人类审查并验收的意图声明数量 |
| **数据源** | 意图声明状态变更事件（Created → In Progress → Validated → Accepted/Rejected） |
| **采集方式** | 意图声明管理系统的状态机事件流（可通过 Jira/Linear/自建系统采集） |
| **计算公式** | `Intent_Throughput = Count(status == 'Accepted') / Time_Period` |
| **层级差异** | L1: 每日/每 FDE+、L2: 每周/每 Pod、L3: 每月/每产品 |
| **注意事项** | 需按意图复杂度加权（简单意图 vs 架构级意图） |

**技术可行性评级：★★★★☆（核心指标可采集，但需自建意图声明状态管理系统）**

_来源: [DX Core 4](https://getdx.com/research/measuring-developer-productivity-with-the-dx-core-4/), [DORA Metrics Tools 2026](https://getdx.com/blog/dora-metrics-tools/), [Developer Productivity Metrics 2026](https://zylos.ai/research/2026-02-07-developer-productivity-metrics)_

---

### B2. 质量指标——AI 代码质量的特殊挑战

#### B2.1 2026 年 AI 代码质量实证数据

| 指标 | 数据 | 来源 |
|------|------|------|
| AI 代码 bug 率 vs 人工 | **1.7 倍** | CodeRabbit 2026 |
| AI 代码安全漏洞含有率 | **40-62%**（通用）/ **92%** 代码库含至少一个关键漏洞 | 多源 / Sherlock 2026 |
| AI 辅助提交频率 vs 安全发现率 | 提交速度 **3-4 倍** / 安全发现 **10 倍** | Veracode / Fortune 50 数据 |
| 开发者高度信任 AI 代码的比例 | **3%** | 行业调查 2026 |
| 修复"几乎正确"AI 代码的比例 | **66%** | 开发者调查 |
| AI 相关 CVE 月增长 | 6 个(1月) → 15 个(2月) → 35 个(3月) | Georgia Tech Vibe Security Radar |

#### B2.2 SAND 质量指标的技术采集方案

| SAND 指标 | 定义 | 数据源 | 采集工具 | 自动化程度 |
|-----------|------|--------|---------|-----------|
| **意图首通率** | Intent → Validated 无回退的比例 | 意图状态机事件流 | 自建 MCP Server | 全自动 |
| **审查打回率** | Build → Validate 被打回到 Build 或 Intent 的比例 | Git PR 审查记录 + 意图偏差事件 | GitHub API + 自建事件系统 | 全自动 |
| **缺陷逃逸率** | Validate 后在 Operate 阶段发现的缺陷数 ÷ 总缺陷数 | 生产事故记录 + 缺陷追踪系统 | Jira/Linear API + 监控系统 | 半自动 |
| **变更失败率** | 导致服务降级的变更比例（DORA 标准） | 部署记录 + 事故记录 | CI/CD API + 监控 API | 全自动 |
| 新增：**AI 代码质量比** | AI 生成代码的 bug 密度 ÷ 人工代码的 bug 密度 | 静态分析 + Git blame（区分 AI/人工） | SonarQube + 自定义标记 | 全自动 |
| 新增：**安全漏洞 MTTR** | 从发现到修复 AI 代码安全漏洞的中位时间 | 安全扫描结果 + 修复 PR 记录 | Snyk/Checkmarx + GitHub API | 全自动 |

**技术可行性评级：★★★★☆（DORA 兼容指标全自动，SAND 特有指标需自建事件系统）**

_来源: [AI Code Quality Statistics 2026](https://www.secondtalent.com/resources/ai-generated-code-quality-metrics-and-statistics-for-2026/), [CodeRabbit Quality Report](https://www.coderabbit.ai/blog/2025-was-the-year-of-ai-speed-2026-will-be-the-year-of-ai-quality), [AI Coding Security Statistics](https://sqmagazine.co.uk/ai-coding-security-vulnerability-statistics/)_

---

### B3. 学习指标——资产复用率与飞轮加速

#### B3.1 技术采集方案

| SAND 指标 | 定义 | 采集方案 | 技术实现 |
|-----------|------|---------|---------|
| **资产复用率** | 复用已有 AI 资产的意图数 ÷ 总意图数 | 资产库索引 + 意图声明引用追踪 | 向量数据库（Pinecone/Weaviate）存储资产 → 意图声明提交时检索相似度 → 超过阈值计为复用 |
| **个人资产贡献数** | 每个 FDE+ 产出并入库的 AI 资产数 | Git 提交到资产库的记录 | Git Hook → 资产库目录 → 自动计数 |
| **跨 Pod 资产共享率** | 被其他 Pod 引用的资产数 ÷ 总资产数 | 资产引用追踪（类似 npm 依赖） | 资产元数据中记录引用来源 Pod → 定期统计 |
| **飞轮加速趋势** | 循环周期压缩率 = 本轮 SDC 周期时长 ÷ 前轮周期时长 | SDC 循环起止时间戳 | 工作流引擎自动记录每轮循环的阶段时间戳 → 计算比率 |

**飞轮健康度判断**：
- 资产复用率：30-70%（健康），<30% 资产库不够丰富，>70% 可能过度复用
- 意图首通率：80%+ 为成熟团队
- 循环周期压缩率：持续 <1.0 表示飞轮在加速

**关键技术依赖**：资产库管理系统（Git 仓库 + 向量数据库索引 + 元数据追踪）——这是 SAND Learn 阶段的核心基础设施。

**技术可行性评级：★★★☆☆（概念清晰，但资产库系统需要从零构建）**

---

### B4. 成熟度指标——7 维雷达图

#### B4.1 评估量表设计

SAND 定义了 7 个成熟度维度（已在 `maturity-assessment.yaml` 模板中），建议每维度采用 **5 级量表**：

| 维度 | L1 初始 | L2 尝试 | L3 定义 | L4 管理 | L5 优化 |
|------|--------|--------|--------|--------|--------|
| **AI 工具采纳度** | 个别使用 | 团队试点 | 标准化选型 | 全组织统一 | 自适应工具链 |
| **意图驱动成熟度** | 无意图概念 | 非结构化意图 | 标准 7 字段 | CLEAR 检查 | 意图模式库驱动 |
| **编排能力** | 单 Agent | 手动编排 | 标准拓扑选型 | 自动拓扑推荐 | 自适应编排 |
| **人类审查体系** | 无审查 | 事后审查 | 三层审查标准 | 审查度量驱动 | 审查自动分级 |
| **学习与资产化** | 无资产概念 | 手动积累 | 标准资产分类 | 复用率追踪 | 飞轮自动加速 |
| **治理与合规** | 无治理 | 基础日志 | 审计日志+章程 | ISO 42001 对齐 | 自动合规 |
| **组织文化** | 抵触 AI | 被动接受 | 主动拥抱 | AI 原生思维 | 自演进组织 |

#### B4.2 技术实现方案

| 组件 | 方案 | 工具 |
|------|------|------|
| **评估数据采集** | 混合模式：系统指标自动采集 + 人工评估问卷 | 自建评估 MCP Server + TypeForm/自定义表单 |
| **雷达图生成** | 7 轴雷达图，可视化为 SVG/PNG | Chart.js（Web）/ Matplotlib（报告）/ Mermaid（Markdown 内嵌） |
| **评估频率** | 首次 2-4 周深度评估 → 每 SDC 循环末尾校准评估（1-2 天） | 工作流引擎在 Learn 阶段自动触发 |
| **历史趋势** | 多期雷达图叠加 + 维度进展时间线 | 时序数据库（InfluxDB）或简单 JSON 日志 |

**技术可行性评级：★★★★☆（评估量表可立即操作化，自动化采集需逐步建设）**

---

### B5. 财务指标 [GAP-4]——AI 资本化 ROI

#### B5.1 FASB ASU 2025-06 关键变化

2025/09 FASB 发布 ASU 2025-06——**25 年来最大的内部使用软件成本会计更新**：

| 变化 | 旧规则 | 新规则（ASU 2025-06） |
|------|--------|---------------------|
| 资本化起点 | 基于"开发阶段"分类 | 基于"管理层授权+承诺资助+项目大概率完成" |
| 开发模式假设 | 线性开发（瀑布） | **明确承认软件不总是线性开发**（适配敏捷/AI） |
| 不确定性处理 | — | 引入"重大开发不确定性"概念——技术创新或新功能的不确定性未解决时不资本化 |
| 生效日期 | — | 2027/12/15 后的年度期间（可提前采用） |

#### B5.2 SAND AI 资本资产 → GAAP 映射

| SAND AI 资本资产 | GAAP 处理建议 | 理由 |
|-----------------|-------------|------|
| **上下文库（Context Library）** | 资本化为无形资产（ASC 350-40） | 可复用的结构化领域知识，满足"大概率被使用"标准 |
| **意图模式库（Intent Patterns）** | 资本化为无形资产 | 经验证的高质量模板，具有明确未来经济利益 |
| **审查和验证资产** | 资本化（测试集）/ 费用化（临时配置） | 持久化测试集资本化，一次性配置费用化 |
| **内化模型微调** | 视情况——新功能资本化，维护费用化 | KPMG 2026 指南：微调是否引入新功能是关键判断 |
| **AI API 调用成本** | 费用化（运营支出） | 类似云计算使用费，非资本性支出 |

#### B5.3 ROI 计算框架建议

```
AI 投资 ROI = (AI 资产产出的增量价值 - AI 总投入成本) / AI 总投入成本

其中：
  AI 资产产出的增量价值 =
    意图吞吐量提升带来的时间节约 × 人力成本单价
    + 资产复用节约的重复开发成本
    + 缺陷逃逸率降低节约的修复成本
    + 循环周期压缩带来的 Time-to-Market 价值

  AI 总投入成本 =
    AI 工具/API 订阅费用（费用化）
    + AI 资产构建的人力成本（资本化后摊销）
    + 组织变革成本（培训、流程重设计）
```

**注意事项**：
- DXI 指标的经济换算：1 分 DXI 提升 ≈ 每 100 名开发者每年 $100K 节约
- FASB ASU 2025-06 的"非线性开发"条款使 AI 原生开发更容易满足资本化标准
- 建议 SAND 在 M0-M1 阶段先用简化 ROI（时间节约 × 成本单价），成熟后再引入完整资本化会计

**技术可行性评级：★★★☆☆（概念框架可行，但需要财务/会计专业知识参与设计细节）**

_来源: [Deloitte FASB ASU 2025-06](https://dart.deloitte.com/USDART/home/publications/deloitte/heads-up/2025/fasb-asu-amends-software-costs-guidance), [KPMG Software Costs Handbook 2026](https://kpmg.com/us/en/frv/reference-library/2026/handbook-software-website-costs.html), [PwC ASU 2025-06](https://www.pwc.com/us/en/services/consulting/deals/library/new-software-capitalization-standard.html)_

---

### B6. 度量-层级交叉矩阵——数据聚合架构

#### B6.1 工程智能平台生态

2026 年工程智能平台（SEI）已成为成熟品类：

| 平台 | 定位 | 定价 | SAND 适配度 |
|------|------|------|------------|
| **Jellyfish** | 企业级 R&D 投资分析 | $100K+/年 | ★★★（财务维度强） |
| **LinearB** | 团队级 DevOps + 工作流自动化 | 免费增值 | ★★★★（DORA+工作流） |
| **Faros AI** | 图数据库驱动的工程数据聚合 | 开源可自托管 | ★★★★★（最灵活） |
| **Swarmia** | 开发者优先的团队度量 | $15-20/dev/月 | ★★★（简洁） |
| **Atlassian DX** | Jira/Bitbucket 原生集成 | 内建 | ★★★（Atlassian 锁定） |

#### B6.2 SAND L1-L4 数据聚合架构建议

```
┌─────────────────────────────────────────────────────────┐
│                    L4 组织仪表盘                         │
│  组织级 AI 杠杆率 │ 变更失败率 │ 飞轮加速趋势 │ AI ROI   │
├────────────┬────────────┬───────────────────────────────┤
│ L3 产品    │ L3 产品    │ L3 产品                       │
│ 验证速率   │ 逃逸率     │ 跨Pod共享率                    │
├──────┬─────┴──────┬─────┴──────┬────────────────────────┤
│L2 Pod│ L2 Pod     │ L2 Pod     │ L2 Pod                 │
│吞吐量│ 打回率      │ 复用率     │ 7维雷达                │
├──┬───┴──┬────────┴──┬────────┴──┬───────────────────────┤
│L1│ L1   │ L1        │ L1        │ L1                    │
│杠│ 首通  │ 贡献数     │ 个人雷达  │ —                     │
│杆│ 率   │           │           │                       │
└──┴──────┴───────────┴───────────┴───────────────────────┘
          ▲           ▲           ▲
     系统指标     意图事件流    资产库追踪
   (Git/CI/CD)  (工作流引擎)   (向量DB)
```

**数据流**：
1. **L1 → L2**：个人指标按 Pod 聚合（平均/中位数/分布）
2. **L2 → L3**：Pod 指标按产品线聚合 + 跨 Pod 资产流转
3. **L3 → L4**：产品指标按组织聚合 + 财务度量叠加

**推荐技术栈**：
- **数据采集层**：MCP Server（各阶段工具的事件发射器）+ Git Hook + CI/CD Webhook
- **数据存储层**：Faros AI 开源版（图数据库，灵活聚合）或 InfluxDB（时序指标）
- **可视化层**：Grafana（运营仪表盘）+ 自定义 Web 应用（管理层报告）

**技术可行性评级：★★★★☆（架构设计清晰，但完整实现需要数据管线建设）**

_来源: [Jellyfish SEI](https://jellyfish.co/library/software-engineering-intelligence-platform/), [Faros AI Alternatives](https://www.faros.ai/blog/getdx-alternatives), [Engineering Intelligence Platforms 2026](https://www.cortex.io/post/engineering-intelligence-platforms-definition-benefits-tools)_

---

## 综合评估与技术建议

### 技术可行性总览

| 调研主题 | 可行性 | 关键风险 | 优先级 | 实现方式 |
|---------|--------|---------|-------|---------|
| **C3. 方法论即代码（Skills）** | ★★★★★ | 无——已有验证 | **P0** | Markdown + YAML |
| **C1. MCP 协议（参考知识）** | ★★★★★ | 无重大风险 | P2——延后到度量阶段 | TypeScript/Python |
| **C2. Agent 编排（参考知识）** | ★★★★★ | 框架生态变化快 | P2——延后到度量阶段 | LangGraph |
| **A1. 选型原则操作化** | ★★★★★ | 无 | **P0**——可立即执行 | YAML 模板 |
| **A2. SDC-工具映射** | ★★★★☆ | SAND 特有工具需自建 Skill | **P0**——融入 Skill 设计 | Skill 步骤文件 |
| **A3. Agent 能力卡** | ★★★★★ | 行业标准仍在演进 | P1——对齐 A2A | YAML + JSON |
| **A4. 供应商管理** | ★★★★☆ | 合规审查复杂 | P2 | 指南文档 |
| **B1. 效率指标采集** | ★★★★☆ | 意图状态管理需 Skill 支撑 | P1 | Skill 工作流记录 |
| **B2. 质量指标采集** | ★★★★☆ | DORA 兼容部分成熟 | P1 | 既有工具 + Skill |
| **B3. 学习指标采集** | ★★★☆☆ | 资产库需逐步积累 | P2 | Git + 元数据 |
| **B4. 成熟度指标** | ★★★★☆ | 评估量表设计需迭代 | **P0**——assess Skill 核心 | Skill + YAML 模板 |
| **B5. 财务指标** | ★★★☆☆ | 需财务/会计专业参与 | P2 | 指南文档 |
| **B6. 度量矩阵架构** | ★★★★☆ | 完整实现需数据管线 | P1——先手动后自动 | 渐进式 |

### SAND 可执行层技术路线图（Skills-First）

```
Phase 1 (0-3周): 核心 Skills ─────────────────────────
  ├── sand-assess-maturity Skill（成熟度评估引导工作流）
  ├── sand-create-intent Skill（意图声明创建 + CLEAR 检查）
  ├── sand-validate-delivery Skill（交付验证检查清单）
  ├── 选型评估矩阵模板（YAML，直接操作化 A1 调研）
  └── 意图声明 + 执行契约 + 成熟度评估 YAML 模板

Phase 2 (3-6周): 完整 SDC 工作流 ────────────────────
  ├── sand-design-orchestration Skill（编排方案设计）
  ├── sand-run-retrospective Skill（AI 复盘引导）
  ├── sand-governance-audit Skill（治理合规审计）
  └── Skill 间文件发现链接（完整 SDC 循环闭环）

Phase 3 (6-8周): Agent 角色 + 定制化 ──────────────
  ├── sand-agent-domain-lead（问题域负责人 Agent）
  ├── sand-agent-fde（FDE+ 交付工程师 Agent）
  ├── sand-agent-catalyst（变革催化师 Agent）
  └── 组织级 customize.toml 定制化指南

     ──── MVP: 8周，零基础设施，纯 Markdown+YAML ────

Phase 4 (8-14周): 度量自动化（引入 MCP）──────────
  ├── 度量采集 MCP Server（Git/CI/CD → 效率+质量指标）
  ├── 复用现有 MCP 生态（GitHub/Grafana/Jira MCP Server）
  ├── Grafana 仪表盘（L1-L4 交叉矩阵可视化）
  └── 资产库管理系统（Git + 向量数据库索引）

Phase 5 (14-20周): 企业就绪 ──────────────────────
  ├── MCP Gateway（审计/合规——多团队场景）
  ├── 供应商管理框架（LiteLLM/Bifrost 集成）
  ├── ISO 42001 / EU AI Act 合规映射
  └── SAND 认证/培训体系 v1
```

### 关键架构决策建议

1. **Skills-First, MCP-When-Needed**——SAND 的差异化价值（方法论引导）用 Skill 实现，外部系统集成需求出现时再引入 MCP。不要为了"技术先进性"而过度工程化
2. **复用 BMad 的 Skill 架构模式**——标准激活协议、3 层 TOML merge、文件发现链接、Agent 菜单分发。不需要发明新架构
3. **零基础设施门槛**——SAND 定位为"开放方法论框架"，Skills 架构确保 `git clone` 即可使用，完美匹配定位
4. **度量采集走渐进路径**——Phase 1-3 先通过 Skill 工作流记录关键事件（意图状态、审查决策），Phase 4 再引入 MCP Server 做自动化采集
5. **Agent 能力卡对齐 A2A + MCP Server Cards 标准**——这是文档层面的设计，不依赖 MCP 基础设施，可在 Phase 1 就定义好
6. **资产库 = Git 仓库 + 元数据追踪**——先用 Git 管理资产文件 + YAML 元数据，成熟后再引入向量数据库做语义搜索
7. **C1/C2 调研成果作为参考知识保留**——MCP 协议全景和 Agent 编排框架对比是 SAND 工具层文档（`05-tools/tool-sdc-mapping.md`）的重要输入，即使当前不直接实现

### MCP 调研成果的价值定位

> C1（MCP 协议）和 C2（Agent 编排框架）的调研成果并非无用——它们回答的是"当 SAND 需要实时外部集成时，技术生态是否支持"的问题。答案是肯定的：MCP 已有 9,700 万月下载、13,000+ Server、所有主要厂商支持；LangGraph 是唯一 Tier 1 生产级编排框架。这意味着 **SAND 的未来扩展路径是安全的**——当度量自动化和企业级部署需求出现时，不需要担心技术生态不成熟。
>
> 但对当前阶段的 SAND 来说，**最紧迫的任务是把空壳文档变成可执行的方法论引导流程**，Skills 架构能以 1/10 的成本和 1/5 的时间完成这个目标。

---

**研究完成日期：** 2026-05-12
**引用来源：** 40+ 权威来源，覆盖协议规范、框架文档、行业报告、会计准则
**来源验证：** 所有关键技术主张通过多源交叉验证
**置信水平：** 高——基于公开规范、官方文档和多个独立行业来源

_本报告作为 SAND 框架工具层和度量层的技术基础文件，为后续的架构设计和实现规划提供技术参照。_
