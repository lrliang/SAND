# Agent选型决策框架

基于任务确定性和规模的选型决策树。Agent能力卡标准（capability_domain, model_requirement, context_window_need, known_limitations, cost_profile, reliability）。

---

## 概述

Agent 选型（Agent Selection）是 SAND 编排阶段子过程 O2 的核心能力。它回答"**谁来做这件事？**"——不仅选择 AI 模型，更定义了 Agent 的角色、能力边界和协作方式。

SAND 的 Agent 选型遵循**能力卡标准化**原则——每个可用的 Agent（无论是 SAND 内建角色还是外部 Skill 插件）都通过标准化的能力卡（Capability Card）声明自身能力，编排引擎基于能力卡进行匹配选型。

**理论基础：**

- **Hassan et al. (2026) "Towards AI-Native SE (SE 3.0)"**——其中的 SASE 框架定义了 Agent 自治级别 Level 1-5，与 SAND HIP-1/2/3 形成对标关系，详见[认知协作理论](../../01-foundations/cognitive-collaboration.md)
- **Google DeepMind Agent Archetypes**——提出 10 种 Agent 原型（Orchestrator, Planner, Executor, Evaluator, Synthesiser, Critic, Retriever, Memory Keeper, Mediator, Monitor），引入**协调税**（Coordination Tax）概念——准确率增益在 4 个 Agent 后趋于饱和

---

## 选型决策树

Agent 选型基于两个核心维度：**任务确定性**和**任务规模**。

### 决策流程

```
输入：意图声明（intent_type, scope, constraints, context_references）

1. 评估任务确定性
   ├─ 高确定性（需求明确，路径唯一）→ 单一专业 Agent 即可
   ├─ 中确定性（需求明确，路径多种）→ 需要评估型 Agent 辅助决策
   └─ 低确定性（需求模糊，需探索）  → 需要探索型 Agent + 评估型 Agent

2. 评估任务规模
   ├─ 小规模（单文件/单功能）→ 单 Agent（Solo 拓扑）
   ├─ 中规模（多文件/单模块）→ 2-3 Agent（Pipeline 拓扑）
   └─ 大规模（跨模块/跨系统）→ 3-4+ Agent（Hierarchy 拓扑）

3. 匹配 Agent 能力卡
   ├─ 从可用 Agent 池中筛选能力匹配者
   ├─ 验证上下文窗口需求是否满足
   └─ 检查已知局限是否影响当前任务

4. 输出：agent_selection 列表（agent_id, role_in_workflow, capability_card_ref）
```

### 确定性 × 规模 选型矩阵

| | 小规模 | 中规模 | 大规模 |
|---|---|---|---|
| **高确定性** | 1 个执行型 Agent | 2-3 个执行型 Agent（Pipeline） | 1 管理者 + N 执行者（Hierarchy） |
| **中确定性** | 1 个执行型 + 评估辅助 | 2-3 Agent + 评估节点 | 管理者 + 执行者 + 评估者 |
| **低确定性** | 1 个探索型 Agent | 多个探索型 Agent（Swarm） | 管理者 + 探索者 + 评估者 |

---

## Agent 能力卡标准

能力卡（Capability Card）是 Agent 的标准化自我描述，编排引擎通过读取能力卡来判断 Agent 是否适合当前任务。

### 标准字段

| 字段 | 类型 | 说明 | 示例 |
|------|------|------|------|
| `agent_id` | string | Agent 唯一标识符 | `sand-agent-fde` |
| `capability_domain` | string[] | Agent 擅长的能力域 | `["intent.creation", "build.code-gen", "validate.review"]` |
| `model_requirement` | object | 模型能力需求 | `{ reasoning: "high", context_window: "128K" }` |
| `context_window_need` | string | 典型任务所需上下文窗口估算 | `"64K-128K"` |
| `known_limitations` | string[] | 已知能力局限 | `["不适合大规模架构决策", "数学推理能力有限"]` |
| `cost_profile` | string | 成本特征 | `"medium"` (`low` / `medium` / `high`) |
| `reliability` | string | 可靠性评级 | `"high"` (`low` / `medium` / `high`) |
| `supported_sdc_phases` | string[] | 支持的 SDC 阶段 | `["intent", "build", "validate"]` |
| `default_hip` | string | 该 Agent 的默认 HIP 级别（进入 HIP 覆盖链的角色推荐值） | `"hip-2"` |

### 字段扩展说明

- `capability_domain` 使用点分命名空间（dot-namespaced），格式为 `{sdc_phase}.{sub_capability}`，支持精确匹配
- `model_requirement.reasoning` 取值：`"low"` / `"medium"` / `"high"`——对应模型的推理深度需求
- `model_requirement.context_window` 为最低要求值，单位为 token 数量的 K 级缩写

---

## SAND 三角色默认能力卡

### 问题域负责人（Domain Lead）

