# 意图偏差追踪

偏差事件结构化记录：deviation_type、root_cause_hypothesis、severity、resolution、learning_signal。是 Learn 阶段最有价值的原材料。

---

## 概述

意图偏差追踪（Deviation Tracking）是 Validate 阶段的关键副产物——当验证结果与意图声明之间存在偏差时，SAND 不仅做出验证决策（参见 [验证决策矩阵](./decision-matrix.md)），还将偏差事件结构化记录下来。

偏差追踪的价值体现在两个层面：

1. **即时价值**：为 FDE+ 提供偏差清单，帮助定位修复方向（FR27b）
2. **飞轮价值**：偏差事件是 Learn 阶段最有价值的原材料——通过分析偏差模式，团队可以识别系统性问题并改进上游流程（Intent 质量、Build 实践、验证规则）

---

## 偏差事件数据结构

每个偏差事件包含以下字段：

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `deviation_id` | string | 是 | 偏差唯一标识，格式：`DEV-{session_id}-{seq}` |
| `timestamp` | string | 是 | ISO-8601 UTC 时间戳 |
| `deviation_type` | enum | 是 | 偏差类型（见下方枚举） |
| `source_channel` | enum | 是 | 发现偏差的通道：`contract` / `security` / `architecture` |
| `severity` | enum | 是 | 严重程度：`blocking` / `warning` / `info` |
| `related_acceptance_criteria` | string | 否 | 关联的验收标准条目标识 |
| `description` | string | 是 | 偏差的具体描述 |
| `root_cause_hypothesis` | string | 否 | 根因假说——初步判断偏差的原因 |
| `suggested_action` | string | 是 | 建议的修正动作 |
| `resolution` | enum | 否 | 处理结果（人类标记）：`resolved` / `risk_accepted` / `rejected_to_rebuild` |
| `resolution_notes` | string | 否 | 处理说明 |
| `learning_signal` | string | 否 | 可提取的学习信号——用于 Learn 阶段资产化 |

### 完整示例

```yaml
deviations:
  - deviation_id: "DEV-EXE-20260515-001-01"
    timestamp: "2026-05-15T14:30:00Z"
    deviation_type: contract_deviation
    source_channel: contract
    severity: blocking
    related_acceptance_criteria: "must_pass_item_3"
    description: "API 返回租户数据时未过滤已删除用户，acceptance_criteria 要求仅返回活跃用户"
    root_cause_hypothesis: "Build 阶段 AI 未正确理解 '活跃用户' 的业务定义"
    suggested_action: "在 query 层增加 is_active=true 过滤条件"
    resolution: null
    resolution_notes: null
    learning_signal: "意图声明中 '活跃用户' 的定义需在 context_references 中明确引用领域模型"

  - deviation_id: "DEV-EXE-20260515-001-02"
    timestamp: "2026-05-15T14:30:00Z"
    deviation_type: security_deviation
    source_channel: security
    severity: blocking
    related_acceptance_criteria: null
    description: "错误响应体中包含完整的 SQL 查询语句，可能泄露数据库结构信息"
    root_cause_hypothesis: "AI 生成的错误处理直接将异常信息返回给客户端"
    suggested_action: "替换为通用错误消息，详细错误信息仅写入内部日志"
    resolution: null
    resolution_notes: null
    learning_signal: "安全合规检查应增加 '错误响应体信息泄露' 的专项检查"
```

---

## 偏差类型枚举

| 类型 | 代码标识 | 定义 | 典型场景 |
|------|---------|------|---------|
| **契约偏差** | `contract_deviation` | 交付物未满足执行契约的 must_pass 或 must_not_violate 条目 | must_pass 测试失败、约束被违反 |
| **安全偏差** | `security_deviation` | 交付物引入安全漏洞或合规违规 | 注入漏洞、敏感数据泄露、凭证硬编码 |
| **架构偏差** | `architecture_deviation` | 交付物偏离项目架构约束 | 目录结构违规、依赖方向错误、命名不一致 |
| **意图范围偏差** | `intent_scope_deviation` | 偏差源自意图声明本身的不完整或矛盾 | 验收标准遗漏、约束矛盾、期望结果模糊 |

### 偏差类型与源通道的关系

| 偏差类型 | 最可能的源通道 | 说明 |
|---------|-------------|------|
| contract_deviation | contract | 契约验证通道直接检测 |
| security_deviation | security | 安全合规通道直接检测 |
| architecture_deviation | architecture | 架构对齐通道直接检测 |
| intent_scope_deviation | contract | 由契约验证通道的意图对齐度分析（推断控制）发现 |

> 注：`intent_scope_deviation` 虽由契约通道的推断控制发现，但其根因在 Intent 阶段——这种偏差触发"重定向 Intent"决策。

---

## 严重程度分级

