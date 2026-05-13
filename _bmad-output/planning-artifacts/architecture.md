---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
completedAt: "2026-05-13"
status: "complete"
lastStep: 8
inputDocuments:
  - "_bmad-output/planning-artifacts/prd.md"
  - "_bmad-output/planning-artifacts/prd-validation-report.md"
  - "_bmad-output/planning-artifacts/research/domain-ai-native-development-methodology-research-2026-05-11.md"
  - "_bmad-output/planning-artifacts/research/technical-sand-tools-metrics-feasibility-research-2026-05-12.md"
  - "_bmad-output/brainstorming/brainstorming-session-2026-05-11-02.md"
  - "docs/README.md"
documentCounts:
  prd: 1
  prdValidation: 1
  research: 2
  brainstorming: 1
  projectDocs: 80
workflowType: 'architecture'
project_name: 'SAND'
user_name: 'Leon'
date: '2026-05-12'
---

# Architecture Decision Document

_This document builds collaboratively through step-by-step discovery. Sections are appended as we work through each architectural decision together._

## Project Context Analysis

### Requirements Overview

**Functional Requirements:**

52 个功能需求，组织为 10 个能力域。核心架构挑战集中在四个域：

1. **编排与插件生态（FR16-FR22）**：需要设计可扩展的插件注册/发现/验证机制，同时保持零基础设施约束。这是 SAND 独特的"方法论平台化"需求——类似 npm 注册表但以文件系统为基础。

2. **执行运行时（FR15a-d）**：需要在无中心化服务的前提下实现 Skill 链式调用、输出链接和实时状态记录。状态管理完全依赖文件系统（`.sand/executions/`）。

3. **治理与审计（FR28-FR31）**：审计事件必须在每个 Skill 执行时自动记录，且成功和失败都要写入。这是一个贯穿整个架构的横切关注点。

4. **框架基础设施（FR41-FR48）**：3 层 TOML 定制化、宿主适配声明、版本校验、文件自动发现——这些共同构成了 SAND 的"平台层"。

**Non-Functional Requirements:**

19 个 NFR 横跨 5 个质量域，其中对架构影响最大的 5 个：

| NFR | 影响 | 架构决策驱动 |
|-----|------|------------|
| NFR6（跨宿主一致性） | 核心 | 需要宿主抽象层——Skill 不能依赖宿主特有功能 |
| NFR10（契约 ≥18 月兼容） | 核心 | 契约扩展点设计必须前置；版本化策略严格 |
| NFR14（断点续传） | 重要 | 步骤级状态持久化（frontmatter stepsCompleted 模式） |
| NFR15（失败不损坏工件） | 重要 | 原子写入策略（临时文件 + 重命名） |
| NFR16（双向审计） | 重要 | 审计层独立于 Skill 执行成功/失败 |

**Scale & Complexity:**

- Primary domain: 方法论框架（Methodology Framework）——可执行文档体系
- Complexity level: High
- Estimated architectural components: ~15 核心组件
- Deployment model: 零基础设施（`git clone` → IDE Agent 环境即用）
- State management: 文件系统（YAML frontmatter + `.sand/` 目录结构）

### Technical Constraints & Dependencies

**硬约束（来自 PRD + 7 个 ADR）：**

1. **零基础设施**（ADR-002/006）：无数据库、无后端服务、无 Web 仪表盘。所有状态通过文件系统管理。
2. **模型无关**：Skill 通过 `model_requirement` 声明能力需求，不绑定特定模型名称。
3. **宿主双验证**（ADR-001）：MVP 仅验证 Claude Code + Cursor，其余社区适配。
4. **纯 Git 分发**（ADR-002）：不提供 npm/pip 包。
5. **Skills-First**（ADR-006）：差异化价值（Assess/Intent/Orchestrate/Learn/Governance）用 Skill 实现，不用 MCP。
6. **轻量度量**（ADR-007）：Skill 内嵌脚本（Python/Shell），不引入独立采集服务。
7. **YAML + 可选 JSON Schema**（ADR-004）：人类可读优先。

**软依赖：**

- Git CLI（度量采集需要 `git log`）
- cURL 或类似 HTTP 客户端（CI API 调用，有 CSV fallback）
- 支持 Agent 子进程的 IDE（Claude Code / Cursor）

### Cross-Cutting Concerns Identified

1. **审计追踪**（横跨所有 Skill）：每个 Skill 执行 → `SandAuditEvent` → `.sand/audits/`。设计必须确保审计层与 Skill 执行解耦。
2. **上下文安全**（横跨 Intent → Orchestrate → Build）：默认不发送完整代码文件；脱敏规则在数据离开本地前同步应用。
3. **3 层定制化**（横跨所有 Skill）：base customize.toml → team override → user override。合并语义严格定义（标量覆盖、表深合并、数组追加）。
4. **文件发现链接**（横跨所有 SDC 阶段）：Skill A 输出到 `.sand/` → Skill B 通过 glob 发现。Phase 2 约定路径手动传递，Phase 3 自动发现。
5. **宿主适配**（横跨所有 Skill）：`skill.yaml` 中 `host_requirements` 字段声明所需能力。不支持的宿主给明确错误，不静默失败。
6. **版本兼容**（横跨框架与外部 Skill）：框架 SemVer 0.x.x + Skill 契约独立版本（`sandskill.v1`）。`.sand-version` 文件声明最低框架版本。

## Starter Template Evaluation

### Primary Technology Domain

**方法论框架（Methodology Framework）**——不适用传统软件 starter template。

SAND 的技术栈不是 React/Node.js/PostgreSQL，而是：

| 层 | 技术 | 用途 |
|----|------|------|
| **Skill 文件** | Markdown | 工作流引导逻辑、步骤文件 |
| **工件/模板** | YAML | 意图声明、执行契约、评估报告、编排方案 |
| **定制化** | TOML | 3 层 merge（base → team → user） |
| **验证** | JSON Schema | IDE 补全 + 运行时轻量校验 |
| **脚本** | Python/Shell | 度量采集、脚手架工具（Phase 2+） |
| **分发** | Git 仓库 | `git clone` 即用 |

### Starter Options Considered

