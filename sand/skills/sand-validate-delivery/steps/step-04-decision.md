# Step 4: 验证决策矩阵（Decision Matrix）

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous
5. The 14-row priority table MUST be applied exactly as defined — no deviation

## YOUR TASK:

合并三通道结果，应用 14 行优先级判定表生成验证决策，记录偏差事件，经人类确认后输出完整验证报告。

## EXECUTION SEQUENCE:

向用户显示：
```
[Step 4/4] 验证决策
```

### 1. 收集三通道结果

从前三个 step 的暂存结果中收集：

| 通道 | 结果变量 | 可能值 |
|------|---------|-------|
| 契约验证 | `contract_result` | PASS / PASS_WITH_WARNINGS / FAIL |
| 安全合规 | `security_result` | PASS / PASS_WITH_WARNINGS / FAIL |
| 架构对齐 | `architecture_result` | PASS / PASS_WITH_WARNINGS / FAIL |
| 意图偏差信号 | `intent_deviation_signal` | 有 / 无（来自 step-01 意图对齐度分析） |

向用户显示三通道汇总：
```
三通道验证结果汇总：
  契约验证:   {contract_result}
  安全合规:   {security_result}
  架构对齐:   {architecture_result}
  意图偏差:   {intent_deviation_signal}
```

### 2. 应用 14 行优先级判定表

**按优先级从高到低匹配第一条命中规则：**

| # | 契约 | 安全 | 架构 | 意图偏差 | 决策 |
|---|------|------|------|---------|------|
| 1 | PASS | PASS | PASS | — | **pass** |
| 2 | PASS | PASS_W | PASS | — | **conditional_pass** |
| 3 | PASS | PASS | PASS_W | — | **conditional_pass** |
| 4 | PASS_W | PASS | PASS | — | **conditional_pass** |
| 5 | PASS | PASS_W | PASS_W | — | **conditional_pass** |
| 6 | PASS_W | PASS | PASS_W | — | **conditional_pass** |
| 7 | PASS_W | PASS_W | PASS | — | **conditional_pass** |
| 8 | PASS_W | PASS_W | PASS_W | — | **conditional_pass** |
| 9 | — | FAIL | — | — | **reject_to_build** |
| 10 | — | — | FAIL | — | **reject_to_build** |
| 11 | FAIL | PASS/W | PASS/W | 有 | **redirect_to_intent** |
| 12 | FAIL | PASS/W | PASS/W | 无 | **reject_to_build** |
| 13 | FAIL | FAIL | — | — | **reject_to_build** |
| 14 | FAIL | — | FAIL | — | **reject_to_build** |

> PASS_W = PASS_WITH_WARNINGS, PASS/W = PASS or PASS_WITH_WARNINGS, — = any value

**关键设计决策：**
- 安全 FAIL（规则 9）和架构 FAIL（规则 10）优先级高于意图偏差——安全漏洞和架构违规必须回退到 Build 修复
- 意图偏差信号仅在契约通道是唯一 FAIL 来源时才触发 redirect_to_intent（规则 11）

### 3. 生成决策结果

根据匹配的规则，执行对应的决策处理：

#### 3a. pass 决策

```
✅ 验证决策: PASS — 交付物通过全部验证
后续动作: → Operate（部署）
```

生成：
```yaml
decision:
  result: pass
  timestamp: "{ISO-8601}"
  next_action: operate
```

#### 3b. conditional_pass 决策

收集所有 warning 条目为 `tech_debt_items`：

```yaml
tech_debt_items:
  - source_channel: "{channel}"
    check_item: "{check_name}"
    description: "{warning_detail}"
    suggested_deadline: "{current_date + 30 days}"
    severity: warning
```

```
⚠️ 验证决策: CONDITIONAL PASS — 交付物基本通过，存在 {N} 条技术债
后续动作: → Operate + 技术债记录
技术债项:
{逐条列出}
```

#### 3c. reject_to_build 决策

收集所有 FAIL 检查项为 `fix_guidance`，并保留其他通道的 warnings：

```yaml
fix_guidance:
  failed_checks:
    - channel: "{channel}"
      check_item: "{check_name}"
      failure_reason: "{reason}"
      suggested_fix: "{suggestion}"
  other_channel_warnings:
    - channel: "{channel}"
      check_item: "{check_name}"
      description: "{warning_detail}"
  revalidation_required: true
```

```
❌ 验证决策: REJECT TO BUILD — 交付物需要修复
后续动作: → Build（修复后重新验证）
失败项:
{逐条列出}
其他通道 Warnings（修复时一并处理）:
{如有列出}
```

#### 3d. redirect_to_intent 决策

生成意图修正建议：

```yaml
intent_correction:
  intent_id: "{intent_id}"
  correction_reason: "{reason}"
  affected_fields:
    - field: "{field_name}"
      issue: "{issue_description}"
      suggestion: "{suggestion}"
  revalidation_required: true
  full_cycle_required: true
```

```
🔄 验证决策: REDIRECT TO INTENT — 偏差源自意图声明
后续动作: → Intent（修正意图声明后重新 Build + Validate）
修正建议:
{逐条列出}
```

### 4. 记录偏差事件

对所有 FAIL 和 WARNING 检查项，生成偏差事件：

