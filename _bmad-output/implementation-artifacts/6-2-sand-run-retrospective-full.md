# Story 6.2: 实现 sand-run-retrospective 完整版

Status: done

## Story

As a 技术负责人,
I want 复盘结果自动生成分析报告和资产化入库建议,
so that 团队的 AI 协作经验可以系统性地积累和复用。

## Acceptance Criteria

1. **分析报告生成** — 给定结构化复盘日志（step-01 产出）存在，当 Skill 运行 step-02-classify 时，基于复盘日志中的资产候选列表，按 5 类 AI 资产分类标准（`ai-asset-taxonomy.md`）进行分类，并生成包含趋势分析（如有多轮复盘数据）的分析摘要
2. **资产化入库建议** — 给定分类完成，当 Skill 运行 step-03-register 时，引导用户完成 L2b 人工评审 → L2c 结构化 → L2d 注册，每条入库建议包含完整的资产元数据（asset_id、asset_type、version、confidence、source_intent_id、tags 等）
3. **飞轮指标趋势追踪** — 给定多次复盘数据积累（`.sand/retrospectives/` 中存在历史日志），step-02 可提取飞轮指标历史数据并展示趋势（资产复用率↑/↓、意图首通率↑/↓、循环周期压缩率↑/↓）
4. **SKILL.md 升级** — SKILL.md 更新为完整版：description 移除"Phase 2 基础版"标注、version 升级至 0.2.0、Usage 列出 3 个步骤、输出工件新增分析报告路径
5. **Skill 契约合规** — 更新后的 SKILL.md frontmatter 通过 `scripts/sand-skill-validate.sh` 验证（所有 checks PASS）

## Tasks / Subtasks

