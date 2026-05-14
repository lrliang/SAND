# 三级人类介入模型

HIP-1异步知晓、HIP-2同步审查、HIP-3人类主导。动态调整机制：信任度积累可降级、异常信号可升级、新领域回到HIP-2以上。

---

## 概述

Human Intervention Points（HIP）是 SAND 编排阶段子过程 O4 的核心机制，定义了 AI Agent 执行过程中人类参与的时机、深度和决策权限。HIP 模型是 SAND 区别于"全自主 AI"和"纯人工"两个极端的关键设计——它承认 AI 输出的概率性本质，同时避免过度监督带来的效率损耗。

**理论基础：** HIP 设计根植于两个学术发现：

1. **Delegation Gap**（委托鸿沟）——工程师用 AI 完成约 60% 的工作，但仅能"完全委托" 0-20%，说明渐进式自治是必要的（行业实证研究，2025-2026）
2. **Fowler 非确定性范式**——"人类在环监督仍然不可或缺"（Fowler et al., 2024-2026），详见[非确定性编程范式](../../01-foundations/non-deterministic-paradigm.md)

McKinsey (2025) "State of AI" 报告进一步验证：65% 的 AI 高绩效组织已定义 Human-in-the-Loop 流程，而其他组织仅 23%。

---

## HIP 三级定义

> **方向约束（不可反转）：HIP-1 = 最低介入 / HIP-3 = 最高介入**
> 此方向已在 PRD FR17、Architecture §HIP、[认知协作理论](../../01-foundations/cognitive-collaboration.md) 中统一确认。

### HIP-1：异步知晓（Asynchronous Awareness）

**语义：** AI Agent 全自主执行，人类事后异步审查执行记录。

| 维度 | 说明 |
|------|------|
| **介入时机** | 执行完成后 |
| **人类角色** | 观察者——审阅审计日志和执行报告 |
| **决策权** | Agent 拥有完全决策权，人类保留事后否决权 |
| **适用场景** | 高确定性任务、已建立信任的重复流程、低风险探索 |
| **审计要求** | Agent 自动记录所有决策到 `.sand/audits/audit.jsonl` |
| **典型延迟** | 无等待——执行不阻塞 |

**适用意图类型：** Fix（简单缺陷）、Exploration（低风险调研）

---

### HIP-2：同步审查（Synchronous Review）

**语义：** AI Agent 在关键决策点暂停，等待人类审查和确认后继续。

| 维度 | 说明 |
|------|------|
| **介入时机** | 预定义的关键决策点（编排方案确认、验证决策确认等） |
| **人类角色** | 审查者——检查 Agent 的推荐并批准/修改/拒绝 |
| **决策权** | Agent 提出建议，人类做最终决策 |
| **适用场景** | 大多数生产任务、新功能开发、重构 |
| **审计要求** | 记录人类审查结果（approved/modified/rejected）+ 审查耗时 |
| **典型延迟** | 分钟级——取决于人类响应速度 |

**适用意图类型：** Feature、Refactor、Optimization

**HIP-2 审查点（在 SDC 循环中的位置）：**
- Intent 阶段：意图声明 CLEAR 检查通过后确认
- Orchestrate 阶段：编排方案（拓扑 + HIP 配置）确认
- Validate 阶段：验证决策（pass/conditional_pass/reject_to_build/redirect_to_intent）确认

---

### HIP-3：人类主导（Human-Led）

**语义：** 人类全程主导，AI Agent 作为辅助工具按指令执行。

| 维度 | 说明 |
|------|------|
| **介入时机** | 每个步骤 |
| **人类角色** | 指挥者——逐步指导 Agent 执行 |
| **决策权** | 人类做所有决策，Agent 仅执行明确指令 |
| **适用场景** | 高风险变更、新领域首次探索、合规敏感操作、团队初次使用 SAND |
| **审计要求** | 记录每步人类指令和 Agent 执行结果 |
| **典型延迟** | 高——与人类操作速度同步 |

**适用意图类型：** 高风险 Feature、合规相关 Refactor、组织级 Assessment

---

## HIP 级别决策链

HIP 级别通过四层覆盖机制确定最终值：

```
角色推荐值（Role Default）
    ↓ 被覆盖
.sand/config.yaml → default_human_oversight（项目默认值）
    ↓ 被覆盖
编排方案 → human_oversight（本次编排配置值）
    ↓ 被覆盖
用户会话临时覆盖（Runtime Override）
    ↓
最终值 → 传递给执行引擎（sand-run）
```

**覆盖链保护规则：** 后层覆盖前层时，仅允许**升级**（提高介入级别）或**保持不变**。降级（降低介入级别）需要显式确认——运行时覆盖不可将 HIP-3 静默降为 HIP-1，必须经过人类确认。此约束与动态调整机制的"信任降级需人类确认"保持一致。

### 角色推荐值

