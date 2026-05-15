# Story 7.0: 完善 Operate 阶段理论基础（度量相关）

Status: done

## Story

As a SAND 框架开发者,
I want Operate 阶段中与度量采集相关的理论文档完整,
so that sand-measure-light Skill 的 5 个信号选择有理论依据。

## Acceptance Criteria

1. **信号采集理论定义** — 给定 `signal-collection.md` 已完善，当开发者读取该文档时，可以找到 5 个轻量信号（PR 周期时间、事故标签、AI 参与度、变更失败率、部署频率）的选择依据，且每个信号有采集方法和数据源说明
2. **按需拉动 Metrics 文档** — 给定 `docs/06-metrics/` 存在多个 STUB，仅完善 sand-measure-light 直接需要的度量定义（efficiency-metrics.md 和 quality-metrics.md），不预先完善全部 06-metrics/ STUB
3. **三级运营自动化完整定义** — 给定 `ops-automation-levels.md` 已完善，当开发者读取该文档时，可以找到 OPS-1/2/3 三级的完整定义、适用场景、升降级规则和与 HIP 机制的映射
4. **理论与操作化数据一致性** — 给定所有 Operate 文档已完善，当后续 Story 7-1 创建 sand-measure-light Skill 的 `step-01-collect.md` 时，5 个信号的名称、采集方法和数据源与 signal-collection.md 完全一致

## Tasks / Subtasks

