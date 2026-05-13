# SAND Epics & Stories — 混合拆分策略

**Author:** Leon
**Date:** 2026-05-13
**Strategy:** 每个 Skill Epic 包含 Story 0（理论基础文档完善），不单独设 Docs Epic
**Rationale:** Skill 是 docs 的可执行形态——两者同步完善、同步验收，避免同步漂移

---

## 拆分原则

1. **Story 0 = 理论前置**：每个 Skill Epic 的 Story 0 完善该 SDC 阶段的理论文档（`docs/02-development-cycle/<phase>/`），确保 Skill 的 `data/` 操作化数据与理论定义一致
2. **按需拉动 Foundations**：如果 Story 0 依赖的 `docs/01-foundations/` 文件是 STUB，则在该 Story 0 中一并补强（不预先补全所有 Foundations）
3. **不做的事**：
   - 不单独填充 `docs/05-tools/` 和 `docs/06-metrics/` 的 STUB（等 Phase 3 sand-measure-light 拉动）
   - 不完善 `docs/10-reference/framework-comparison.md`（营销材料，不影响 Skill 开发）
   - 不预设 `docs/09-templates/` 内容（模板随 Skill 同步产出）
4. **Story 0 验收标准统一模式**：Skill 的 `data/` 目录中的操作化数据与 `docs/` 中的理论定义一致且可溯源

---

## Phase 1（0-3 周）：核心 Skills + 框架基础设施

### Epic 1: sand-assess-maturity（成熟度评估 + 框架基础设施）

**目标：** 验证 SAND 可执行方法论的核心假设——"诊断即处方"
**支撑旅程：** 林涛（P0 技术负责人）、吴芳（P1 变革催化师）
**覆盖 FR：** FR1-FR8 + FR41-FR46（部分框架基础设施）
**Phase：** 1（Week 1-2）

#### Story 1-0: 完善 Assess 阶段理论基础

**User Story:**
As a SAND 框架开发者,
I want Assess 阶段的理论文档完整且可操作化,
so that sand-assess-maturity Skill 的评估量表和改进路径有坚实的理论依据。

**当前文档状态：**
- `docs/02-development-cycle/assess/maturity-framework.md` — STUB（仅标题，5 行）
- `docs/02-development-cycle/assess/gap-analysis.md` — STUB（仅标题，5 行）
- `docs/02-development-cycle/assess/assess-tools.md` — STUB（仅标题，4 行）
- `docs/01-foundations/ai-native-definition.md` — STUB（Assess 依赖：定义"AI 原生成熟度"的理论基础）
- `docs/01-foundations/non-deterministic-paradigm.md` — STUB（Assess 依赖：解释传统度量失效的范式基础）

**BDD Acceptance Criteria:**

```gherkin
Scenario: 7 维度成熟度框架完整定义
  Given maturity-framework.md 已完善
  When 开发者读取该文档
  Then 可以找到 7 个维度的完整定义
  And 每个维度包含 L1-L5 五个等级的行为指标和证据标准
  And 每个等级的描述足以支撑结构化对话引导（非问卷式）

Scenario: 差距分析与改进路径理论基础
  Given gap-analysis.md 已完善
  When 开发者需要设计 pathway-rules.yaml
  Then 可以找到差距分析方法论（三种组织形状）
  And 可以找到"红→黄→绿"改进路径的推荐逻辑

Scenario: Foundations 理论支撑 Assess 阶段
  Given ai-native-definition.md 和 non-deterministic-paradigm.md 已补强
  When maturity-framework.md 引用基础理论
  Then 引用链完整（定义 → 理论 → 量表 → 评估标准）

Scenario: 理论与操作化数据一致性
  Given 所有 Assess 文档已完善
  When 后续 Story 1-2 创建 data/dimension-rubrics.yaml
  Then 该 YAML 中的 7 维度名称、L1-L5 标准与 maturity-framework.md 完全一致
  And 该 YAML 中的改进路径规则与 gap-analysis.md 一致
```

**Tasks:**
- [ ] 补强 `docs/01-foundations/ai-native-definition.md`：Hassan SE 3.0 + Cao AI-Native 定义，建立 SAND 对"AI 原生"的操作化定义
- [ ] 补强 `docs/01-foundations/non-deterministic-paradigm.md`：Fowler 非确定性范式，解释为什么传统软件工程度量对 AI 生成代码失效
- [ ] 完善 `docs/02-development-cycle/assess/maturity-framework.md`：7 维度 × L1-L5 完整评估量表（行为指标 + 证据标准 + 采集方法）
- [ ] 完善 `docs/02-development-cycle/assess/gap-analysis.md`：三种组织形状 + 差距分析方法 + 改进路径推荐逻辑
- [ ] 审查 `docs/02-development-cycle/assess/assess-tools.md`：确认 Phase 1 不需要单独完善（assess-tools 的内容将在 Skill 的 step 文件中体现），标记为 Phase 3 拉动

**Dependencies:** 无（第一个 Story）
**Source Hints:** PRD §成熟度评估与诊断 FR1-FR8、Architecture §sandskill.v1 Contract、research/domain-ai-native-development-methodology-research-2026-05-11.md

---

#### Story 1-1: 框架仓库骨架 + sandskill.v1 契约 Schema

**User Story:**
As a SAND Skill 开发者,
I want 一个标准化的仓库结构和 Skill 契约定义,
so that 所有后续 Skill 开发有一致的基础设施和约束。

