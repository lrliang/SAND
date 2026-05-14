# 上下文工程

上下文四层次（项目/意图/历史/协作）、上下文质量评估模型（完整性/准确性/精简性/可发现性）、上下文金字塔、上下文资产组织形态。

---

## 概述

上下文工程（Context Engineering）是 SAND 编排阶段子过程 O1 的核心能力。它回答一个根本问题：**AI Agent 在执行任务前，应该"看到"什么信息？** 上下文的质量直接决定 Agent 输出的质量——过少导致幻觉，过多导致"中间迷失"（Lost in the Middle），泄露过度则威胁安全。

**理论基础：**

- **Andrej Karpathy (2025)** [待验证]：推广"上下文工程"概念，取代 Prompt Engineering 成为 AI 开发核心能力
- **Patrick Debois (2025)**：提出 Context Development Lifecycle (CDLC)——Generate → Evaluate → Distribute → Observe——类比传统 SDLC 的上下文管理全生命周期
- 核心区分：Prompt Engineering = 选择正确的提问措辞；Context Engineering = 在提问之前**设计整个信息环境**

上下文工程在 SAND 中同时服务两个目标：**最大化 Agent 效能**（给够信息）和**最小化安全风险**（不给多余信息）。

---

## 上下文四层次

SAND 将 Agent 可用的上下文分为四个层次，每层有不同的来源、生命周期和安全敏感度：

### 第一层：项目上下文（Project Context）

**定义：** 项目级的持久化知识——架构约定、编码规范、技术栈版本、目录结构。

| 维度 | 说明 |
|------|------|
| **来源** | `CLAUDE.md`、`project-context.md`、`.sand/config.yaml`、项目文档 |
| **生命周期** | 跨会话持久——随项目演进缓慢更新 |
| **安全敏感度** | 低——通常不含敏感数据 |
| **更新频率** | 按 Sprint 或架构变更时更新 |

**对 SAND 的作用：** 确保 Agent 了解项目的"规则"和"边界"，避免产出与项目约定不一致的工件。

---

### 第二层：意图上下文（Intent Context）

**定义：** 当前任务的具体上下文——意图声明、执行契约、验收标准、约束条件。

| 维度 | 说明 |
|------|------|
| **来源** | `.sand/intents/{intent_id}.yaml`、`.sand/intents/contracts/{intent_id}.contract.yaml` |
| **生命周期** | 单次 SDC 循环——意图完成后归档 |
| **安全敏感度** | 中——可能包含业务需求细节 |
| **更新频率** | Intent 阶段创建，Validate 阶段引用 |

**对 SAND 的作用：** 让 Agent 理解"这次要做什么"以及"做到什么程度算完成"。

---

### 第三层：历史上下文（Historical Context）

**定义：** 过往执行的经验积累——审计日志、偏差记录、学习信号。

| 维度 | 说明 |
|------|------|
| **来源** | `.sand/audits/audit.jsonl`、`.sand/executions/EXE-*/deviations.json`、回顾记录 |
| **生命周期** | 跨会话累积——构成组织学习飞轮的原材料 |
| **安全敏感度** | 中——含执行决策和偏差细节 |
| **更新频率** | 每次执行自动追加 |

**对 SAND 的作用：** 让 Agent 从过去的错误和成功中学习，避免重复同类偏差。

---

### 第四层：协作上下文（Collaboration Context）

**定义：** Agent 间协作产生的运行时上下文——Skill 间传递的输入/输出、拓扑状态、中间产物。

| 维度 | 说明 |
|------|------|
| **来源** | `.sand/executions/EXE-*/execution.yaml`、Skill 间 outputs→inputs 链接 |
| **生命周期** | 单次执行会话——会话结束后归档 |
| **安全敏感度** | 高——可能包含代码片段和中间计算结果 |
| **更新频率** | 执行过程中实时更新 |

**对 SAND 的作用：** 确保 Pipeline/Swarm/Hierarchy 拓扑中 Agent 间信息传递的准确性和完整性。

