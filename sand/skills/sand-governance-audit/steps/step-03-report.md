# Step 3: 审计追踪报告生成

## MANDATORY EXECUTION RULES (READ FIRST):

1. 读完整个步骤文件后再执行——不要边读边做
2. 按编号顺序执行每个子节——不跳步
3. 遇到不确定性时请求人类确认——不猜测用户意图
4. 每个子节完成后向用户汇报进度——保持透明
5. 失败时快速报错并说明原因——不静默降级或继续

## YOUR TASK:

从 Step 2 构建的证据链生成结构化审计追踪报告，支持 JSON/CSV 导出，满足模拟 SOC2 检查需求。

## EXECUTION SEQUENCE:

### §1 初始化报告结构

从 `templates/audit-report.yaml` 读取报告模板结构，准备填充。

如果模板文件不存在，使用以下内联结构：
```yaml
report_metadata: {}
evidence_summary: []
intent_details: []
anomalies:
  failures: []
  interruptions: []
  missing_confirmations: []
compliance_mapping:
  iso_42001: []
  eu_ai_act: []
  nist_ai_rmf: []
```

### §2 填充报告元数据

填充 `report_metadata` 节：

```yaml
report_metadata:
  report_id: "AUD-YYYYMMDD-{seq}"   # 当日日期 + 序号（扫描 .sand/audits/reports/ 确定下一个序号）
  generated_at: "ISO-8601 UTC"        # 当前 UTC 时间
  time_range:
    from: "{time_from}"               # Step 1 确定的时间范围
    to: "{time_to}"
  sand_version: "{sand_version}"      # 从事件中提取最新的 sand_version
  total_events: {count}
  total_intents: {count}
  total_failures: {count}
  total_interruptions: {count}
```

`report_id` 序号规则：扫描 `.sand/audits/reports/` 目录中同日期的报告数量，+1 作为序号。如目录不存在则创建。

### §3 填充证据链摘要

填充 `evidence_summary` 节——每个 Intent 一行摘要：

```yaml
evidence_summary:
  - intent_id: "INT-20260512-001"
    intent_purpose: "实现多租户权限隔离"    # 从 §6a 提取，不可用时为空
    execution_count: 1                       # 该 Intent 下的执行会话数
    skill_chain:                             # Skill 调用链
      - "sand-create-intent@0.1.0"
      - "sand-validate-delivery@0.1.0"
    human_confirmations_count: 3             # 人工确认总数
    status: "success"                        # 整体状态判定逻辑见下
    compliance_flags: []                     # MVP 保留为空
```

**整体状态判定逻辑：**
- 所有事件 `status` = success → `"success"`
- 存在 failure 但无 interrupted → `"partial_failure"`
- 存在 interrupted → `"interrupted"`
- 混合状态 → `"partial_failure"`

### §4 填充意图级明细

填充 `intent_details` 节——每个 Intent 展开完整链路：

```yaml
intent_details:
  - intent_id: "INT-20260512-001"
    intent_purpose: "实现多租户权限隔离"
    executions:
      - execution_id: "EXE-20260512-001"
        events:
          - event_id: "uuid-1"
            timestamp: "2026-05-12T10:00:00Z"
            skill_name: "sand-create-intent"
            skill_version: "0.1.0"
            sdc_phase: "intent"
            step: "step-03-clear-check"
            actor: "agent"
            host: "claude-code"
            model_used: "claude-opus-4-6"
            status: "success"
            input_hash: "sha256:..."
            output_hash: "sha256:..."
            human_confirmations:
              - step: "step-02-draft"
                timestamp: "2026-05-12T10:15:00Z"
                decision: "approved"
            error: null
    deviations: []                # 从 deviations.json 提取
    validation_result: "通过"     # 从 validation-report.yaml 提取
```

每条事件保留 SandAuditEvent 的全部字段（不丢弃任何字段）。

### §5 填充异常事件高亮

填充 `anomalies` 节：