**BDD Acceptance Criteria:**

```gherkin
Scenario: 仓库目录结构完整
  Given 开发者 git clone sand-framework
  When 查看目录结构
  Then 存在 sand/skills/、schemas/、templates/、docs/、scripts/、examples/ 目录
  And 存在 .sand-version、.gitignore、CHANGELOG.md、LICENSE
  And 存在 CLAUDE.md 和 CURSOR_RULES.md（IDE 适配入口）
  And .claude/skills/ 正确指向 sand/skills/

Scenario: sandskill.v1 契约 Schema 可验证
  Given schemas/sandskill.v1.schema.json 已创建
  When 用 JSON Schema 验证一个合规的 SKILL.md frontmatter
  Then 验证通过
  And 必填字段（sand_contract, name, version, description, sdc_phase, entry_point, requires, inputs, outputs）全部校验
  And 可选字段（sand_min_version, model_requirement, human_oversight 等）允许缺省

Scenario: SandAuditEvent 基础设施就绪
  Given schemas/audit-event.schema.json 已创建
  When Phase 1 Skill 执行时
  Then 可以按 schema 格式向 .sand/audits/audit.jsonl 追加审计事件
  And 事件包含 event_id, timestamp, intent_id, skill_name, skill_version, status 等必填字段

Scenario: 核心模板集可用
  Given templates/ 目录已创建
  When Skill 需要初始化 YAML 工件
  Then 存在 intent-statement.yaml、execution-contract.yaml、maturity-assessment.yaml 模板
  And 模板符合对应的 JSON Schema 结构
```

**Tasks:**
- [ ] 创建完整仓库目录结构（参照 Architecture §Project Structure）
- [ ] 编写 `schemas/sandskill.v1.schema.json`（必填/可选字段、字段顺序约束）
- [ ] 编写 `schemas/audit-event.schema.json`（SandAuditEvent 完整定义）
- [ ] 编写核心 JSON Schema 集（intent-statement、execution-contract、maturity-assessment、orchestration-plan）
- [ ] 创建 YAML 模板集（templates/ 下所有初始模板）
- [ ] 编写 CLAUDE.md（Claude Code Agent 入口配置）
- [ ] 编写 CURSOR_RULES.md（Cursor Agent 入口配置）
- [ ] 配置 .gitignore（含 .sand/ 排除）
- [ ] 创建 .sand-version（`0.1.0`）
- [ ] 创建 CHANGELOG.md 初始版本

**Dependencies:** Story 1-0（理论文档为 Schema 设计提供语义基础）
**Source Hints:** Architecture §Core Architectural Decisions（D1-D5）、§Implementation Patterns、§Project Structure

---

#### Story 1-2: 实现 sand-assess-maturity Skill

**User Story:**
As a 技术负责人（林涛角色）,
I want 通过结构化对话完成 7 维度成熟度评估并获得可执行改进路径,
so that 我可以向 CTO 展示具体的 AI 转型行动方案和预期 ROI。

**BDD Acceptance Criteria:**

```gherkin
Scenario: Skill 契约合规
  Given sand-assess-maturity/SKILL.md 已创建
  When 用 sandskill.v1.schema.json 验证 frontmatter
  Then 验证通过
  And sdc_phase = "assess"
  And requires 包含 file_read, file_write

Scenario: 评估范围选择
  Given 用户启动 sand-assess-maturity
  When Skill 进入 step-01-scope
  Then 引导用户选择评估范围（团队级 / 组织级）
  And 收集团队基本信息（team_id、规模、AI 工具使用时长）

Scenario: 7 维度结构化对话
  Given 评估范围已确认
  When Skill 进入 step-02-dialogue
  Then 按 7 个维度依次引导结构化对话
  And 每个维度的对话基于 data/dimension-rubrics.yaml 中的 L1-L5 行为指标
  And 对话风格为引导式问答，而非传统问卷

Scenario: 雷达图生成
  Given 7 维度对话完成
  When Skill 进入 step-04-radar
  Then 生成 7 维雷达图 JSON 数据
  And 每个维度标注 L1-L5 等级
  And 输出持久化到 .sand/assessments/{timestamp}_{team_id}.yaml

Scenario: 改进路径推荐
  Given 雷达图已生成
  When 存在红色（L1-L2）维度
  Then 基于 data/pathway-rules.yaml 生成 ≥1 条可执行改进路径
  And 每条路径关联具体的 SAND Skill + 预期 ROI + 所需时间投入

Scenario: 审计事件记录
  Given Skill 执行完成（成功或失败）
  When 检查 .sand/audits/audit.jsonl
  Then 存在该次执行的审计事件
  And 包含 skill_name="sand-assess-maturity"、status、input_hash、output_hash
```

**Tasks:**
- [ ] 创建 `sand/skills/sand-assess-maturity/SKILL.md`（sandskill.v1 frontmatter + 激活入口）
- [ ] 创建 `customize.toml`（默认配置）
- [ ] 创建 `data/dimension-rubrics.yaml`（从 maturity-framework.md 操作化，7 维度 × L1-L5）
- [ ] 创建 `data/pathway-rules.yaml`（从 gap-analysis.md 操作化，改进路径推荐规则）
- [ ] 创建 `templates/maturity-assessment.yaml`
- [ ] 编写 `steps/step-01-scope.md`（评估范围确认）
- [ ] 编写 `steps/step-02-dialogue.md`（7 维度结构化对话）
- [ ] 编写 `steps/step-03-data-collect.md`（Git/CI 数据自动采集辅助）
- [ ] 编写 `steps/step-04-radar.md`（雷达图生成 + 评级）
- [ ] 编写 `steps/step-05-pathways.md`（可执行改进路径推荐）
- [ ] 验证 data/ 与 docs/ 的一致性（Story 0 验收标准交叉检查）

