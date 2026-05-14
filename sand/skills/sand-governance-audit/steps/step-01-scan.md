# Step 1: 审计事件扫描

## MANDATORY EXECUTION RULES (READ FIRST):

1. 读完整个步骤文件后再执行——不要边读边做
2. 按编号顺序执行每个子节——不跳步
3. 遇到不确定性时请求人类确认——不猜测用户意图
4. 每个子节完成后向用户汇报进度——保持透明
5. 失败时快速报错并说明原因——不静默降级或继续

## YOUR TASK:

扫描 `.sand/audits/audit.jsonl` 中的审计事件，按用户指定的时间范围和筛选条件提取目标事件集。

## EXECUTION SEQUENCE:

### §1 检查审计日志存在性

检查 `.sand/audits/audit.jsonl` 文件是否存在且非空。

**如果文件不存在或为空：**
- 输出：`❌ 未找到审计日志文件 .sand/audits/audit.jsonl`
- 提示：`审计事件由 SandRuntime 在 Skill 执行时自动记录。请先运行至少一个 SAND Skill（如 sand-create-intent 或 sand-validate-delivery）来产生审计数据。`
- **HALT** — 无法继续

### §2 收集时间范围

提示用户输入审计扫描的时间范围：

```
📊 审计事件扫描

请指定扫描时间范围：
[1] 过去 1 周
[2] 过去 2 周
[3] 过去 4 周（默认）
[4] 自定义范围（ISO-8601 格式，如 2026-05-01T00:00:00Z 到 2026-05-14T23:59:59Z）
```

将用户选择转换为 `time_from` 和 `time_to` 两个 ISO-8601 UTC 时间戳。默认选项为过去 4 周。

### §3 解析和筛选审计事件

逐行读取 `.sand/audits/audit.jsonl`，每行解析为 JSON 对象（SandAuditEvent 格式）。

对每条事件执行以下筛选：
- **时间范围**：`timestamp` 在 `time_from` 至 `time_to` 之间
- 跳过格式错误的行（记录警告但不中断）

将通过筛选的事件存入内存事件集合。

### §4 可选维度筛选

向用户展示扫描摘要后，提供可选的进一步筛选：

```
📋 初步扫描结果：{total_count} 条事件

是否需要进一步筛选？
[A] 按意图 ID 筛选（输入 INT-YYYYMMDD-{seq}）
[B] 按 Skill 名称筛选（输入 sand-*）
[C] 按 SDC 阶段筛选（assess/intent/orchestrate/build/validate/operate/learn/governance）
[D] 按执行状态筛选（success/failure/interrupted）
[E] 按执行者筛选（human/agent）
[N] 不需要，使用全部事件继续
```

如果用户选择筛选维度，应用筛选并更新事件集合。支持组合筛选（多次选择）。

### §5 输出扫描摘要

向用户展示最终扫描结果摘要：

```
✅ 审计事件扫描完成

📊 扫描摘要：
- 时间范围：{time_from} — {time_to}
- 总事件数：{total_events}
- 唯一 Intent 数：{unique_intents}（含 {unlinked} 条未关联事件）
- 唯一 Skill 数：{unique_skills}
- 执行会话数：{unique_executions}
- 失败事件数：{failure_count}
- 中断事件数：{interrupted_count}
- 人工确认记录数：{total_confirmations}
```

将扫描结果（事件集合 + 摘要统计）传递给下一步骤。

## SUCCESS METRICS:

✅ audit.jsonl 成功解析，格式错误行已跳过并警告
✅ 时间范围筛选正确应用
✅ 可选维度筛选正确应用（如选择）
✅ 扫描摘要统计数据准确

## FAILURE MODES:

❌ audit.jsonl 不存在 → HALT 并建议先运行 Skill 产生审计数据
❌ audit.jsonl 全部为格式错误行 → HALT 并报告文件损坏
❌ 时间范围内无事件 → 提示用户扩大时间范围或检查审计数据

## NEXT STEP:

继续执行 `steps/step-02-chain.md` — 构建证据链
