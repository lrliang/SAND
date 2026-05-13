# Story 1.0: 完善 Assess 阶段理论基础

Status: done

## Story

As a SAND 框架开发者,
I want Assess 阶段的理论文档和 Foundations 依赖文档完整且可操作化,
so that 后续 Story 1-2（sand-assess-maturity Skill 实现）的 `data/dimension-rubrics.yaml` 和 `data/pathway-rules.yaml` 有坚实、可溯源的理论依据，且理论与操作化数据零偏差。

## Acceptance Criteria

1. `docs/01-foundations/ai-native-definition.md` 从 STUB（6 行）扩展为完整文档，包含 Cao 等学者的 AI 原生双层工程蓝图、AI 赋能/AI 优先/AI 原生的三级谱系定义、"移除 AI 测试"评估标准，引用可验证的学术来源
2. `docs/01-foundations/non-deterministic-paradigm.md` 从 STUB（6 行）扩展为完整文档，包含 Fowler 非确定性编程范式的核心论点、容差思维、幻觉即特征的场景边界、对传统度量失效的影响分析，引用可验证的学术来源
3. `docs/02-development-cycle/assess/maturity-framework.md` 从 STUB（6 行）扩展为完整的 7 维度 × L1-L5 评估框架，每个维度-等级组合包含：行为指标（≥2 条）、证据类型、数据采集方式（自动/手动/混合）
4. `docs/02-development-cycle/assess/gap-analysis.md` 从 STUB（6 行）扩展为完整文档，包含：雷达图诊断方法论、三种组织形状（均衡型/偏科型/尖刺型）的定义和识别规则、改进路径推荐逻辑（红→黄→绿的优先级、Skill 关联、ROI 预期）
5. `docs/02-development-cycle/assess/assess-tools.md` 添加 Phase 标注（Phase 3 拉动），不做实质内容完善
6. 7 个维度名称在 maturity-framework.md 中与 assess/README.md 第 9 行（已定义的目录引用）和 sdc-overview.md 保持一致：AI 工具采纳度、意图驱动成熟度、编排能力、人类审查体系、学习与资产化、治理与合规、组织文化
7. 所有新增文档内容的学术引用必须来自已验证来源（参见 Dev Notes §可用学术来源），禁止编造论文/作者/年份

## Tasks / Subtasks