---

## 上下文金字塔

四层次形成金字塔结构——从底层宽泛的项目上下文到顶层精确的协作上下文：

```
        ╱╲
       ╱  ╲         第四层：协作上下文
      ╱ 协作 ╲        （执行时产生，高精度，高敏感）
     ╱────────╲
    ╱   历史    ╲     第三层：历史上下文
   ╱──────────────╲    （跨会话积累，学习价值高）
  ╱     意图       ╲   第二层：意图上下文
 ╱──────────────────╲   （单次任务，核心驱动力）
╱      项目          ╲  第一层：项目上下文
╲════════════════════╱   （持久化，奠定基线）
```

**信息传递方向：**
- **自底向上**：下层上下文为上层提供基础约束（项目规范约束意图表达）
- **自顶向下**：上层上下文为下层提供聚焦过滤（当前意图决定哪些项目上下文需要加载）

**金字塔原则：** 排序依据是**对当前任务的精确度**（specificity to current task），而非绝对寿命。越靠近顶层的上下文越精确、越聚焦于当前执行，越靠近底层的上下文越宽泛、越不依赖特定任务。注意：第三层（历史上下文）虽然跨会话累积，但它服务于"从过去学习"这一宽泛目的；第二层（意图上下文）虽然仅存于单次 SDC 循环，但它直接驱动当前任务——因此意图比历史更靠近底层（更宽泛地奠定当前执行的基础）。编排引擎的核心工作之一是从金字塔中**选择性加载**正确层级的正确信息。

---

## 上下文质量评估模型

上下文质量通过四个维度评估，对应 `docs/09-templates/orchestration-plan.yaml` 的 `context_quality_check` 结构：

| 维度 | 评估问题 | 通过标准 | 失败信号 |
|------|---------|---------|---------|
| **完整性**（Completeness） | Agent 是否拥有完成任务所需的全部信息？ | 意图声明全部字段已填、相关约束已加载 | Agent 询问已有但未加载的信息 |
| **准确性**（Accuracy） | 加载的上下文是否反映最新状态？ | 项目上下文与当前代码库一致 | 上下文引用已删除的文件或已变更的架构 |
| **精简性**（Conciseness） | 是否排除了无关信息？ | 加载的上下文全部与当前任务相关 | Agent 上下文窗口中超过 30% 是无关内容 |
| **可发现性**（Discoverability） | Agent 是否能找到需要的上下文？ | 上下文通过明确路径可定位 | Agent 需要搜索或猜测信息位置 |

**质量评估时机：** 在 `sand-design-orchestration` Skill 的 `step-01-context.md` 阶段执行，评估结果写入编排方案的 `context_quality_check` 字段。

---

## 上下文最小化原则

**核心规则（与 FR32-FR33 对齐）：**

> 默认仅将签名化的接口契约、依赖关系摘要、以及用户显式标记的上下文片段发送给 AI 模型。完整代码文件默认不上传，除非用户在 constraints 中明确授权并记录审计事件。

### 最小化规则表

| 上下文类型 | 默认行为 | 需显式授权 | 审计要求 |
|-----------|---------|-----------|---------|
| 接口契约（API signatures） | 自动包含 | 否 | 无 |
| 依赖关系摘要 | 自动包含 | 否 | 无 |
| 用户标记的代码片段 | 用户确认后包含 | 否 | 记录标记范围 |
| 完整代码文件 | **不包含** | 是——需在 constraints 中授权 | 记录审计事件 |
| 环境变量 / 密钥 | **禁止** | 不允许授权 | 阻断 + 告警 |
| 业务数据样本 | **不包含** | 是——需脱敏后包含 | 记录脱敏规则 |

### 数据脱敏规则（FR33）

- 系统支持用户配置脱敏规则（替换敏感字符串、移除内部路径）
- 脱敏规则在数据离开本地前**同步应用**——不存在"发送后脱敏"
- 脱敏配置位于 `.sand/config.yaml` 的 `redaction_rules` 字段