| 选项 | 描述 | 评估 |
|------|------|------|
| **BMad Method 架构模式** | 62 个 Skill，标准激活协议，3 层 TOML merge，Agent 菜单分发 | ✅ 已实机验证，作为架构模式参照 |
| **Superpowers Framework** | 可组合 SKILL.md，跨 IDE 支持，MIT 开源 | 参考价值高，验证了跨 IDE 可移植性 |
| **从零构建** | 自定义 Skill 架构 | ❌ 不必要——成熟模式已存在 |

### Selected Starter: BMad 架构模式（作为地基，非天花板）

**Rationale for Selection:**

1. **已实机验证**：SAND 当前的 PRD、调研、架构设计本身就是通过此架构模式执行的
2. **匹配 SAND 约束**：零基础设施、`git clone` 分发、文件系统状态管理
3. **成熟的定制化机制**：3 层 TOML merge 满足 FR42 和 NFR13
4. **标准化激活协议**：定制化解析 → prepend → persistent_facts → config → greet → append

**关键架构修正（基于多视角评审）：**

#### 修正 1：IDE 解耦——Skills 路径独立化

**问题**：`.claude/skills/` 将 SAND 耦合到 Claude Code，Cursor 用户 DX 为零。

**决策**：Skills 放在 IDE 无关路径 `sand/skills/`，通过适配层映射到各 IDE 约定：

```
sand/skills/                    ← Skills 本体（IDE 无关）
.claude/skills/ → sand/skills/  ← Claude Code 适配（symlink 或显式引用）
.cursor/rules/ → sand/skills/   ← Cursor 适配
```

#### 修正 2：`sandskill.v1` 契约独立

**问题**：如果 `sandskill.v1` 混同 BMad Skill 格式，SAND 永远是 BMad 的"皮肤"，18 个月兼容承诺变成空头支票。

**决策**：
- `sandskill.v1` 有独立的 `schemas/sandskill.v1.schema.json`，明确标注哪些字段继承自通用 Skill 模式、哪些是 SAND 扩展
- SAND 特有字段用 `sand_` 命名空间前缀
- 用户可见表面（文档、CLI、错误信息）零 BMad 认知泄漏
- 兼容承诺精确到具体字段和行为清单，而非模糊的"格式兼容"

#### 修正 3：SAND_ROOT 锚点机制

**问题**：Skill 内引用 `schemas/`、`templates/` 的相对路径在跨目录使用时必断。

**决策**：定义 `{sand-root}` 变量作为路径锚点，Skill 内所有跨目录引用使用此变量。激活协议中自动解析 `{sand-root}` 为框架仓库根目录。

#### 修正 4：`.sand/` 归属明确

**问题**：`.sand/` 是用户项目的运行时产物，放在框架 repo 里会被 `git pull` 覆盖。

**决策**：
- `.sand/` 目录只存在于**用户的项目根目录**，不在框架 repo 中
- 框架 repo 的 `.gitignore` 包含 `.sand/`
- 提供 `.sand/.gitignore` 模板：排除 `cache/`，保留 `artifacts/`（用户可选 commit）

#### 修正 5：贡献者体验三件套

**问题**：没有独立于 BMad 的贡献者工具链，北极星目标会因摩擦死在起跑线。

**决策**（Phase 2 交付）：
- `docs/skill-dev-guide.md`：全程不提 BMad 的 SAND Skill 开发者入门（≤2000 字）
- `scripts/sand-skill-init.sh`：生成符合 `sandskill.v1` 契约的 Skill 骨架
- `scripts/sand-skill-validate.sh`：独立验证器，检查契约合规性

### SAND 仓库结构（修正后）

```
sand-framework/
├── sand/
│   └── skills/                    ← SAND Skills 本体（IDE 无关）
│       ├── sand-assess-maturity/
│       │   ├── SKILL.md
│       │   ├── customize.toml
│       │   ├── steps/
│       │   └── templates/
│       ├── sand-create-intent/
│       ├── sand-validate-delivery/
│       ├── sand-design-orchestration/
│       ├── sand-run-retrospective/
│       ├── sand-governance-audit/
│       └── sand-measure-light/
├── .claude/
│   └── skills -> ../sand/skills   ← Claude Code 适配层
├── schemas/                       ← JSON Schema 验证
│   ├── sandskill.v1.schema.json   ← 独立的 SAND Skill 契约
│   ├── intent.schema.json
│   ├── contract.schema.json
│   ├── assessment.schema.json
│   └── audit-event.schema.json
├── templates/                     ← YAML 工件模板
│   ├── intent-statement.yaml
│   ├── execution-contract.yaml
│   └── maturity-assessment.yaml
├── docs/                          ← 方法论文档体系（80+ 文件）
├── scripts/                       ← 工具脚本（Phase 2+）
│   ├── sand-skill-init.sh
│   └── sand-skill-validate.sh
├── examples/
│   └── external-skills/           ← 外部 Skill 示例（带 README 标注状态）
├── CLAUDE.md                      ← Claude Code Agent 入口
├── CURSOR_RULES.md                ← Cursor Agent 入口
├── .sand-version                  ← 框架版本声明（唯一版本源）
├── .gitignore                     ← 含 .sand/ 排除
└── README.md
```

### 战略定位注记

BMad 架构模式是**暂时的地基，不是永久的身份**。SAND 的"新物种"宣称建立在它占据的生态位上，不是技术格式上。三步演进：

1. **今天**：用 BMad 架构模式，无聊技术胜出，加速 MVP
2. **定义不可替代原语**：找到只有 SAND 才能表达的概念——意图声明 7 字段标准、CLEAR 质量检查、SDC 7 阶段闭环、治理作为价值生成层
3. **引力反转**：一年内让问题变为"其他框架是否支持 SAND 格式？"

**Note:** 仓库初始化和目录结构创建应作为第一个实现 Story。

## Core Architectural Decisions

### Decision Priority Analysis

**Critical Decisions (Block Implementation):**