- [x] Task 1: 补强 `docs/01-foundations/ai-native-definition.md` (AC: #1)
  - [x] 1.1 阅读研究材料中 Cao 相关内容（domain-foundations-deep-dive §343-362 行）
  - [x] 1.2 撰写 AI 赋能 vs AI 优先 vs AI 原生三级谱系定义
  - [x] 1.3 撰写"移除 AI 测试"评估标准
  - [x] 1.4 撰写 AI 原生双层工程蓝图（个人层 + 组织层）
  - [x] 1.5 标注引用来源，确保可验证
- [x] Task 2: 补强 `docs/01-foundations/non-deterministic-paradigm.md` (AC: #2)
  - [x] 2.1 阅读研究材料中 Fowler 相关内容（domain-foundations-deep-dive §44-136 行）
  - [x] 2.2 撰写非确定性编程范式核心论点
  - [x] 2.3 撰写容差思维和约束工程分层
  - [x] 2.4 撰写幻觉即特征的场景边界分析
  - [x] 2.5 撰写 Vibe Coding 的场景边界
  - [x] 2.6 分析对传统软件度量（行覆盖率、静态分析等）失效的影响
- [x] Task 3: 完善 `docs/02-development-cycle/assess/maturity-framework.md` (AC: #3, #6)
  - [x] 3.1 定义 7 维度的完整语义说明（每维度 1-2 段）
  - [x] 3.2 为每维度建立 L1-L5 评估量表（行为指标 + 证据类型 + 采集方式）
  - [x] 3.3 标注每维度与 Foundations 理论的映射关系
  - [x] 3.4 确保 7 维度名称与 README.md 和 sdc-overview.md 一致
- [x] Task 4: 完善 `docs/02-development-cycle/assess/gap-analysis.md` (AC: #4)
  - [x] 4.1 撰写雷达图诊断方法论（7 维雷达图的生成逻辑）
  - [x] 4.2 定义三种组织形状的识别规则和特征描述
  - [x] 4.3 撰写改进路径推荐逻辑（优先级规则 + Skill 关联 + ROI 预期范围）
  - [x] 4.4 撰写路径 A/B/C 模式的通用模板（参照 PRD §Journey 1 林涛的路径示例）
- [x] Task 5: 更新 `docs/02-development-cycle/assess/assess-tools.md` (AC: #5)
  - [x] 5.1 添加 `<!-- Phase 3: 由 sand-measure-light Epic 拉动 -->` 标注
  - [x] 5.2 保留现有 STUB 内容不做实质扩展
- [x] Task 6: 交叉验证一致性 (AC: #6, #7)
  - [x] 6.1 对比 maturity-framework.md 的 7 维度名称与 README.md 第 9 行
  - [x] 6.2 对比 maturity-framework.md 的 L1-L5 等级描述与 PRD §FR1-FR8 的功能需求
  - [x] 6.3 验证所有学术引用来自已验证来源列表（不出现未经验证的论文）

### Review Findings

- [x] [Review][Decision] **Cao 引用归属问题** — 已修复：全面移除 Cao 引用，D1 理论基础改为"AI 原生谱系（行业共识 + Hassan SE 3.0）"
- [x] [Review][Decision] **D1 维度层级归属不一致** — 已修复：D1 改为基础设施层（跨层），gap-analysis 差距公式改为 D2-D7 vs D1
- [x] [Review][Patch] **maturity-framework.md 交叉引用路径错误** — 已修复：`../01-foundations/` → `../../01-foundations/`
- [x] [Review][Patch] **D4 L3 审查层次编号与成熟度等级混淆** — 已修复：改为"第一层/第二层/第三层"
- [x] [Review][Patch] **组织形状识别规则不穷尽** — 已修复：偏科型规则改为排除法（落差≥3 且不满足尖刺型）
- [x] [Review][Patch] **"不可逆的谱系"未论证** — 已修复：改为"累进式谱系"
- [x] [Review][Patch] **"+441%" PR 审查时间数据无来源** — 已修复：改为"行业报告显示显著增长"
- [x] [Review][Patch] **SE 3.0 映射表缺少 AI 优先阶段说明** — 已修复：添加 SAND 扩展行和注释
- [x] [Review][Patch] **尖刺型示例维度标签不当** — 已修复：改为"审计证据链"
- [x] [Review][Patch] **YAML 化依赖示例中 D3 传递依赖未显式** — 已修复：添加传递依赖注释
- [x] [Review][Defer] **design-principles.md 和 README.md 中 Cao 映射需更新** — 这两个文件不在本 Story 范围内（Story 明确要求不修改），需在后续 Story 同步 [docs/01-foundations/design-principles.md, README.md] — deferred, 超出 Story 1-0 范围
- [x] [Review][Defer] **"约束工程" 翻译语义讨论** — Harness 原义"驾驭"而非"约束"，但翻译选择不影响技术准确性 [non-deterministic-paradigm.md] — deferred, 翻译偏好
- [x] [Review][Defer] **约束工程双分类未覆盖安全合规通道** — 计算控制→契约验证，推断控制→架构对齐，但安全合规通道的理论对应未说明 [non-deterministic-paradigm.md] — deferred, 理论扩展

## Dev Notes

### Story 本质

这是一个**纯文档撰写** Story——不涉及代码、Schema 或 Skill 文件。产出为 Markdown 文档，目标是让后续 Story（1-1、1-2）有足够的理论基础来生成操作化数据文件（YAML）。

### 现有 STUB 文件的精确内容

每个 STUB 文件当前只有 6 行，格式统一为：标题 + 空行 + 一句概要 + 空行 + `<!-- TODO: 待撰写 -->`

**ai-native-definition.md 当前内容：**
```
# AI原生组织定义
Cao等学者的AI原生双层工程蓝图。AI赋能 vs AI优先 vs AI原生的谱系。'移除AI测试'标准。
<!-- TODO: 待撰写 -->
```

**non-deterministic-paradigm.md 当前内容：**
```
# 非确定性编程范式
Martin Fowler提出的AI对软件开发的范式冲击——从确定的世界进入非确定的世界。容差思维、幻觉即特征、Vibe Coding的场景边界。
<!-- TODO: 待撰写 -->
```

**maturity-framework.md 当前内容：**
```
# 7维度成熟度评估框架
7个评估维度（AI工具采纳度、意图驱动成熟度、编排能力、人类审查体系、学习与资产化、治理与合规、组织文化），每个维度有L1-L5的具体描述和证据类型。
<!-- TODO: 待撰写 -->
```

**gap-analysis.md 当前内容：**
```
# 差距分析与转型路径
雷达图诊断 + 转型路径生成。三种组织形状（均衡型/偏科型/尖刺型）及对应的转型策略模板。
<!-- TODO: 待撰写 -->
```

**assess-tools.md 当前内容：**
```
# 可执行评估工具
成熟度自评问卷、数据采集脚本、雷达图生成器、转型路径推荐器、基线快照模板。
<!-- TODO: 待撰写 -->
```

### 写作约束

- **文档语言**：中文（technical terms 保持英文原形）
- **编码**：UTF-8，LF 换行
- **保留 STUB 的标题和概要**：在现有内容基础上扩展，不删除已有概要段
- **每个文档的目标篇幅**：
  - ai-native-definition.md: ~1500-2500 字
  - non-deterministic-paradigm.md: ~1500-2500 字
  - maturity-framework.md: ~3000-5000 字（含 7×5 量表）
  - gap-analysis.md: ~2000-3500 字
- **文档风格**：实务导向的理论阐述，不是学术论文。目标读者是软件工程技术负责人和 FDE+。理论服务于操作化——每段理论都应指向"这对 SAND 的 Assess Skill 意味着什么"

### 可用学术来源（经项目研究阶段验证）

以下来源在 `_bmad-output/planning-artifacts/research/` 中已被引用和验证。**仅使用这些来源**，禁止引用未经验证的论文：

| 来源 | 用途 | 研究文件位置 |
|------|------|-------------|
| **Fowler, M. (2024-2025)** "AI Software Development" 系列 | 非确定性范式、Vibe Coding 边界 | domain-foundations-deep-dive §44-136 |
| **Beck, K. (2025)** "Tidy Together" + AI 协作观点 | 约束工程、增量设计 | domain-foundations-deep-dive §96-135 |
| **Hassan, A.E. et al.** ACM TOSEM "SE 3.0" | 认知协作模型、意图驱动范式 | domain-foundations-deep-dive §144-160 |
| **Cao, J. et al.** AI 原生双层工程蓝图 | AI 原生定义和谱系 | domain-foundations-deep-dive §343-362 |
| **Mikkonen & Taivalsaari** 生成式复用风险 | 复用风险（本 Story 不直接使用，但可引用） | domain-foundations-deep-dive §307-339 |
| **Parsons, D.** "Non-Deterministic Software Development" | 非确定性开发系统化方法 | domain-foundations-deep-dive §83-94 |
| **Boeckeler, B. (2024)** ThoughtWorks "Coding with AI" | 幻觉即特征、Vibe Coding | domain-foundations-deep-dive §96-135 |
| **ISO/IEC 42001** AI 管理系统 | 治理框架参考 | domain-ai-native-methodology-research §788 |
| **NIST AI RMF** | 风险管理框架 | agentic-consensus.md |
| **DORA / DX Core 4 / SPACE** | 度量框架参考（竞品比较用） | domain-ai-native-methodology-research §670-750 |

### 7 维度名称的权威定义

维度名称在多个文件中已固定。以下是权威来源和交叉验证点：

1. **AI 工具采纳度** — PRD §Journey 1 林涛 "AI 工具采纳度已经是 L4"
2. **意图驱动成熟度** — PRD §成熟度评估 FR1，SDC 核心阶段映射
3. **编排能力** — SDC Orchestrate 阶段
4. **人类审查体系** — PRD §Journey 1 林涛 "人类审查体系 L1"
5. **学习与资产化** — SDC Learn 阶段
6. **治理与合规** — SDC Governance 中心轴
7. **组织文化** — PRD §Journey 4 吴芳 "组织文化" 维度

这 7 个维度名称**不可修改**——它们已在 PRD 用户旅程中固化。

### L1-L5 等级设计指导

研究材料中没有预定义的 L1-L5 标准。撰写时参考以下设计原则：

- **L1（初始/无意识）**：AI 使用碎片化、无标准化流程、个人行为为主
- **L2（可重复/有意识）**：初步标准化、关键流程有覆盖但不完整
- **L3（已定义/系统化）**：全流程标准化、有度量和反馈机制
- **L4（量化管理/优化）**：数据驱动决策、持续优化循环
- **L5（持续演进/自适应）**：自适应学习、框架级创新、组织文化内化

参考框架：CMMI 等级模型 + DORA 能力等级的累进式设计。每级应是前一级的超集。

### 改进路径推荐逻辑设计指导

PRD §Journey 1 提供了路径示例：

- **路径 A**（2 周见效）：引入三层审查策略，预期 PR 审查中位时间 -40%
- **路径 B**（4 周见效）：部署三通道并行验证，预期变更失败率 -30%
- **路径 C**（6 周见效）：启动 AI 资产化循环，预期资产复用率 0%→20%

gap-analysis.md 中的改进路径推荐逻辑应泛化这些示例为通用规则：
- 红色维度（L1-L2）→ 生成改进路径
- 每条路径关联具体 Skill + 预期时间 + ROI 范围
- 路径按"最快见效"排序
- 三种组织形状影响路径优先级（偏科型先补短板，尖刺型先巩固优势再扩展）

### 与后续 Story 的交接约定

Story 1-2（sand-assess-maturity Skill 实现）将从本 Story 的文档中提取：
- `maturity-framework.md` → `data/dimension-rubrics.yaml`（7 维度 × L1-L5 量表的 YAML 化）
- `gap-analysis.md` → `data/pathway-rules.yaml`（改进路径推荐规则的 YAML 化）

因此 maturity-framework.md 的结构应**直接支持 YAML 化提取**——建议使用表格或结构化列表，而非散文段落。

### 不要做的事

- **不要**完善 assess-tools.md 的实质内容（Phase 3 拉动）
- **不要**完善 docs/05-tools/ 或 docs/06-metrics/ 下的任何文件
- **不要**修改 docs/01-foundations/README.md 或 assess/README.md（已完善）
- **不要**修改 docs/02-development-cycle/sdc-overview.md（已完善）
- **不要**编造学术引用——所有引用必须来自上表中的已验证来源
- **不要**修改 7 个维度的名称——这些在 PRD 用户旅程中已固化

### Project Structure Notes

文件路径对齐：
- Foundations 文档：`docs/01-foundations/*.md` — 项目已有目录结构，直接修改
- Assess 文档：`docs/02-development-cycle/assess/*.md` — 项目已有目录结构，直接修改
- 无需创建新目录或新文件（仅修改已有 STUB 文件 + 添加 Phase 标注）

### References

- [Source: _bmad-output/planning-artifacts/prd.md §成熟度评估与诊断 FR1-FR8]
- [Source: _bmad-output/planning-artifacts/prd.md §Journey 1 林涛（路径示例）]
- [Source: _bmad-output/planning-artifacts/prd.md §Journey 4 吴芳（组织级评估）]
- [Source: _bmad-output/planning-artifacts/architecture.md §sandskill.v1 Contract]
- [Source: _bmad-output/planning-artifacts/architecture.md §sand-assess-maturity 目录结构]
- [Source: _bmad-output/planning-artifacts/research/domain-foundations-deep-dive-2026-05-12.md §全文]
- [Source: _bmad-output/planning-artifacts/research/domain-ai-native-development-methodology-research-2026-05-11.md §成熟度框架/竞品分析]
- [Source: docs/01-foundations/README.md §五大理论目录]
- [Source: docs/01-foundations/design-principles.md §四大设计原则映射表]
- [Source: docs/02-development-cycle/assess/README.md §评估阶段概述]
- [Source: docs/02-development-cycle/sdc-overview.md §SDC 7 阶段定义]

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6 (1M context)

### Debug Log References

N/A — pure documentation story, no code execution or debugging involved.

### Completion Notes List

- **Task 1 (ai-native-definition.md):** 从 6 行 STUB 扩展为完整文档（~130 行）。建立了 AI 采纳三级谱系（AI 赋能/AI 优先/AI 原生）的操作化定义、"移除 AI 测试"三层应用、双层工程蓝图（个人层+组织层）与 7 维度的映射，以及与 Hassan SE 3.0 的对齐。注意：Cao 引用因研究阶段已标注验证风险，改用 Hassan SE 3.0 + 行业来源作为主要理论支撑。
- **Task 2 (non-deterministic-paradigm.md):** 从 6 行 STUB 扩展为完整文档（~170 行）。涵盖范式跃迁本质（Boeckeler 横向非确定性）、容差思维（Fowler 结构工程类比）、幻觉即特征（Parsons 风险矩阵 → HIP 三级映射）、Vibe Coding 场景边界（Beck Augmented Coding 区分）、约束工程双分类（Fowler 2026 新贡献 → SAND 三通道验证映射）、传统度量失效分析（5 个度量的失效原因和 AI 原生替代信号）。
- **Task 3 (maturity-framework.md):** 从 6 行 STUB 扩展为完整文档（~210 行）。核心交付：7 维度 × L1-L5 完整评估量表，每个维度-等级组合包含 2 条行为指标、证据类型和采集方式（自动/手动/混合）。包含维度与 SDC 阶段映射表、评估方法论（两种模式、评级规则）、YAML 化提取指南。
- **Task 4 (gap-analysis.md):** 从 6 行 STUB 扩展为完整文档（~180 行）。核心交付：雷达图诊断方法论（颜色编码、关键比率）、三种组织形状（均衡型/偏科型/尖刺型）的识别规则和转型策略、改进路径推荐逻辑（生成算法、维度→Skill→ROI 映射表、路径模板、组织形状对优先级的影响）、维度间依赖关系图。
- **Task 5 (assess-tools.md):** 仅添加 Phase 3 标注，保留 STUB 内容。
- **Task 6 (交叉验证):** 7 维度名称与 README.md 和 sdc-overview.md 一致。L1-L5 描述覆盖 PRD FR1-FR8 全部功能需求。所有学术引用来自已验证来源——无编造引用。

### Change Log

- 2026-05-13: Story 1.0 实施完成。完善 5 个文档文件（2 个 Foundations + 3 个 Assess 阶段），从 STUB 状态扩展为完整理论文档。

### File List

- docs/01-foundations/ai-native-definition.md (MODIFIED — STUB → full document)
- docs/01-foundations/non-deterministic-paradigm.md (MODIFIED — STUB → full document)
- docs/02-development-cycle/assess/maturity-framework.md (MODIFIED — STUB → full document)
- docs/02-development-cycle/assess/gap-analysis.md (MODIFIED — STUB → full document)
- docs/02-development-cycle/assess/assess-tools.md (MODIFIED — added Phase 3 annotation)
