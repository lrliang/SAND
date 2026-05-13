# Story 2.0: 完善 Intent 阶段理论基础

Status: done

## Story

As a SAND 框架开发者,
I want Intent 阶段的理论文档和 Foundations 依赖文档完整且可操作化,
so that 后续 Story 2-1（sand-create-intent Skill 实现）的 `data/clear-checklist.yaml`、`templates/intent-statement.yaml` 和 `templates/execution-contract.yaml` 有坚实、可溯源的理论依据，且理论与操作化数据零偏差。

## Acceptance Criteria

1. `docs/01-foundations/cognitive-collaboration.md` 从 STUB（5 行）扩展为完整文档，包含 Hassan SE 3.0 演进路径中的认知协作愿景、SDD（Spec-Driven Development）作为行业验证、分布式认知和互补性理论基础、"认知协作 vs 提示词工程"的操作化区分，引用可验证的学术来源
2. `docs/02-development-cycle/intent/intent-statement.md` 从 STUB（5 行）扩展为完整文档，包含 7 个字段（purpose、desired_outcome、acceptance_criteria、constraints、context_references、meta、intent_type）的完整定义——每字段包含：语义说明、格式要求、示例、常见错误/反模式
3. `docs/02-development-cycle/intent/clear-checklist.md` 从 STUB（5 行）扩展为完整文档，包含 CLEAR 5 维度（Complete/Lean/Executable/Assessable/Reversible）× 具体检查项 + 每项的通过/不通过判定标准 + AI 可自动化标注
4. `docs/02-development-cycle/intent/execution-contract.md` 从 STUB（5 行）扩展为完整文档，包含 must_pass/should_pass/must_not_violate 三级结构的完整定义 + 从意图声明字段到契约条目的映射规则 + 与 Validate 阶段四种决策的对应关系
5. `docs/02-development-cycle/intent/intent-lifecycle.md` 从 STUB（5 行）扩展为完整文档，包含 Draft → Reviewed → Approved → In Execution → Validated → Archived 六状态完整定义 + 状态转换触发条件 + 审计追踪要求
6. `docs/02-development-cycle/intent/intent-taxonomy.md` 从 STUB（5 行）扩展为完整文档，包含 5 种意图类型（Feature/Fix/Refactor/Exploration/Optimization）的完整分类 + 每类型与编排拓扑和审查强度的关联
7. `docs/02-development-cycle/intent/decomposition-patterns.md` 从 STUB（5 行）扩展为完整文档，包含 3 种分解模式（垂直切片/能力分层/风险梯度）的完整定义 + 适用场景 + 与意图类型的对应关系
8. 7 个字段名称在 intent-statement.md 中与 PRD FR9、epics BDD、Architecture sand-create-intent 目录结构、以及 `docs/09-templates/intent-statement.yaml` 保持一致：purpose、desired_outcome、acceptance_criteria、constraints、context_references、meta、intent_type
9. 所有新增文档内容的学术引用必须来自已验证来源（参见 Dev Notes §可用学术来源），禁止编造论文/作者/年份

## Tasks / Subtasks