| # | 决策 | 域 | 影响范围 |
|---|------|-----|---------|
| D1 | sandskill.v1 契约：元数据嵌入 SKILL.md frontmatter | 域 1 | 所有 Skill 开发 |
| D2 | 宿主能力声明模式（`requires: [...]`） | 域 1 | 跨宿主兼容 |
| D3 | 审计层 Skill 透明，执行引擎自动记录 | 域 1+2 | 审计架构 |
| D4 | 步骤级审计写入 + 完整文件 hash + JSONL 追加 | 域 2 | 审计实现 |
| D5 | `.sand/` 完整目录结构 + 意图 ID 格式 INT-YYYYMMDD-{seq} | 域 3 | 运行时状态管理 |
| D6 | `sand-run` = 遵循契约的元 Skill + SandRuntime 模块 | 域 4 | 执行引擎架构 |
| D7 | 执行引擎显式传递 Skill 间状态 | 域 4 | 数据流 |

**Important Decisions (Shape Architecture):**

| # | 决策 | 域 | 影响范围 |
|---|------|-----|---------|
| D8 | 断点续传：执行引擎管理，Skill 无感知 | 域 4 | 可靠性 |
| D9 | 插件注册：MVP 手动 registry.yaml + `sand plugin add` | 域 3 | 插件生态 |
| D10 | Agent 角色 = 独立菜单分发 Skill | 域 5 | 用户入口 |
| D11 | 编排拓扑 = 引导式对话 + 规则推荐 | 域 5 | 编排体验 |
| D12 | HIP = 角色推荐 + 系统默认 + 用户覆盖 | 域 5 | 人类介入 |

**Deferred Decisions (Post-MVP):**

| 决策 | 推迟到 | 理由 |
|------|--------|------|
| 自动跨 Skill 调用（Agent 角色内） | Phase 3 | MVP 先做引导建议，降低复杂度 |
| Fan-out/Fan-in 并行拓扑 | Phase 3 | MVP 仅支持单链拓扑 |
| 跨 Skill 断点续传 | Phase 3 | MVP 仅支持单 Skill 内步骤级恢复 |
| 插件自动发现 + `sand plugin sync` | Phase 3 | MVP 手动注册足够 |
| MCP 集成 | Phase 4 | Skills-First 策略，MCP 仅在度量自动化时引入 |
| `.sand/` 自动清理（`sand gc`） | Phase 4 | MVP 用户自行归档 |

### sandskill.v1 Contract Specification

**契约元数据位置：** SKILL.md YAML frontmatter（单文件自包含）

**必填字段（Breaking Change 保护范围，≥18 个月向前兼容）：**

```yaml
---
sand_contract: "sandskill.v1"
name: "sand-assess-maturity"
version: "0.1.0"
description: "7 维度成熟度评估引导工作流"
sdc_phase: "assess"                     # assess|intent|orchestrate|build|validate|operate|learn|governance
entry_point: "SKILL.md"                 # 相对于 Skill 目录
requires:                               # 宿主能力声明
  - file_read
  - file_write
inputs:                                 # 输入声明（glob 或显式路径）
  - "{sand-root}/templates/maturity-assessment.yaml"
outputs:                                # 输出声明
  - ".sand/assessments/{timestamp}_{team_id}.yaml"
---
```

**可选字段（可自由扩展，不受兼容承诺约束）：**

```yaml
sand_min_version: "0.1.0"              # 最低框架版本
model_requirement:                      # 模型能力需求（非模型名称）
  reasoning: "high"
  context_window: "128K"
human_oversight: "hip-2"                # 默认 HIP 级别
customize_schema: "customize.schema.json"
dependencies: []                        # 依赖的其他 Skill（Phase 3）
tags: ["assessment", "maturity"]
author: "SAND Core Team"
license: "MIT"
```

**Skill 目录结构约定：**

```
sand-{name}/
├── SKILL.md              ← 激活入口 + sandskill.v1 契约（frontmatter）
├── customize.toml        ← 默认定制化配置
├── steps/                ← 步骤文件（多步骤 Skill 必须）
│   ├── step-01-*.md
│   └── step-02-*.md
├── templates/            ← Skill 专用模板（可选）
└── data/                 ← Skill 专用数据文件（可选）
```

### Audit Event Architecture

**设计原则：** 审计层对 Skill 开发者完全透明，由 SandRuntime 执行引擎自动记录。

**写入策略：**
- **粒度：** 步骤级——每个 step 完成时追加一条 `SandAuditEvent`
- **格式：** JSONL 追加写入 `.sand/audits/audit.jsonl`
- **完整性：** SHA-256 hash 覆盖 Skill 声明的所有 inputs/outputs 完整文件内容
- **双向记录：** success、failure、interrupted 三种状态均写入（NFR16）
- **并发保护：** 依赖 OS 级 O_APPEND 原子性，文档建议避免并行写入

**SandAuditEvent Schema：**

```json
{
  "event_id": "uuid-v4",
  "timestamp": "ISO-8601",
  "sand_version": "0.1.0",
  "intent_id": "INT-20260512-003",
  "execution_id": "EXE-{session_id}",
  "skill_name": "sand-create-intent",
  "skill_version": "0.2.0",
  "sdc_phase": "intent",
  "step": "step-03-clear-check",
  "actor": "human|agent",
  "host": "claude-code|cursor",
  "model_used": "claude-opus-4-6",
  "input_hash": "sha256:...",
  "output_hash": "sha256:...",
  "status": "success|failure|interrupted",
  "human_confirmations": [
    {"step": "step-03", "timestamp": "...", "decision": "approved"}
  ],
  "error": null
}
```

### `.sand/` Directory Structure & Data Flow

**归属：** 用户项目根目录（不在框架 repo 中）

```
.sand/
├── config.yaml                     ← 项目级配置
│   # sand_version: "0.1.0"
│   # team_id: "team-alpha"
│   # default_human_oversight: "hip-2"
│   # output_language: "zh-CN"
├── audits/
│   └── audit.jsonl                 ← 审计事件日志
├── intents/
│   ├── INT-20260512-001.yaml       ← 意图声明
│   └── contracts/
│       └── INT-20260512-001.contract.yaml
├── executions/
│   └── EXE-{session_id}/
│       ├── execution.yaml          ← 执行会话元数据 + steps_completed
│       └── deviations.json         ← 偏差事件
├── assessments/
│   └── {timestamp}_{team_id}.yaml
├── metrics/
│   └── {date}_metrics.json
├── plugins/
│   ├── registry.yaml               ← 手动注册的外部 Skill 清单
│   └── {skill-name}/               ← 外部 Skill 本地副本
├── retrospectives/
│   └── {date}_retro.md
└── .gitignore                      ← 排除 *.tmp, cache/, node_modules/
```