**Dependencies:** Story 1-0（理论文档）、Story 1-1（仓库骨架 + Schema）
**Source Hints:** PRD §Journey 1 林涛、§FR1-FR8、Architecture §sand-assess-maturity 目录结构

---

### Epic 2: sand-create-intent（意图管理）

**目标：** 验证 SAND "意图驱动协作"假设——从提示词工程到认知协作的范式转变
**支撑旅程：** 陈雨（P0 FDE+）
**覆盖 FR：** FR9-FR14
**Phase：** 1（Week 2-3）

#### Story 2-0: 完善 Intent 阶段理论基础

**User Story:**
As a SAND 框架开发者,
I want Intent 阶段的理论文档完整且可操作化,
so that sand-create-intent Skill 的意图字段标准、CLEAR 检查清单和执行契约结构有坚实的理论依据。

**当前文档状态：**
- `docs/02-development-cycle/intent/intent-statement.md` — STUB（仅列出 7 字段名，无详细定义）
- `docs/02-development-cycle/intent/clear-checklist.md` — STUB（仅列出 CLEAR 5 维名称）
- `docs/02-development-cycle/intent/execution-contract.md` — STUB（仅提及三级结构名称）
- `docs/02-development-cycle/intent/intent-lifecycle.md` — STUB
- `docs/02-development-cycle/intent/intent-taxonomy.md` — STUB
- `docs/02-development-cycle/intent/decomposition-patterns.md` — STUB
- `docs/01-foundations/cognitive-collaboration.md` — STUB（Intent 依赖：认知协作理论基础）

**BDD Acceptance Criteria:**

```gherkin
Scenario: 意图声明 7 字段标准完整定义
  Given intent-statement.md 已完善
  When 开发者读取该文档
  Then 可以找到 7 个字段（purpose, desired_outcome, acceptance_criteria, constraints, context_references, meta, intent_type）的完整定义
  And 每个字段包含：语义说明、格式要求、示例、常见错误

Scenario: CLEAR 质量检查清单可操作化
  Given clear-checklist.md 已完善
  When 开发者需要设计 data/clear-checklist.yaml
  Then 可以找到 5 个维度（Complete/Lean/Executable/Assessable/Reversible）的具体检查项
  And 每个检查项有明确的通过/不通过判定标准
  And 检查项可被 AI 自动化执行

Scenario: 执行契约三级结构定义
  Given execution-contract.md 已完善
  When 开发者需要实现契约生成逻辑
  Then 可以找到 must_pass/should_pass/must_not_violate 三级结构的完整定义
  And 每级包含典型条目示例和从意图声明的映射规则

Scenario: 认知协作理论支撑 Intent 阶段
  Given cognitive-collaboration.md 已补强
  When intent-statement.md 引用基础理论
  Then "意图驱动 vs 提示词工程"的理论区分有学术支撑
  And SDD（Specification-Driven Development）理论被正确引用

Scenario: 理论与操作化数据一致性
  Given 所有 Intent 文档已完善
  When 后续 Story 2-1 创建 data/clear-checklist.yaml
  Then 该 YAML 中的检查项与 clear-checklist.md 完全一致
  And intent-statement.yaml 模板的字段与 intent-statement.md 完全一致
```

**Tasks:**
- [ ] 补强 `docs/01-foundations/cognitive-collaboration.md`：SDD 意图驱动理论 + 认知协作 vs 工具使用的范式区分
- [ ] 完善 `docs/02-development-cycle/intent/intent-statement.md`：7 字段详细定义（语义 + 格式 + 示例 + 反模式）
- [ ] 完善 `docs/02-development-cycle/intent/clear-checklist.md`：CLEAR 5 维 × 具体检查项 + 自动化检查逻辑
- [ ] 完善 `docs/02-development-cycle/intent/execution-contract.md`：三级结构定义 + 映射规则
- [ ] 完善 `docs/02-development-cycle/intent/intent-lifecycle.md`：Draft → Reviewed → Approved → In Execution → Validated → Archived 状态机
- [ ] 完善 `docs/02-development-cycle/intent/intent-taxonomy.md`：Feature/Fix/Refactor/Exploration/Optimization 分类及特征
- [ ] 完善 `docs/02-development-cycle/intent/decomposition-patterns.md`：意图分解模式（何时拆分、如何拆分）

**Dependencies:** 无（可与 Epic 1 并行，但建议在 Story 1-0 后启动以建立一致的文档标准）
**Source Hints:** PRD §意图管理 FR9-FR14、§Journey 2 陈雨、research/domain-foundations-deep-dive-2026-05-12.md

---

#### Story 2-1: 实现 sand-create-intent Skill

**User Story:**
As a FDE+（陈雨角色）,
I want 通过结构化对话创建高质量的意图声明并自动生成执行契约,
so that AI 可以基于明确的契约进行认知协作而非被动执行。

**BDD Acceptance Criteria:**

