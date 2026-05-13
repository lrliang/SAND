# 意图生命周期

Draft → Reviewed → Approved → In Execution → Validated → Archived。每次状态变更记录变更原因和操作人，形成意图审计追踪链。

---

## 概述

意图生命周期定义了意图声明从创建到归档的完整状态流转。每个意图在其生命周期内都有一个明确的状态，状态变更需要满足前置条件并记录审计事件——这是 SAND [Governance 中心轴](../governance/) 的重要数据来源。

### 状态存储

意图状态存储在意图声明文件的 `meta.status` 字段中：`.sand/intents/{intent_id}.yaml`

---

## 6 状态定义

### Draft（草案）

**语义：** 意图声明正在创建中，尚未完成 CLEAR 检查。

| 属性 | 说明 |
|------|------|
| **前置条件** | 用户启动 `sand-create-intent` |
| **后置条件** | 意图声明文件已创建，7 字段至少部分填写 |
| **允许操作** | 编辑任意字段、运行 CLEAR 检查、废弃 |
| **负责角色** | FDE+（意图创建者） |

---

### Reviewed（已审查）

**语义：** 意图声明已通过 CLEAR 检查，等待人工审批。

| 属性 | 说明 |
|------|------|
| **前置条件** | CLEAR 检查 overall 为 pass 或 warn（无 fail） |
| **后置条件** | CLEAR 检查报告已关联到意图文件 |
| **允许操作** | 人工审批、退回修改、废弃 |
| **负责角色** | 技术负责人或指定审批人 |

---

### Approved（已批准）

**语义：** 意图声明和执行契约已确认，可以进入编排和执行。

| 属性 | 说明 |
|------|------|
| **前置条件** | 人工审批通过，执行契约已生成 |
| **后置条件** | 执行契约文件已创建（`.sand/intents/contracts/{intent_id}.contract.yaml`） |
| **允许操作** | 启动编排设计、启动执行、废弃 |
| **负责角色** | 技术负责人 |

---

### In Execution（执行中）

**语义：** 意图已进入 SDC 循环的 Orchestrate → Build → Validate 阶段。

| 属性 | 说明 |
|------|------|
| **前置条件** | 编排方案已确认，执行已启动 |
| **后置条件** | 执行会话记录已创建（`.sand/executions/{session_id}/`） |
| **允许操作** | 执行、暂停、Validate → Build 打回（状态不变）、Validate → Intent 重定向（状态回退） |
| **负责角色** | FDE+（执行监督）、AI Agent（执行者） |

**特殊回退规则：**
- **Validate → Build 打回**：意图状态**保持 In Execution**——只是回到 Build 阶段修复交付物
- **Validate → Intent 重定向**：意图状态回退到 **Draft**（修订现有意图）或创建新意图（废弃当前意图）

---

### Validated（已验证）

**语义：** 交付物已通过 Validate 阶段的三通道验证。

| 属性 | 说明 |
|------|------|
| **前置条件** | Validate 决策为"通过"或"有条件通过" |
| **后置条件** | 验证报告已生成并关联 |
| **允许操作** | 归档、进入 Learn 阶段复盘 |
| **负责角色** | 系统自动（Validate 通过时自动转换） |

---

### Archived（已归档）

**语义：** 意图生命周期结束，成为历史记录和 Learn 阶段的输入。

| 属性 | 说明 |
|------|------|
| **前置条件** | 已验证 + Learn 阶段复盘完成（或显式跳过） |
| **后置条件** | 意图文件标记为只读，关联的资产化建议已记录 |
| **允许操作** | 只读查阅、作为新意图的 context_references |
| **负责角色** | 系统自动或 FDE+ 手动归档 |

---

## 状态机

```
                    ┌─────── 废弃（Draft/Reviewed/Approved 可废弃）
                    │
  ┌─────┐  CLEAR通过  ┌──────────┐  人工审批  ┌──────────┐
  │Draft├──────────→│Reviewed  ├─────────→│Approved  │
  │     │←──────────┤          │          │          │
  └──┬──┘  审批退回   └──────────┘          └────┬─────┘
     ↑                                          │
     ↑ Approved 重新修改                         │ 启动执行
     ↑                                          ↓
     │ Validate→Intent          ┌──────────────┐  Validate  ┌──────────┐
     │ 重定向                    │In Execution  ├──通过────→│Validated │
     └──────────────────────────┤              │           └────┬─────┘
                                │  ←─── Validate→Build 打回 │    │ 归档
                                └──────────────┘                ↓
                                                         ┌──────────┐
                                                         │Archived  │
                                                         └──────────┘
```

---

## 合法状态转换

| 源状态 | 目标状态 | 触发条件 | 所需角色 |
|--------|---------|---------|---------|
| Draft | Reviewed | CLEAR overall ≠ fail | 系统自动 |
| Draft | （废弃） | 用户主动放弃 | FDE+ |
| Reviewed | Approved | 人工审批通过 | 技术负责人 |
| Reviewed | Draft | 审批退回 | 技术负责人 |
| Approved | In Execution | 编排方案确认 + 执行启动 | FDE+ |
| Approved | Draft | 重新修改 | 技术负责人 |
| In Execution | Validated | Validate 决策 = 通过/有条件通过 | 系统自动 |
| In Execution | In Execution | Validate → Build 打回（重新执行） | 系统自动 |
| In Execution | Draft | Validate → Intent 重定向 | 系统自动 |
| Validated | Archived | Learn 阶段复盘完成 | FDE+ 或系统自动 |

**非法转换**：不在上表中的任何转换都是非法的。例如不可从 Archived 直接回到 In Execution——需要创建新意图。

---

## 审计追踪要求

每次状态变更必须记录以下信息到 `.sand/audits/audit.jsonl`：

| 字段 | 说明 | 示例 |
|------|------|------|
| event_id | 唯一事件标识 | `EVT-20260512-001` |
| timestamp | ISO 8601 时间戳 | `2026-05-12T14:30:00Z` |
| intent_id | 关联的意图 ID | `INT-20260512-003` |
| from_status | 变更前状态 | `draft` |
| to_status | 变更后状态 | `reviewed` |
| trigger | 触发原因 | `clear_check_passed` |
| actor | 操作人（人类或系统） | `chen.yu` 或 `system` |
| notes | 补充说明（可选） | `CLEAR warn: E2 性能基线已补充` |

---

## 对 SAND Intent Skill 的实践意义

1. **`sand-create-intent` 管理 Draft → Reviewed**：Skill 的 step-01 到 step-03 在 Draft 状态运行，step-03 CLEAR 通过后自动转为 Reviewed
2. **step-04 执行契约生成发生在 CLEAR 通过后**：CLEAR 通过 → 自动生成执行契约 → 人工审批（审批对象包括意图声明和执行契约）→ Approved
3. **状态流转与 SDC 阶段回退对齐**：Validate → Build 打回不改变意图状态，Validate → Intent 重定向回退意图到 Draft
4. **审计链是 Governance 的基础数据**：每次状态变更的审计事件是 `sand-governance-audit` Skill 构建证据链的数据源

---

## 引用来源

- [PRD §FR13: 意图生命周期状态](../../_bmad-output/planning-artifacts/prd.md)
- [Architecture §.sand/ 目录结构](../../_bmad-output/planning-artifacts/architecture.md)
- [SDC 总览 §阶段间回退路径](../sdc-overview.md)
