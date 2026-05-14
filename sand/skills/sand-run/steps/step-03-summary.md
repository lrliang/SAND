# Step 3: 执行摘要 + 偏差汇总

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. 此步骤为只读汇总——不修改已完成的 Skill 产出

## YOUR TASK:

从 `execution.yaml` 生成执行摘要，汇总审计事件，检查偏差记录，更新最终执行状态，提示下一步操作。

## EXECUTION SEQUENCE:

### 1. 生成执行摘要

从 `.sand/executions/EXE-{session_id}/execution.yaml` 读取完整执行状态：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Step 3/3] 执行摘要

Session:     EXE-{session_id}
Plan:        {plan_id}
Intent:      {intent_id}
Topology:    {topology}
HIP Level:   {human_oversight}
Status:      {status}
Started:     {started_at}
Completed:   {completed_at}
Duration:    {计算耗时}

Steps Summary:
  Total:     {total_count}
  Success:   {success_count}
  Failed:    {failure_count}
  Skipped:   {skipped_count}

Step Details:
  {order}. {skill_name} — {status} ({duration})
  {order}. {skill_name} — {status} ({duration})
  ...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 2. 汇总审计事件

从 `.sand/audits/audit.jsonl` 过滤当前 session 的审计事件：

```
过滤条件：execution_id == "EXE-{session_id}"
```

展示审计摘要：
```
审计事件汇总：
  总事件数:    {count}
  成功事件:    {success_count}
  失败事件:    {failure_count}
  人类确认数:  {total_human_confirmations}
  
  Hash 验证:
    输入完整性: {input_hash_count}/{total} 个 Skill 有 input_hash
    输出完整性: {output_hash_count}/{total} 个 Skill 有 output_hash
```

### 3. 检查偏差记录

检查 `.sand/executions/EXE-{session_id}/deviations.json` 是否存在：

**如果存在偏差事件：**
```
偏差事件汇总：
  总偏差数:    {total_deviations}
  Blocking:   {blocking_count}
  Warning:    {warning_count}
  Info:       {info_count}
  
  关键偏差:
  - [{severity}] {deviation_type}: {description}
  - [{severity}] {deviation_type}: {description}
```

**如果不存在偏差文件：**
```
偏差事件: 无（Build 阶段未记录偏差或未运行验证）
```

### 4. 更新最终执行状态

确认 `execution.yaml` 的 `status` 字段反映最终状态：
- `completed` — 所有 Skill 成功完成
- `partial` — 部分 Skill 成功，存在失败或跳过
- `interrupted` — 用户主动中止
- `failure` — 关键 Skill 失败导致无法继续

设置 `completed_at` 为当前时间（如尚未设置）。

保存 `execution.yaml`。

### 5. 提示下一步操作

根据执行状态提供建议：

**如果 status = completed：**
```
执行完成！所有 {total_count} 个 Skill 成功执行。

下一步建议:
1. 运行 `sand-validate-delivery` 对交付物进行三通道验证
2. 查看审计日志: .sand/audits/audit.jsonl
3. 查看执行详情: .sand/executions/EXE-{session_id}/execution.yaml
```

**如果 status = partial：**
```
执行部分完成（{success_count}/{total_count} 成功）。

失败/跳过的 Skill:
  - {skill_name}: {status} — {error 或 "用户跳过"}

建议:
1. 修复失败原因后重新运行 sand-run（断点续传将跳过已完成步骤）
2. 如果跳过的 Skill 不影响交付，可直接运行 sand-validate-delivery
```

**如果 status = interrupted：**
```
执行已中止（{success_count}/{total_count} 完成）。

重新运行 sand-run 时将提供恢复选项，从上次中断处继续。
```

## SUCCESS METRICS:

- 执行摘要正确反映所有 Skill 的执行结果
- 审计事件汇总与 audit.jsonl 中的数据一致
- 偏差记录（如存在）正确汇总
- execution.yaml status 和 completed_at 已更新
- 下一步操作建议与当前状态匹配

## FAILURE MODES:

- execution.yaml 不存在或不可读 → 显示警告，尝试从 audit.jsonl 重建摘要
- audit.jsonl 不存在 → 显示"审计日志不可用"
- deviations.json 格式错误 → 显示"偏差文件格式异常，请手动检查"

## NEXT STEP:

执行引擎工作完成。根据状态建议下一步操作（通常为 `sand-validate-delivery`）。