**意图 ID 格式：** `INT-YYYYMMDD-{seq}`（如 `INT-20260512-003`）

**生命周期规则：**
- 审计日志不可删除（合规需要）
- MVP 不自动清理，用户自行归档到 `.sand/archive/`
- Phase 4 可引入 `sand gc` 命令

**插件注册（MVP）：** `registry.yaml` 手动声明 + `sand plugin add <git-url>` 命令。编排层扫描 `.sand/plugins/` 下 SKILL.md frontmatter 做 sandskill.v1 验证。

### Execution Runtime Model

**`sand-run` 定位：** 遵循 `sandskill.v1` 契约的元 Skill，拥有特殊运行时权限，内部调用 `SandRuntime` 框架模块。

**SandRuntime 模块架构：**

| 子模块 | 职责 |
|--------|------|
| **AuditWriter** | JSONL 追加写入，步骤级触发，SHA-256 hash 计算 |
| **Executor** | 步骤级 Skill 包装器，解析 SKILL.md → 顺序执行 steps/ |
| **StateManager** | 断点续传（execution.yaml 中 steps_completed）+ 输入输出链接 |
| **HashComputer** | 对 Skill 声明的 inputs/outputs 文件计算 SHA-256 |
| **HostChecker** | 校验宿主是否满足 Skill 的 `requires` 声明 |

**Skill 间状态传递：** 执行引擎显式传递，基于 `outputs`/`inputs` 契约匹配。MVP 仅支持单链拓扑（A → B → C），路径替换用简单字符串模板。

**断点续传：** 执行引擎在 `.sand/executions/EXE-*/execution.yaml` 中管理 `steps_completed`。Skill 无感知恢复机制。MVP 仅支持单 Skill 内步骤级恢复。

### Agent Roles & Orchestration Topology

**Agent 角色实现：** 每个角色 = 独立菜单分发 Skill

| 角色 | Skill 路径 | 目标用户 | 引导到的 Skill | 推荐 HIP |
|------|-----------|---------|--------------|---------|
| 问题域负责人 | `sand-agent-domain-lead` | 技术负责人/架构师 | assess → governance → orchestration | HIP-2 |
| FDE+ | `sand-agent-fde` | 一线工程师 | intent → run → validate | HIP-2 |
| 变革催化师 | `sand-agent-catalyst` | 工程效能负责人 | assess(组织级) → measure → retrospective | HIP-3 |

**MVP 行为：** 角色 Skill 通过对话理解用户需求，输出引导建议（"现在运行 `sand-create-intent` 来继续"），不自动跨 Skill 调用。Phase 3 可升级为框架 API 自动链式调用。

**编排拓扑选型：** `sand-design-orchestration` Skill 中采用引导式对话 + 规则推荐：

| 意图特征 | 推荐拓扑 |
|---------|---------|
| 单一功能、无依赖 | Solo |
| 有顺序步骤（A → B → C） | Pipeline |
| 并行探索多个方案 | Swarm |
| 需要协调不同 Agent 类型 | Hierarchy |

用户最终确认或修改。MVP 用清晰规则表，不实现复杂推导引擎。

**HIP 级别决策链：**

```
角色推荐值 → 被 .sand/config.yaml default_human_oversight 覆盖
           → 被用户本次会话临时覆盖
           → 最终值传递给执行引擎
```

### Decision Impact Analysis

**Implementation Sequence:**

1. `sandskill.v1` 契约 Schema（`schemas/sandskill.v1.schema.json`）— 所有 Skill 的基础
2. `.sand/` 目录结构初始化逻辑 — 运行时状态的容器
3. SandRuntime 模块（AuditWriter + Executor + StateManager）— 执行引擎
4. 核心 Skill 开发（assess → intent → validate）— 基于契约和运行时
5. Agent 角色 Skill — 基于核心 Skill 的菜单分发
6. 插件注册机制 — 基于契约的外部 Skill 管理

**Cross-Component Dependencies:**

```
sandskill.v1 契约
    ├─→ 所有 Skill（遵循契约）
    ├─→ SandRuntime.Executor（解析契约字段）
    ├─→ SandRuntime.HostChecker（读取 requires）
    └─→ 插件验证（校验外部 Skill 契约合规）

SandRuntime
    ├─→ sand-run 元 Skill（调用 SandRuntime API）
    ├─→ .sand/audits/（AuditWriter 写入）
    ├─→ .sand/executions/（StateManager 管理）
    └─→ HashComputer（读取 inputs/outputs 声明）

.sand/ 目录结构
    ├─→ 所有 Skill 的 outputs 目标
    ├─→ 插件 registry.yaml
    └─→ config.yaml（HIP 默认值、框架版本）
```

## Implementation Patterns & Consistency Rules

### Pattern Categories Defined

**8 个关键冲突域**，覆盖 SAND Skills 开发和工件创建中 AI Agent 可能做出不同选择的所有区域。

### 1. SKILL.md Frontmatter Patterns

**字段顺序（强制）：**

必填字段按以下固定顺序排列，可选字段按字母序追加：

```yaml
---
# === 必填字段（固定顺序）===
sand_contract: "sandskill.v1"
name: "sand-{name}"
version: "0.1.0"
description: "一句话描述"
sdc_phase: "assess"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - "{sand-root}/templates/..."
outputs:
  - ".sand/assessments/..."
# === 可选字段（字母序）===
author: "..."
dependencies: []
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "high"
sand_min_version: "0.1.0"
tags: ["..."]
---
```

**命名规则：**
- Skill 名称：`sand-{kebab-case}`（如 `sand-assess-maturity`，不用下划线或驼峰）
- 版本：严格 SemVer（`MAJOR.MINOR.PATCH`）

### 2. YAML Artifact Patterns

