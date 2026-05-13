# 执行契约标准

三级结构：must_pass（全部不满足则失败）、should_pass（尽量满足）、must_not_violate（反向约束）。映射到 Validate 阶段的四种决策结果。

---

## 概述

执行契约（Execution Contract）是从意图声明**自动生成**的验证依据——它将意图声明中的验收标准和约束转化为结构化的三级检查清单，供 [Validate 阶段](../validate/) 的三通道并行验证使用。

执行契约的核心设计哲学是：**将质量保证从"事后审查"前移到"事前定义"**。在传统开发流程中，代码审查是事后发现问题；在 SAND 的认知协作模式中，执行契约在编码开始前就定义了验收边界（参见 [认知协作与 SE 3.0](../../01-foundations/cognitive-collaboration.md)）。

### 与意图声明的关系

执行契约不是独立创建的——它由 `sand-create-intent` Skill 的 step-04-contract 从意图声明自动生成。手动修改执行契约需要记录审计事件。

### 存储位置

`.sand/intents/contracts/{intent_id}.contract.yaml`

---

## 三级结构定义

### must_pass — 必须通过

**语义：** 全部条目必须满足，任何一条未通过则交付物**不合格**。

**来源映射：** 意图声明中 `acceptance_criteria` 的 `priority: must` 条目。

**特征：**
- 数量通常 3-8 条（过多说明意图范围过大，应考虑分解）
- 每条必须有明确的通过/未通过二元判定
- 对应 Validate 阶段的**契约验证通道**

**Validate 决策影响：**
- 全部通过 + should_pass 全部通过 + must_not_violate 无违反 → **通过**
- 全部通过 + should_pass 部分未通过 → **有条件通过**
- **任何 must_pass 未通过 → 打回 Build**

---

### should_pass — 尽量通过

**语义：** 尽量满足，部分未通过不构成失败，但需要记录为偏差事件。

**来源映射：** 意图声明中 `acceptance_criteria` 的 `priority: should` 条目。

**特征：**
- 数量不限，但建议不超过 must_pass 的 2 倍
- 每条未通过需生成偏差记录（deviation），标明偏差类型和严重程度
- 多条 should_pass 同时未通过可能升级为 must_pass 级别的阻断

**Validate 决策影响：**
- must_pass 全部通过 + should_pass 部分未通过 + must_not_violate 无违反 → **有条件通过**（附偏差记录）
- 累计偏差严重时 → 人工裁决是否打回 Build

---

### must_not_violate — 绝对不可违反

**语义：** 反向约束——定义禁止行为而非期望行为。任何违反等同于**意图偏差**，需要重新评估意图本身。

**来源映射：** 意图声明中 `constraints` 的全部条目（technical + security + scope）。

**特征：**
- 数量通常 2-6 条
- 每条是"不可做"而非"应该做"——例如"不可在日志中输出敏感信息"
- 违反 must_not_violate 通常意味着 AI 对意图的理解有根本性偏差
- 对应 Validate 阶段的**安全合规通道**和**架构对齐通道**

**Validate 决策影响：**
- **任何 must_not_violate 被违反 → 重定向 Intent**（回到 Intent 阶段重新定义意图）

---

## 从意图声明到执行契约的映射规则

### 自动映射规则

| 意图声明字段 | 映射目标 | 映射逻辑 |
|------------|---------|---------|
| acceptance_criteria[priority=must] | must_pass | 每条 criterion → 一条 must_pass 条目 |
| acceptance_criteria[priority=should] | should_pass | 每条 criterion → 一条 should_pass 条目 |
| constraints.technical | must_not_violate | 每条约束 → 一条 must_not_violate 条目（直接映射，保持原始表述） |
| constraints.security | must_not_violate | 每条约束 → 一条 must_not_violate 条目 |
| constraints.scope | must_not_violate | 每条范围约束 → 一条 must_not_violate 条目 |

### 映射示例

**意图声明（来自陈雨多租户场景）：**
```yaml
acceptance_criteria:
  - criterion: "API 请求仅返回当前租户数据"
    verification: automated_test
    priority: must
  - criterion: "跨租户访问返回 403 并记录 AuditEvent"
    verification: automated_test
    priority: must
  - criterion: "P95 延迟增量不超过 50ms"
    verification: performance_benchmark
    priority: should

constraints:
  security:
    - "不可在日志中输出 tenant_id 之外的租户敏感信息"
  scope:
    - "不涉及 UI 层变更"
```

**生成的执行契约：**
```yaml
contract:
  intent_id: "INT-20260512-003"
  generated_at: "2026-05-12T14:45:00Z"

  must_pass:
    - id: MP-001
      criterion: "API 请求仅返回当前租户数据"
      verification: automated_test
      source: "acceptance_criteria[0]"
    - id: MP-002
      criterion: "跨租户访问返回 403 并记录 AuditEvent"
      verification: automated_test
      source: "acceptance_criteria[1]"

  should_pass:
    - id: SP-001
      criterion: "P95 延迟增量不超过 50ms"
      verification: performance_benchmark
      source: "acceptance_criteria[2]"

  must_not_violate:
    - id: MNV-001
      constraint: "不可在日志中输出 tenant_id 之外的租户敏感信息"
      source: "constraints.security[0]"
    - id: MNV-002
      constraint: "不涉及 UI 层变更"
      source: "constraints.scope[0]"
```

### 补充条目

AI 在映射过程中可以**建议补充**条目——例如从 constraints 中推导出隐含的 must_pass 条目（如"约束要求兼容 PostgreSQL 14+ → 补充 must_pass: 数据库操作在 PG 14 上可执行"）。补充条目需标注 `source: "ai_derived"` 并经过人工确认。

---

## 与 Validate 阶段四种决策的完整映射

| Validate 决策 | 触发条件 | 后续动作 |
|-------------|---------|---------|
| **通过** | must_pass 全部通过 + should_pass 全部通过 + must_not_violate 无违反 | 意图状态 → Validated |
| **有条件通过** | must_pass 全部通过 + should_pass 部分未通过 + must_not_violate 无违反 | 记录偏差事件，意图状态 → Validated（附偏差标记） |
| **打回 Build** | 任何 must_pass 未通过 | 回到 Build 阶段修复，意图状态保持 In Execution |
| **重定向 Intent** | 任何 must_not_violate 被违反 | 回到 Intent 阶段重新定义意图，当前意图可能被废弃或修订 |

---

## 对 SAND Intent Skill 的实践意义

1. **执行契约是自动生成的**：`sand-create-intent` 的 step-04-contract 基于上述映射规则自动生成契约，FDE+ 只需审核而非手写
2. **三级结构对应三种风险级别**：must_pass = 功能风险，should_pass = 质量风险，must_not_violate = 安全/架构风险
3. **source 字段保证可追溯性**：每条契约条目都可追溯到意图声明的具体字段，支撑 Governance 阶段的审计链
4. **条目 ID 格式固定**：must_pass 用 MP-NNN，should_pass 用 SP-NNN，must_not_violate 用 MNV-NNN，便于偏差事件引用

---

## 引用来源

- [PRD §FR11: 执行契约生成](../../_bmad-output/planning-artifacts/prd.md)
- [PRD §FR27a-27b: 意图偏差追踪](../../_bmad-output/planning-artifacts/prd.md)
- [PRD §Journey 2 陈雨: 契约驱动的边界条件识别](../../_bmad-output/planning-artifacts/prd.md)
- [Architecture §.sand/ 目录结构: 契约存储路径](../../_bmad-output/planning-artifacts/architecture.md)
