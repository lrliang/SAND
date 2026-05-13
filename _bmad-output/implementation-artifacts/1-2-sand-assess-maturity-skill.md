# Story 1.2: 实现 sand-assess-maturity Skill

Status: ready-for-dev

## Story

As a 技术负责人（林涛角色）,
I want 通过结构化对话完成 7 维度成熟度评估并获得可执行改进路径,
so that 我可以向 CTO 展示具体的 AI 转型行动方案和预期 ROI。

## Acceptance Criteria

1. `sand/skills/sand-assess-maturity/SKILL.md` 存在，frontmatter 通过 `sandskill.v1.schema.json` 验证，`sdc_phase` = "assess"，`requires` 包含 file_read 和 file_write
2. 5 个 step 文件存在且符合 Architecture §Step File Patterns 命名规范（step-01-scope、step-02-dialogue、step-03-data-collect、step-04-radar、step-05-pathways）
3. `data/dimension-rubrics.yaml` 包含 7 维度 × L1-L5 完整评估量表，维度名称与 `docs/02-development-cycle/assess/maturity-framework.md` 完全一致
4. `data/pathway-rules.yaml` 包含三种组织形状识别规则和改进路径推荐逻辑，规则与 `docs/02-development-cycle/assess/gap-analysis.md` 完全一致
5. step-01 引导用户选择评估范围（团队级/组织级）并收集基本信息（team_id、规模、AI 工具使用时长）
6. step-02 按 7 个维度依次引导结构化对话，对话基于 dimension-rubrics.yaml 中的行为指标，风格为引导式问答而非传统问卷
7. step-04 生成 7 维雷达图 JSON 数据（每维度 L1-L5 等级），输出持久化到 `.sand/assessments/{timestamp}_{team_id}.yaml`，文件通过 `maturity-assessment.schema.json` 验证
8. step-05 基于 pathway-rules.yaml 为红色维度（L1-L2）生成 ≥1 条可执行改进路径，每条路径关联 SAND Skill + 预期 ROI + 时间范围
9. `customize.toml` 存在且包含标准 workflow 配置块

## Tasks / Subtasks

