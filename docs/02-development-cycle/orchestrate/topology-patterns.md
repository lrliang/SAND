# Agent拓扑模式

4种标准拓扑：Solo（独奏）、Pipeline（流水线）、Swarm（蜂群）、Hierarchy（层级）。拓扑选择决策矩阵（不确定性×规模）。

---

## 概述

编排拓扑（Orchestration Topology）定义了 AI Agent 之间的协作结构——谁与谁通信、按什么顺序、以什么粒度交接工作。拓扑选择是 Orchestrate 阶段子过程 O3 的核心输出，直接决定了执行效率、失败隔离能力和人类审查成本。

SAND 定义 4 种标准拓扑，覆盖从单一简单任务到大规模复杂系统的全谱系。拓扑选择遵循 **MVP 原则**：使用清晰的规则表引导选型，用户最终确认或修改，不实现复杂推导引擎。

**理论基础：** 拓扑设计根植于[非确定性编程范式](../../01-foundations/non-deterministic-paradigm.md)的核心洞见——AI 输出具有概率性，需要通过结构化的协作模式来约束不确定性传播。Multi-Agent 编排实证研究表明，多 Agent 在 DevOps 事故响应中实现 100% 可操作建议率，相比单 Agent 的 1.7% 差异显著（arXiv:2601.13671, 2026）。

---

## 四种标准拓扑

### 1. Solo（独奏）

**定义：** 单个 Agent 独立完成全部任务，通过工具链（MCP Tools）扩展能力边界。

**适用场景：**
- 单一功能开发，无外部依赖
- 明确定义的 bug 修复
- 小范围代码重构
- 探索性调研（风险可控）

**优势：**
- 最低协调开销——无 Agent 间通信成本
- 上下文完整——单一 Agent 持有全部信息
- 调试简单——行为可追踪、可复现

**劣势：**
- 单点能力瓶颈——受限于单一模型的能力上限
- 上下文窗口压力——复杂任务可能超出有效上下文
- 无内置检查机制——缺少 Agent 间交叉验证

**典型用例：** FDE+ 为一个 API endpoint 编写 CRUD 代码，意图类型为 Fix 或简单 Feature。

**对应行业模式：** 单 Agent + 工具链（Claude Agent SDK 或 LangGraph 单节点）。

---

### 2. Pipeline（流水线）

**定义：** 多个 Agent 按严格顺序执行（A → B → C），前一个 Agent 的输出作为后一个的输入。

**适用场景：**
- 有明确顺序步骤的任务（设计 → 实现 → 测试）
- 多阶段转换流程（代码生成 → 代码审查 → 文档生成）
- 需要渐进式精化的工作流

**优势：**
- 流程清晰——每步职责明确，便于审计
- 中间产物可检查——每个交接点都是潜在的 HIP 审查点
- 故障隔离——某步失败不影响已完成步骤

**劣势：**
- 总执行时间 = 各步时间之和（无并行加速）
- 上下文衰减——长链条后端 Agent 可能丢失前端信息
- 单链脆弱——任一步骤失败则整条链停滞

**典型用例：** FDE+ 执行"意图 → 编排 → 构建 → 验证"的标准 SDC 循环，意图类型为 Feature 或 Refactor。

**对应行业模式：** 顺序传递链（LangGraph 线性图 / CrewAI Sequential Process）。

---

### 3. Swarm（蜂群）

**定义：** 多个 Agent 并行执行独立子任务，结果由聚合器（Aggregator）合并。

**适用场景：**
- 可分解为独立并行子任务的工作（多文件并行生成）
- 需要多视角探索的方案评估
- 大规模但低耦合的批量操作

**优势：**
- 并行加速——总时间 ≈ 最慢子任务时间
- 方案多样性——多 Agent 可探索不同路径
- 容错性——单个 Agent 失败不阻塞其他

**劣势：**
- 聚合复杂——需要合并逻辑处理冲突结果
- 协调税（Coordination Tax）——准确率增益在 4 个 Agent 后趋于饱和（Google DeepMind）
- 上下文一致性风险——并行 Agent 可能基于不同假设工作