---

## 上下文资产组织形态

上下文资产通过 `.sand/` 目录结构持久化管理：

```
.sand/
├── config.yaml              ← 项目上下文配置（含脱敏规则）
├── intents/                  ← 意图上下文
│   ├── {intent_id}.yaml
│   └── contracts/
│       └── {intent_id}.contract.yaml
├── executions/               ← 协作上下文 + 历史上下文
│   └── EXE-{session_id}/
│       ├── execution.yaml    ← 执行状态和 Skill 间链接
│       ├── validation-report.yaml
│       └── deviations.json   ← 偏差记录（学习信号）
├── audits/                   ← 历史上下文
│   └── audit.jsonl           ← 审计事件流
├── assessments/              ← 评估上下文
│   └── {timestamp}_{team_id}.yaml
└── orchestration-plan.yaml   ← 编排上下文
```

**CDLC 映射（Debois, 2025）：**

| CDLC 阶段 | SAND 对应 | 上下文层次 |
|-----------|---------|----------|
| **Generate** | Intent 阶段创建意图声明 + Orchestrate 阶段设计编排方案 | 第二层 |
| **Evaluate** | `context_quality_check` 四维评估 | O1 子过程 |
| **Distribute** | 执行引擎按 `context_scope` 分发上下文给 Skill | 第四层 |
| **Observe** | 审计事件记录 + 偏差追踪 + 回顾 | 第三层 |

---

## 上下文安全边界

上下文工程必须在安全边界内运作——信息泄露的风险随上下文范围扩大而增长。

### 安全原则

1. **默认拒绝**：未被显式包含的上下文不可被 Agent 访问
2. **最小权限**：Agent 仅获得完成当前步骤所需的最小上下文集
3. **本地优先**：脱敏和过滤在数据离开本地环境前完成
4. **审计可追溯**：每次上下文扩展授权都记录在审计链中

### 有效上下文窗口（MECW）警示

研究表明，AI 模型的有效上下文窗口（Maximum Effective Context Window, MECW）与宣传的上下文窗口差距在复杂任务上可达 99%。所有前沿模型在中间位置信息上均出现 30% 以上的准确率下降（"中间迷失"问题）。

**SAND 的应对策略：**
- 上下文放置策略：关键信息置于开头和结尾，避免中间区域
- 上下文分块加载：按步骤需要加载，而非一次性全量加载
- `context_scope` 的 `exclude_patterns` 主动排除噪音文件

---

## 对 SAND 的实践意义

上下文工程是 SAND Orchestrate 阶段**最具原创性的贡献**之一。它将"给 AI 什么信息"从一个隐性决策提升为显式的工程实践：

1. **从 Prompt Engineering 到 Context Engineering**：有效 prompt 不再是单一文本块，而是由不同组件组装的模块化架构
2. **安全与效能的平衡**：最小化原则（FR32）确保安全，质量评估模型确保效能
3. **与学习飞轮联动**：第三层历史上下文是 Learn 阶段飞轮的输入——偏差记录和学习信号在未来执行中成为更好的上下文
4. **可操作化路径清晰**：四层次模型直接映射为 `step-01-context.md` 的收集逻辑，质量评估模型直接映射为 `context_quality_check` 字段

---

## Schema 对齐

本文档定义的上下文工程模型与以下工件严格对齐：

- `schemas/orchestration-plan.schema.json` → `context_scope`（`include_files[]`, `exclude_patterns[]`）
- `docs/09-templates/orchestration-plan.yaml` → `context_strategy`（O1 结构：`project_context`, `domain_context`, `intent_context`, `context_quality_check`）
- PRD FR32 → 上下文最小化原则（默认不发送完整代码文件）
- PRD FR33 → 数据脱敏规则（发送前同步应用）
- `sand-design-orchestration` Skill → `steps/step-01-context.md`（待 Story 4-1 创建）