```yaml
agent_id: "sand-agent-domain-lead"
capability_domain:
  - "assess.maturity"
  - "governance.audit"
  - "orchestrate.design"
model_requirement:
  reasoning: "high"
  context_window: "128K"
context_window_need: "64K-128K"
known_limitations:
  - "不直接执行代码生成"
  - "需要项目具体上下文才能给出有效建议"
cost_profile: "high"
reliability: "high"
supported_sdc_phases: ["assess", "orchestrate", "governance"]
default_hip: "hip-2"
```

### FDE+（Full-Cycle Developer Engineer）

```yaml
agent_id: "sand-agent-fde"
capability_domain:
  - "intent.creation"
  - "intent.clear-check"
  - "build.code-gen"
  - "build.test-gen"
  - "validate.review"
model_requirement:
  reasoning: "high"
  context_window: "128K"
context_window_need: "32K-128K"
known_limitations:
  - "组织级架构决策需升级到问题域负责人"
  - "合规判断需人类确认"
cost_profile: "medium"
reliability: "high"
supported_sdc_phases: ["intent", "build", "validate"]
default_hip: "hip-2"
```

### 变革催化师（Catalyst）

```yaml
agent_id: "sand-agent-catalyst"
capability_domain:
  - "assess.organization"
  - "measure.metrics"
  - "learn.retrospective"
model_requirement:
  reasoning: "high"
  context_window: "128K"
context_window_need: "64K-128K"
known_limitations:
  - "不执行技术实现"
  - "组织变革建议需人类决策确认"
cost_profile: "high"
reliability: "medium"
supported_sdc_phases: ["assess", "measure", "learn"]
default_hip: "hip-3"
```

---

## 能力卡与拓扑匹配

选型逻辑根据能力卡组合推荐拓扑模式：

| Agent 组合特征 | 推荐拓扑 | 匹配理由 |
|--------------|---------|---------|
| 单一 Agent 覆盖全部 `capability_domain` | Solo | 无需协调，直接执行 |
| 多个 Agent，`capability_domain` 互补且有序 | Pipeline | 能力互补 + 顺序依赖 |
| 多个 Agent，`capability_domain` 相同或重叠 | Swarm | 并行探索，结果聚合 |
| 需要一个 Agent 分解任务给其他 Agent | Hierarchy | 管理者 + 专业 Worker |

**协调税约束：** 当 Swarm 或 Hierarchy 中 Agent 数量超过 4 时，应警告用户准确率增益可能趋于平坦，建议重新评估拆分粒度。

---

## 外部 Agent 引入评估标准

为 Story 4-3（插件验证机制）奠基——外部 Agent（通过 `.sand/plugins/` 注册）需满足以下评估标准：

### 准入条件

| 条件 | 要求 | 验证方式 |
|------|------|---------|
| **契约合规** | SKILL.md frontmatter 通过 `sandskill.v1.schema.json` 验证 | 自动化检查 |
| **能力卡存在** | 必须提供标准化能力卡 | 自动化检查 |
| **入口可达** | `entry_point` 指向的文件存在且可读 | 自动化检查 |
| **安全声明** | SKILL.md frontmatter 的 `requires` 字段声明所有需要的权限 | 人工审查 |
| **已知局限透明** | `known_limitations` 不可为空 | 人工审查 |

### 风险评级

| 风险级别 | 条件 | 处理方式 |
|---------|------|---------|
| **低风险** | 仅需 `file_read`，无外部网络访问 | HIP-1 可引入 |
| **中风险** | 需 `file_write` 或 `shell_execute` | HIP-2 审查后引入 |
| **高风险** | 需网络访问或系统级权限 | HIP-3 逐一审批 |

---

## 对 SAND 的实践意义

Agent 选型框架解决了 AI 原生开发中的核心问题——**不是所有 AI 都适合所有任务**：

1. **能力卡标准化**：将隐性的"这个模型擅长什么"转化为显式的、可查询的结构化声明
2. **协调税意识**：防止"越多 Agent 越好"的误解——4 Agent 饱和点是重要的经验性阈值（Google DeepMind 研究）
3. **渐进式开放**：外部 Agent 通过评估标准分级引入，而非无差别信任
4. **与 HIP 联动**：能力卡中的 `default_hip` 和 `human_oversight` 字段确保选型与人类审查级别匹配

SAND 的 Agent 选型**不绑定具体模型或供应商**——能力卡描述的是任务需求，不是模型名称。这确保了框架的模型无关性（Model Agnostic）设计原则。

---

## Schema 对齐

本文档定义的 Agent 选型框架与以下工件严格对齐：

- `docs/09-templates/orchestration-plan.yaml` → `agent_selection` 结构（`agent_id`, `role_in_workflow`, `capability_card_ref`）
- `schemas/orchestration-plan.schema.json` → `skill_chain[].skill_name` pattern: `^sand-[a-z][a-z0-9-]*$`
- Architecture §Agent Roles — 三角色定义与推荐 HIP
- `sand-design-orchestration` Skill → `steps/step-01-context.md` + `steps/step-02-topology.md`（待 Story 4-1 创建）