每条偏差事件结构（12 字段）：
```yaml
- deviation_id: "DEV-{session_id}-{seq}"
  timestamp: "{ISO-8601}"
  deviation_type: "{contract_deviation|security_deviation|architecture_deviation|intent_scope_deviation}"
  source_channel: "{contract|security|architecture}"
  severity: "{blocking|warning|info}"
  related_acceptance_criteria: "{MP-NNN or null}"
  description: "{deviation description}"
  root_cause_hypothesis: "{AI-generated hypothesis}"
  suggested_action: "{suggested fix}"
  resolution: null  # 或 "auto_resolved" for info 级别（D4 处理）
  resolution_notes: null
  learning_signal: "{AI-generated learning signal suggestion}"  # D5: 提示 AI 生成，标记待人类确认
```

**偏差类型映射：**
- step-01 的 FAIL/WARNING → `contract_deviation`
- step-02 的 FAIL/WARNING → `security_deviation`
- step-03 的 FAIL/WARNING → `architecture_deviation`
- step-01 意图偏差信号（且触发 redirect_to_intent）→ `intent_scope_deviation`

**跨通道偏差处理（D3）：** 如同一底层问题在多个通道触发，为每个通道创建独立偏差事件，在 `description` 中注明"此偏差与 DEV-{session_id}-{other_seq} 可能有相同根因"。

**info 级偏差处理（D4）：** 自动标记 `resolution: "auto_resolved"`，但仍输出到 deviations.json。FDE+ 可在后续复盘中手动覆盖该值。注：`auto_resolved` 是对理论文档 3 值枚举（resolved/risk_accepted/rejected_to_rebuild）的实现扩展，表示系统自动处理而非人类决策。

**learning_signal 生成（D5）：** AI 为每条偏差生成 learning_signal 建议值，格式为"[AI 建议] {signal content}"，标记待人类确认。

### 5. HIP 级别人类确认

根据 Skill 配置的 `human_oversight: "hip-2"` 和决策结果，请求人类确认：

| 决策 | HIP-2 确认方式 |
|------|--------------|
| pass | 通知确认："验证通过，确认部署？(y/n)" |
| conditional_pass | 逐条审查 warning："以下技术债项是否接受？(y/n 逐条)" |
| reject_to_build | 逐条审查 FAIL："以下修复指引是否准确？(y/n)" |
| redirect_to_intent | 逐条审查修正建议："以下意图修正是否合理？(y/n 逐条)" |

记录人类确认：
```yaml
human_confirmation:
  required: true
  hip_level: "hip-2"
  confirmed_by: "{user_name}"
  confirmed_at: "{ISO-8601}"
```

### 6. 输出验证报告

将完整验证报告写入 `.sand/executions/EXE-{session_id}/validation-report.yaml`：

从 `templates/validation-report.yaml` 初始化，填充所有字段：
- `validation_report.session_id`
- `validation_report.intent_id`
- `validation_report.timestamp`
- `validation_report.overall_result`（三通道合并结果，计算逻辑：any channel == FAIL → `fail`; any channel == PASS_WITH_WARNINGS → `pass_with_warnings`; else → `pass`。注意：此值是三通道原始合并结果，与 `decision.result` 不同——后者是经决策矩阵处理后的最终决策）
- `validation_report.channels.*`（三通道详细结果）
- `validation_report.decision.*`（决策结果 + 附属数据）
- `validation_report.deviations`（偏差事件引用）
- `validation_report.human_review_required: true`
- `validation_report.hip_level: "hip-2"`

### 7. 输出偏差事件

将所有偏差事件写入 `.sand/executions/EXE-{session_id}/deviations.json`：

```json
{
  "session_id": "EXE-{session_id}",
  "intent_id": "{intent_id}",
  "validation_timestamp": "{ISO-8601}",
  "total_deviations": {count},
  "severity_summary": {
    "blocking": {count},
    "warning": {count},
    "info": {count}
  },
  "deviations": [...]
}
```

### 8. 最终摘要

向用户显示验证完成摘要：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  sand-validate-delivery 验证完成
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
会话 ID:    {session_id}
意图 ID:    {intent_id}
验证决策:   {decision_result}
后续动作:   {next_action}

通道结果:
  契约验证:  {contract_result}
  安全合规:  {security_result}
  架构对齐:  {architecture_result}

偏差统计:
  blocking:  {count}
  warning:   {count}
  info:      {count}

输出文件:
  验证报告:  .sand/executions/EXE-{session_id}/validation-report.yaml
  偏差事件:  .sand/executions/EXE-{session_id}/deviations.json

人类确认:   {confirmed_by} @ {confirmed_at}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## SUCCESS METRICS:

✅ 三通道结果正确合并
✅ 14 行判定表正确匹配决策
✅ 决策对应的附属数据（tech_debt/fix_guidance/intent_correction）完整生成
✅ 偏差事件全部记录（12 字段结构），含 AI 生成的 learning_signal
✅ HIP-2 人类确认完成
✅ validation-report.yaml 正确输出
✅ deviations.json 正确输出
✅ D1-D6 遗留设计决策全部在本 step 中体现

## FAILURE MODES:

❌ 三通道结果不完整（某通道未执行）→ 缺失通道默认为 FAIL（D2），记录偏差
❌ 用户拒绝确认决策 → HALT，请用户说明原因并决定下一步
❌ 文件写入失败 → HALT，提示检查 .sand/ 目录权限

## NEXT STEP:

验证流程完成。无后续步骤。

根据验证决策，用户可选择：
- **pass / conditional_pass** → 交付物进入 Operate 阶段
- **reject_to_build** → 回到 Build 阶段修复
- **redirect_to_intent** → 回到 Intent 阶段修正意图声明