```gherkin
Scenario: 意图声明引导式创建
  Given 用户启动 sand-create-intent
  When Skill 引导用户填写 7 个字段
  Then 通过结构化对话逐步完善意图声明
  And 不要求用户预先了解字段格式
  And 输出符合 schemas/intent-statement.schema.json 的 YAML 文件

Scenario: CLEAR 自动质量检查
  Given 意图声明草案已完成
  When Skill 运行 CLEAR 检查（step-03）
  Then 5 个维度逐项检查并给出 ✓/⚠️/✗ 标记
  And ⚠️ 和 ✗ 项提供具体修改建议
  And 检查项基于 data/clear-checklist.yaml

Scenario: 执行契约自动生成
  Given CLEAR 检查通过
  When Skill 进入 step-04-contract
  Then 自动从意图声明生成执行契约
  And 契约包含 must_pass/should_pass/must_not_violate 三级条目
  And 输出到 .sand/intents/contracts/{intent_id}.contract.yaml

Scenario: 意图生命周期管理
  Given 意图声明已创建
  When 查看 .sand/intents/{intent_id}.yaml
  Then 状态为 "Draft"
  And frontmatter 包含 intent_id、创建时间、意图类型
```

**Tasks:**
- [ ] 创建 `sand/skills/sand-create-intent/SKILL.md`（sandskill.v1 frontmatter）
- [ ] 创建 `customize.toml`
- [ ] 创建 `data/clear-checklist.yaml`（从 clear-checklist.md 操作化）
- [ ] 编写 `steps/step-01-scope.md`（需求收集 + 意图边界）
- [ ] 编写 `steps/step-02-draft.md`（7 字段意图声明草案引导）
- [ ] 编写 `steps/step-03-clear-check.md`（CLEAR 5 维自动检查）
- [ ] 编写 `steps/step-04-contract.md`（执行契约生成）
- [ ] 创建 `templates/intent-statement.yaml`（如未在 Story 1-1 中创建）
- [ ] 创建 `templates/execution-contract.yaml`（如未在 Story 1-1 中创建）
- [ ] 验证 data/ 与 docs/ 的一致性

**Dependencies:** Story 2-0（Intent 理论文档）、Story 1-1（仓库骨架 + Schema）
**Source Hints:** PRD §Journey 2 陈雨、§FR9-FR14、Architecture §sand-create-intent 目录结构

---

### Epic 3: sand-validate-delivery（交付验证）

**目标：** 完成 Phase 1 的核心 SDC 循环——验证通道确保交付质量
**支撑旅程：** 陈雨（P0 SDC 循环完整性）、吴芳（P1 最小切口实验）
**覆盖 FR：** FR23-FR27b
**Phase：** 1（Week 3）

#### Story 3-0: 完善 Validate 阶段理论基础

**User Story:**
As a SAND 框架开发者,
I want Validate 阶段的理论文档完整且可操作化,
so that sand-validate-delivery Skill 的三通道验证和决策矩阵有坚实的理论依据。

**当前文档状态：**（需确认，预计为 STUB）
- `docs/02-development-cycle/validate/three-channel.md`
- `docs/02-development-cycle/validate/decision-matrix.md`
- `docs/02-development-cycle/validate/deviation-tracking.md`
- `docs/02-development-cycle/validate/validation-assets.md`
- `docs/01-foundations/generative-reuse-risk.md` — STUB（Validate 依赖：生成式复用风险理论）

**BDD Acceptance Criteria:**

```gherkin
Scenario: 三通道验证定义完整
  Given three-channel.md 已完善
  When 开发者设计验证 step 文件
  Then 可以找到三通道（契约验证、安全合规、架构对齐）的完整定义
  And 每通道包含检查项列表和判定标准

Scenario: 决策矩阵可操作化
  Given decision-matrix.md 已完善
  When 开发者实现 step-04-decision
  Then 可以找到四种决策结果（通过/有条件通过/打回 Build/重定向 Intent）的判定逻辑
  And 决策边界明确无歧义

Scenario: 生成式复用风险理论支撑
  Given generative-reuse-risk.md 已补强
  When Validate 阶段引用基础理论
  Then "为什么需要三通道而非单一代码审查"有理论支撑（Mikkonen 论文）

Scenario: 理论与操作化数据一致性
  Given 所有 Validate 文档已完善
  When 后续 Story 3-1 创建验证 step 文件
  Then 三通道检查项与 three-channel.md 一致
  And 决策矩阵与 decision-matrix.md 一致
```

**Tasks:**
- [ ] 补强 `docs/01-foundations/generative-reuse-risk.md`：Mikkonen 生成式复用风险理论
- [ ] 完善 `docs/02-development-cycle/validate/three-channel.md`：三通道定义 + 检查项
- [ ] 完善 `docs/02-development-cycle/validate/decision-matrix.md`：四种决策判定逻辑
- [ ] 完善 `docs/02-development-cycle/validate/deviation-tracking.md`：偏差事件记录规范
- [ ] 审查 `docs/02-development-cycle/validate/validation-assets.md`：评估 Phase 1 是否需要

**Dependencies:** 无
**Source Hints:** PRD §交付验证 FR23-FR27b、§意图偏差追踪

---

#### Story 3-1: 实现 sand-validate-delivery Skill

**User Story:**
As a FDE+,
I want 对交付物运行三通道并行验证获得结构化验证决策,
so that AI 生成的代码在合并前有系统性的质量保障。

