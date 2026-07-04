# Story 7.1: 实现 sand-measure-light Skill

Status: review

## Story

As a 变革催化师（吴芳角色）,
I want 从 Git/PR/CI 自动采集轻量度量信号并生成认知失调报告,
so that 我可以用数据制造认知失调推动团队渐进改变。

## Acceptance Criteria

1. **Skill 契约合规** — SKILL.md frontmatter 通过 `scripts/sand-skill-validate.sh` 验证（所有 checks PASS），sdc_phase = "operate"，requires 包含 file_read、file_write、shell_exec
2. **Git 度量自动采集** — 给定当前目录是 Git 仓库，当运行 sand-measure-light step-01-collect 时，自动采集 PR 周期时间和 AI 参与度（通过 git-metrics.py），输出到 `.sand/metrics/{date}_metrics.json`
3. **CI 度量采集（含 Fallback）** — 给定 CI API 可访问，当运行 step-01-collect 时，自动获取变更失败率、部署频率和事故标签（通过 ci-metrics.py）；如果 CI API 不可访问，接受手动 CSV 导入（FR36）
4. **认知失调报告** — 给定度量数据已采集，当运行 step-02-report 时，生成包含正向指标、负向指标、变化趋势分析、推荐下一步行动的结构化认知失调报告（FR37）
5. **理论一致性** — 5 个信号的名称、采集方法和数据源与 `signal-collection.md` 完全一致（Story 7-0 AC #4 延续）

## Tasks / Subtasks