| 角色 | Skill 路径 | 推荐 HIP | 理由 |
|------|-----------|---------|------|
| 问题域负责人 | `sand-agent-domain-lead` | HIP-2 | 架构和治理决策需审查，但日常操作可信任 |
| FDE+ | `sand-agent-fde` | HIP-2 | 一线开发的标准审查级别 |
| 变革催化师 | `sand-agent-catalyst` | HIP-3 | 组织级变更影响范围大，需全程监督 |

### 意图类型与 HIP 推荐关联

基于[意图分类学](../intent/intent-taxonomy.md)：

| 意图类型 | 推荐 HIP | 可调整范围 | 关联理由 |
|---------|---------|----------|---------|
| **Feature** | HIP-2 | HIP-1 ~ HIP-3 | 新功能需关键决策审查，低复杂度可降至 HIP-1 |
| **Fix** | HIP-1 / HIP-2 | HIP-1 ~ HIP-2 | 明确缺陷修复可全自主，复杂修复需审查 |
| **Refactor** | HIP-2 | HIP-2 ~ HIP-3 | 重构涉及行为保持承诺，需审查确认 |
| **Exploration** | HIP-1 | HIP-1 ~ HIP-2 | 探索性工作风险可控，结果需事后审阅 |
| **Optimization** | HIP-2 | HIP-1 ~ HIP-2 | 性能优化需基线对比审查 |

---

## 动态调整机制

HIP 级别不是静态配置——SAND 定义三种动态调整场景：

### 1. 信任度积累降级（Trust-Based De-escalation）

**触发条件：** 同一类型任务连续 N 次在当前 HIP 级别下未触发人类修改（Agent 建议被全部接受）。

**调整方向：** HIP-3 → HIP-2 → HIP-1

**约束：**
- 仅在同一意图类型和同一领域内有效
- 降级建议需人类确认（不允许自动降级）
- 降级历史记录到审计日志

### 2. 异常信号升级（Anomaly-Based Escalation）

**触发条件：** 执行过程中检测到异常信号——验证失败、偏差事件、安全告警等。

**调整方向：** HIP-1 → HIP-2 → HIP-3

**约束：**
- 异常信号触发即时升级，不等待当前步骤完成
- 升级为强制行为，Agent 不可覆盖
- 升级后的 HIP 级别持续到本次执行结束

### 3. 新领域重置（Domain-Reset）

**触发条件：** Agent 进入未曾处理过的新领域（新的代码库、新的技术栈、新的业务领域）。

**调整方向：** 任何当前级别 → HIP-2 或更高

**约束：**
- "新领域"判定标准：`.sand/` 中无该领域的历史执行记录
- 不允许新领域首次执行使用 HIP-1（异步知晓不足以应对未知风险）

---

## HIP 审查要求矩阵

| 审查维度 | HIP-1 | HIP-2 | HIP-3 |
|---------|-------|-------|-------|
| **编排方案审查** | 事后查阅 | 执行前确认 | 逐步参与设计 |
| **拓扑选型确认** | 自动应用 | 推荐后确认 | 人类直接指定 |
| **Skill 链确认** | 自动配置 | 审查 Skill 链后确认 | 逐步选择每个 Skill |
| **验证决策确认** | 自动执行 | 审查决策后确认 | 人类做最终裁决 |
| **偏差处理** | 自动记录 | 审查并标记处理方式 | 人类逐条裁定 |
| **外部 Skill 引入** | 仅限已验证 Skill | 审查后引入 | 人类逐一审批 |

---

## 对 SAND 的实践意义

HIP 模型是 SAND "AI 原生但人类驻留"理念的核心操作化机制：

1. **信任渐进**：团队不需要一开始就全面信任 AI——从 HIP-3 开始，随着信任积累逐步降级到 HIP-2、HIP-1
2. **风险匹配**：高风险操作自动升级审查力度，低风险操作减少审查摩擦
3. **审计可追溯**：每次 HIP 决策（包括动态调整）都记录在审计链中，满足合规要求
4. **与 Validate 阶段联动**：验证决策（pass/conditional_pass/reject_to_build/redirect_to_intent）的人类确认遵循当前 HIP 级别

SAND 的 HIP 设计避免了两个常见陷阱：**全自主的失控风险**（AI 做出不可逆错误决策）和**全监督的效率瓶颈**（人类成为整个流程的限速步骤）。

---

## Schema 对齐

本文档定义的 HIP 三级模型与以下工件严格对齐：

- `schemas/orchestration-plan.schema.json` → `human_oversight` enum: `["hip-1", "hip-2", "hip-3"]`
- `templates/orchestration-plan.yaml` → `human_oversight` 默认值: `hip-2`
- `docs/09-templates/orchestration-plan.yaml` → `human_intervention_points[].level` 字段
- `sand-design-orchestration` Skill → `steps/step-03-hip.md`（待 Story 4-1 创建）