**BDD Acceptance Criteria:**

```gherkin
Scenario: 契约验证通道
  Given 存在已生成的交付物和执行契约
  When Skill 运行 step-01-contract-check
  Then 逐条检查 must_pass/should_pass/must_not_violate
  And 输出每条的通过/未通过状态

Scenario: 安全合规通道
  Given 交付物已提交验证
  When Skill 运行 step-02-security
  Then 检查常见安全风险（注入、XSS、敏感数据泄露等）
  And 包含非阻塞许可证警告提示（FR25）

Scenario: 架构对齐通道
  Given 交付物已提交验证
  When Skill 运行 step-03-architecture
  Then 检查交付物是否符合架构约束
  And 检查命名规范、目录结构、依赖关系等

Scenario: 验证决策输出
  Given 三通道验证完成
  When Skill 进入 step-04-decision
  Then 基于决策矩阵生成结构化决策（通过/有条件通过/打回/重定向）
  And 输出验证报告到 .sand/executions/ 下

Scenario: 偏差记录
  Given 验证结果与意图声明存在偏差
  When 检查 .sand/executions/{session_id}/deviations.json
  Then 偏差事件已记录（偏差类型、严重程度、关联验收条款、建议修正动作）
```

**Tasks:**
- [ ] 创建 `sand/skills/sand-validate-delivery/SKILL.md`
- [ ] 创建 `customize.toml`
- [ ] 编写 `steps/step-01-contract-check.md`（契约验证通道）
- [ ] 编写 `steps/step-02-security.md`（安全合规通道）
- [ ] 编写 `steps/step-03-architecture.md`（架构对齐通道）
- [ ] 编写 `steps/step-04-decision.md`（验证决策矩阵）
- [ ] 创建 `templates/validation-report.yaml`

**Dependencies:** Story 3-0（Validate 理论文档）、Story 1-1（仓库骨架）
**Source Hints:** PRD §交付验证 FR23-FR27b、Architecture §sand-validate-delivery 目录结构

---

## Phase 2（3-6 周）：编排 + 治理 + 插件 + 回顾基础

### Epic 4: sand-design-orchestration + 执行引擎（编排与插件生态）

**目标：** 完成编排设计能力——让 SDC 循环可以串联多个 Skill
**支撑旅程：** 全旅程（编排核心）、刘洋（贡献者生态前置）
**覆盖 FR：** FR15a-d、FR16-FR22
**Phase：** 2（Week 4-5）

#### Story 4-0: 完善 Orchestrate 阶段理论基础

**User Story:**
As a SAND 框架开发者,
I want Orchestrate 阶段的理论文档完整,
so that 编排拓扑选型、HIP 机制和上下文工程有理论支撑。

**当前文档状态：**（需确认）
- `docs/02-development-cycle/orchestrate/topology-patterns.md`
- `docs/02-development-cycle/orchestrate/agent-selection.md`
- `docs/02-development-cycle/orchestrate/human-intervention.md`
- `docs/02-development-cycle/orchestrate/context-engineering.md`
- `docs/02-development-cycle/orchestrate/failure-modes.md`

**BDD Acceptance Criteria:**

```gherkin
Scenario: 拓扑模式理论完整
  Given topology-patterns.md 已完善
  When 开发者设计 data/topology-rules.yaml
  Then 4 种拓扑（Solo/Pipeline/Swarm/Hierarchy）有完整的适用条件和权衡分析

Scenario: HIP 机制定义完整
  Given human-intervention.md 已完善
  When 开发者实现 HIP 配置逻辑
  Then HIP-1/2/3 的含义、适用场景和决策链完整定义

Scenario: 上下文工程与 FR32 一致
  Given context-engineering.md 已完善
  When 开发者实现上下文安全机制
  Then 上下文最小化原则与 FR32 要求一致
```

**Tasks:**
- [ ] 完善 Orchestrate 阶段 5 个文档（topology-patterns, agent-selection, human-intervention, context-engineering, failure-modes）
- [ ] 确保 HIP 理论与 Architecture §HIP Level Decision Chain 一致

**Dependencies:** Epic 1 完成（框架基础设施就绪）

---

#### Story 4-1: 实现 sand-design-orchestration Skill

**User Story:**
As a FDE+,
I want 通过引导式工作流设计编排方案（拓扑 + HIP + 外部 Skill 引入）,
so that 复杂任务可以按最优策略分解和执行。

**BDD Acceptance Criteria:**

```gherkin
Scenario: 拓扑选型引导
  Given 用户启动 sand-design-orchestration
  When 提供意图范围和依赖信息
  Then Skill 基于规则推荐最适拓扑
  And 用户可确认或修改

Scenario: HIP 级别配置
  Given 拓扑已选定
  When Skill 进入 HIP 配置步骤
  Then 显示角色推荐值 + 项目默认值
  And 用户可覆盖

Scenario: 插件 Skill 注册
  Given .sand/plugins/registry.yaml 存在
  When 编排方案需要外部 Skill
  Then 可引入已验证的外部 Skill
  And 未验证的 Skill 不可被选择

Scenario: 编排方案输出
  Given 编排设计完成
  When 查看 .sand/orchestration-plan.yaml
  Then 包含拓扑类型、Skill 链、HIP 级别、输入/输出映射
```