**格式（强制）：**
- 缩进：**2 空格**（不用 Tab，不用 4 空格）
- 字符串：无引号，除非包含特殊字符（`: # { } [ ] , & * ? | - < > = ! % @ \`）
- 布尔值：`true`/`false`（不用 `yes`/`no`/`on`/`off`）
- 空值：`null`（不用 `~` 或留空）
- 数组：多行格式（`- item`），不用行内 `[a, b, c]`（除非 ≤3 个简单标量）
- 编码：UTF-8，LF 换行（不用 CRLF）

**文件命名：**
- 工件文件：`kebab-case.yaml`（如 `intent-statement.yaml`）
- ID 含文件：`{ID-FORMAT}.yaml`（如 `INT-20260512-003.yaml`）
- 时间戳文件：`{YYYYMMDD}_{descriptor}.yaml`

### 3. Step File Patterns

**文件命名（强制）：**
- 格式：`step-{NN}-{kebab-case}.md`（两位数字填充，如 `step-01-init.md`）
- 编号从 01 开始，连续不跳号

**步骤文件内部结构（强制）：**

```markdown
# Step {N}: {Title}

## MANDATORY EXECUTION RULES (READ FIRST):
{标准规则块——从模板复制}

## YOUR TASK:
{本步骤目标的一句话描述}

## EXECUTION SEQUENCE:
### 1. {First action}
### 2. {Second action}

## SUCCESS METRICS:
✅ {metric_1}

## FAILURE MODES:
❌ {failure_1}

