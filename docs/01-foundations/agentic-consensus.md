# Agentic AI 治理理论

> **定位说明**：本章节原引用"Wang等学者(2026)的Agentic Consensus范式"，经深度文献验证后未能在公开学术数据库中定位该精确引用。现将本章节重新定位为**多源治理理论综合**——从多个可验证来源构建 SAND 治理中心轴的理论基础。

## 核心主张

规模化 AI 开发需要一个贯穿全生命周期的治理机制——不是事后审计，而是设计阶段即内嵌的结构化治理能力。SAND 将此称为"治理中心轴"（Governance Backbone）。

治理中心轴的核心设计理念：治理不随 SDC 阶段切换而改变，而是作为旋转轴心持续运转。每次 AI 参与决策或生成产物时，必须留下可追溯的结构化证据链。详见 [治理中心轴概述](../02-development-cycle/governance/README.md)。

## 理论来源

本章节的理论基础由四个可验证学术/标准来源综合构建，并辅以 EU AI Act 最新监管框架演进（共 5 个来源）：

### 1. Mikkonen 的"人类审查不可削减"原则

Mikkonen & Taivalsaari (2025) 论证了 AI 辅助的生成式代码复用在概念上与 Cargo Cult 开发并无本质区别——开发者将信任置于 AI 生成的代码上，但对代码的理解与手写代码时根本不同。这建立了治理的第一性原理：**人类审查是不可削减的（non-reducible）**。

> 来源：Mikkonen, T. & Taivalsaari, A. (2025). "Software Reuse in the Generative AI Era: From Cargo Cult Towards Systematic Practices." *Internetware '25*. [ACM DL](https://dl.acm.org/doi/10.1145/3755881.3755981)

**对 SAND 治理中心轴的贡献：**

Mikkonen 的论证从三个层面支撑治理的第一性原理：

1. **信任-理解断裂**：开发者对 AI 代码的信任建立在"似乎正确"的输出之上，而非对代码的深度理解。这种断裂使得传统的"作者自查"质量模式失效——代码的"作者"（AI）无法对其输出承担认知层面的责任，人类审查必须填补这一空白
2. **灰盒复用盲区**：AI 生成式复用引入了传统白盒/黑盒之外的第三种模式——代码可见但生成过程不透明。这要求审计不仅记录"做了什么"，还要记录"基于什么上下文生成了什么"——即 SandAuditEvent 中 `input_hash` 和 `output_hash` 的设计理据
3. **Cargo Cult 递推风险**：一段 AI 生成的代码被后续 AI 会话引用为上下文，可能产生信任递推链。治理中心轴通过 `intent_id` → `execution_id` 的追踪链条切断递推，确保每段代码可回溯至原始意图声明

这一理论直接推导出 SAND 的**四根治理支柱**中"审计治理"支柱的核心要求：每个 AI 决策必须留下结构化证据链，详见 [审计治理](../02-development-cycle/governance/audit-governance.md)。同时也是 [生成式复用风险](./generative-reuse-risk.md) 中完整阐述的 Validate 阶段三通道验证必要性的直接延伸。

### 2. ISO/IEC 42001 AI 管理系统标准

ISO 42001 是全球首个可认证的 AI 管理系统标准，提供 38 项结构化控制措施、9 大治理领域，遵循 Plan-Do-Check-Act (PDCA) 循环。其核心要求——风险管理、AI 全生命周期管理、第三方监督、数据治理、技术文档——与 SAND 治理中心轴的设计天然对齐。