**Dependencies:** Story 4-0
**Source Hints:** PRD §编排与插件 FR16-FR22、Architecture §Agent Roles & Orchestration Topology

---

#### Story 4-2: sand-run 执行引擎（SandRuntime 基础版）

**User Story:**
As a FDE+,
I want 按编排方案自动串联执行多个 Skill,
so that 完整的 SDC 循环无需手动切换 Skill。

**BDD Acceptance Criteria:**

```gherkin
Scenario: 编排方案加载
  Given .sand/orchestration-plan.yaml 存在
  When 用户启动 sand-run
  Then 加载编排方案和关联的意图声明

Scenario: 单链 Skill 执行
  Given 编排方案为 Pipeline 拓扑（A → B → C）
  When sand-run 执行
  Then 按顺序调用 Skill，前一个输出链接为后一个输入
  And 每步完成后记录到 .sand/executions/{session_id}/execution.yaml

Scenario: 断点续传
  Given 执行中断（用户中断或宿主崩溃）
  When 重新启动 sand-run
  Then 从最后完成的步骤恢复
  And 已完成步骤不重复执行

Scenario: 审计事件自动记录
  Given Skill 链执行过程中
  When 每个步骤完成
  Then SandRuntime 自动追加审计事件到 .sand/audits/audit.jsonl
  And Skill 开发者无需手动记录
```

**Dependencies:** Story 4-1、Story 1-1（Schema 基础）
**Source Hints:** Architecture §Execution Runtime Model（D6-D8）

---

#### Story 4-3: 插件基础验证机制 + 贡献者工具链

**User Story:**
As a 外部 Skill 贡献者（刘洋角色）,
I want 标准化的开发工具和验证机制,
so that 我可以开发符合 sandskill.v1 契约的 Skill 并提交验证。

**BDD Acceptance Criteria:**

```gherkin
Scenario: Skill 骨架生成
  Given scripts/sand-skill-init.sh 存在
  When 运行 sand-skill-init sand-my-custom-skill
  Then 生成符合 sandskill.v1 契约的完整 Skill 目录骨架

Scenario: Skill 契约验证
  Given scripts/sand-skill-validate.sh 存在
  When 对一个 Skill 目录运行验证
  Then 检查 SKILL.md frontmatter 字段完整性和顺序
  And 检查 requires 声明有效性
  And 检查 steps/ 文件命名规范

Scenario: 示例外部 Skill
  Given examples/external-skills/sand-example-skill/ 存在
  When 查看该示例
  Then 包含完整可运行的 Skill + README（步骤说明 + 使用方式）

Scenario: 开发者文档
  Given docs/skill-dev-guide.md 存在
  When 外部贡献者阅读该文档
  Then 可以理解 Skill 目录结构、契约字段、验证要求和提交流程
  And 文档不超过 2000 字
  And 全程不提及 BMad
```

**Dependencies:** Story 1-1（sandskill.v1 Schema）
**Source Hints:** PRD §Skill Development Guide、Architecture §贡献者体验三件套

---

### Epic 5: sand-governance-audit（治理与审计）

**目标：** 让审计证据链可查询、可导出、可向外部审计师展示
**支撑旅程：** 赵明（P1 架构师/合规）
**覆盖 FR：** FR28-FR31
**Phase：** 2（Week 5-6）

#### Story 5-0: 完善 Governance 阶段理论基础

**User Story:**
As a SAND 框架开发者,
I want Governance 阶段的理论文档完整,
so that sand-governance-audit Skill 的证据链构建和报告格式有理论依据。

**当前文档状态：**
- `docs/02-development-cycle/governance/audit-governance.md`
- `docs/02-development-cycle/governance/compliance-governance.md`
- `docs/02-development-cycle/governance/decision-governance.md`
- `docs/02-development-cycle/governance/quality-governance.md`
- `docs/01-foundations/agentic-consensus.md` — ~70% 完成（Governance 主要理论依赖）

**BDD Acceptance Criteria:**

```gherkin
Scenario: 审计治理理论完整
  Given audit-governance.md 已完善
  When 开发者设计审计追踪报告模板
  Then 可以找到意图→Skill→决策证据链的完整定义
  And 报告结构满足模拟 SOC2 检查需求

Scenario: Agentic AI 治理理论补全
  Given agentic-consensus.md 已完善至 100%
  When Governance 文档引用基础理论
  Then ISO 42001 映射、EU AI Act 相关引用完整
```

**Tasks:**
- [ ] 补全 `docs/01-foundations/agentic-consensus.md` 剩余 TODO
- [ ] 完善 Governance 阶段 4 个文档

**Dependencies:** Epic 1 完成

---

#### Story 5-1: 实现 sand-governance-audit Skill

**User Story:**
As a 架构师（赵明角色）,
I want 自动生成审计追踪报告展示 AI 决策的完整证据链,
so that 我可以向外部审计师证明 AI 决策的合理性和可追溯性。

**BDD Acceptance Criteria:**

```gherkin
Scenario: 审计事件扫描
  Given .sand/audits/audit.jsonl 中存在审计事件
  When 运行 sand-governance-audit
  Then 扫描指定时间范围内的所有审计事件

Scenario: 证据链构建
  Given 审计事件已扫描
  When 构建意图→Skill→决策证据链
  Then 每个意图 ID 可追溯到执行的 Skill 版本和人工确认点
  And 证据链无断裂

Scenario: 审计报告生成
  Given 证据链已构建
  When 生成审计追踪报告
  Then 报告包含：Intent ID、意图声明摘要、执行契约版本、Skill 调用链、人工确认点、验证结果
  And 报告可导出为 JSON/CSV 格式

Scenario: 赵明旅程验证
  Given 报告已生成
  When 模拟 SOC2 检查场景
  Then 审计师可从报告中回答"AI 为什么做了这个决策"
```