**典型用例：** 问题域负责人同时评估 3 种架构方案的可行性，意图类型为 Exploration。

**对应行业模式：** Fan-Out / Fan-In 并行（LangGraph 并行分支 + 聚合节点）。

---

### 4. Hierarchy（层级）

**定义：** 管理者 Agent（Orchestrator）将任务分解并分配给 Worker Agent，Worker 可进一步嵌套子 Agent。

**适用场景：**
- 需要协调不同类型 Agent（代码生成 + 测试 + 文档）的复杂项目
- 跨领域任务（前端 + 后端 + 数据库）
- 大规模系统变更

**优势：**
- 分治策略——复杂问题被分解为可管理的子问题
- 专业化——每个 Worker 专注于其擅长领域
- 可扩展——通过添加层级适应更大规模

**劣势：**
- 最高协调开销——管理者 Agent 自身消耗上下文和推理资源
- 信息瓶颈——管理者可能成为通信瓶颈
- 级联失败风险——管理者判断错误会传播到所有 Worker

**典型用例：** 变革催化师规划组织级 AI 转型，涉及评估、培训方案设计、工具选型等多个并行工作流。

**对应行业模式：** Orchestrator-Worker 多层级（LangGraph 嵌套子图 / Google ADK 代理树）。

---

## 拓扑选型决策矩阵

### 不确定性 × 规模矩阵

| | 小规模（单文件/单功能） | 中规模（多文件/单模块） | 大规模（跨模块/跨系统） |
|---|---|---|---|
| **低不确定性**（需求明确，路径清晰） | **Solo** | **Pipeline** | **Pipeline** 或 **Hierarchy** |
| **中不确定性**（需求明确，实现路径有多种） | **Solo** 或 **Pipeline** | **Pipeline** | **Hierarchy** |
| **高不确定性**（需求模糊，需探索多种方案） | **Solo**（探索阶段） | **Swarm** | **Hierarchy** + **Swarm** 嵌套 |

### 意图特征快速匹配表

此表为 `sand-design-orchestration` Skill 的 `data/topology-rules.yaml` 直接输入：

| 意图特征 | 推荐拓扑 | 推荐理由 |
|---------|---------|---------|
| 单一功能、无依赖 | `solo` | 协调开销为零，单 Agent 即可覆盖 |
| 有顺序步骤（A → B → C） | `pipeline` | 自然映射到步骤链，中间产物可审查 |
| 并行探索多个方案 | `swarm` | 并行加速 + 方案多样性 |
| 需要协调不同 Agent 类型 | `hierarchy` | 分治 + 专业化，管理者负责协调 |
| 高风险 + 大规模 | `hierarchy` | 需要分层审查和故障隔离 |
| 探索性 + 小规模 | `solo` | 低成本快速试错 |

---

## 意图类型与拓扑推荐关联

基于[意图分类学](../intent/intent-taxonomy.md)定义的 5 种意图类型：

| 意图类型 | 主推拓扑 | 备选拓扑 | 关联理由 |
|---------|---------|---------|---------|
| **Feature**（新功能） | Pipeline | Swarm / Hierarchy | 新功能通常有设计→实现→测试的顺序依赖 |
| **Fix**（缺陷修复） | Solo | Pipeline | 修复通常范围小、路径明确，Solo 最高效 |
| **Refactor**（重构） | Pipeline | Hierarchy | 重构需要"分析→改写→验证"的顺序保障 |
| **Exploration**（探索） | Solo | Swarm | 小范围用 Solo 快速试错，大范围用 Swarm 并行探索 |
| **Optimization**（优化） | Solo / Pipeline | — | 优化通常范围小（Solo）或需性能基线对比（Pipeline） |

---

## 拓扑升级与降级规则

运行时可能发现初始拓扑不适配，SAND 定义以下调整策略：

### 升级（Escalation）