| 严重程度 | 代码标识 | 定义 | 对决策矩阵的影响 |
|---------|---------|------|-----------------|
| **阻塞** | `blocking` | 必须在交付前修复的问题 | 触发 `reject_to_build` 或 `redirect_to_intent` |
| **警告** | `warning` | 应该修复但不阻塞交付的问题 | 触发 `conditional_pass`，记录为技术债 |
| **信息** | `info` | 观察性发现，不需要立即处理 | 不影响决策，记录为学习信号 |

### 严重程度判定指南

| 判定维度 | blocking | warning | info |
|---------|----------|---------|------|
| **功能影响** | 核心功能不可用或行为错误 | 非核心功能受影响 | 无功能影响 |
| **安全影响** | 可被利用的安全漏洞 | 潜在风险但不可直接利用 | 安全最佳实践建议 |
| **架构影响** | 违反架构核心约束 | 偏离约定但不影响系统稳定性 | 风格偏好差异 |
| **可逆性** | 修复成本高或影响范围大 | 修复成本低 | 无需修复 |

---

## 偏差处理流程（FR27b）

FDE+ 在复盘时可查看偏差清单，并对每条偏差做出处理决策：

### 三种处理结果

| 处理结果 | 代码标识 | 含义 | 适用场景 |
|---------|---------|------|---------|
| **已解决** | `resolved` | 偏差已修复并通过重新验证 | blocking/warning 偏差被修复 |
| **接受风险** | `risk_accepted` | 已知偏差但选择接受 | warning 偏差经评估后可接受 |
| **打回重建** | `rejected_to_rebuild` | 偏差严重需要重新构建 | blocking 偏差无法简单修复 |

### 处理约束

- `blocking` 偏差只能标记为 `resolved` 或 `rejected_to_rebuild`——不可标记为 `risk_accepted`
- `warning` 偏差可标记为任何处理结果
- `info` 偏差自动标记为 `resolved`（无需人工处理）
- 所有处理决策记录到审计日志，包含处理人和时间戳

---

## 偏差到 Learn 阶段的数据流转

偏差事件是飞轮加速的关键数据源。每条偏差的 `learning_signal` 字段提取了可用于改进上游流程的学习信号：

### 偏差 → 学习信号 → 资产化路径

| 偏差类型 | 学习信号方向 | Learn 阶段资产化 |
|---------|-----------|----------------|
| contract_deviation | 意图声明质量需改进 | **意图模式资产**——提炼更好的 acceptance_criteria 编写模式 |
| security_deviation | 安全检查规则需扩展 | **验证规则资产**——补充安全合规通道的检查项 |
| architecture_deviation | 架构约束文档需完善 | **上下文资产**——更新架构规范文档 |
| intent_scope_deviation | CLEAR 检查清单需增强 | **意图模式资产**——改进 CLEAR 的 Complete 维度检查项 |

### 飞轮效应

```
Validate 产出偏差事件
  → Learn 分析偏差模式
    → 资产化为改进建议
      → Intent 阶段改进（更好的意图声明模式）
      → Build 阶段改进（更好的代码生成约束）
      → Validate 阶段改进（更全面的检查项）
        → 下一轮 Validate 的偏差减少
          → 飞轮加速
```

每一轮 SDC 循环中发现的偏差都会反馈到下一轮的改进中，使第 N+1 轮的验证比第 N 轮更全面、偏差更少。这是 SAND "学习与资产化"阶段（Learn）的核心价值主张。

**对 SAND 的实践意义：** 偏差追踪是 SDC 飞轮的核心数据泵。没有结构化的偏差记录，Learn 阶段只能依赖人类回忆进行复盘——而人类回忆是选择性的、衰减的。偏差追踪将每次验证失败转化为可资产化的学习信号，使 SAND 框架能够**从失败中系统性地提取价值**，而非仅仅记录失败。

---

## 持久化格式（FR27a）

偏差事件持久化到 `.sand/executions/EXE-{session_id}/deviations.json`：

```json
{
  "session_id": "EXE-20260515-001",
  "intent_id": "INT-20260512-003",
  "validation_timestamp": "2026-05-15T14:30:00Z",
  "total_deviations": 2,
  "severity_summary": {
    "blocking": 2,
    "warning": 0,
    "info": 0
  },
  "deviations": [
    {
      "deviation_id": "DEV-EXE-20260515-001-01",
      "timestamp": "2026-05-15T14:30:00Z",
      "deviation_type": "contract_deviation",
      "source_channel": "contract",
      "severity": "blocking",
      "related_acceptance_criteria": "must_pass_item_3",
      "description": "...",
      "root_cause_hypothesis": "...",
      "suggested_action": "...",
      "resolution": null,
      "resolution_notes": null,
      "learning_signal": "..."
    }
  ]
}
```

---

## 引用来源

- PRD §意图偏差追踪 FR27a-b
- PRD §学习与资产化 FR38-FR40
- [三通道并行验证架构](./three-channel.md) — 偏差的发现机制
- [验证决策矩阵](./decision-matrix.md) — 偏差对决策的影响
- [意图声明 7 字段标准](../intent/intent-statement.md) — acceptance_criteria 字段定义