**Dependencies:** Story 5-0、Story 4-2（sand-run 产生的审计数据）
**Source Hints:** PRD §Journey 3 赵明、§FR28-FR31

---

### Epic 6: sand-run-retrospective（学习与资产化）

**目标：** 建立 AI 复盘和资产化闭环
**支撑旅程：** 全旅程（飞轮加速）
**覆盖 FR：** FR38-FR40
**Phase：** 2-3

#### Story 6-0: 完善 Learn 阶段理论基础

**User Story:**
As a SAND 框架开发者,
I want Learn 阶段的理论文档完整,
so that 复盘引导和资产化分类有理论支撑。

**当前文档状态：**（需确认）
- `docs/02-development-cycle/learn/ai-retrospective.md`
- `docs/02-development-cycle/learn/ai-asset-taxonomy.md`
- `docs/02-development-cycle/learn/assetization-process.md`
- `docs/02-development-cycle/learn/asset-lifecycle.md`
- `docs/02-development-cycle/learn/flywheel-metrics.md`

**BDD Acceptance Criteria:**

```gherkin
Scenario: AI 复盘 5 议题完整定义
  Given ai-retrospective.md 已完善
  Then 5 个标准议题有完整定义和引导脚本

Scenario: 5 类 AI 资产分类可操作化
  Given ai-asset-taxonomy.md 已完善
  Then 5 类资产（上下文资产、意图模式、编排配方、验证规则、失败案例）有完整分类标准
```

**Dependencies:** 无
**Source Hints:** PRD §学习与资产化 FR38-FR40

---

#### Story 6-1: 实现 sand-run-retrospective 基础版（Phase 2）

**User Story:**
As a FDE+,
I want 通过引导式工作流完成 AI 复盘并输出结构化日志,
so that 每次 SDC 循环的经验可被捕获。

**BDD Acceptance Criteria:**

```gherkin
Scenario: 5 议题结构化引导
  Given 用户启动 sand-run-retrospective
  Then 按 5 个标准议题引导复盘对话
  And 输出结构化日志到 .sand/retrospectives/{date}_retro.md

Scenario: 基础版范围限制
  Given Phase 2 基础版
  Then 仅实现数据收集和结构化日志输出
  And 不包含分析报告生成和资产化入库建议（Phase 3）
```

**Dependencies:** Story 6-0
**Source Hints:** PRD §Phase 2 范围微调

---

#### Story 6-2: 实现 sand-run-retrospective 完整版（Phase 3）

**User Story:**
As a 技术负责人,
I want 复盘结果自动生成资产化入库建议,
so that 团队的 AI 协作经验可以系统性地积累和复用。

**BDD Acceptance Criteria:**

```gherkin
Scenario: 分析报告生成
  Given 结构化复盘日志存在
  When Skill 运行分析步骤
  Then 生成复盘分析报告（趋势、模式、改进建议）

Scenario: 资产化入库建议
  Given 分析报告已生成
  When Skill 运行资产分类步骤
  Then 生成 5 类 AI 资产的入库建议
  And 每条建议包含资产类型、来源、建议的存储位置

Scenario: 飞轮指标追踪
  Given 多次复盘数据积累
  Then 可追踪飞轮加速指标（资产复用率、意图首通率、循环周期压缩率）
```

**Dependencies:** Story 6-1
**Source Hints:** PRD §FR38-FR40

---

## Phase 3（6-8 周）：Agent 角色 + 度量 + 生态完善

### Epic 7: Agent 角色 + 度量 + 框架完善

**目标：** 完成 MVP 全部交付物——Agent 角色入口、轻量度量、Skill 间自动发现
**支撑旅程：** 全旅程（角色入口）、吴芳（度量驱动认知失调报告）
**覆盖 FR：** FR34-FR37、FR47-FR48
**Phase：** 3（Week 7-8）

#### Story 7-0: 完善 Operate 阶段理论基础（度量相关）

**User Story:**
As a SAND 框架开发者,
I want Operate 阶段中与度量采集相关的理论文档完整,
so that sand-measure-light Skill 的 5 个信号选择有理论依据。

**当前文档状态：**（需确认）
- `docs/02-development-cycle/operate/signal-collection.md`
- `docs/02-development-cycle/operate/ops-automation-levels.md`
- `docs/06-metrics/` 下的文件（在此 Epic 中按需拉动，不预先完善全部）

**BDD Acceptance Criteria:**

```gherkin
Scenario: 信号采集理论定义
  Given signal-collection.md 已完善
  Then 5 个轻量信号（PR 周期时间、事故标签、AI 参与度、变更失败率、部署频率）有选择依据
  And 每个信号有采集方法和数据源说明

Scenario: 按需拉动 Metrics 文档
  Given docs/06-metrics/ 存在多个 STUB
  Then 仅完善 sand-measure-light 直接需要的度量定义
  And 不预先完善全部 06-metrics/ STUB
```

**Dependencies:** 无
**Source Hints:** PRD §度量与洞察 FR34-FR37、Architecture §ADR-007