- `failures`：所有 `status == "failure"` 的事件（含 `error` 字段内容）
- `interruptions`：所有 `status == "interrupted"` 的事件
- `missing_confirmations`：Step 2 §7 检测到的缺失确认事件

每条异常包含 `event_id`、`intent_id`、`skill_name`、`step`、`timestamp` 和异常原因。

### §6 填充合规标准映射

填充 `compliance_mapping` 节：

**MVP 范围：** 仅输出预留结构框架，不填充具体行业映射。添加注释说明 Phase 5 将扩展：

```yaml
compliance_mapping:
  # MVP：预留结构。Phase 5 将填充行业垂直映射（PCI DSS、HIPAA、EU AI Act 高风险细化）
  iso_42001: []    # A.7 记录控制、A.9 内部审计映射
  eu_ai_act: []    # Article 12/17 映射
  nist_ai_rmf: []  # Govern/Detect 功能映射
```

### §7 输出审计报告

将完成的报告写入 `.sand/audits/reports/AUD-{date}-{seq}.yaml`。

确保输出目录 `.sand/audits/reports/` 存在（不存在则创建）。

使用 YAML 格式，遵循以下规范：
- 2 空格缩进
- 字符串无引号（除非含特殊字符）
- 布尔值 true/false
- 空值 null
- UTF-8 编码，LF 换行

输出成功消息：
```
📄 审计追踪报告已生成

路径：.sand/audits/reports/AUD-{date}-{seq}.yaml
报告 ID：AUD-{date}-{seq}
覆盖：{total_intents} 个 Intent，{total_events} 条事件
异常：{failure_count} 次失败，{interrupted_count} 次中断，{missing_conf_count} 处缺失确认
```

### §8 导出选项

向用户提供导出选项：

```
📤 导出选项

[1] JSON 导出 — 完整结构化数据（.sand/audits/reports/AUD-{date}-{seq}.json）
[2] CSV 导出 — 扁平化 evidence_summary 表（.sand/audits/reports/AUD-{date}-{seq}.csv）
[3] 两者都导出
[N] 不需要额外导出，YAML 报告即可
```

**JSON 导出：** 将 YAML 报告直接转换为等效 JSON 结构。
**CSV 导出：** 将 `evidence_summary` 节扁平化为 CSV 表，列包含：`intent_id, intent_purpose, execution_count, skill_chain, human_confirmations_count, status`。`skill_chain` 列使用 pipe (`|`) 连接多个值（如 `sand-create-intent@0.1.0|sand-validate-delivery@0.1.0`）。

### §9 赵明旅程式摘要

为每个 Intent 生成一句话的"审计师友好"摘要——回答"AI 为什么做了这个决策"：

```
🔍 审计师摘要（赵明旅程视角）

对于 INT-20260512-001（实现多租户权限隔离）：
→ 意图由人类创建并通过 CLEAR 质量检查，AI 在 HIP-2 监督下执行，
  经三通道验证通过（契约✓ 安全✓ 架构✓），3 个关键节点有人工确认。
  证据链完整，无异常。

对于 INT-20260512-002（...）：
→ ...
```

这一摘要是审计报告的"执行摘要"——审计师可以先看摘要，再按需下钻到 `intent_details` 查看完整链路。

## SUCCESS METRICS:

✅ 报告 YAML 格式正确（2 空格缩进、UTF-8、LF）
✅ 报告包含全部 5 个顶层节（report_metadata、evidence_summary、intent_details、anomalies、compliance_mapping）
✅ report_id 序号不与已有报告冲突
✅ JSON/CSV 导出功能可用（FR30）
✅ 赵明旅程式摘要可回答"AI 为什么做了这个决策"（AC #4）

## FAILURE MODES:

❌ 输出目录创建失败 → HALT 并报告权限问题
❌ YAML 序列化失败 → HALT 并报告数据结构问题
❌ 证据链数据为空（Step 2 传递错误）→ HALT 并建议重新运行