- [x] Task 1: 创建 `sand/skills/sand-measure-light/SKILL.md` (AC: #1, #5)
  - [x] 1.1 sandskill.v1 frontmatter（固定字段顺序）：sand_contract, name="sand-measure-light", version="0.1.0", description（中文）, sdc_phase="operate", entry_point, requires=[file_read, file_write, shell_exec], inputs=[Git 仓库, .sand/config.yaml(可选), CSV fallback(可选)], outputs=[.sand/metrics/{date}_metrics.json]
  - [x] 1.2 可选字段：author, human_oversight="hip-2", license, model_requirement, sand_min_version, tags=["metrics", "measurement", "operate"]
  - [x] 1.3 Body 概述段：Skill 用途、2 步工作流说明、输入输出、软依赖（Git CLI + cURL + Python 3）
  - [x] 1.4 Usage 节：[Step 1/2] 信号采集（step-01-collect.md）、[Step 2/2] 认知失调报告（step-02-report.md）
- [x] Task 2: 创建 `sand/skills/sand-measure-light/customize.toml` (AC: #5)
  - [x] 2.1 3 层 merge 语义注释
  - [x] 2.2 [workflow] 块：activation_steps_prepend=[], activation_steps_append=[], on_complete=""
  - [x] 2.3 persistent_facts 引用理论文档：signal-collection.md, ops-automation-levels.md, efficiency-metrics.md, quality-metrics.md
- [x] Task 3: 创建 `sand/skills/sand-measure-light/scripts/git-metrics.py` (AC: #2, #5)
  - [x] 3.1 采集信号 1（PR 周期时间）：`git log --merges` 解析合并提交，计算 `median(merge_timestamp - first_commit_timestamp)` 取最近 N 个 PR（默认 N=50）
  - [x] 3.2 采集信号 3（AI 参与度）：`git log` 扫描 commit message 中的 AI 特征标记（Co-Authored-By 含 AI/Claude/Copilot/Cursor、IDE 插件标记），计算 `count(ai_assisted_commits) / count(all_commits)` 取最近 N 天（默认 N=30）
  - [x] 3.3 输出 JSON 结构体（pr_cycle_time_median_hours, ai_involvement_rate, raw data arrays）
  - [x] 3.4 命令行参数：--days N（时间窗口）、--pr-count N（PR 数量）、--output PATH（输出路径）
  - [x] 3.5 错误处理：非 Git 仓库 → 退出码 1 + 错误消息；无合并提交 → pr_cycle_time=null + 警告
- [x] Task 4: 创建 `sand/skills/sand-measure-light/scripts/ci-metrics.py` (AC: #3, #5)
  - [x] 4.1 采集信号 4（变更失败率）：从 CI API 获取部署事件 + 关联事故记录，计算 `count(failed_changes) / count(all_changes)`
  - [x] 4.2 采集信号 5（部署频率）：从 CI API 获取部署事件时间线，计算 `count(deployments) / time_window`
  - [x] 4.3 采集信号 2（事故标签）：从 CI API 或 incident tracking 读取事故记录，按 ai_related/non_ai/mixed 分类
  - [x] 4.4 CSV fallback（FR36）：--csv PATH 参数，接受标准 CSV 格式导入全部 5 个信号的数据
  - [x] 4.5 命令行参数：--api-url URL（CI API 端点）、--days N（时间窗口）、--csv PATH（CSV fallback）、--output PATH
  - [x] 4.6 错误处理：API 不可达 → 提示 CSV fallback；CSV 格式错误 → 退出码 1 + 错误消息
- [x] Task 5: 创建 `sand/skills/sand-measure-light/templates/metrics-output.json` (AC: #2, #3)
  - [x] 5.1 JSON 模板结构：metadata（collected_at, git_repo, time_window_days）+ signals（5 个信号各自的 value/raw_data/data_source/status 结构）
  - [x] 5.2 status 字段枚举：collected（成功采集）、fallback（CSV 导入）、unavailable（无法采集）、partial（部分数据）
- [x] Task 6: 创建 `sand/skills/sand-measure-light/steps/step-01-collect.md` (AC: #2, #3, #5)
  - [x] 6.1 MANDATORY EXECUTION RULES 标准块（5 条规则）
  - [x] 6.2 YOUR TASK：运行 git-metrics.py 和 ci-metrics.py 采集 5 个轻量信号
  - [x] 6.3 EXECUTION SEQUENCE：
    - §1: 环境检查——验证 Git 仓库、Python 3 可用、.sand/metrics/ 目录存在（不存在则创建）
    - §2: Git 信号采集——运行 `python3 scripts/git-metrics.py`，展示 PR 周期时间和 AI 参与度结果
    - §3: CI 信号采集——尝试运行 `python3 scripts/ci-metrics.py`；如 API 不可达，询问用户是否提供 CSV；无 CSV 则标记 3 个 CI 信号为 unavailable
    - §4: 合并输出——将 Git 和 CI 采集结果合并为 `.sand/metrics/{YYYYMMDD}_metrics.json`，展示 5 信号采集状态汇总
  - [x] 6.4 SUCCESS METRICS + FAILURE MODES + NEXT STEP 指向 step-02-report.md
- [x] Task 7: 创建 `sand/skills/sand-measure-light/steps/step-02-report.md` (AC: #4, #5)
  - [x] 7.1 MANDATORY EXECUTION RULES 标准块
  - [x] 7.2 YOUR TASK：基于采集的度量数据生成认知失调报告
  - [x] 7.3 EXECUTION SEQUENCE：
    - §1: 加载度量数据——从 `.sand/metrics/` 读取最新的 metrics JSON，如有历史数据则加载前 N 轮用于趋势分析
    - §2: 信号分类——将 5 个信号按正向（改善趋势）和负向（恶化趋势）分类，无历史数据时基于 DORA 基准和健康范围判定
    - §3: 趋势分析——如有多轮数据，计算每个信号的变化方向和幅度；标注显著变化（>10% 变动）
    - §4: 认知失调叙事——生成 2-3 条"好消息 vs 坏消息"对比叙事（参照吴芳旅程模式），突出团队自我感觉与数据之间的落差
    - §5: 推荐行动——基于负向信号推荐具体的改善行动（关联到 SAND Skill，如"建议运行 sand-validate-delivery 加强审查"）
    - §6: 报告输出——生成 Markdown 格式报告到 `.sand/metrics/{YYYYMMDD}_report.md`，展示完整报告内容
  - [x] 7.4 SUCCESS METRICS + FAILURE MODES（最终步骤，无 NEXT STEP）
- [x] Task 8: 运行 `sand-skill-validate.sh` 验证 + 最终检查 (AC: #1)
  - [x] 8.1 运行 `bash scripts/sand-skill-validate.sh sand/skills/sand-measure-light/` 确认全部检查 PASS
  - [x] 8.2 验证 step 文件命名规范和连续性（step-01-collect.md, step-02-report.md）
  - [x] 8.3 验证 SKILL.md body 的 Usage 节与 2 个 step 文件一致
  - [x] 8.4 验证 scripts/ 目录中 Python 脚本语法正确（`python3 -c "import ast; ast.parse(open('...').read())"` ）

### Review Findings

- [ ] [Review][Patch] P1: git-metrics.py AI 特征检测遗漏 🤖 emoji 标记 — signal-collection.md 明确列出"🤖"作为 AI 辅助 commit 的检测特征，但 ai_patterns 列表中缺失此 emoji [git-metrics.py AI patterns list]
- [ ] [Review][Patch] P2: step-02-report.md §6 报告模板中的相对链接路径层级错误 — `../../docs/` 从 steps/ 目录解析为 `sand/skills/docs/` 而非仓库根的 `docs/` [step-02-report.md:149]
- [x] [Review][Defer] W1: git log --merges 包含非 PR 合并（back-merge、release merge）— ADR-007 零基础设施约束下的 trade-off，无法用纯 Git 区分 PR 合并和维护合并
- [x] [Review][Defer] W2: Squash merge 产生近零或误导性的周期时间 — 代码返回 "partial" status 但未专门过滤 squash merge
- [x] [Review][Defer] W3: CI API 缺少认证头 — 设计决策：通用 API 框架，依赖 CSV fallback 处理认证失败场景
- [x] [Review][Defer] W4: CI API 无分页 — 30 天窗口内高频部署可能截断数据集，无分页/计数校验
- [x] [Review][Defer] W5: commit message 中 ||| 分隔符碰撞风险 — 极罕见但理论上可能，NUL 字节(\x00)更安全
- [x] [Review][Defer] W6: 未知事故标签默认归类为 non_ai — 可能系统性低估 AI 相关事故占比
- [x] [Review][Defer] W7: SKILL.md 中 ../../docs/ 相对路径错误 — 与 sand-governance-audit 等其他 Skill 同样的预先存在问题
- [x] [Review][Defer] W8: step-02 未定义全部信号同向（全正/全负）时的叙事路径 — AI Agent 可合理处理但缺少显式指导

## Dev Notes

### Story 本质

这是一个 **Skill 实现 Story**——从零创建 `sand-measure-light` Skill。产出为 7 个新文件（SKILL.md, customize.toml, 2 step 文件, 2 Python 脚本, 1 JSON 模板）。这是 SAND 框架中**第一个包含可执行脚本的 Skill**（其他 Skill 均为纯引导式工作流）。

**与其他 Skill Story 的关键差异：**
- **包含 scripts/ 目录** — git-metrics.py 和 ci-metrics.py 是实际的 Python 脚本，由 step-01 指示 AI Agent 运行（ADR-007 "Skill 内嵌脚本"）
- **需要 shell_exec 权限** — 因为要运行 Python 脚本，requires 需声明 shell_exec（此前 Skill 仅需 file_read + file_write）
- **仅 2 个 step** — collect + report，比 governance-audit（3 步）和 retrospective（3 步）更精简
- **输出为 JSON + Markdown** — metrics.json（机器可读）+ report.md（人类可读）

### 前序 Story 7-0 关键产出

**已完善的理论文档（本 Story 必须严格对齐）：**

| 文档 | 核心内容 | 本 Story 映射 |
|------|---------|-------------|
| `signal-collection.md` | 5 信号定义 + 采集方法 + ADR-007 架构 | step-01 + scripts |
| `ops-automation-levels.md` | OPS-1/2/3 定义 | 度量采集=OPS-1，报告解读=OPS-2 |
| `efficiency-metrics.md` | PR 周期时间/AI 参与度/部署频率定义 | git-metrics.py + ci-metrics.py |
| `quality-metrics.md` | 变更失败率/事故标签定义 | ci-metrics.py |

**Story 7-0 Review 关键发现（影响本 Story）：**
- D1: PR 周期时间已统一为 `first_commit_timestamp`（不是 `pr_created_timestamp`）——git-metrics.py 必须使用 `git log --merges` 解析首次提交时间
- W1: 替代的传统度量映射与 non-deterministic-paradigm.md 不完全对齐——本 Story 不需要处理此问题
- W4: OPS 否决追踪机制未定义——本 Story 不涉及 OPS 升降级实现

### 5 个信号的精确定义（从 signal-collection.md 提取，AC #5 对齐基准）

| # | 信号 | 公式 | 采集工具 | 数据源 |
|---|------|------|---------|--------|
| 1 | PR 周期时间 | `median(merge_timestamp - first_commit_timestamp)` 最近 N 个 PR | git-metrics.py | `git log --merges` |
| 2 | 事故标签 | ai_related / non_ai / mixed 分类统计 | ci-metrics.py + CSV | Incident tracking / 手动 |
| 3 | AI 参与度 | `count(ai_assisted_commits) / count(all_commits)` 最近 N 天 | git-metrics.py | `git log` commit message 特征 |
| 4 | 变更失败率 | `count(failed_changes) / count(all_changes)` 最近 N 周期 | ci-metrics.py | CI/CD pipeline + incident |
| 5 | 部署频率 | `count(deployments) / time_window` | ci-metrics.py | CI/CD pipeline |

### Architecture 架构参照

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

**输出目录：** `.sand/metrics/{date}_metrics.json` + `.sand/metrics/{date}_report.md`
**软依赖：** Git CLI + cURL/HTTP + Python 3（CSV fallback 无额外依赖）
**性能约束：** NFR18 — 典型规模 Git 仓库 5 分钟内完成
**兼容性：** NFR9 — 任何有 git + curl + python3 的环境可运行

### Skill 契约要求（sandskill.v1）

**必填字段固定顺序：** sand_contract → name → version → description → sdc_phase → entry_point → requires → inputs → outputs

**可选字段字母序：** author, human_oversight, license, model_requirement, sand_min_version, tags

**requires 声明：** `[file_read, file_write, shell_exec]` — shell_exec 为首次使用（因需运行 Python 脚本）

### Step 文件编写规范（6 段强制结构）

与前序 Skill（sand-governance-audit, sand-run-retrospective）相同：
1. MANDATORY EXECUTION RULES（5 条标准规则）
2. YOUR TASK（单句描述）
3. EXECUTION SEQUENCE（§1-§N 编号子节）
4. SUCCESS METRICS（✅ 清单）
5. FAILURE MODES（❌ 清单 + 处理策略）
6. NEXT STEP（指向下一步或"最终步骤"）

### Python 脚本编写规范

- **标准库 only** — 不引入 pip 依赖（零基础设施约束）
- **CLI 接口** — argparse 参数解析，支持 --help
- **JSON 输出** — 结构化输出到 stdout 或 --output 文件
- **退出码** — 0=成功, 1=错误, 2=部分成功（部分信号不可用）
- **编码** — UTF-8，中文注释和帮助文本
- **shebang** — `#!/usr/bin/env python3`

### PRD 功能需求对齐

| FR | 描述 | 本 Story 实现 |
|----|------|-------------|
| FR34 | 从 Git/PR/CI 自动采集 5 个轻量信号 | step-01 + git-metrics.py + ci-metrics.py |
| FR35 | 技术负责人可查看度量输出 | .sand/metrics/{date}_metrics.json |
| FR36 | 手动 CSV fallback | ci-metrics.py --csv 参数 |
| FR37 | 认知失调报告 | step-02 生成 report.md |

### PRD 吴芳旅程关键场景（step-02 认知失调叙事参照）

吴芳使用 sand-measure-light 产出的数据制造认知失调的 3 个模式：
1. "好消息 vs 坏消息"对比：PR 合并量↑ 3 倍 但 PR 审查时间↑ 4.7 倍 → PR 周期时间信号
2. "AI 风险可见化"：3 次事故中 2 次 AI 相关 → 事故标签信号
3. "重复建设暴露"：4 团队重复开发同一组件 → AI 参与度 + 飞轮指标联动

step-02 的 §4 认知失调叙事应生成类似模式的对比句式。

### 现有 Skill 模式参照（sand-governance-audit）

| 模式 | sand-governance-audit | sand-measure-light |
|------|----------------------|-------------------|
| Step 数量 | 3（scan → chain → report） | 2（collect → report） |
| Scripts | 无 | 有（git-metrics.py, ci-metrics.py）← **首次** |
| Templates | audit-report.yaml | metrics-output.json |
| persistent_facts | governance 理论文档 ×4 | operate + metrics 理论文档 ×4 |
| 数据源 | .sand/audits/audit.jsonl | Git CLI + CI API + CSV |
| 输出 | AUD-*.yaml + JSON/CSV 导出 | metrics.json + report.md |

### Deferred Work 关联

- Story 7-0 W1: 替代的传统度量映射不对齐 — 不影响本 Story（本 Story 实现信号采集，不处理度量映射关系）
- Story 7-0 W4/W5: OPS 否决追踪和降级规则 — 不影响本 Story（度量采集属于 OPS-1，无需升降级逻辑）
- Story 4-3 W1: get_array_items 无法解析 inline YAML — 可能影响 SKILL.md frontmatter 中 requires 的 flow-sequence 格式，建议使用 block-sequence 格式

### Project Structure Notes

- 创建 `sand/skills/sand-measure-light/SKILL.md` (NEW)
- 创建 `sand/skills/sand-measure-light/customize.toml` (NEW)
- 创建 `sand/skills/sand-measure-light/steps/step-01-collect.md` (NEW)
- 创建 `sand/skills/sand-measure-light/steps/step-02-report.md` (NEW)
- 创建 `sand/skills/sand-measure-light/scripts/git-metrics.py` (NEW)
- 创建 `sand/skills/sand-measure-light/scripts/ci-metrics.py` (NEW)
- 创建 `sand/skills/sand-measure-light/templates/metrics-output.json` (NEW)
- 删除 `sand/skills/sand-measure-light/.gitkeep`（被实际文件替代）
- **不修改** 任何理论文档或其他 Skill 文件

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Story 7-1] — BDD 验收标准
- [Source: _bmad-output/planning-artifacts/prd.md#度量与洞察 FR34-FR37] — 功能需求
- [Source: _bmad-output/planning-artifacts/prd.md#Journey 4 吴芳] — 认知失调报告应用场景
- [Source: _bmad-output/planning-artifacts/architecture.md#sand-measure-light] — Skill 目录结构（行 731-741）
- [Source: _bmad-output/planning-artifacts/architecture.md#ADR-007] — 轻量度量架构决策
- [Source: _bmad-output/planning-artifacts/architecture.md#sandskill.v1] — Skill 契约规范（行 263-301）
- [Source: _bmad-output/planning-artifacts/architecture.md#Step File Patterns] — Step 文件编写规范（行 534-563）
- [Source: docs/02-development-cycle/operate/signal-collection.md] — 5 信号精确定义 + 采集架构（AC #5 对齐基准）
- [Source: docs/02-development-cycle/operate/ops-automation-levels.md] — OPS-1/2/3 定义（采集=OPS-1）
- [Source: docs/06-metrics/efficiency-metrics.md] — PR 周期时间/AI 参与度/部署频率度量定义
- [Source: docs/06-metrics/quality-metrics.md] — 变更失败率/事故标签度量定义
- [Source: sand/skills/sand-governance-audit/SKILL.md] — Skill 实现模式参照
- [Source: sand/skills/sand-governance-audit/customize.toml] — customize.toml 模式参照
- [Source: sand/skills/sand-governance-audit/steps/step-01-scan.md] — Step 文件模式参照
- [Source: _bmad-output/implementation-artifacts/7-0-operate-theory-foundation.md] — 前序 Story + Review Findings
- [Source: _bmad-output/implementation-artifacts/deferred-work.md] — W1 度量映射、W4/W5 OPS 规则
- [Source: scripts/sand-skill-validate.sh] — Skill 契约验证脚本

## Dev Agent Record

### Agent Model Used

Claude Opus 4.6

### Debug Log References

N/A — Skill authoring story (Markdown + Python + JSON files), no runtime debugging required.

### Completion Notes List

- Task 1: Created SKILL.md. Frontmatter: sandskill.v1 contract, name=sand-measure-light, version=0.1.0, sdc_phase=operate, requires=[file_read, file_write, shell_exec] (shell_exec is first-use across SAND Skills). 3 inputs (Git repo, config, CSV fallback), 2 outputs (metrics.json, report.md). Optional fields in alphabetical order. Body: overview with ADR-007 rationale, theory references, 2-step Usage, prerequisites table, soft dependencies table.
- Task 2: Created customize.toml. 3-layer merge semantics comment. [workflow] block with persistent_facts referencing 4 theory docs: signal-collection.md, ops-automation-levels.md, efficiency-metrics.md, quality-metrics.md.
- Task 3: Created git-metrics.py (~200 lines). Collects Signal 1 (PR Cycle Time) via `git log --merges` + merge-base analysis for first_commit_timestamp, calculates median. Collects Signal 3 (AI Involvement Rate) via commit message pattern matching (Co-Authored-By + AI tool keywords). CLI: --days, --pr-count, --output. Exit codes: 0=all success, 1=all fail, 2=partial. Standard library only.
- Task 4: Created ci-metrics.py (~200 lines). Collects Signal 4 (Change Failure Rate), Signal 5 (Deployment Frequency), Signal 2 (Incident Labels) via CI API or CSV fallback (FR36). CSV format documented in --help. Generic API framework with deployment/incident endpoints. CLI: --api-url, --days, --csv, --output. Same exit code convention.
- Task 5: Created metrics-output.json template. 5 signals with value/unit/data_source/status fields. Status enum: collected/fallback/unavailable/partial. Metadata includes collected_at, git_repo, time_window_days, collectors.
- Task 6: Created step-01-collect.md. 6-section structure. 4 execution subsections: §1 environment check (Git repo + Python 3 + .sand/metrics/ dir + parameter confirmation), §2 Git signal collection (run git-metrics.py, display results), §3 CI signal collection (3 options: API/CSV/skip, with automatic fallback prompt), §4 merge output (combine Git+CI results into {YYYYMMDD}_metrics.json, display 5-signal summary table). NEXT STEP links to step-02-report.md.
- Task 7: Created step-02-report.md. 6-section structure. 6 execution subsections: §1 load metrics data (latest + historical), §2 signal classification (positive/negative per DORA benchmarks), §3 trend analysis (direction + magnitude for multi-round data), §4 cognitive dissonance narrative (2-3 "good news vs bad news" contrasts per 吴芳 journey patterns), §5 recommended actions (linked to specific SAND Skills), §6 report output (Markdown to .sand/metrics/{YYYYMMDD}_report.md). No NEXT STEP (final step).
- Task 8: Validation complete. sand-skill-validate.sh: 23/23 PASS (0 warnings). Step naming sequential: step-01-collect.md → step-02-report.md. SKILL.md Usage lists 2 steps correctly. Python syntax valid for both scripts.

### Change Log

- 2026-05-15: Story implementation complete. 7 new files created (SKILL.md, customize.toml, 2 step files, 2 Python scripts, 1 JSON template). .gitkeep removed. sand-skill-validate.sh 23/23 PASS. First SAND Skill with scripts/ directory and shell_exec requirement.

### File List

- sand/skills/sand-measure-light/SKILL.md (NEW)
- sand/skills/sand-measure-light/customize.toml (NEW)
- sand/skills/sand-measure-light/steps/step-01-collect.md (NEW)
- sand/skills/sand-measure-light/steps/step-02-report.md (NEW)
- sand/skills/sand-measure-light/scripts/git-metrics.py (NEW)
- sand/skills/sand-measure-light/scripts/ci-metrics.py (NEW)
- sand/skills/sand-measure-light/templates/metrics-output.json (NEW)
- sand/skills/sand-measure-light/.gitkeep (DELETED)