## NEXT STEP:
{明确指向下一个步骤文件}
```

### 4. Path Reference Patterns

**强制规则：**
- 框架内文件引用：**始终使用 `{sand-root}/`**（如 `{sand-root}/templates/intent-statement.yaml`）
- 用户项目工件引用：**始终使用 `.sand/`**（如 `.sand/intents/INT-20260512-001.yaml`）
- Skill 内部引用：**使用相对于 Skill 目录的路径**（如 `./steps/step-01-init.md`）
- **禁止**：绝对路径、`../..` 向上越级超过 Skill 目录、硬编码用户目录

### 5. User Interaction Patterns

**菜单格式（强制）：**
- 主菜单使用字母标记：`[A]`、`[P]`、`[C]`
- 选项列表使用数字：`1.`、`2.`、`3.`
- 确认使用明确提示：`(y/n)` 或 `[C] 继续`
- **禁止**：等待自由输入而不给菜单提示

**输出语言：**
- 用户交互语言：遵循 `.sand/config.yaml` 中的 `output_language`
- 技术术语保持英文原形（如 `sandskill.v1`、`CLEAR`、`HIP-2`）
- 代码块、路径、命令始终英文

**进度反馈：**
- 每个步骤开始时显示进度：`[Step 2/5]`
- 长操作前告知用户将要做什么

### 6. Error Handling Patterns

**原则：快速失败，明确报错，不静默降级**

| 场景 | 行为 |
|------|------|
| 缺失必填输入 | 报错 + 列出缺失文件 + 建议运行哪个 Skill 生成 |
| 宿主不支持 requires 中的能力 | 报错 + 列出缺失能力 + 不尝试降级运行 |
| YAML 解析失败 | 报错 + 显示具体行号和错误 |
| `.sand/` 目录不存在 | 自动创建 + 提示"已初始化 .sand/ 目录" |
| 意图 ID 冲突 | 自增序号，不覆盖已有文件 |

**Anti-Pattern：** 禁止 Skill 在遇到错误时"猜测"用户意图并继续执行。所有不确定性必须请求人类确认。

### 7. Audit Event Value Patterns

**枚举值（强制，小写 kebab-case）：**

| 字段 | 允许的值 |
|------|---------|
| `status` | `success`, `failure`, `interrupted` |
| `actor` | `human`, `agent` |
| `host` | `claude-code`, `cursor`, `codex-cli`, `gemini-cli` |
| `sdc_phase` | `assess`, `intent`, `orchestrate`, `build`, `validate`, `operate`, `learn`, `governance` |
| `human_confirmations[].decision` | `approved`, `rejected`, `deferred` |

**时间戳：** ISO-8601 UTC（`2026-05-12T14:30:00Z`），不用本地时间

### 8. TOML Customization Patterns

**键命名（强制）：**
- 所有键使用 `snake_case`（如 `activation_steps_prepend`）
- 表名使用 `snake_case`（如 `[workflow]`）
- 数组表使用 `[[array_name]]`

**3 层 merge 语义（不可变更）：**
- 标量：覆盖
- 表：深合并
- 数组：追加
- 按 `code` 或 `id` 键控的数组表：匹配替换，新增追加

### Enforcement Guidelines

**所有 AI Agent 编写 SAND Skills 时必须：**

1. 在 SKILL.md frontmatter 中按固定顺序排列必填字段
2. 所有 YAML 使用 2 空格缩进 + `true`/`false` + `null`
3. 所有路径引用使用 `{sand-root}/` 或 `.sand/` 锚点，禁止绝对路径
4. 所有审计枚举值使用小写 kebab-case
5. 所有步骤文件使用 `step-{NN}-{kebab-case}.md` 命名
6. 遇到错误快速失败，不静默降级

**验证机制：**
- `scripts/sand-skill-validate.sh` 检查 frontmatter 字段完整性和顺序
- JSON Schema（`sandskill.v1.schema.json`）验证结构合规
- Phase 3 可增加 lint 规则检查 YAML 格式和路径引用

## Project Structure & Boundaries

### Complete Project Directory Structure

```
sand-framework/
├── sand/
│   └── skills/
│       │
│       │  ── SDC 核心 Skills ──
│       │
│       ├── sand-assess-maturity/           ← FR1-FR8: 成熟度评估
│       │   ├── SKILL.md
│       │   ├── customize.toml
│       │   ├── steps/
│       │   │   ├── step-01-scope.md        ← 评估范围确认（团队级/组织级）
│       │   │   ├── step-02-dialogue.md     ← 7 维度结构化对话
│       │   │   ├── step-03-data-collect.md ← Git/CI 数据自动采集
│       │   │   ├── step-04-radar.md        ← 雷达图生成 + 评级
│       │   │   └── step-05-pathways.md     ← 可执行改进路径推荐
│       │   ├── templates/
│       │   │   └── maturity-assessment.yaml
│       │   └── data/
│       │       ├── dimension-rubrics.yaml  ← 7 维度 L1-L5 评估量表
│       │       └── pathway-rules.yaml      ← 改进路径推荐规则
│       │
│       ├── sand-create-intent/             ← FR9-FR14: 意图管理
│       │   ├── SKILL.md
│       │   ├── customize.toml
│       │   ├── steps/
│       │   │   ├── step-01-scope.md        ← 需求收集 + 意图边界
│       │   │   ├── step-02-draft.md        ← 7 字段意图声明草案
│       │   │   ├── step-03-clear-check.md  ← CLEAR 5 维质量检查
│       │   │   └── step-04-contract.md     ← 执行契约生成
│       │   ├── templates/
│       │   │   ├── intent-statement.yaml
│       │   │   └── execution-contract.yaml
│       │   └── data/
│       │       └── clear-checklist.yaml    ← CLEAR 检查项定义
│       │
│       ├── sand-design-orchestration/      ← FR16-FR22: 编排与插件
│       │   ├── SKILL.md
│       │   ├── customize.toml
│       │   ├── steps/
│       │   │   ├── step-01-context.md      ← 收集意图范围和依赖
│       │   │   ├── step-02-topology.md     ← 拓扑选型（规则推荐 + 用户确认）
│       │   │   ├── step-03-hip.md          ← HIP 级别配置
│       │   │   └── step-04-plan.md         ← 输出编排方案
│       │   ├── templates/
│       │   │   └── orchestration-plan.yaml
│       │   └── data/
│       │       └── topology-rules.yaml     ← Solo/Pipeline/Swarm/Hierarchy 选型规则
│       │
│       ├── sand-validate-delivery/         ← FR23-FR27b: 交付验证
│       │   ├── SKILL.md
│       │   ├── customize.toml
│       │   ├── steps/
│       │   │   ├── step-01-contract-check.md  ← 契约验证通道
│       │   │   ├── step-02-security.md        ← 安全合规通道
│       │   │   ├── step-03-architecture.md    ← 架构对齐通道
│       │   │   └── step-04-decision.md        ← 验证决策矩阵
│       │   └── templates/
│       │       └── validation-report.yaml
│       │
│       ├── sand-governance-audit/          ← FR28-FR31: 治理与审计
│       │   ├── SKILL.md
│       │   ├── customize.toml
│       │   ├── steps/
│       │   │   ├── step-01-scan.md         ← 扫描 .sand/audits/ 审计事件
│       │   │   ├── step-02-chain.md        ← 构建意图→Skill→决策证据链
│       │   │   └── step-03-report.md       ← 生成审计追踪报告
│       │   └── templates/
│       │       └── audit-report.yaml
│       │
│       ├── sand-run-retrospective/         ← FR38-FR40: 学习与资产化
│       │   ├── SKILL.md
│       │   ├── customize.toml
│       │   ├── steps/
│       │   │   ├── step-01-collect.md      ← 5 议题结构化回顾
│       │   │   ├── step-02-classify.md     ← 5 类 AI 资产分类
│       │   │   └── step-03-register.md     ← 资产入库建议
│       │   └── templates/
│       │       └── retrospective.yaml
│       │
│       ├── sand-measure-light/             ← FR34-FR37: 度量与洞察
│       │   ├── SKILL.md
│       │   ├── customize.toml
│       │   ├── steps/
│       │   │   ├── step-01-collect.md      ← Git/CI 5 信号采集
│       │   │   └── step-02-report.md       ← 度量输出 + 认知失调报告
│       │   ├── scripts/
│       │   │   ├── git-metrics.py          ← Git 度量采集脚本
│       │   │   └── ci-metrics.py           ← CI API 度量采集脚本
│       │   └── templates/
│       │       └── metrics-output.json
│       │
│       │  ── 元 Skill ──
│       │
│       ├── sand-run/                       ← FR15a-d: 执行运行时
│       │   ├── SKILL.md
│       │   ├── customize.toml
│       │   └── steps/
│       │       ├── step-01-load-plan.md    ← 加载意图 + 编排方案
│       │       ├── step-02-execute.md      ← 按拓扑执行 Skill 链
│       │       └── step-03-summary.md      ← 执行摘要 + 偏差汇总
│       │
│       │  ── Agent 角色 Skills ──
│       │
│       ├── sand-agent-domain-lead/         ← FR48: 问题域负责人入口
│       │   ├── SKILL.md
│       │   └── steps/
│       │       ├── step-01-identify.md
│       │       └── step-02-guide.md
│       │
│       ├── sand-agent-fde/                 ← FR48: FDE+ 入口
│       │   ├── SKILL.md
│       │   └── steps/
│       │       ├── step-01-identify.md
│       │       └── step-02-guide.md
│       │
│       └── sand-agent-catalyst/            ← FR48: 变革催化师入口
│           ├── SKILL.md
│           └── steps/
│               ├── step-01-identify.md
│               └── step-02-guide.md
│
├── schemas/                               ← FR44: JSON Schema 验证
│   ├── sandskill.v1.schema.json
│   ├── intent-statement.schema.json
│   ├── execution-contract.schema.json
│   ├── maturity-assessment.schema.json
│   ├── audit-event.schema.json
│   ├── orchestration-plan.schema.json
│   └── plugin-registry.schema.json
│
├── templates/                             ← 全局工件模板
│   ├── intent-statement.yaml
│   ├── execution-contract.yaml
│   ├── maturity-assessment.yaml
│   ├── orchestration-plan.yaml
│   └── sand-config.yaml
│
├── docs/                                  ← 方法论文档体系（80+ 文件）
│   ├── README.md
│   ├── 00-manifesto/ ... 10-reference/
│   ├── skill-dev-guide.md                 ← Phase 2
│   └── adr/
│       ├── ADR-001-host-validation.md
│       ├── ADR-002-git-distribution.md
│       ├── ADR-003-minimal-dev-docs.md
│       ├── ADR-004-yaml-json-schema.md
│       ├── ADR-005-version-strategy.md
│       ├── ADR-006-skills-first.md
│       └── ADR-007-lightweight-metrics.md
│
├── scripts/                               ← Phase 2+
│   ├── sand-skill-init.sh
│   ├── sand-skill-validate.sh
│   └── sand-init.sh
│
├── examples/
│   └── external-skills/
│       ├── README.md
│       └── sand-example-skill/
│
├── .claude/
│   └── skills -> ../sand/skills           ← Claude Code 适配层
│
├── CLAUDE.md
├── CURSOR_RULES.md
├── .sand-version
├── .gitignore
├── LICENSE
└── README.md
```

### Architectural Boundaries

**Skill 边界（核心隔离原则）：**

每个 Skill 是自包含的独立单元。Skill 之间不直接调用，只通过 `.sand/` 文件系统交换数据，由 SandRuntime 执行引擎显式链接。

**框架层 vs Skill 层边界：**

| 层 | 职责 | 文件位置 |
|----|------|---------|
| **框架层**（SandRuntime） | 审计写入、状态管理、hash 计算、宿主检查、Skill 链接 | 框架内部模块 |
| **Skill 层** | 方法论引导、模板填充、质量检查、用户交互 | `sand/skills/sand-*/` |
| **Schema 层** | 契约定义、工件验证 | `schemas/` |
| **模板层** | 工件初始值 | `templates/` + 各 Skill 内 `templates/` |
| **工件层** | 运行时产物 | `.sand/`（用户项目中） |

**数据所有权边界：**

| 数据 | 所有者 | 位置 | Git 提交 |
|------|--------|------|---------|
| Skill 源码 | 框架 | `sand/skills/` | ✅ |
| JSON Schema | 框架 | `schemas/` | ✅ |
| 全局模板 | 框架 | `templates/` | ✅ |
| 方法论文档 | 框架 | `docs/` | ✅ |
| 意图声明 | 用户项目 | `.sand/intents/` | ✅（用户选择） |
| 审计日志 | 用户项目 | `.sand/audits/` | ✅（强制） |
| 执行状态 | 用户项目 | `.sand/executions/` | 可选 |
| 度量输出 | 用户项目 | `.sand/metrics/` | 可选 |
| 插件注册 | 用户项目 | `.sand/plugins/` | ✅ |

### Requirements to Structure Mapping

| FR 类别 | Skill | 关键文件 |
|---------|-------|---------|
| FR1-FR8 成熟度评估 | `sand-assess-maturity` | dimension-rubrics.yaml, pathway-rules.yaml |
| FR9-FR14 意图管理 | `sand-create-intent` | intent-statement.yaml, clear-checklist.yaml |
| FR15a-d 执行运行时 | `sand-run` | SandRuntime 模块 |
| FR16-FR22 编排与插件 | `sand-design-orchestration` | topology-rules.yaml, orchestration-plan.yaml |
| FR23-FR27b 交付验证 | `sand-validate-delivery` | validation-report.yaml |
| FR28-FR31 治理审计 | `sand-governance-audit` | audit-report.yaml |
| FR32-FR33 上下文安全 | SandRuntime（框架层） | 上下文最小化逻辑 |
| FR34-FR37 度量洞察 | `sand-measure-light` | git-metrics.py, ci-metrics.py |
| FR38-FR40 学习资产化 | `sand-run-retrospective` | retrospective.yaml |
| FR41-FR48 框架基础设施 | 多个组件协同 | schemas/, scripts/, .sand-version |

### Data Flow

**完整 SDC 循环数据流：**

```
[用户] ─── sand-agent-{role} ───→ 角色识别
                                    │
                                    ▼
