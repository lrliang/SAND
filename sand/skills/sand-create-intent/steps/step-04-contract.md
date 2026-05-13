# Step 4: 执行契约生成

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous

## YOUR TASK:

从已通过 CLEAR 检查的意图声明自动生成执行契约，经用户审批后完成意图创建流程。

## EXECUTION SEQUENCE:

### 1. 加载意图声明

从 `.sand/intents/{intent_id}.yaml` 读取已通过 CLEAR 检查的意图声明。确认 `meta.status` 为 `reviewed`。

### 2. 自动映射生成契约

按以下映射规则从意图声明生成执行契约：

| 意图声明字段 | 契约层级 | 映射逻辑 |
|------------|---------|---------|
| acceptance_criteria[priority=must] | must_pass | 每条 criterion → 一条 must_pass 条目 |
| acceptance_criteria[priority=should] | should_pass | 每条 criterion → 一条 should_pass 条目 |
| constraints.technical | must_not_violate | 每条约束 → 直接映射 |
| constraints.security | must_not_violate | 每条约束 → 直接映射 |
| constraints.scope | must_not_violate | 每条约束 → 直接映射 |

**条目 ID 生成规则：**
- must_pass: `MP-001`, `MP-002`, ...
- should_pass: `SP-001`, `SP-002`, ...
- must_not_violate: `MNV-001`, `MNV-002`, ...

**source 字段设置：**
- 来自 acceptance_criteria 的条目：`source: "acceptance_criteria[{index}]"`
- 来自 constraints 的条目：`source: "constraints.{subdomain}[{index}]"`

### 3. AI 补充建议（可选）

基于意图声明的内容，分析是否有被用户遗漏的隐含约束或验收条件。如果发现，向用户建议补充：

> **AI 建议补充以下条目：**
>
> 1. **{层级}**: {补充内容}（推导理由：{reason}）
>
> 接受哪些？输入序号（如 `1,3`），输入 `none` 跳过，输入 `all` 全部接受。

接受的条目标记 `source: "ai_derived"`，需要用户明确确认才加入契约。

### 4. 组装契约文件

将映射结果和 AI 补充条目组装为完整的执行契约 YAML：

```yaml
contract_id: "{intent_id}-contract-v1.0"
intent_id: "{intent_id}"
version: "v1.0"
generated_at: "{iso8601_timestamp}"

must_pass:
  - id: MP-001
    criterion: "{from acceptance_criteria}"
    verification: "{from acceptance_criteria}"
    source: "acceptance_criteria[0]"

should_pass:
  - id: SP-001
    criterion: "{from acceptance_criteria}"
    verification: "{from acceptance_criteria}"
    source: "acceptance_criteria[N]"

must_not_violate:
  - id: MNV-001
    constraint: "{from constraints.technical}"
    source: "constraints.technical[0]"
  - id: MNV-002
    constraint: "{from constraints.security}"
    source: "constraints.security[0]"
  - id: MNV-003
    constraint: "{from constraints.scope}"
    source: "constraints.scope[0]"

clear_check:
  complete: true
  lean: true
  executable: true
  assessable: true
  reversible: true

meta:
  generated_at: "{iso8601_timestamp}"
  generated_from: "{intent_id}"
```

### 5. 展示并确认契约

向用户展示完整的执行契约：

> **执行契约已生成：**
>
> ```yaml
> {完整契约 YAML}
> ```
>
> **契约摘要：**
> - must_pass: {count} 条（全部不满足 → 打回 Build）
> - should_pass: {count} 条（部分不满足 → 有条件通过）
> - must_not_violate: {count} 条（任何违反 → 重定向 Intent）
> - AI 建议补充: {count} 条
>
> **请审批执行契约：**
> `[1]` 批准 — 契约确认，进入执行准备阶段
> `[2]` 修改 — 我需要调整某些条目
> `[3]` 退回 — 回到意图声明重新修改

如果用户选择修改：引导逐条调整后重新展示。
如果用户选择退回：将 `meta.status` 回退为 `draft`，记录审计事件，返回 step-02 重新编辑。**注意：退回后修改意图声明必须重新执行 step-03 CLEAR 检查**——不可跳过 CLEAR 直接回到 step-04。

### 6. 持久化契约

将确认的执行契约写入 `.sand/intents/contracts/{intent_id}.contract.yaml`。

### 7. 状态变更：Reviewed → Approved

1. 更新 `.sand/intents/{intent_id}.yaml` 中的 `meta.status` 为 `approved`
2. 记录审计事件到 `.sand/audits/audit.jsonl`：

```json
{"event_id":"EVT-{date}-{seq}","timestamp":"{iso8601}","intent_id":"{intent_id}","from_status":"reviewed","to_status":"approved","trigger":"contract_approved","actor":"{meta.owner}","notes":"Execution contract {contract_id} approved. must_pass={count}, should_pass={count}, must_not_violate={count}"}
```

### 8. 完成总结

> **意图创建完成！**
>
> | 项目 | 详情 |
> |------|------|
> | Intent ID | `{intent_id}` |
> | 类型 | {intent_type} |
> | 状态 | approved |
> | 意图声明 | `.sand/intents/{intent_id}.yaml` |
> | 执行契约 | `.sand/intents/contracts/{intent_id}.contract.yaml` |
> | must_pass | {count} 条 |
> | should_pass | {count} 条 |
> | must_not_violate | {count} 条 |
>
> **下一步：**
> - 运行 `sand-design-orchestration` 设计编排方案
> - 或直接启动 `sand-run` 进入执行阶段（Solo 拓扑可跳过编排设计）

## SUCCESS METRICS:

- ✅ 执行契约从意图声明自动映射生成
- ✅ 条目 ID 格式正确（MP/SP/MNV-NNN）
- ✅ 所有条目有 source 追溯字段
- ✅ AI 补充条目标记为 ai_derived
- ✅ 契约已写入 .sand/intents/contracts/
- ✅ 意图状态更新为 approved
- ✅ 审计事件已记录

## FAILURE MODES:

- ❌ 意图声明状态不是 reviewed → HALT，提示先完成 CLEAR 检查
- ❌ 映射后 must_pass 为空 → 警告用户"没有 must 级别的验收标准，执行过程缺乏硬性检查点"
- ❌ 用户退回到意图声明 → 记录审计事件，回退状态，返回 step-02