| 触发信号 | 当前拓扑 | 升级目标 | 操作 |
|---------|---------|---------|------|
| 任务复杂度超预期，单 Agent 上下文不足 | Solo | Pipeline | 拆分为多步骤，引入专业化 Agent |
| 需要并行探索替代方案 | Pipeline | Swarm | 在特定步骤分叉为并行路径 |
| Worker 数量 > 4 或涉及跨领域协调 | Swarm | Hierarchy | 引入管理者 Agent 统筹分配 |

### 降级（De-escalation）

| 触发信号 | 当前拓扑 | 降级目标 | 操作 |
|---------|---------|---------|------|
| 协调税超过收益（Agent 间通信 > 实际工作） | Hierarchy | Pipeline 或 Swarm | 移除管理层，简化为直接执行 |
| 并行任务实际存在强依赖 | Swarm | Pipeline | 改为顺序执行，避免冲突 |
| 多步骤链中仅第一步有实质工作 | Pipeline | Solo | 合并为单 Agent 执行 |

**降级保护：** 拓扑降级需在 HIP 审查点确认——不允许自动降级绕过人类审查。

---

## 拓扑选型决策流程

以下流程为 `sand-design-orchestration` Skill `steps/step-02-topology.md` 的操作化基础：

```
1. 输入：意图声明（intent_type, scope, dependencies, constraints）

2. 判定：意图是否涉及多个独立子任务？
   ├─ 是 → 子任务间是否有顺序依赖？
   │       ├─ 是 → 推荐 Pipeline
   │       └─ 否 → 子任务数量 ≤ 4？
   │               ├─ 是 → 推荐 Swarm
   │               └─ 否 → 推荐 Hierarchy（协调税阈值）
   └─ 否 → 评估不确定性
           ├─ 高不确定性 → 推荐 Solo（探索模式：标注为探索性执行，建议低 HIP）
           └─ 低/中不确定性 → 推荐 Solo（标准模式）

3. 交叉检查：意图类型关联表（见上方）是否一致？
   ├─ 一致 → 输出推荐 + 理由
   └─ 不一致 → 向用户呈现两种推荐及理由，由用户决定

4. 不确定性 × 规模矩阵复核：推荐结果与上方选型矩阵是否一致？
   ├─ 一致 → 确认推荐
   └─ 不一致 → 向用户说明分歧并由用户决定

5. 输出：topology 字段值（solo/pipeline/swarm/hierarchy）+ topology_rationale
```

**注意：** 协调税阈值（4 Agent 饱和点）来自 Google DeepMind 的 Agent 原型研究——超过 4 个并行 Agent 后，准确率增益趋于平坦，而协调成本持续上升。

---

## 对 SAND 的实践意义

拓扑选择不是技术决策，而是**协作架构决策**。它决定了：

1. **人类审查成本**：Pipeline 的中间交接点天然适合 HIP-2 审查；Solo 则依赖最终验证
2. **失败影响范围**：Hierarchy 的级联失败风险最高，需要在 O5（失败模式预案）中重点规划
3. **上下文管理策略**：Swarm 的并行 Agent 需要 O1（上下文工程）确保一致性
4. **成本可预测性**：Solo 成本最低、最可预测；Hierarchy 成本最高、波动最大

SAND 的拓扑选型以**简单规则优先**——MVP 不实现动态拓扑切换，而是通过引导式对话帮助用户在执行前做出正确选择，并在编排方案中记录 `topology_rationale` 以供审计追溯。

---

## Schema 对齐

本文档定义的 4 种拓扑与以下工件严格对齐：

- `schemas/orchestration-plan.schema.json` → `topology` enum: `["solo", "pipeline", "swarm", "hierarchy"]`
- `templates/orchestration-plan.yaml` → `topology` 默认值: `solo`
- `docs/09-templates/orchestration-plan.yaml` → `topology.pattern` 字段
- `sand-design-orchestration` Skill → `data/topology-rules.yaml`（待 Story 4-1 创建）