- [ ] Task 1: 创建 SKILL.md 入口文件 (AC: #1)
  - [ ] 1.1 编写 sandskill.v1 frontmatter（全部 9 个必填字段 + 相关可选字段）
  - [ ] 1.2 编写 Skill 激活入口内容（概述 + 步骤导航）
- [ ] Task 2: 创建 customize.toml (AC: #9)
  - [ ] 2.1 编写标准 workflow 配置块（activation_steps_prepend/append、persistent_facts、on_complete）
- [ ] Task 3: 创建 data/dimension-rubrics.yaml (AC: #3)
  - [ ] 3.1 从 maturity-framework.md 提取 7 维度定义，转化为 YAML 结构
  - [ ] 3.2 为每个维度-等级组合填写行为指标、证据类型、采集方式
  - [ ] 3.3 交叉验证维度名称和等级描述与 maturity-framework.md 一致
- [ ] Task 4: 创建 data/pathway-rules.yaml (AC: #4)
  - [ ] 4.1 从 gap-analysis.md 提取组织形状识别规则
  - [ ] 4.2 编写维度→Skill→ROI 映射表
  - [ ] 4.3 编写维度间依赖关系
  - [ ] 4.4 编写路径排序策略（形状驱动 → 最快见效 → 依赖关系）
- [ ] Task 5: 创建 step-01-scope.md (AC: #5)
  - [ ] 5.1 编写评估范围选择引导（团队级/组织级）
  - [ ] 5.2 编写基本信息收集（team_id、规模、AI 工具使用时长）
- [ ] Task 6: 创建 step-02-dialogue.md (AC: #6)
  - [ ] 6.1 编写 7 维度结构化对话引导流程
  - [ ] 6.2 引用 dimension-rubrics.yaml 中的行为指标作为对话锚点
- [ ] Task 7: 创建 step-03-data-collect.md (AC: 补充)
  - [ ] 7.1 编写 Git/CI 数据采集引导（辅助评估，非必须）
- [ ] Task 8: 创建 step-04-radar.md (AC: #7)
  - [ ] 8.1 编写等级汇总和雷达图 JSON 生成逻辑
  - [ ] 8.2 编写颜色编码（红/黄/绿）标注
  - [ ] 8.3 编写输出持久化到 .sand/assessments/ 的指令
- [ ] Task 9: 创建 step-05-pathways.md (AC: #8)
  - [ ] 9.1 编写改进路径生成逻辑（引用 pathway-rules.yaml）
  - [ ] 9.2 编写路径展示格式（Skill + ROI + 时间范围）

## Dev Notes

### Story 本质

这是 SAND 框架的**第一个真正的 Skill 实现**——验证 sandskill.v1 契约、目录结构约定和 step 文件架构的可行性。所有产出是 Markdown 工作流文件 + YAML 数据文件，不涉及可执行代码。

### 关键约束：Skill 是 Markdown 工作流，不是代码

SAND Skills 在 AI Agent 环境（Claude Code / Cursor）中运行。它们是**引导式工作流文件**——通过 Markdown 指令引导 AI Agent 逐步执行。因此：
- `SKILL.md` 是入口，AI Agent 阅读它来了解 Skill 的目的和步骤
- `steps/step-*.md` 是逐步执行的工作流指令
- `data/*.yaml` 是 Skill 运行时读取的参考数据
- 不需要 Python/Shell 代码（那是 Phase 3 的 sand-measure-light）

### 前置 Story 完成情况

**Story 1-0（Assess 理论基础）**：done
- 完善了 maturity-framework.md（7 维度 × L1-L5 量表）和 gap-analysis.md（三种组织形状 + 改进路径推荐逻辑）
- Code Review 修复：Cao 引用移除、路径修正、组织形状规则改为互斥穷尽、"不可逆"改为"累进式"、D1 归为基础设施层
- **关键交接**：dimension-rubrics.yaml 应直接从 maturity-framework.md 的表格提取；pathway-rules.yaml 从 gap-analysis.md 提取

**Story 1-1（框架骨架 + Schema）**：done
- 创建了完整仓库目录结构（sand/skills/sand-assess-maturity/ 目录已存在，含 .gitkeep）
- 创建了 schemas/sandskill.v1.schema.json 和 schemas/maturity-assessment.schema.json
- 创建了 templates/maturity-assessment.yaml
- Code Review 修复：maturity-assessment schema 允许 organizational_shape 为 null，improvement_pathways 添加 required 字段

### SKILL.md frontmatter 精确内容

按 Architecture §1 SKILL.md Frontmatter Patterns 的固定字段顺序：

```yaml
---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-assess-maturity"
version: "0.1.0"
description: "7 维度成熟度评估引导工作流"
sdc_phase: "assess"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - "{sand-root}/templates/maturity-assessment.yaml"
outputs:
  - ".sand/assessments/{timestamp}_{team_id}.yaml"
# === 可选字段（字母序）===
author: "SAND Core Team"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["assessment", "maturity", "radar-chart"]
---
```

### 7 维度名称（不可修改，从 maturity-framework.md 锁定）

| D | 维度名称 | SDC 映射 | 理论基础 |
|---|---------|---------|---------|
| D1 | AI 工具采纳度 | 全阶段（基础设施层） | AI 原生谱系（行业共识 + Hassan SE 3.0） |
| D2 | 意图驱动成熟度 | Intent | Hassan SE 3.0 |
| D3 | 编排能力 | Orchestrate | 多 Agent 编排理论 |
| D4 | 人类审查体系 | Validate + Build | Fowler 约束工程 |
| D5 | 学习与资产化 | Learn | Fowler 认知债务 |
| D6 | 治理与合规 | Governance | ISO 42001 + NIST AI RMF |
| D7 | 组织文化 | 全阶段（组织层） | 渐进采纳理论 |

### dimension-rubrics.yaml 预期结构

从 maturity-framework.md 直接提取。每个维度-等级包含 2 条行为指标 + 证据类型 + 采集方式：

```yaml
dimensions:
  - id: D1
    name: "AI 工具采纳度"
    sdc_phase: "全阶段"
    theory_basis: "AI 原生谱系（行业共识 + Hassan SE 3.0）"
    levels:
      L1:
        name: "初始/无意识"
        indicators:
          - "个别工程师自发使用 AI 编码助手"
          - "无组织层面的 AI 工具策略"
        evidence:
          - type: "工具安装数、个人许可证"
            collection: "手动：问卷"
          - type: "策略文档缺失"
            collection: "手动：文档检查"
      L2:
        # ... 以此类推，从 maturity-framework.md 表格逐行提取
```

### pathway-rules.yaml 预期结构

从 gap-analysis.md 直接提取：

```yaml
organizational_shapes:
  balanced:
    rule: "max(levels) - min(levels) <= 2"
    strategy: "选择最快见效的红色维度"
  skewed:
    rule: "max(levels) - min(levels) >= 3 且不满足尖刺型"
    strategy: "先补短板"
  spiked:
    rule: "count(levels >= 4) <= 2 且 count(levels <= 2) >= 4"
    strategy: "先巩固优势再扩展"

dimension_skill_mapping:
  D1: { skill: null, note: "外部工具部署" }
  D2: { skill: "sand-create-intent", timeframe: "2-3 周" }
  D3: { skill: "sand-design-orchestration", timeframe: "3-4 周" }
  D4: { skill: "sand-validate-delivery", timeframe: "2 周" }
  D5: { skill: "sand-run-retrospective", timeframe: "6 周" }
  D6: { skill: "sand-governance-audit", timeframe: "4 周" }
  D7: { skill: null, note: "组合多个 Skill" }

dependencies:
  D2: { requires: "D1 >= L2" }
  D3: { requires: "D2 >= L2" }  # 传递依赖: D1 >= L2
  D6: { requires: "D4 >= L2" }
```

### Step 文件格式规范

每个 step 文件必须遵循 Architecture §3 Step File Patterns：

```markdown
# Step {N}: {Title}

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous

## YOUR TASK:
{一句话描述}

## EXECUTION SEQUENCE:
### 1. {First action}
### 2. {Second action}

## SUCCESS METRICS:
✅ {metric_1}

## FAILURE MODES:
❌ {failure_1}

## NEXT STEP:
Read fully and follow `./step-{NN+1}-{name}.md`
```

### customize.toml 结构

```toml
[workflow]
activation_steps_prepend = []
activation_steps_append = []
persistent_facts = [
  "file:{sand-root}/docs/02-development-cycle/assess/maturity-framework.md",
  "file:{sand-root}/docs/02-development-cycle/assess/gap-analysis.md",
]
on_complete = ""
```

### 路径引用规则

- 框架内文件：`{sand-root}/templates/maturity-assessment.yaml`
- 用户项目工件：`.sand/assessments/{timestamp}_{team_id}.yaml`
- Skill 内部：`./steps/step-01-scope.md`
- 数据文件：`./data/dimension-rubrics.yaml`
- **禁止**：绝对路径、超过 Skill 目录的 `../..`

### 审计层交互（SandRuntime 自动，Skill 无需手动）

Skill 不需要手动记录审计事件。SandRuntime 在每个 step 完成时自动追加 SandAuditEvent 到 `.sand/audits/audit.jsonl`。Skill 只需正常执行工作流即可。

### 用户交互模式

- 菜单选择：`[A]`/`[B]`/`[C]` 或 `1.`/`2.`/`3.`
- 确认：`(y/n)` 或 `[C] 继续`
- 进度反馈：`[Step 2/5]` 格式
- **禁止**等待自由输入而不给菜单提示

### 林涛旅程验证场景

PRD §Journey 1 描述的关键场景：
- 林涛 `git clone` SAND 仓库，在 Claude Code 中运行 `sand-assess-maturity`
- 45 分钟内完成 7 维度评估
- 生成雷达图：D1（AI 工具采纳度）L4，D4（人类审查体系）L1，D5（学习与资产化）L1
- 点击红色维度时获得 3 条可执行改进路径（路径 A 2 周见效、路径 B 4 周见效、路径 C 6 周见效）
- 每条路径关联具体 Skill + ROI 预期

### 不要做的事

- **不要**编写 Python/Shell 脚本——这是 Markdown 工作流 Skill
- **不要**实现自动化数据采集（step-03 是引导式辅助，非自动执行）
- **不要**修改 `docs/` 下的任何文件
- **不要**修改 `schemas/` 或 `templates/` 下已创建的文件
- **不要**实现团队间聚合或组织级雷达图——这是 FR8（后续功能扩展）
- **不要**实现历史评估对比——这是 FR5（后续功能扩展）

### 完整文件创建清单

```
sand/skills/sand-assess-maturity/
├── SKILL.md                        (NEW)
├── customize.toml                  (NEW)
├── steps/
│   ├── step-01-scope.md            (NEW)
│   ├── step-02-dialogue.md         (NEW)
│   ├── step-03-data-collect.md     (NEW)
│   ├── step-04-radar.md            (NEW)
│   └── step-05-pathways.md         (NEW)
├── data/
│   ├── dimension-rubrics.yaml      (NEW)
│   └── pathway-rules.yaml          (NEW)
└── templates/                      (不创建——使用全局 templates/)
```

注意：删除 `sand/skills/sand-assess-maturity/.gitkeep`（Story 1-1 创建的占位文件，实际内容创建后不再需要）。

### Project Structure Notes

所有文件在 `sand/skills/sand-assess-maturity/` 下创建。不修改任何已有文件。

### References

- [Source: _bmad-output/planning-artifacts/architecture.md §sandskill.v1 Contract Specification]
- [Source: _bmad-output/planning-artifacts/architecture.md §sand-assess-maturity 目录结构（完整 step 列表）]
- [Source: _bmad-output/planning-artifacts/architecture.md §Implementation Patterns（8 个一致性规则域）]
- [Source: _bmad-output/planning-artifacts/architecture.md §Audit Event Architecture]
- [Source: _bmad-output/planning-artifacts/prd.md §FR1-FR8（成熟度评估与诊断）]
- [Source: _bmad-output/planning-artifacts/prd.md §Journey 1 林涛（核心验证场景）]
- [Source: _bmad-output/planning-artifacts/epics.md §Story 1-2]
- [Source: docs/02-development-cycle/assess/maturity-framework.md §7 维度 × L1-L5 量表（dimension-rubrics 来源）]
- [Source: docs/02-development-cycle/assess/gap-analysis.md §三种组织形状 + 改进路径逻辑（pathway-rules 来源）]
- [Source: schemas/sandskill.v1.schema.json（frontmatter 验证）]
- [Source: schemas/maturity-assessment.schema.json（输出验证）]
- [Source: templates/maturity-assessment.yaml（输出模板）]

## Dev Agent Record

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