- [x] Task 1: 更新 `sand/skills/sand-run-retrospective/SKILL.md` (AC: #4, #5)
  - [x] 1.1 frontmatter: version 从 0.1.0 升级到 0.2.0，description 改为完整版描述（移除"Phase 2 基础版"），inputs 新增 `.sand/retrospectives/`（历史复盘日志用于趋势分析）
  - [x] 1.2 body 概述段：移除"Phase 2 基础版范围"说明，改为完整版描述
  - [x] 1.3 Usage 节：从 1 个步骤扩展为 3 个步骤（step-01-collect + step-02-classify + step-03-register）
  - [x] 1.4 输出工件节：保留复盘日志路径，新增分析报告说明
- [x] Task 2: 创建 `sand/skills/sand-run-retrospective/steps/step-02-classify.md` (AC: #1, #3)
  - [x] 2.1 MANDATORY EXECUTION RULES 标准块（5 条规则）
  - [x] 2.2 YOUR TASK：基于 step-01 产出的资产候选列表，按 5 类标准分类并生成趋势分析
  - [x] 2.3 EXECUTION SEQUENCE：
    - §1: 加载 step-01 产出——从最新的 `.sand/retrospectives/{date}_retro_{seq}.md` 读取资产候选列表（asset_candidates YAML 块），如列表为空或文件不存在则 HALT
    - §2: 5 类资产分类——将每个候选按 asset_type 分组（context/intent_pattern/orchestration_recipe/validation_rule/failure_case），展示分类结果摘要，请用户确认或调整分类
    - §3: 历史趋势分析——扫描 `.sand/retrospectives/` 中所有历史复盘日志，提取每轮的飞轮指标快照，生成趋势表（如仅有 1 轮数据则标注"首轮复盘，无趋势数据"）
    - §4: 生成分析摘要——综合分类结果和趋势数据，输出：每类资产候选数量、高频/低频分布、置信度分布、飞轮指标变化方向、改进建议
  - [x] 2.4 SUCCESS METRICS + FAILURE MODES + NEXT STEP 指向 step-03-register.md
- [x] Task 3: 创建 `sand/skills/sand-run-retrospective/steps/step-03-register.md` (AC: #2)
  - [x] 3.1 MANDATORY EXECUTION RULES 标准块（5 条规则）
  - [x] 3.2 YOUR TASK：引导用户完成 L2b-L2d 资产化流程，为每个接受的候选生成完整的入库建议
  - [x] 3.3 EXECUTION SEQUENCE：
    - §1: L2b 人工评审——逐个展示 step-02 分类后的候选，引导用户按 3 维标准（准确性、通用性、时效性）做出评审决策（accepted/rejected/accepted_with_changes），记录评审意见
    - §2: L2c 结构化——对所有 accepted 的候选，填充完整的标准元数据字段（asset_id 自动生成 AST-{type_code}-{YYYYMMDD}-{seq}、version=1.0.0、confidence 从候选继承可调、expires_at 基于类型默认周期计算），按 ai-asset-taxonomy.md 中对应类型的标准 YAML 格式结构化内容
    - §3: L2d 注册建议——为每个结构化资产生成入库建议，包含：建议的存储位置（Phase 3: Git 仓库资产目录，具体路径由用户确认）、版本化策略说明、过期审查周期、关联关系建议
    - §4: 汇总输出——生成入库建议汇总，追加到复盘日志末尾（或作为独立文件输出），包含总候选数/接受数/拒绝数/结构化数、每条资产的完整元数据 YAML
  - [x] 3.4 SUCCESS METRICS + FAILURE MODES + 无 NEXT STEP（最终步骤）
- [x] Task 4: 运行 `sand-skill-validate.sh` 验证 + 最终检查 (AC: #5)
  - [x] 4.1 运行 `bash scripts/sand-skill-validate.sh sand/skills/sand-run-retrospective/` 确认全部检查 PASS
  - [x] 4.2 验证 step 文件命名规范和连续性（step-01-collect.md, step-02-classify.md, step-03-register.md）
  - [x] 4.3 验证 step-01 → step-02 → step-03 的 NEXT STEP 链接完整
  - [x] 4.4 验证 SKILL.md body 的 Usage 节与 3 个 step 文件一致

### Review Findings

- [x] [Review][Decision] D1: 微循环复盘在 step-02 死循环 — 选项 2：step-02 §1 从复盘日志元数据读取 retro_type，micro 类型直接输出"微循环不含资产分类"并正常结束 [step-02-classify.md §1] ✅ fixed
- [x] [Review][Patch] P1: step-01 §9 残留"Phase 2 基础版"完成消息 — 更新为"数据收集完成。继续 Step 2 进行资产分类与趋势分析。" [step-01-collect.md:295] ✅ fixed
- [x] [Review][Patch] P2: step-02 飞轮健康矩阵新增"单维突破"行（↑ ↑ >1.0 = 任务复杂度上升抵消） [step-02-classify.md] ✅ fixed
- [x] [Review][Patch] P3: step-02 趋势表占位符改为 {reuse_rate_N}/{first_pass_rate_N}/{compression_rate_N} [step-02-classify.md] ✅ fixed
- [x] [Review][Patch] P4: step-02 §4 分析摘要中"减速"改为完整 5 场景枚举（飞轮加速/空转/虚假加速/资产过时/单维突破） [step-02-classify.md] ✅ fixed
- [x] [Review][Defer] W1: 资产存储路径未具体定义 — step-03 使用"建议路径由团队约定"，符合 story spec 设计（追加到日志 + 用户手动创建资产文件）
- [x] [Review][Defer] W2: type_code 映射表未在 step-03 重述 — 依赖 step-02 同 session 上下文传递，与其他 Skill 模式一致
- [x] [Review][Defer] W3: L2b 评审中置信度调整未操作化 — 可通过"修改后接受"的 notes 字段 workaround
- [x] [Review][Defer] W4: 关联关系推理规则未详细定义 — 当前"AI 建议，用户确认或跳过"设计可接受
- [x] [Review][Defer] W5: inputs 裸目录路径 — 继承自 Story 6-1 Deferred Work W2
- [x] [Review][Defer] W6: step-03 §4 追加到日志不幂等 — 重复运行可能产生重复内容，MVP 可接受

## Dev Notes

### Story 本质

这是一个 **Skill 升级** Story——不是从零创建 Skill，而是在 Story 6-1 已创建的 Phase 2 基础版上增量扩展。产出为 2 个新文件（step-02-classify.md + step-03-register.md）+ 1 个更新文件（SKILL.md），将 `sand-run-retrospective` 从 Phase 2 基础版升级为 Phase 3 完整版。

**关键区别于 Story 6-1：**
- **不创建** SKILL.md 和 customize.toml（已存在，仅更新 SKILL.md）
- **不修改** step-01-collect.md（Phase 2 已完善，保持不变）
- **不创建** templates/ 目录（Story 6-1 review 决定删除 YAML 模板，Phase 3 资产结构化输出直接追加到复盘日志）
- **新增** step-02-classify.md 和 step-03-register.md
- **需要更新** SKILL.md 的 step-01 NEXT STEP 以链接到 step-02

### 前序 Story 6-1 关键产出和 Review 发现

**已创建的文件（本 Story 不修改 step-01 和 customize.toml）：**

| 文件 | 状态 | 本 Story 操作 |
|------|------|-------------|
| `SKILL.md` | Phase 2 版本 | **UPDATE** — 升级为完整版 |
| `customize.toml` | 完成 | 不修改 |
| `steps/step-01-collect.md` | 完成 | **UPDATE** — 仅添加 NEXT STEP 链接到 step-02 |
| `steps/step-02-classify.md` | 不存在 | **NEW** |
| `steps/step-03-register.md` | 不存在 | **NEW** |

**Story 6-1 Review 关键发现（影响本 Story）：**
- D1: YAML 模板已删除——本 Story 不需要重新创建 templates/，分析输出直接追加到复盘日志
- P1: asset_candidates YAML 已包含 source_intent_id 字段——step-02 可直接消费
- P3: suggested_by 字段已添加——step-03 L2b 评审可区分 AI 建议 vs 人类提名
- P5: 文件名已改为 `{YYYYMMDD}_retro_{seq}.md`——step-02 需按此模式扫描
- W2: inputs 使用裸目录路径——本 Story 更新 SKILL.md 时可一并修正

**Story 6-0 Review Deferred Work D2（直接影响本 Story）：**
- `.sand/assets/` 目录已从文档中移除，改为"Git 仓库中的资产目录，Phase 3 实现时定义具体路径"
- **本 Story 的 step-03 需要定义资产存储位置**——建议方案：资产入库建议作为结构化 YAML 追加到复盘日志末尾，用户后续手动创建资产文件。不自动创建 `.sand/assets/` 目录（避免引入架构未定义的路径）

### 关键理论文档映射

| 理论文档 | 映射到 | 核心内容 |
|---------|--------|---------|
| `ai-asset-taxonomy.md` | step-02 §2 | 5 类资产分类标准（type_code: CTX/INT/ORC/VAL/FAI）+ 标准 YAML 格式 |
| `assetization-process.md` | step-03 | L2b 评审标准（准确性/通用性/时效性）+ L2c 元数据填充规则 + L2d 过期周期表 |
| `asset-lifecycle.md` | step-03 §2 | 置信度初始值（0.3-1.0 按证据强度）+ 版本化策略（SemVer） |
| `flywheel-metrics.md` | step-02 §3 | 3 指标趋势分析方法 + 飞轮健康度联动矩阵 |

### 资产元数据标准（从 ai-asset-taxonomy.md 提取）

```yaml
asset_metadata:
  asset_id: "AST-{type_code}-{YYYYMMDD}-{seq}"
  asset_type: "context"                            # context / intent_pattern / orchestration_recipe / validation_rule / failure_case
  version: "1.0.0"
  confidence: 0.8                                  # 0.0-1.0
  source_intent_id: "INT-YYYYMMDD-{seq}"
  source_retro_date: "YYYY-MM-DD"
  created_at: "ISO-8601 UTC"
  updated_at: "ISO-8601 UTC"
  expires_at: "ISO-8601 UTC"                       # 基于类型默认周期
  tags: ["tag1", "tag2"]
  created_by: "ai+human"
  usage_count: 0
  last_used_at: null
```

### 过期周期表（从 assetization-process.md 提取）

| 资产类型 | type_code | 默认过期周期 |
|---------|-----------|------------|
| 上下文资产 | CTX | 90 天 |
| 意图模式 | INT | 180 天 |
| 编排配方 | ORC | 120 天 |
| 验证规则 | VAL | 180 天 |
| 失败案例 | FAI | 365 天 |

### L2b 评审标准（从 assetization-process.md 提取）

| 评审维度 | 通过标准 | 拒绝标准 |
|---------|---------|---------|
| **准确性** | 模式与实际执行数据一致，证据链完整 | 证据不足或存在矛盾 |
| **通用性** | 适用于类似场景的多个实例 | 仅在单一特殊情况下有效 |
| **时效性** | 基于当前有效的技术栈和业务规则 | 基于已弃用的技术或已变更的业务规则 |

评审决策：`accepted` / `rejected` / `accepted_with_changes`

### Step 文件编写规范

与 Story 6-1 相同的 6 段强制结构。step-02 和 step-03 各自末尾有 NEXT STEP（step-02 指向 step-03，step-03 无 NEXT STEP）。

### PRD 功能需求对齐

- **FR38:** （已由 Story 6-1 step-01 实现）5 议题结构化复盘
- **FR39:** 基于复盘结果生成资产化入库建议（5 类 AI 资产）— step-02 + step-03 核心功能
- **FR40:** 追踪飞轮加速指标 — step-02 §3 历史趋势分析

### Project Structure Notes

- 更新 `sand/skills/sand-run-retrospective/SKILL.md` (UPDATE — version 0.1.0→0.2.0, Phase 2→完整版)
- 更新 `sand/skills/sand-run-retrospective/steps/step-01-collect.md` (UPDATE — 仅末尾添加 NEXT STEP 链接)
- 创建 `sand/skills/sand-run-retrospective/steps/step-02-classify.md` (NEW)
- 创建 `sand/skills/sand-run-retrospective/steps/step-03-register.md` (NEW)
- **不修改** `customize.toml`
- **不创建** `templates/` 目录

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 6-2] — BDD 验收标准（行 763-792）
- [Source: _bmad-output/planning-artifacts/prd.md#学习与资产化 FR38-FR40] — 功能需求（行 675-678）
- [Source: docs/02-development-cycle/learn/ai-asset-taxonomy.md] — 5 类资产分类标准 + 标准 YAML 格式
- [Source: docs/02-development-cycle/learn/assetization-process.md] — L2b-L2d 流程 + 评审标准 + 过期周期
- [Source: docs/02-development-cycle/learn/asset-lifecycle.md] — 置信度模型 + 版本化策略
- [Source: docs/02-development-cycle/learn/flywheel-metrics.md] — 趋势分析方法 + 飞轮健康度矩阵
- [Source: sand/skills/sand-run-retrospective/SKILL.md] — 当前 Phase 2 版本（需 UPDATE）
- [Source: sand/skills/sand-run-retrospective/steps/step-01-collect.md] — Phase 2 step（需添加 NEXT STEP）
- [Source: sand/skills/sand-governance-audit/steps/step-02-chain.md] — step-02 模式参照
- [Source: sand/skills/sand-governance-audit/steps/step-03-report.md] — step-03 模式参照
- [Source: _bmad-output/implementation-artifacts/6-1-sand-run-retrospective-basic.md] — 前序 Story + Review Findings
- [Source: _bmad-output/implementation-artifacts/6-0-learn-theory-foundation.md] — Learn 理论基础 Story
- [Source: _bmad-output/implementation-artifacts/deferred-work.md] — D2 资产存储路径、W2 inputs 路径约定
- [Source: scripts/sand-skill-validate.sh] — Skill 契约验证脚本

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

N/A — Skill authoring story (Markdown + YAML files), no runtime debugging required.

### Completion Notes List

- Task 1: Updated SKILL.md. Frontmatter: version 0.1.0→0.2.0, description removed "Phase 2 基础版", inputs added `.sand/retrospectives/` (4 total inputs now). Body: overview paragraph updated to remove Phase 2 scope note, Usage section expanded from 1 step to 3 steps ([Step 1/3] collect, [Step 2/3] classify, [Step 3/3] register), output artifacts description updated to include asset classification and registration.
- Task 2: Created step-02-classify.md (~140 lines). 6-section structure. 4 execution subsections: §1 load step-01 output (scan retrospectives/ for latest retro file, extract asset_candidates YAML, handle empty/missing with 3 options), §2 5-type asset classification (CTX/INT/ORC/VAL/FAI grouping table with frequency distribution and average confidence, user confirmation/adjustment), §3 historical trend analysis (scan all retro files for flywheel metrics history, generate trend table with direction indicators, flywheel health judgment matrix from flywheel-metrics.md), §4 analysis summary (classification stats + trend + improvement recommendations). NEXT STEP links to step-03-register.md.
- Task 3: Created step-03-register.md (~195 lines). 6-section structure. 4 execution subsections: §1 L2b human review (per-candidate display with 3-criteria evaluation, accepted/rejected/accepted_with_changes decisions, Mikkonen principle enforcement for AI-suggested candidates, review summary), §2 L2c structuring (auto-fill metadata: asset_id generation AST-{type_code}-{YYYYMMDD}-{seq}, version 1.0.0, expires_at from per-type expiry table 90-365 days, tags extraction, user confirmation per asset), §3 L2d registration (recommendation YAML with storage suggestion, versioning strategy, expiry review, relationship suggestions), §4 summary output (append classification + registration results to retro log file as new Markdown sections). No NEXT STEP (final step).
- Task 4: Validation complete. sand-skill-validate.sh: 23/23 PASS (0 warnings), version correctly shows 0.2.0, 4 inputs, 3 step files detected. Step naming sequential: step-01-collect.md → step-02-classify.md → step-03-register.md. NEXT STEP chain verified: step-01→step-02→step-03 (terminal). SKILL.md Usage lists all 3 steps correctly.

### Change Log

- 2026-05-15: Story implementation complete. SKILL.md updated (version 0.2.0, Phase 3 full), step-01 updated (NEXT STEP added), 2 new step files created, all 4 tasks done. sand-skill-validate.sh 23/23 PASS.

### File List

- sand/skills/sand-run-retrospective/SKILL.md (MODIFIED — version 0.1.0→0.2.0, Phase 2→full, Usage 1→3 steps, inputs 3→4)
- sand/skills/sand-run-retrospective/steps/step-01-collect.md (MODIFIED — added NEXT STEP section at end)
- sand/skills/sand-run-retrospective/steps/step-02-classify.md (NEW)
- sand/skills/sand-run-retrospective/steps/step-03-register.md (NEW)