> 来源：[ISO/IEC 42001:2023](https://www.iso.org/standard/42001)

**ISO 42001 PDCA 循环与 SAND SDC 阶段映射：**

| PDCA 阶段 | ISO 42001 核心要求 | SAND SDC 对应 | SAND 控制措施 |
|-----------|-------------------|---------------|--------------|
| **Plan** | 风险评估、AI 政策制定、控制目标确定 | Assess + Intent | `sand-assess-maturity` 7 维度评估、意图声明 CLEAR 检查 |
| **Plan** | 利益相关方需求、法规要求识别 | Intent | 意图声明 `constraints` 字段记录合规约束 |
| **Do** | AI 系统开发与运行控制 | Orchestrate + Build | 编排方案 HIP 配置、SandRuntime 自动审计写入 |
| **Do** | 数据管理、模型管理、第三方管理 | Build + Orchestrate | 上下文最小化（FR32）、外部 Skill 验证（FR20） |
| **Check** | 监控、测量、分析与评价 | Validate + Operate | 三通道并行验证、`sand-measure-light` 度量采集 |
| **Check** | 内部审计、管理评审 | Governance | `sand-governance-audit` 审计追踪报告 |
| **Act** | 纠正措施、持续改进 | Learn | `sand-run-retrospective` 复盘 + 资产化 |

**ISO 42001 关键控制措施与 SAND 的对应关系（精选 12 项）：**

| ISO 42001 控制措施 | 治理领域 | SAND 实现 |
|-------------------|---------|----------|
| A.2 AI 政策 | 组织治理 | `.sand/config.yaml` 项目级治理配置 |
| A.3 AI 系统生命周期 | 生命周期管理 | SDC 7 阶段闭环 |
| A.4 风险管理 | 风险治理 | Assess 阶段雷达图 + 改进路径 |
| A.5 数据管理 | 数据治理 | FR32-FR33 上下文最小化 + 脱敏 |
| A.6 技术文档 | 文档治理 | 意图声明 7 字段 + 执行契约 |
| A.7 记录控制 | 记录管理 | `.sand/audits/audit.jsonl` 审计日志 |
| A.8 监控与测量 | 运营治理 | `sand-measure-light` 度量采集 |
| A.9 内部审计 | 审计治理 | `sand-governance-audit` 审计报告 |
| A.10 管理评审 | 决策治理 | HIP-2/3 人工审查决策 |
| A.11 变更管理 | 变更治理 | 意图生命周期状态机 |
| A.12 供应链管理 | 供应链治理 | 外部 Skill 验证机制（FR20） |
| A.13 持续改进 | 改进治理 | Learn 阶段资产化 + 飞轮指标 |

截至 2026 年 1 月，ISO 42001 已可通过 UKAS 认证机构（如 NQA）正式获取认证。SAND 的审计证据链可直接作为 ISO 42001 合规证据的输入。

### 3. Wang 等人的 MI9 运行时治理框架

Charles L. Wang 等人 (2025) 提出了首个专为 Agentic AI 系统设计的集成运行时治理框架 MI9，包含六个核心组件：Agency 风险指数、Agent 语义遥测、持续授权监控、FSM 一致性引擎、目标条件漂移检测和分级遏制策略。MI9 的"委托图"（delegation graph）跟踪跨衍生 Agent 的权限继承链，提供了 Agent 治理的技术实现参照。

> 来源：Wang, C.L. et al. (2025). "MI9: An Integrated Runtime Governance Framework for Agentic AI." [arXiv:2508.03858](https://arxiv.org/abs/2508.03858)

**MI9 六核心组件与 SAND SandRuntime 模块的对应关系：**

| MI9 组件 | MI9 职责 | SAND SandRuntime 对应 | SAND 实现方式 |
|---------|---------|---------------------|-------------|
| Agency 风险指数 | 量化 Agent 自主决策的风险级别 | HIP 级别配置 | HIP-1/2/3 三级人类介入模型 |
| Agent 语义遥测 | 实时监控 Agent 行为语义 | **AuditWriter** | 步骤级审计事件追加到 `audit.jsonl` |
| 持续授权监控 | 跟踪 Agent 权限随时间的变化 | **StateManager** | `execution.yaml` 中 `steps_completed` 状态追踪 |
| FSM 一致性引擎 | 确保 Agent 行为符合有限状态机约束 | **Executor** | 按 SKILL.md 契约顺序执行 steps/，不允许跳步 |
| 目标条件漂移检测 | 检测执行过程中目标偏离 | 偏差追踪 | `deviations.json` 意图偏差记录（FR27a-b） |
| 分级遏制策略 | 根据风险级别采取不同响应 | HIP 动态调整 | 信任度积累降级、异常信号升级、新领域重置 |

MI9 的委托图概念在 SAND 中体现为 `intent_id` → `execution_id` → `skill_chain` 的链式追踪——每个 Skill 的执行权限可追溯至原始意图声明中的 `constraints` 和 `acceptance_criteria`。

**对 SAND 的实践意义：** MI9 验证了运行时治理的技术可行性。SAND 采用了等效但更轻量的设计——零基础设施约束下，通过文件系统（JSONL + YAML）实现了 MI9 六组件的核心功能，避免了独立治理服务的部署负担。

### 4. NIST AI 风险管理框架 1.1

NIST AI RMF 与网络安全框架和隐私框架天然整合，2026 年 3 月发布的 1.1 版本和 Cyber AI Profile (IR 8596) 将 AI 特定风险扩展到 Secure/Defend/Thwart 三个焦点领域。为 SAND 的治理中心轴提供了与既有企业风险管理体系对接的标准化路径。

> 来源：[NIST AI RMF](https://www.nist.gov/artificial-intelligence/risk-management-framework)

**NIST Cyber AI Profile 六功能与 SAND 的映射：**

| CSF 2.0 功能 | 核心目标 | SAND 对应 |
|-------------|---------|----------|
| **Govern** | 建立 AI 风险管理策略和监督机制 | 治理中心轴（四根支柱）+ `.sand/config.yaml` |
| **Identify** | 识别 AI 相关风险和资产 | Assess 阶段 7 维度评估 + 差距分析 |
| **Protect** | 实施 AI 安全防护措施 | FR32-FR33 上下文最小化 + 脱敏 + HIP 配置 |
| **Detect** | 检测 AI 相关异常和偏差 | Validate 三通道验证 + 偏差追踪 |
| **Respond** | 响应 AI 安全事件 | 验证决策矩阵（通过/有条件/打回/重定向） |
| **Recover** | 恢复 AI 系统正常运行 | Learn 阶段复盘 + 断点续传恢复 |

**Secure/Defend/Thwart 三焦点在 SAND 中的体现：**

- **Secure**（保护 AI 系统自身安全）：SAND 通过 `requires` 能力声明 + 外部 Skill 验证（FR20）+ 上下文最小化确保 Skill 执行环境安全
- **Defend**（利用 AI 增强安全能力）：三通道验证中的安全合规通道自动检测注入、XSS、敏感数据泄露等风险
- **Thwart**（对抗 AI 相关威胁）：HIP 机制确保关键决策有人类审查，防止 AI 被利用为攻击向量

NIST 同时在开发 SP 800-53 AI 控制覆盖层（COSAiS），预计提供实施级控制指南。2026 年 Q4 计划发布的 Agentic AI Agent Interoperability Profile 将进一步覆盖 SAND 编排层涉及的多 Agent 治理场景。

### 5. EU AI Act 合规路径

EU AI Act (Regulation 2024/1689) 于 2024 年 8 月 1 日生效，高风险 AI 系统的全面合规要求将于 **2026 年 8 月 2 日**全面适用。2026 年 5 月 7 日达成的 Digital Omnibus 政治协议进一步调整了部分领域的适用时间表。

> 来源：[EU AI Act](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)

**Article 17 质量管理体系 (QMS) 要求与 SAND 的对应：**

| Article 17 QMS 要求 | SAND 实现 |
|--------------------|----------|
| 文档化风险管理系统 | Assess 阶段雷达图 + 改进路径 + `.sand/assessments/` |
| 数据治理措施 | FR32-FR33 上下文最小化 + 脱敏规则 |
| 详细技术文档 | 意图声明 7 字段 + 执行契约 + 审计日志 |
| 自动日志记录 | SandRuntime AuditWriter → `audit.jsonl` |
| 适当人类监督 | HIP-1/2/3 三级人类介入模型 |
| 准确性与网络安全保障 | 三通道并行验证 + SHA-256 完整性校验 |

**合规路径链条：** EU AI Act Article 17 → ISO 42001 PDCA 循环 → SAND 治理中心轴。SAND 的审计追踪报告（`sand-governance-audit` 产出）可直接作为 ISO 42001 认证审计和 EU AI Act 合规评估的证据输入。

**对 SAND 的实践意义：** SAND 不是合规工具——它是方法论框架。但通过治理中心轴的设计，使用 SAND 的组织可以在日常开发工作流中自动积累合规证据，而非在审计前突击准备。这是"治理即工作流"设计理念的体现。

## 对 SAND 设计原则的贡献

本章节的四个理论来源 + EU AI Act 合规路径共同支撑 SAND 的**可治理可审计原则**：

| 理论来源 | 贡献 | 治理支柱对应 |
|---------|------|------------|
| Mikkonen "人类审查不可削减" | 治理的第一性原理——AI 输出必须经人类审查 | 审计治理 + 决策治理 |
| ISO 42001 PDCA 循环 | 治理的结构化框架——计划/执行/检查/改进 | 合规治理 |
| Wang MI9 运行时治理 | Agent 系统的技术治理实现——运行时监控 | 审计治理 |
| NIST AI RMF 1.1 | 企业风险管理体系对接——六功能映射 | 合规治理 |
| EU AI Act Article 17 | 监管合规的法律约束——QMS 要求 | 合规治理 |

四根治理支柱（决策治理、合规治理、质量治理、审计治理）的详细定义见 [治理中心轴](../02-development-cycle/governance/README.md) 及其子文档。