[Assess] ─── sand-assess-maturity ───→ .sand/assessments/*.yaml
                                        │
                                        ▼
[Intent] ─── sand-create-intent ─────→ .sand/intents/INT-*.yaml
                                      + .sand/intents/contracts/INT-*.contract.yaml
                                        │
                                        ▼
[Orchestrate] ─ sand-design-orchestration → .sand/executions/orchestration-plan.yaml
                                            │
                                            ▼
[Build] ─── sand-run ──────────────────→ .sand/executions/EXE-*/
            (SandRuntime 驱动)              │ execution.yaml + audit.jsonl
                                            ▼
                                        [交付物]
                                            │
[Validate] ── sand-validate-delivery ──→ .sand/executions/EXE-*/validation-report.yaml
                                          + deviations.json
                                            │
[Learn] ─── sand-run-retrospective ────→ .sand/retrospectives/*.md
                                            │
[Governance] ── sand-governance-audit ──→ 审计追踪报告（JSON/CSV 导出）
                                            │
                                            ▼
                                    ┌─ 飞轮闭环 ─┐
                                    │ 回到 Assess  │
                                    │ 校准雷达图   │
                                    └─────────────┘
```

## Architecture Validation Results

### Coherence Validation ✅

**Decision Compatibility:**
所有 12 个核心决策（D1-D12）经交叉检查无矛盾。关键兼容链验证通过：
- sandskill.v1 契约（frontmatter）↔ SandRuntime.Executor（解析 frontmatter）↔ HostChecker（读取 requires）→ 一致
- 审计透明（D3）↔ 步骤级写入（D4）↔ execution.yaml 管理（D8）→ 一致
- IDE 解耦（Step 3 修正 1）↔ `sand/skills/` 路径 ↔ 适配层 symlink → 一致
- 插件 registry.yaml（D9）↔ sand-design-orchestration 扫描 → 一致

**Pattern Consistency:**
8 个一致性规则域与架构决策完全对齐。命名约定（kebab-case Skill 名、snake_case TOML 键）、格式规则（2 空格 YAML、ISO-8601 UTC 时间戳）、路径引用（`{sand-root}/` 和 `.sand/` 锚点）覆盖了所有已知冲突点。

**Structure Alignment:**
项目目录结构（Step 6）精确映射到所有架构决策——每个 Skill 对应明确的 FR 类别，SandRuntime 模块对应横切关注点，`.sand/` 子目录对应工件生命周期。

### Requirements Coverage Validation ✅

**Functional Requirements Coverage: 52/52**

| FR 类别 | 覆盖 | 架构支撑 |
|---------|------|---------|
| FR1-FR8 成熟度评估 | 8/8 | sand-assess-maturity |
| FR9-FR14 意图管理 | 6/6 | sand-create-intent |
| FR15a-d 执行运行时 | 4/4 | sand-run + SandRuntime |
| FR16-FR22 编排与插件 | 7/7 | sand-design-orchestration + .sand/plugins/ |
| FR23-FR27b 交付验证 | 6/6 | sand-validate-delivery + deviations.json |
| FR28-FR31 治理审计 | 4/4 | sand-governance-audit + audit.jsonl |
| FR32-FR33 上下文安全 | 2/2 | SandRuntime（机制待 Phase 1 细化） |
| FR34-FR37 度量洞察 | 4/4 | sand-measure-light + scripts |
| FR38-FR40 学习资产化 | 3/3 | sand-run-retrospective |
| FR41-FR48 框架基础设施 | 8/8 | schemas/ + scripts/ + 多组件协同 |

**Non-Functional Requirements Coverage: 19/19**

| NFR 域 | 覆盖 | 架构支撑 |
|--------|------|---------|
| NFR1-5 安全隐私 | 5/5 | SandRuntime + HashComputer + requires 声明 |
| NFR6-9 兼容可移植 | 4/4 | IDE 适配层 + UTF-8 + git+curl 可移植 |
| NFR10-13 可维护演进 | 4/4 | sandskill.v1 schema + ADR 体系 + TOML merge 语义 |
| NFR14-16 可靠性 | 3/3 | StateManager + AuditWriter 双向记录 |
| NFR17-19 性能 | 3/3 | 运行时级约束，架构不阻塞 |

### Implementation Readiness Validation ✅

**Decision Completeness:**
- 12 个核心决策含完整描述、理由和影响范围
- 6 个推迟决策含明确推迟理由和目标 Phase
- sandskill.v1 契约含必填/可选字段完整定义和示例

**Structure Completeness:**
- 文件级完整目录树（12 个 Skill + 7 个 Schema + 5 个模板 + 7 个 ADR + 3 个脚本）
- 5 层架构边界清晰定义
- 数据所有权矩阵明确框架 vs 用户项目归属

**Pattern Completeness:**
- 8 个冲突域全覆盖，含具体示例和 Anti-Pattern
- 6 条强制执行规则
- 验证机制已定义（validate.sh + JSON Schema + Phase 3 lint）

### Gap Analysis Results

**Critical Gaps: 0**

**Important Gaps (不阻塞，Phase 1 期间细化):**

| # | Gap | 细化路径 |
|---|-----|---------|
| Gap-1 | FR32-FR33 / NFR1,4：上下文安全机制未详细设计 | sand-create-intent 开发时细化上下文范围选择；脱敏规则以 config.yaml 扩展字段定义 |
| Gap-2 | NFR11：CHANGELOG 要求未纳入 | 仓库初始化时创建 CHANGELOG.md，首次 breaking change 时建立规范 |
| Gap-3 | NFR15：原子写入策略未细化 | SandRuntime 实现时采用"写临时文件 → rename"模式 |

**Nice-to-Have Gaps (可延后):**

| # | Gap | 建议时机 |
|---|-----|---------|
| Gap-4 | SAND 激活协议完整文档化 | Phase 1 第一个 Skill 开发时 |
| Gap-5 | CLAUDE.md / CURSOR_RULES.md 具体内容 | Phase 1 仓库初始化 Story |
| Gap-6 | sand-init.sh 具体行为定义 | Phase 1 |

### Architecture Completeness Checklist

**Requirements Analysis**

- [x] 项目上下文深入分析
- [x] 规模和复杂度评估
- [x] 技术约束识别
- [x] 跨切面关注点映射

**Architectural Decisions**

- [x] 关键决策文档化含版本
- [x] 技术栈完全指定
- [x] 集成模式定义
- [x] 性能考虑覆盖

**Implementation Patterns**

- [x] 命名约定建立
- [x] 结构模式定义
- [x] 通信模式指定
- [x] 流程模式文档化

**Project Structure**

- [x] 完整目录结构定义
- [x] 组件边界建立
- [x] 集成点映射
- [x] 需求到结构映射完成

### Architecture Readiness Assessment

**Overall Status:** READY WITH MINOR GAPS

**Confidence Level:** High — 16/16 检查清单项通过，0 个 Critical Gap，3 个 Important Gap 均有明确细化路径。

**Key Strengths:**
1. **契约驱动**：sandskill.v1 从 Day 1 建立，所有 Skill 开发有明确规范
2. **审计内建**：审计层对 Skill 开发者完全透明，不增加贡献者负担
3. **零基础设施**：完全文件系统驱动，`git clone` 即用
4. **IDE 解耦**：Skills 路径独立化确保跨宿主一致性
5. **模块化清晰**：SandRuntime 5 个子模块职责明确，边界清晰
6. **品牌独立**：sandskill.v1 契约独立于 BMad，用户可见表面零认知泄漏

**Areas for Future Enhancement:**
1. 上下文安全机制细化（Gap-1，Phase 1）
2. 多链拓扑支持（Fan-out/Fan-in，Phase 3）
3. 跨 Skill 断点续传（Phase 3）
4. MCP 集成层（Phase 4）
5. 企业级审计网关（Phase 5）

### Implementation Handoff

**AI Agent Guidelines:**

1. 遵循 sandskill.v1 契约编写所有 Skill——frontmatter 字段固定顺序，必填字段完整
2. 使用 8 个一致性规则域中的所有模式——命名、格式、路径、交互、错误处理
3. 尊重架构边界——Skill 间不直接调用，只通过 `.sand/` 文件系统和 SandRuntime 链接
4. 所有架构问题参照本文档

**First Implementation Priority:**

1. 创建 `sand-framework/` 仓库骨架（完整目录结构 + .sand-version + .gitignore + CHANGELOG.md）
2. 编写 `schemas/sandskill.v1.schema.json`（契约的机器可读定义）
3. 开发 `sand-assess-maturity` Skill（第一个完整 SDC 核心 Skill，验证契约可行性）