- [x] Task 1: 完善 `docs/02-development-cycle/operate/signal-collection.md` (AC: #1, #4)
  - [x] 1.1 四类信号分类框架（业务信号/技术信号/AI 行为信号/异常信号）— 基于 Operate README 已定义的四类结构
  - [x] 1.2 sand-measure-light 5 个轻量信号详细定义，每个信号包含：定义、选择依据（为什么是这 5 个而非其他）、数据源（Git/PR/CI）、采集方法（CLI 命令/API 调用）、计算公式、健康范围/基准值、与非确定性范式的关联（为什么传统度量失效而这些信号有效）
  - [x] 1.3 采集架构说明：ADR-007 轻量度量原则（Skill 内嵌脚本，无独立采集服务）+ 软依赖（Git CLI + cURL/HTTP + CSV fallback）
  - [x] 1.4 信号→度量映射表：5 个信号与 `docs/06-metrics/` 度量体系的交叉引用
  - [x] 1.5 目标行数：150-200 行（与前序 Story 0 文档规范一致）
- [x] Task 2: 完善 `docs/02-development-cycle/operate/ops-automation-levels.md` (AC: #3)
  - [x] 2.1 OPS-1/OPS-2/OPS-3 三级完整定义：AI 行为边界、人类行为边界、典型场景示例
  - [x] 2.2 级别升降规则：新规则默认 OPS-2 → 积累信任后升级 OPS-1；异常时降级回 OPS-3
  - [x] 2.3 与 HIP（Human Intervention Protocol）三级的映射关系（HIP-1/2/3 vs OPS-1/2/3），说明两者互补而非替代
  - [x] 2.4 与 sand-measure-light 的关系：度量采集的自动化级别属于 OPS-1（已知模式标准操作）
  - [x] 2.5 目标行数：150-200 行
- [x] Task 3: 按需完善 `docs/06-metrics/efficiency-metrics.md` (AC: #2, #4)
  - [x] 3.1 PR 周期时间（PR Cycle Time）：定义、计算公式（PR 创建到合并的时长中位数）、健康范围、数据源（Git/GitHub API）
  - [x] 3.2 AI 参与度（AI Involvement Rate）：定义、计算公式（AI 辅助 commit 占比）、健康范围、检测方法（commit message 特征/author 标记）
  - [x] 3.3 部署频率（Deployment Frequency）：定义、计算公式（单位时间部署次数）、健康范围（DORA 基准）、数据源（CI/CD pipeline）
  - [x] 3.4 保留并扩展 AI 杠杆率和意图吞吐量的已有定义（STUB 中已列出）
  - [x] 3.5 目标行数：100-150 行（按需拉动，非全面完善）
- [x] Task 4: 按需完善 `docs/06-metrics/quality-metrics.md` (AC: #2, #4)
  - [x] 4.1 变更失败率（Change Failure Rate）：定义、计算公式（导致生产问题的变更占比）、健康范围（DORA 基准）、数据源（CI/CD + incident tracking）
  - [x] 4.2 事故标签（Incident Labels）：定义、分类方法（AI 相关/非 AI 相关/混合）、采集方法（incident tracking 系统/手动标记）
  - [x] 4.3 保留并扩展意图首通率、审查打回率、缺陷逃逸率的已有定义（STUB 中已列出）
  - [x] 4.4 与 `non-deterministic-paradigm.md` §失效度量分析 的交叉引用（解释为什么选择这些 AI 原生替代信号）
  - [x] 4.5 目标行数：100-150 行（按需拉动）
- [x] Task 5: 评估并标注不在范围内的文档 (AC: #2)
  - [x] 5.1 `docs/02-development-cycle/operate/incident-response.md` — 保持 STUB，标注为 Phase 4 或后续 Epic 拉动
  - [x] 5.2 `docs/02-development-cycle/operate/production-validation.md` — 保持 STUB，标注为 Phase 4 或后续 Epic 拉动
  - [x] 5.3 `docs/06-metrics/financial-metrics.md` — 保持 [GAP-4] 标注，不完善
  - [x] 5.4 `docs/06-metrics/maturity-metrics.md` — 不在 sand-measure-light 范围，保持 STUB
  - [x] 5.5 `docs/06-metrics/learning-metrics.md` — 评估结论：不需要。飞轮指标已在 flywheel-metrics.md（Epic 6）完整定义，sand-measure-light 不直接依赖此文件
  - [x] 5.6 `docs/06-metrics/metrics-layer-matrix.md` — 保持 STUB，不在 sand-measure-light 直接范围

### Review Findings

- [x] [Review][Decision] D1: PR 周期时间计算公式不一致 — 选项 2：统一为 `first_commit_timestamp`，文字改为"从首次提交到合并" [signal-collection.md:48, efficiency-metrics.md:85,98] ✅ fixed
- [x] [Review][Patch] P1: OPS-3 节的概括性降级声明与降级规则表矛盾 — 改为"异常结果触发降级（具体规则见下方降级路径表）" [ops-automation-levels.md:86] ✅ fixed
- [x] [Review][Patch] P2: metrics/README.md 效率指标描述过时 — 更新为含全部 5 个度量名称 [docs/06-metrics/README.md:7] ✅ fixed
- [x] [Review][Patch] P3: metrics/README.md 质量指标描述过时 — 更新为含全部 5 个度量名称 [docs/06-metrics/README.md:8] ✅ fixed
- [x] [Review][Patch] P4: Dev Agent 完成记录未确认 quality-metrics.md 行数超标 — 补充确认 [story file completion notes] ✅ fixed
- [x] [Review][Defer] W1: 替代的传统度量映射与 non-deterministic-paradigm.md 失效度量分析表不对齐 — signal-collection.md 的 5 个信号各自声明替代的传统度量，但映射关系与基础理论文档的替代信号表不一致（如 AI 参与度声明替代 LoC，但基础理论表说 LoC 应被意图声明完成率替代）。两者使用不同概念框架（操作信号 vs 战略度量），但交叉引用容易造成误读
- [x] [Review][Defer] W2: 意图首通率分母定义在 flywheel-metrics.md 的文字描述中为"总意图数"但公式为 all_completed_intents — quality-metrics.md 正确使用"总完成意图数"和 all_completed_intents，但 flywheel-metrics.md 文字描述有预先存在的不一致
- [x] [Review][Defer] W3: 事故标签和部署频率未出现在 metrics/README.md 度量-层级交叉矩阵中 — 矩阵为预先存在的工件，新增度量的矩阵位置标注仅在各度量文档中，README 矩阵未更新
- [x] [Review][Defer] W4: OPS 否决追踪机制未定义 — ops-automation-levels.md 的升级条件引用"否决"但未定义谁发起、如何记录。属于运行时实现细节
- [x] [Review][Defer] W5: "连续 2 次触发新问题"中"新问题"无操作化定义 — 降级规则的触发条件需要在运行时实现时明确判定标准

## Dev Notes

### Story 本质

这是一个 **Theory Foundation Story**（Story 0 模式）——不涉及代码或 Skill 文件创建，纯文档完善。产出为 4 个文档从 STUB 升级为完整内容（signal-collection.md、ops-automation-levels.md、efficiency-metrics.md、quality-metrics.md），以及对不在范围文档的评估和标注。

**与前序 Story 0 的模式差异：**
- **不需要拉动 01-foundations/ 文档** — `non-deterministic-paradigm.md` 已 COMPLETE（185 行），其 §失效度量分析 直接支撑本 Story 的信号选择依据
- **按需拉动 06-metrics/ 而非全部完善** — 明确范围控制，仅完善 sand-measure-light 的 5 个信号涉及的度量定义
- **不完善全部 Operate 文档** — incident-response.md 和 production-validation.md 不在 Epic 7 epics doc status 列表中，评估后标注拉动时机

### 关键理论来源

| 理论来源 | 映射到 | 核心贡献 |
|---------|--------|---------|
| `non-deterministic-paradigm.md` §失效度量分析 | signal-collection.md §信号选择依据 | 传统度量失效原因 + AI 原生替代信号表（直接引用） |
| PRD FR34-FR37 | signal-collection.md §5 信号定义 | 5 个轻量信号的功能需求定义 |
| Architecture §ADR-007 | signal-collection.md §采集架构 | 轻量度量实现约束（内嵌脚本、无独立服务） |
| PRD §Journey 4 吴芳 | signal-collection.md §认知失调应用 | 度量数据如何被用于制造认知失调推动变革 |
| Operate README §四类信号 | signal-collection.md §信号分类 | 四类信号分类框架（业务/技术/AI行为/异常） |
| Architecture §HIP | ops-automation-levels.md §HIP 映射 | OPS-1/2/3 与 HIP-1/2/3 的互补关系 |

### 文档编写规范（从前序 Story 0 继承）

- 目标行数：150-200 行/主文档，100-150 行/按需拉动文档
- 结构：概述 → 核心定义/分类 → 详细规范 → 与 SAND 的映射关系 → 引用来源
- 语言：中文主体 + 英文术语保留原文 + 学术引用保留原文
- 交叉引用：使用相对路径引用同仓库内文档
- 每个度量/信号定义包含：定义、计算公式/采集方法、数据源、健康范围/基准值

### 5 个轻量信号与 4 类信号的映射

| 信号 | 分类 | 数据源 | 采集工具 |
|------|------|--------|---------|
| PR 周期时间 | 技术信号 | Git/GitHub API | git-metrics.py |
| 事故标签 | 异常信号 | Incident tracking / 手动 | ci-metrics.py + CSV fallback |
| AI 参与度 | AI 行为信号 | Git commit history | git-metrics.py |
| 变更失败率 | 技术信号 | CI/CD pipeline | ci-metrics.py |
| 部署频率 | 技术信号 | CI/CD pipeline | ci-metrics.py |

### sand-measure-light 架构参照（Architecture 提取）

```
sand-measure-light/             ← FR34-FR37
├── SKILL.md
├── customize.toml
├── steps/
│   ├── step-01-collect.md      ← Git/CI 5 信号采集
│   └── step-02-report.md       ← 度量输出 + 认知失调报告
├── scripts/
│   ├── git-metrics.py          ← Git 度量采集（git log）
│   └── ci-metrics.py           ← CI API 度量采集（cURL + CSV fallback）
└── templates/
    └── metrics-output.json
```

**输出目录：** `.sand/metrics/{date}_metrics.json`
**软依赖：** Git CLI + cURL/HTTP（CSV fallback）
**性能约束：** NFR18 — 典型规模 Git 仓库 5 分钟内完成
**兼容性：** NFR9 — 任何有 git + curl 的环境可运行

### 已有理论基础（直接引用，不重写）

- `docs/01-foundations/non-deterministic-paradigm.md`（COMPLETE, 185 行）— §失效度量分析 表格直接支撑信号选择依据
- `docs/06-metrics/README.md`（PARTIAL, 28 行）— 度量-层级交叉矩阵和飞轮三核心指标已定义
- `docs/02-development-cycle/learn/flywheel-metrics.md`（Epic 6 已完善）— 飞轮指标趋势分析方法已定义

### PRD 功能需求对齐

| FR | 描述 | 本 Story 覆盖 |
|----|------|-------------|
| FR34 | 从 Git/PR/CI 自动采集 5 个轻量信号 | signal-collection.md 定义信号 + 采集方法 |
| FR35 | 技术负责人可查看度量输出 | signal-collection.md 定义输出格式引用 |
| FR36 | 手动 CSV fallback | signal-collection.md 定义 fallback 机制 |
| FR37 | 认知失调报告 | signal-collection.md 定义报告数据要素 |

### PRD 吴芳旅程关键数据点（sand-measure-light 应用场景参照）

吴芳使用 sand-measure-light 产出的数据制造认知失调的 3 个示例：
- "PR 合并量 3 倍增长，但 PR 审查中位时间从 1.5 天涨到 7 天" → PR 周期时间信号
- "3 次生产事故中 2 次根因是 AI 生成代码未经充分审查" → 事故标签信号
- "4 个团队各自开发了类似认证中间件，无复用" → AI 参与度 + 飞轮指标

signal-collection.md 应包含此类应用场景说明，使理论文档与实际使用场景可追溯。

### Deferred Work 关联

- 无直接关联的 deferred work（本 Story 不涉及 Skill 实现或 Schema 变更）
- ADR-007 在架构中引用（`docs/04-artifacts/ADR-007-lightweight-metrics.md`）但不存在为独立文件——本 Story 不需要创建该文件，signal-collection.md 中引用 ADR-007 原则即可

### Project Structure Notes

- 完善 `docs/02-development-cycle/operate/signal-collection.md` (UPDATE — STUB 5 行 → 完整 150-200 行)
- 完善 `docs/02-development-cycle/operate/ops-automation-levels.md` (UPDATE — STUB 5 行 → 完整 150-200 行)
- 完善 `docs/06-metrics/efficiency-metrics.md` (UPDATE — STUB 5 行 → 按需完善 100-150 行)
- 完善 `docs/06-metrics/quality-metrics.md` (UPDATE — STUB 5 行 → 按需完善 100-150 行)
- 可能更新 `docs/02-development-cycle/operate/README.md` (UPDATE — 如需调整四类信号描述)
- **不修改** `docs/01-foundations/` 下任何文件
- **不修改** `docs/02-development-cycle/operate/incident-response.md`（保持 STUB，标注拉动时机）
- **不修改** `docs/02-development-cycle/operate/production-validation.md`（保持 STUB，标注拉动时机）
- **不修改** `docs/06-metrics/financial-metrics.md`、`maturity-metrics.md`、`metrics-layer-matrix.md`

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 7-0] — BDD 验收标准和任务列表
- [Source: _bmad-output/planning-artifacts/prd.md#度量与洞察 FR34-FR37] — 功能需求定义
- [Source: _bmad-output/planning-artifacts/prd.md#Journey 4 吴芳] — 变革催化师旅程（sand-measure-light 应用场景）
- [Source: _bmad-output/planning-artifacts/prd.md#Phase 3 核心交付] — Phase 3 交付物清单
- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-007] — 轻量度量架构决策
- [Source: _bmad-output/planning-artifacts/architecture.md#sand-measure-light] — Skill 目录结构定义
- [Source: _bmad-output/planning-artifacts/architecture.md#NFR18] — 度量采集性能约束
- [Source: _bmad-output/planning-artifacts/architecture.md#NFR9] — 度量采集兼容性约束
- [Source: docs/01-foundations/non-deterministic-paradigm.md#失效度量分析] — 传统度量失效分析表（COMPLETE, 185 行）
- [Source: docs/02-development-cycle/operate/README.md] — Operate 阶段导航（四类信号 + 三级自动化概览）
- [Source: docs/02-development-cycle/operate/signal-collection.md] — 当前 STUB（5 行）
- [Source: docs/02-development-cycle/operate/ops-automation-levels.md] — 当前 STUB（5 行）
- [Source: docs/06-metrics/README.md] — 度量体系导航（交叉矩阵 + 飞轮三核心指标）
- [Source: docs/06-metrics/efficiency-metrics.md] — 当前 STUB（5 行）
- [Source: docs/06-metrics/quality-metrics.md] — 当前 STUB（5 行）

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

N/A — Theory foundation story (documentation), no runtime debugging required.

### Completion Notes List

- Task 1: 完善 signal-collection.md (162 行)。四类信号分类框架（业务/技术/AI行为/异常） + 5 个轻量信号详细定义（每个含定义/选择依据/数据源/采集方法/计算公式/健康范围/替代的失效传统度量） + ADR-007 采集架构（零基础设施、内嵌脚本、CSV fallback） + 信号→度量映射表 + 认知失调应用场景（吴芳旅程）。
- Task 2: 完善 ops-automation-levels.md (168 行)。OPS-1/2/3 三级完整定义（AI 行为边界/人类行为边界/典型场景/准入条件） + 升级路径（OPS-3→2→1 信任积累）和降级路径（异常触发自动降级） + 信任重置机制 + HIP 映射（互补而非替代，控制对象/决策类型/风险评估时机的差异） + sand-measure-light 关系（采集=OPS-1，报告解读=OPS-2）。
- Task 3: 按需完善 efficiency-metrics.md (216 行)。5 个效率度量完整定义：AI 杠杆率（主观评估法）、意图吞吐量（状态机统计）、PR 周期时间（git log 中位数）、AI 参与度（commit 特征检测）、部署频率（DORA 基准）。每个含定义/度量层级/计算方法/数据源/基准值。3 个信号含 sand-measure-light 采集方法交叉引用。略超 100-150 行目标因覆盖 5 个度量（含 STUB 已有的 2 个扩展）。
- Task 4: 按需完善 quality-metrics.md (231 行)。5 个质量度量完整定义：意图首通率（PRD 成功标准对齐）、审查打回率（趋势解读）、缺陷逃逸率（验证有效性）、变更失败率（DORA 基准）、事故标签（AI/非AI/混合三分类）。每个含定义/度量层级/计算方法/数据源/基准值。变更失败率和事故标签含 sand-measure-light 采集方法交叉引用。含 non-deterministic-paradigm.md 失效度量分析交叉引用。略超 100-150 行目标因覆盖 5 个度量（含 STUB 已有的 3 个扩展 + 2 个新增）。
- Task 5: 评估并标注 6 个范围外文档。incident-response.md 和 production-validation.md 的 TODO 注释更新为含拉动时机标注（Phase 4）。learning-metrics.md 评估结论：不需要完善，飞轮指标已在 flywheel-metrics.md (Epic 6) 完整定义。其余 3 个保持原状。

### Change Log

- 2026-05-15: Story 实现完成。4 个文档从 STUB 升级为完整内容，2 个文档标注拉动时机。全部 5 个 Task / 23 个 Subtask 完成。

### File List

- docs/02-development-cycle/operate/signal-collection.md (MODIFIED — STUB 5 行 → 完整 162 行)
- docs/02-development-cycle/operate/ops-automation-levels.md (MODIFIED — STUB 5 行 → 完整 168 行)
- docs/06-metrics/efficiency-metrics.md (MODIFIED — STUB 5 行 → 按需完善 216 行)
- docs/06-metrics/quality-metrics.md (MODIFIED — STUB 5 行 → 按需完善 231 行)
- docs/02-development-cycle/operate/incident-response.md (MODIFIED — TODO 注释更新，标注 Phase 4 拉动时机)
- docs/02-development-cycle/operate/production-validation.md (MODIFIED — TODO 注释更新，标注 Phase 4 拉动时机)