- [x] Task 1: 补强 `docs/01-foundations/cognitive-collaboration.md` (AC: #1)
  - [x] 1.1 阅读研究材料中 Hassan SE 3.0 相关内容（domain-foundations-deep-dive §140-221）
  - [x] 1.2 撰写 SE 1.0 → 2.0 → 3.0 演进路径和认知协作愿景
  - [x] 1.3 撰写 SDD（Spec-Driven Development）作为"意图驱动"的行业验证（SDD 光谱三层级）
  - [x] 1.4 撰写分布式认知理论和互补性理论的核心论点
  - [x] 1.5 撰写"认知协作 vs 提示词工程（工具使用）"的操作化区分
  - [x] 1.6 推导 SAND 设计原则 #2（意图驱动原则）的理论链条
  - [x] 1.7 标注引用来源，确保可验证
- [x] Task 2: 完善 `docs/02-development-cycle/intent/intent-statement.md` (AC: #2, #8)
  - [x] 2.1 阅读 PRD FR9、Journey 2 陈雨、`docs/09-templates/intent-statement.yaml` 中的字段结构
  - [x] 2.2 撰写 7 字段概述（双受众设计原则：人类理解 + AI 执行）
  - [x] 2.3 逐字段撰写完整定义（语义说明 + 格式要求 + 示例 + 反模式）
  - [x] 2.4 撰写字段分组逻辑（5 组：人类决策域/契约域/约束域/上下文域/元数据域）
  - [x] 2.5 说明 intent_id 为系统生成标识符（不计入 7 字段标准）
- [x] Task 3: 完善 `docs/02-development-cycle/intent/clear-checklist.md` (AC: #3)
  - [x] 3.1 阅读 PRD FR10、Journey 2 陈雨 CLEAR 检查场景
  - [x] 3.2 为 5 个维度分别撰写 3-5 项具体检查项
  - [x] 3.3 每项标注通过/不通过判定标准（具体、可量化）
  - [x] 3.4 每项标注自动化级别（AI 自动 / 需人工 / 混合）
  - [x] 3.5 撰写 CLEAR 检查流程（顺序、阈值、输出格式）
- [x] Task 4: 完善 `docs/02-development-cycle/intent/execution-contract.md` (AC: #4)
  - [x] 4.1 阅读 PRD FR11、Architecture 执行契约相关定义
  - [x] 4.2 撰写三级结构完整定义（must_pass / should_pass / must_not_violate）
  - [x] 4.3 撰写从意图声明 7 字段到契约条目的映射规则
  - [x] 4.4 撰写与 Validate 阶段四种决策（通过/有条件通过/打回 Build/重定向 Intent）的对应关系
  - [x] 4.5 提供契约条目示例（从陈雨旅程推导）
- [x] Task 5: 完善 `docs/02-development-cycle/intent/intent-lifecycle.md` (AC: #5)
  - [x] 5.1 阅读 PRD FR13、Architecture .sand/ 目录结构
  - [x] 5.2 撰写 6 状态完整定义（每状态含：语义、前置条件、后置条件）
  - [x] 5.3 撰写状态转换规则（合法转换路径 + 触发条件 + 所需角色）
  - [x] 5.4 撰写审计追踪要求（每次状态变更记录什么）
  - [x] 5.5 绘制状态机文字图
- [x] Task 6: 完善 `docs/02-development-cycle/intent/intent-taxonomy.md` (AC: #6)
  - [x] 6.1 阅读 PRD FR14、Architecture 编排拓扑相关定义
  - [x] 6.2 撰写 5 种意图类型完整定义（含典型场景、复杂度特征）
  - [x] 6.3 撰写每类型与编排拓扑的推荐关联
  - [x] 6.4 撰写每类型与审查强度（HIP 级别）的推荐关联
  - [x] 6.5 撰写分类判定指南（边界情况处理）
- [x] Task 7: 完善 `docs/02-development-cycle/intent/decomposition-patterns.md` (AC: #7)
  - [x] 7.1 撰写 3 种分解模式完整定义（垂直切片 / 能力分层 / 风险梯度）
  - [x] 7.2 每模式包含：适用场景、操作步骤、示例、与意图类型的对应
  - [x] 7.3 撰写"何时拆分"的判定规则（复杂度阈值、风险信号）
  - [x] 7.4 撰写拆分后意图间的依赖管理
- [x] Task 8: 交叉验证一致性 (AC: #8, #9)
  - [x] 8.1 对比 intent-statement.md 的 7 字段名称与 PRD FR9 和 `docs/09-templates/intent-statement.yaml`
  - [x] 8.2 对比 clear-checklist.md 的 5 维度与 PRD Journey 2 陈雨场景
  - [x] 8.3 对比 execution-contract.md 的三级结构与 Architecture 定义
  - [x] 8.4 对比 intent-lifecycle.md 的 6 状态与 PRD FR13
  - [x] 8.5 对比 intent-taxonomy.md 的 5 类型与 PRD FR14
  - [x] 8.6 验证所有学术引用来自已验证来源列表

### Review Findings

- [x] [Review][Decision] **HIP 级别数字方向在文档间完全矛盾** — 已修复：统一为 PRD 方向（HIP-1=全自主/最低介入，HIP-3=全程监督/最高介入），修正 cognitive-collaboration.md HIP 表和 intent-taxonomy.md 描述
- [x] [Review][Patch] **should_pass 的 Validate 决策影响段落缺失** — 已修复：补充完整决策条件描述 [execution-contract.md]
- [x] [Review][Patch] **CLEAR 执行顺序 C-E-A-L-R 与缩写 C-L-E-A-R 不同但未解释** — 已修复：添加说明"AI 自动维度先行，人工判断维度后行" [clear-checklist.md]
- [x] [Review][Patch] **执行契约生成时序矛盾** — 已修复：改为"CLEAR 通过→自动生成契约→人工审批" [intent-lifecycle.md]
- [x] [Review][Patch] **desired_outcome 示例 10% 降级与 acceptance_criteria 示例 50ms 不对齐** — 已修复：desired_outcome 改为"显著降级（具体阈值见 acceptance_criteria）" [intent-statement.md]
- [x] [Review][Patch] **CLEAR A1 通过≥80%与不通过>50%之间存在未覆盖判定区间** — 已修复：添加"50%-80% 区间判定为 warn" [clear-checklist.md]
- [x] [Review][Patch] **状态机 ASCII 图与合法转换表不一致** — 已修复：图中增加 Approved→Draft 路径 [intent-lifecycle.md]
- [x] [Review][Patch] **constraints.technical 映射规则"取反表述"无具体规则** — 已修复：改为"直接映射，保持原始表述" [execution-contract.md]
- [x] [Review][Patch] **SASE arXiv 引用链接格式不规范** — 已修复：/html/ → /abs/ [cognitive-collaboration.md]
- [x] [Review][Defer] **Assess 阶段在 SE 3.0 四组件映射中缺席** — SE 3.0 四组件没有 Assess 对应物，文档未解释此缺失 [cognitive-collaboration.md] — deferred, 理论讨论不阻塞实现
- [x] [Review][Defer] **intent_id 格式冲突：模板用 SAND-YYYY-NNNN，理论/架构用 INT-YYYYMMDD-{seq}** — 模板不在本 Story 修改范围 [docs/09-templates/intent-statement.yaml] — deferred, 模板修正属于 Story 2-1
- [x] [Review][Defer] **"废弃"操作无正式终态** — 6 状态不含 Abandoned/Cancelled，废弃后 meta.status 值未定义 [intent-lifecycle.md] — deferred, 生命周期扩展
- [x] [Review][Defer] **CLEAR 全维度 fail 无熔断机制** — 无"建议废弃并重新创建"的短路逻辑 [clear-checklist.md] — deferred, Skill 实现增强
- [x] [Review][Defer] **生命周期审计事件 Schema 与 Architecture SandAuditEvent Schema 不兼容** — 两者字段集不同，event_id 格式冲突 [intent-lifecycle.md vs architecture.md] — deferred, 架构级统一
- [x] [Review][Defer] **should_pass 偏差升级阈值未定义** — "累计偏差超过阈值"的阈值未量化 [execution-contract.md] — deferred, Validate Skill 实现细节
- [x] [Review][Defer] **非法状态转换系统行为 + Validate→Build 打回循环无上限** — 未定义拦截/回滚行为和重试上限 [intent-lifecycle.md] — deferred, 运行时实现
- [x] [Review][Defer] **README 核心产出列表与文档定义不一致** — README 列出"约束上下文"和"投资假设"为独立工件，但文档中这些是字段非独立工件 [intent/README.md] — deferred, README 不在本 Story 范围

## Dev Notes

### Story 本质

这是一个**纯文档撰写** Story——不涉及代码、Schema 或 Skill 文件。产出为 7 个 Markdown 文档（1 个 Foundations + 6 个 Intent 阶段），目标是让后续 Story 2-1（sand-create-intent Skill 实现）有足够的理论基础来生成操作化数据文件（`data/clear-checklist.yaml`）和模板文件（`templates/intent-statement.yaml`、`templates/execution-contract.yaml`）。

### 现有 STUB 文件的精确内容

每个 STUB 文件当前只有 5 行，格式统一为：标题 + 空行 + 一句概要 + 空行 + `<!-- TODO: 待撰写 -->`

**cognitive-collaboration.md 当前内容：**
```
# 认知协作与SE 3.0

Ahmed E. Hassan等学者提出的Software Engineering 3.0——以意图为中心、对话式驱动的AI原生开发范式。SE 1.0→2.0→3.0演变路径。

<!-- TODO: 待撰写 -->
```

**intent-statement.md 当前内容：**
```
# 意图声明7字段标准

7个必填字段：intent_id、intent_type、purpose、desired_outcome、acceptance_criteria、constraints、context_references、meta。双受众设计（人类理解+AI执行）。

<!-- TODO: 待撰写 -->
```
> **注意**：STUB 概要中列出了 8 个项目（含 intent_id），但 PRD FR9 和 epics BDD 明确说的是"7 字段标准"——不含 intent_id。intent_id 是系统生成的标识符，不属于用户定义的 7 字段。完善时须澄清这一点。

**clear-checklist.md 当前内容：**
```
# CLEAR质量检查清单

Complete（完整）、Lean（精简）、Executable（可执行）、Assessable（可评估）、Reversible（可回退）。其中C/E/A三项可AI自动化检查。

<!-- TODO: 待撰写 -->
```

**execution-contract.md 当前内容：**
```
# 执行契约标准

三级结构：must_pass（全部不满足则失败）、should_pass（尽量满足）、must_not_violate（反向约束）。直接映射到Validate阶段的三种判定结果。

<!-- TODO: 待撰写 -->
```

**intent-lifecycle.md 当前内容：**
```
# 意图生命周期

Draft → Reviewed → Approved → In Execution → Validated → Archived。每次状态变更记录变更原因和操作人，形成意图审计追踪链。

<!-- TODO: 待撰写 -->
```

**intent-taxonomy.md 当前内容：**
```
# 意图类型学

5种意图类型：Feature（功能）、Fix（修复）、Refactor（重构）、Exploration（探索）、Optimization（优化）。每种类型关联不同的编排拓扑和审查强度。

<!-- TODO: 待撰写 -->
```

**decomposition-patterns.md 当前内容：**
```
# 意图分解模式

3种标准分解模式：垂直切片（用户价值切片）、能力分层（渐进深度）、风险梯度（风险递增排列）。

<!-- TODO: 待撰写 -->
```

### 写作约束

- **文档语言**：中文（technical terms 保持英文原形）
- **编码**：UTF-8，LF 换行
- **保留 STUB 的标题和概要**：在现有内容基础上扩展，不删除已有概要段
- **每个文档的目标篇幅**：
  - cognitive-collaboration.md: ~2000-3500 字（核心理论文档，需覆盖 SE 3.0 + SDD + 分布式认知 + 互补性 + SAND 映射）
  - intent-statement.md: ~2500-4000 字（7 字段 × 完整定义，需直接支持 YAML 化提取）
  - clear-checklist.md: ~2000-3000 字（5 维度 × 检查项，结构化列表为主）
  - execution-contract.md: ~1500-2500 字（三级结构 + 映射规则 + 决策对应）
  - intent-lifecycle.md: ~1000-1500 字（状态机定义，简洁明确）
  - intent-taxonomy.md: ~1200-1800 字（5 类型 × 特征 + 编排/审查关联）
  - decomposition-patterns.md: ~1000-1500 字（3 模式 × 定义 + 操作步骤）
- **文档风格**：实务导向的理论阐述，不是学术论文。目标读者是软件工程 FDE+ 和技术负责人。理论服务于操作化——每段理论都应指向"这对 SAND 的 Intent Skill 意味着什么"

### 可用学术来源（经项目研究阶段验证）

以下来源在 `_bmad-output/planning-artifacts/research/` 中已被引用和验证。**仅使用这些来源**，禁止引用未经验证的论文：

| 来源 | 用途 | 研究文件位置 |
|------|------|-------------|
| **Hassan, A.E. et al. (2026)** "Towards AI-Native SE (SE 3.0)" ACM TOSEM, DOI: 10.1145/3807901 | SE 3.0 演进路径、意图驱动愿景、四组件技术栈 | domain-foundations-deep-dive §140-221 |
| **SDD（Spec-Driven Development）** AIWare 2026 预印本 + 多行业来源 | SDD 光谱（Spec-First/Spec-Anchored/Spec-as-Source）、SAND 意图声明 = SDD Spec-Anchored 形式化 | domain-ai-native-methodology-research §2.5 |
| **分布式认知理论** Collaborative AI Literacy, Taylor & Francis (2025) | 认知过程分布在人-工具-环境之间 | domain-foundations-deep-dive §2.3 |
| **互补性理论** Complementarity in Human-AI Collaboration, EJIS (2025) | CTP（互补团队绩效）、人-AI 犯不同类型错误 | domain-foundations-deep-dive §2.3 |
| **HAT 信任衰减** Schmutz et al. (2024), Current Opinion in Psychology | AI 队友信任随时间下降、需结构化信任框架 | domain-foundations-deep-dive §2.3 |
| **Fowler, M. (2024-2025)** "AI Software Development" 系列 | 非确定性范式（已在 Story 1-0 使用，可交叉引用） | domain-foundations-deep-dive §44-136 |
| **Beck, K. (2025)** "Tidy Together" + AI 协作观点 | 约束工程、增量设计 | domain-foundations-deep-dive §96-135 |
| **Augment Code / DeepLearning.AI / CGI** SDD 相关文章 | SDD 行业采纳证据（GitHub Spec Kit、AWS Kiro、JetBrains Planning Mode） | domain-ai-native-methodology-research |

### 7 字段名称的权威定义

字段名称和含义在多个文件中已固定。以下是权威来源和交叉验证点：

| 字段 | PRD 定义 | 模板位置 | 语义分组 |
|------|---------|---------|---------|
| **purpose** | FR9 "7 字段标准" | intent-statement.yaml 第 9-11 行 | 人类决策域（Why + What） |
| **desired_outcome** | FR9 | intent-statement.yaml 第 13-16 行 | 人类决策域 |
| **acceptance_criteria** | FR9 + Journey 2 陈雨 "缺少性能基线" | intent-statement.yaml 第 19-22 行 | 契约域（How to verify） |
| **constraints** | FR9 + FR32 "constraints 中明确授权" | intent-statement.yaml 第 26-29 行 | 约束域（What NOT to do） |
| **context_references** | FR9 | intent-statement.yaml 第 33-39 行 | 上下文域 |
| **meta** | FR9 | intent-statement.yaml 第 42-48 行 | 元数据域 |
| **intent_type** | FR9 + FR14 分类管理 | intent-statement.yaml 第 5 行 | 元数据域 |

**注意**：intent_id（格式 `INT-YYYYMMDD-{seq}`）是系统生成标识符，不属于用户定义的 7 字段。模板中 intent_id 位于 YAML 顶部但不计入"7 字段标准"。

这 7 个字段名称**不可修改**——它们在 PRD FR9、Architecture、模板中已固化。

### CLEAR 维度权威定义

| 维度 | 英文 | PRD/Journey 引用 | AI 自动化 |
|------|------|-----------------|----------|
| **完整** | Complete | Journey 2 陈雨 "Complete ✓" | 是（C） |
| **精简** | Lean | Journey 2 陈雨 "Lean ✓" | 否 |
| **可执行** | Executable | Journey 2 陈雨 "Executable ⚠️" | 是（E） |
| **可评估** | Assessable | Journey 2 陈雨 "Assessable ✓" | 是（A） |
| **可回退** | Reversible | Journey 2 陈雨 "Reversible ✓" | 否 |

STUB 指出 C/E/A 三项可 AI 自动化，L/R 需人工判断。这一分类**不可修改**。

### 执行契约三级结构与 Validate 决策映射

| 契约层级 | 语义 | Validate 阶段对应 |
|---------|------|------------------|
| **must_pass** | 全部满足才能通过 | 未满足 → 打回 Build |
| **should_pass** | 尽量满足，部分未满足可有条件通过 | 部分未满足 → 有条件通过 |
| **must_not_violate** | 反向约束（绝对不可违反） | 违反 → 重定向 Intent |

STUB 说"直接映射到 Validate 阶段的三种判定结果"——实际上 Validate 有四种决策（通过/有条件通过/打回 Build/重定向 Intent），三级契约与四种决策的映射关系需要在文档中明确。

### 意图生命周期 6 状态

PRD FR13 和 STUB 定义了 6 个状态：Draft → Reviewed → Approved → In Execution → Validated → Archived

需注意与 SDC 阶段回退路径的对应：
- Validate → Build（打回）= 意图状态从 In Execution 不变（重新执行）
- Validate → Intent（重定向）= 意图状态回退到 Draft 或创建新意图
- 每次状态变更记录为审计事件

### 意图类型学 5 类型

PRD FR14 和 STUB 定义了 5 种类型。需在文档中关联：

| 类型 | 推荐编排拓扑 | 推荐 HIP 级别 | 备注 |
|------|------------|-------------|------|
| **Feature** | Pipeline 或 Swarm | HIP-2 | 新功能，需完整验证 |
| **Fix** | Solo | HIP-1 | 修复，范围明确 |
| **Refactor** | Pipeline | HIP-2 | 重构，影响范围广 |
| **Exploration** | Solo | HIP-1 | 探索，容忍失败 |
| **Optimization** | Solo 或 Pipeline | HIP-2 | 优化，需性能基准 |

上述编排拓扑和 HIP 级别为**推荐值**（参考 Architecture §Agent Roles & Orchestration Topology），文档中应说明这些是默认推荐而非硬约束。

### 意图分解 3 种模式

STUB 定义了 3 种分解模式。需覆盖：
- **垂直切片**（Vertical Slice）：按用户价值端到端切片，每片可独立交付价值
- **能力分层**（Capability Layering）：按技术深度渐进实现，先基础后增强
- **风险梯度**（Risk Gradient）：按风险从低到高排列，先验证低风险假设

### 与已完成 Story 1-0 的模式对齐

Story 1-0 建立了以下文档模式，本 Story 应保持一致：
- **标题保留**：保留 STUB 原有标题文字
- **概要段保留并扩展**：不删除 STUB 概要，在其后添加分隔线和详细内容
- **引用格式**：使用 `> **参考文献：**` 格式在相关段落附近标注
- **交叉引用格式**：使用相对路径 `../../01-foundations/cognitive-collaboration.md`（从 intent/ 目录引用 foundations）
- **结构化优先**：使用表格和列表而非散文段落，以支持后续 YAML 化提取
- **"对 SAND 的实践意义"收尾**：每个文档末尾说明对 Skill 开发的实践映射

### 与后续 Story 的交接约定

Story 2-1（sand-create-intent Skill 实现）将从本 Story 的文档中提取：
- `clear-checklist.md` → `data/clear-checklist.yaml`（CLEAR 5 维 × 检查项的 YAML 化）
- `intent-statement.md` → 验证 `templates/intent-statement.yaml`（字段与理论定义一致）
- `execution-contract.md` → 验证 `templates/execution-contract.yaml`（三级结构与理论一致）

因此 **clear-checklist.md 的检查项结构应直接支持 YAML 化提取**——建议使用表格或结构化列表（维度 > 检查项 > 判定标准 > 自动化级别），而非散文段落。

### 不要做的事

- **不要**修改 `docs/09-templates/intent-statement.yaml`（已有完整模板，本 Story 只写理论文档）
- **不要**修改 `docs/04-artifacts/intent-statement-spec.md`（该文件为工件规格 STUB，不在本 Story 范围）
- **不要**完善 `docs/05-tools/` 或 `docs/06-metrics/` 下的任何文件
- **不要**修改 `docs/02-development-cycle/intent/README.md`（已完善，含目录和核心原则）
- **不要**修改 `docs/02-development-cycle/sdc-overview.md`（已完善）
- **不要**修改 `docs/01-foundations/ai-native-definition.md`（Story 1-0 已完善）
- **不要**修改 `docs/01-foundations/non-deterministic-paradigm.md`（Story 1-0 已完善）
- **不要**编造学术引用——所有引用必须来自上表中的已验证来源
- **不要**修改 7 个字段名称、CLEAR 5 维度名称、三级契约结构名称——这些在 PRD 和 Architecture 中已固化

### 关键上下文：陈雨旅程（PRD Journey 2）

PRD Journey 2 是 Intent 阶段的核心场景参考，文档中的示例和反模式应与此旅程一致：

- **场景**：陈雨（FDE+，4 年经验）用 sand-create-intent 创建多租户权限隔离意图
- **CLEAR 检查结果**：Complete ✓、Lean ✓、Executable ⚠️（acceptance_criteria 缺少性能基线）、Assessable ✓、Reversible ✓
- **核心顿悟**：AI 基于执行契约主动识别 3 个未覆盖的边界条件（schema 版本不一致、增量同步、回滚窗口）
- **关键引用**："前者基于结构化契约让 AI 成为思考伙伴，后者基于自然语言让 AI 成为执行工具"

### 关键上下文：Hassan SE 3.0 → SAND 推导链

cognitive-collaboration.md 的核心推导链条：

```
Hassan SE 3.0 意图驱动愿景
  + 分布式认知理论（认知分布在人-工具-环境之间）
  + 互补性理论（人-AI 犯不同类型错误 → 组队更优）
    ↓
SAND 设计原则 #2：意图驱动原则
    ↓
实践映射：
  - 意图声明 7 字段 ← SE 3.0 "intent-centric" 主张
  - 执行契约 ← SE 3.0 "conversation-oriented" 模式
  - FDE+ 角色 ← 认知互补性（人类定义意图，AI 处理实现）
  - HIP 机制 ← HAT 信任衰减研究（需结构化信任框架）
```

SDD 行业验证链：

```
SDD（Spec-Driven Development）行业趋势
  - GitHub Spec Kit、AWS Kiro IDE、JetBrains Planning Mode
  - SDD 光谱：Spec-First → Spec-Anchored → Spec-as-Source
    ↓
SAND 定位：Intent Statement + Execution Contract = SDD Spec-Anchored 层级的形式化
  - CLEAR 检查清单 = SDD 规格质量验证框架
```

### Project Structure Notes

文件路径对齐：
- Foundations 文档：`docs/01-foundations/cognitive-collaboration.md` — 项目已有文件，直接修改
- Intent 文档：`docs/02-development-cycle/intent/*.md` — 项目已有 6 个 STUB 文件，直接修改
- 无需创建新目录或新文件（仅修改已有 STUB 文件）
- 交叉引用路径：从 intent/ 引用 foundations 用 `../../01-foundations/`，从 intent/ 引用 assess/ 用 `../assess/`

### References

- [Source: _bmad-output/planning-artifacts/prd.md §意图管理 FR9-FR14]
- [Source: _bmad-output/planning-artifacts/prd.md §意图偏差追踪 FR27a-FR27b]
- [Source: _bmad-output/planning-artifacts/prd.md §Journey 2 陈雨]
- [Source: _bmad-output/planning-artifacts/prd.md §成功标准 "意图首通率"]
- [Source: _bmad-output/planning-artifacts/architecture.md §sand-create-intent 目录结构]
- [Source: _bmad-output/planning-artifacts/architecture.md §sandskill.v1 Contract Specification]
- [Source: _bmad-output/planning-artifacts/architecture.md §.sand/ 目录结构（意图 ID 格式）]
- [Source: _bmad-output/planning-artifacts/research/domain-foundations-deep-dive-2026-05-12.md §二、认知协作模型（§140-221）]
- [Source: _bmad-output/planning-artifacts/research/domain-ai-native-development-methodology-research-2026-05-11.md §2.5 SDD]
- [Source: docs/01-foundations/ai-native-definition.md §与 Hassan SE 3.0 的对齐（Story 1-0 已完善）]
- [Source: docs/02-development-cycle/intent/README.md §Intent 阶段概述]
- [Source: docs/02-development-cycle/sdc-overview.md §SDC 7 阶段定义]
- [Source: docs/09-templates/intent-statement.yaml §完整模板结构]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

N/A — pure documentation story, no code execution or debugging involved.

### Completion Notes List

- **Task 1 (cognitive-collaboration.md):** 从 5 行 STUB 扩展为完整文档（~230 行）。涵盖 Hassan SE 3.0 演进路径（SE 1.0→2.0→3.0 + 四组件技术栈映射到 SDC）、SASE 框架（双模态协作 + 结构化工件 CRP/MRP/VCR + 自治等级分类）、SDD 行业验证（三层光谱 Spec-First/Spec-Anchored/Spec-as-Source + GitHub/AWS/JetBrains 采纳证据）、认知科学理论（分布式认知 + 互补性 CTP + HAT 信任衰减）、认知协作 vs 提示词工程操作化区分表、SAND 设计原则 #2 推导链。
- **Task 2 (intent-statement.md):** 从 5 行 STUB 扩展为完整文档（~265 行）。核心交付：7 字段逐一完整定义（语义 + 格式 + YAML 示例 + 反模式）、5 组分组逻辑（人类决策域/契约域/约束域/上下文域/元数据域）、intent_id 非 7 字段的澄清、双受众设计矩阵、与 SDD Spec-Anchored 的定位关系。示例统一使用陈雨多租户场景。
- **Task 3 (clear-checklist.md):** 从 5 行 STUB 扩展为完整文档（~165 行）。核心交付：5 维度 × 具体检查项表格（C=5 项、L=4 项、E=5 项、A=3 项、R=3 项 = 共 20 项），每项含通过/不通过判定标准、自动化级别标注、检查执行顺序（C→E→A→L→R）、YAML 输出格式示例（含 overall/维度/检查项三级结构）、汇总规则。
- **Task 4 (execution-contract.md):** 从 5 行 STUB 扩展为完整文档（~175 行）。核心交付：三级结构完整定义（must_pass/should_pass/must_not_violate 含语义、来源映射、特征）、从意图声明到契约的自动映射规则表、陈雨场景完整映射示例（含生成的 YAML 契约）、四种 Validate 决策完整映射表、AI 补充条目机制、条目 ID 格式约定（MP/SP/MNV-NNN）。修正了 STUB 中"三种判定结果"的不准确描述——实际为四种。
- **Task 5 (intent-lifecycle.md):** 从 5 行 STUB 扩展为完整文档（~165 行）。核心交付：6 状态完整定义（每状态含语义、前置/后置条件、允许操作、负责角色）、ASCII 状态机图、合法状态转换表（10 条转换 + 触发条件 + 所需角色）、审计追踪字段规范（8 字段）、SDC 回退路径对齐（Validate→Build 打回 vs Validate→Intent 重定向的不同状态影响）。
- **Task 6 (intent-taxonomy.md):** 从 5 行 STUB 扩展为完整文档（~145 行）。核心交付：5 种意图类型完整定义（含典型场景、复杂度特征、推荐编排拓扑、推荐 HIP 级别、CLEAR 侧重点）、汇总表、Fix vs Refactor 边界辨析、边界情况判定指南（5 个典型场景）、无法确定类型时的分解建议。明确标注拓扑和 HIP 为推荐默认值而非硬约束。
- **Task 7 (decomposition-patterns.md):** 从 5 行 STUB 扩展为完整文档（~160 行）。核心交付：3 种分解模式完整定义（垂直切片/能力分层/风险梯度），每模式含定义、适用场景、操作步骤、示例、与意图类型对应。"何时拆分"判定规则（5 个信号）、子意图依赖管理（3 种关系类型 + 总体完整性验证规则）。
- **Task 8 (交叉验证):** 7 字段名称与 PRD FR9 和 intent-statement.yaml 模板完全一致。5 个 intent_type 枚举值匹配。CLEAR 5 维度与 Journey 2 陈雨场景一致。三级契约结构与 Architecture 定义一致。6 状态与 PRD FR13 一致。所有学术引用来自已验证来源——6 项学术来源 + 3 项 SDD 行业来源，无编造引用。

### Change Log

- 2026-05-13: Story 2.0 实施完成。完善 7 个文档文件（1 个 Foundations + 6 个 Intent 阶段），从 STUB 状态扩展为完整理论文档。

### File List

- docs/01-foundations/cognitive-collaboration.md (MODIFIED — STUB → full document)
- docs/02-development-cycle/intent/intent-statement.md (MODIFIED — STUB → full document)
- docs/02-development-cycle/intent/clear-checklist.md (MODIFIED — STUB → full document)
- docs/02-development-cycle/intent/execution-contract.md (MODIFIED — STUB → full document)
- docs/02-development-cycle/intent/intent-lifecycle.md (MODIFIED — STUB → full document)
- docs/02-development-cycle/intent/intent-taxonomy.md (MODIFIED — STUB → full document)
- docs/02-development-cycle/intent/decomposition-patterns.md (MODIFIED — STUB → full document)