---

#### Story 7-1: 实现 sand-measure-light Skill

**User Story:**
As a 变革催化师（吴芳角色）,
I want 从 Git/PR/CI 自动采集轻量度量信号并生成认知失调报告,
so that 我可以用数据制造认知失调推动团队渐进改变。

**BDD Acceptance Criteria:**

```gherkin
Scenario: Git 度量自动采集
  Given 当前目录是 Git 仓库
  When 运行 sand-measure-light
  Then 自动采集 PR 周期时间、AI 参与度等 Git 相关信号
  And 输出到 .sand/metrics/{date}_metrics.json

Scenario: CI 度量采集（含 Fallback）
  Given CI API 可访问
  When 运行度量采集
  Then 自动获取变更失败率、部署频率等 CI 信号
  And 如果 CI API 不可访问，接受手动 CSV 导入

Scenario: 认知失调报告
  Given 度量数据已采集
  When 生成报告
  Then 包含正向指标、负向指标、变化趋势分析、推荐下一步行动
```

**Dependencies:** Story 7-0
**Source Hints:** PRD §Journey 4 吴芳 §FR34-FR37、Architecture §sand-measure-light

---

#### Story 7-2: 实现 Agent 角色 Skills（3 个角色）

**User Story:**
As a SAND 用户,
I want 根据我的角色（技术负责人/FDE+/变革催化师）获得定制化的工作流入口引导,
so that 我不需要了解全部 Skills 就能开始使用 SAND。

**BDD Acceptance Criteria:**

```gherkin
Scenario: sand-agent-domain-lead
  Given 用户以技术负责人身份启动
  When 描述需求
  Then 引导到 assess → governance → orchestration 工作流

Scenario: sand-agent-fde
  Given 用户以 FDE+ 身份启动
  When 描述需求
  Then 引导到 intent → run → validate 工作流

Scenario: sand-agent-catalyst
  Given 用户以变革催化师身份启动
  When 描述需求
  Then 引导到 assess(组织级) → measure → retrospective 工作流

Scenario: 角色行为（MVP 限制）
  Given MVP 阶段
  Then 角色 Skill 通过对话引导建议下一步
  And 不自动跨 Skill 调用（Phase 4 升级）
```

**Dependencies:** 所有核心 Skill Epic 完成（Epic 1-5）
**Source Hints:** PRD §FR48、Architecture §Agent Roles

---

#### Story 7-3: Skill 间自动文件发现 + 组织级文档

**User Story:**
As a SAND 框架维护者,
I want Skill 间可自动发现和链接工件文件,
so that SDC 循环中各 Skill 的输出无缝流转。

**BDD Acceptance Criteria:**

```gherkin
Scenario: 自动文件发现
  Given Skill A 输出到 .sand/ 标准目录
  When Skill B 需要该输出作为输入
  Then 通过 glob 模式自动发现文件
  And 替代 Phase 2 的约定路径手动传递

Scenario: 组织级定制化指南
  Given docs/ 中存在 customize.toml 定制化说明
  Then 3 层 TOML merge（base → team → user）有完整文档
  And 包含典型定制化场景示例
```

**Dependencies:** 核心 Skill 开发完成
**Source Hints:** Architecture §数据所有权边界、PRD §FR47

---

## Cross-Cutting Notes

### 不在 Epic 范围内的工作

| 文档/目录 | 状态 | 拉动时机 |
|-----------|------|---------|
| `docs/05-tools/` | 多个 STUB | Phase 3 sand-measure-light Epic 拉动 |
| `docs/06-metrics/` | 多个 STUB | Phase 3 sand-measure-light Epic 按需拉动 |
| `docs/09-templates/` | 空 | 模板随 Skill 同步产出，不预设 |
| `docs/10-reference/framework-comparison.md` | 存在但为营销材料 | Post-MVP |
| `docs/03-organization-model/` | 需确认 | Phase 3 Agent 角色 Epic 按需引用 |
| `docs/07-adoption/` | 需确认 | Post-MVP（培训课程、变革路线图） |
| `docs/08-relationships/` | 需确认 | Post-MVP |
| `docs/04-artifacts/` | 需确认 | 随 Schema/Template 开发同步校验 |

### Foundations 补强计划

| 文件 | 当前状态 | 拉动 Epic |
|------|---------|----------|
| `ai-native-definition.md` | STUB | Epic 1 Story 1-0 |
| `non-deterministic-paradigm.md` | STUB | Epic 1 Story 1-0 |
| `cognitive-collaboration.md` | STUB | Epic 2 Story 2-0 |
| `generative-reuse-risk.md` | STUB | Epic 3 Story 3-0 |
| `agentic-consensus.md` | ~70% | Epic 5 Story 5-0 |
| `design-principles.md` | ~60% | 不单独拉动，随相关 Epic 校验 |

### Phase-Epic 映射

| Phase | 周次 | Epics |
|-------|------|-------|
| Phase 1 | 0-3 | Epic 1（assess + 基础设施）、Epic 2（intent）、Epic 3（validate） |
| Phase 2 | 3-6 | Epic 4（orchestration + 执行引擎 + 插件）、Epic 5（governance）、Epic 6 Story 6-1（retrospective 基础版） |
| Phase 3 | 6-8 | Epic 6 Story 6-2（retrospective 完整版）、Epic 7（Agent 角色 + 度量 + 生态完善） |
