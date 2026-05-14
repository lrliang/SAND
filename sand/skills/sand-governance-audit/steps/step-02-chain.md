# Step 2: 证据链构建

## MANDATORY EXECUTION RULES (READ FIRST):

1. 读完整个步骤文件后再执行——不要边读边做
2. 按编号顺序执行每个子节——不跳步
3. 遇到不确定性时请求人类确认——不猜测用户意图
4. 每个子节完成后向用户汇报进度——保持透明
5. 失败时快速报错并说明原因——不静默降级或继续

## YOUR TASK:

从 Step 1 扫描到的审计事件集合中构建意图→执行→Skill→步骤→确认→验证的完整证据链。

## EXECUTION SEQUENCE:

### §1 按 Intent ID 分组

将事件集合按 `intent_id` 字段分组：
- 有 `intent_id` 的事件按其值分组
- 无 `intent_id`（字段缺失或为空）的事件归入"未关联"分组（`_unlinked`）

输出分组结果：
```
🔗 证据链分组

已关联 Intent：{linked_count} 个
- INT-20260512-001：{event_count} 条事件
- INT-20260512-002：{event_count} 条事件
...
未关联事件：{unlinked_count} 条
```

### §2 按 Execution ID 子分组

每个 Intent 组内，按 `execution_id` 字段进一步分组：
- 每个 `execution_id`（如 `EXE-20260512-001`）代表一个执行会话
- 同一 Intent 可能有多个执行会话（重试、多次运行）
- 无 `execution_id` 的事件归入该 Intent 的"直接事件"子组

### §3 事件排序

每个执行会话内，按 `timestamp` 字段升序排列事件。

验证时间连续性：`timestamp` 排序后的顺序应与 `step` 编号顺序大致一致（step-01 的时间早于 step-02）。如有不一致，标记为警告但不阻断。

### §4 提取 Skill 调用链

从每个执行会话的有序事件中提取 Skill 调用链：

按事件顺序收集唯一的 `skill_name@skill_version` 对，保持首次出现的顺序。

示例输出：
```
Skill 调用链：sand-create-intent@0.1.0 → sand-validate-delivery@0.1.0
```

### §5 汇总人工确认记录

跨所有事件合并 `human_confirmations` 数组：
- 收集每条事件中 `human_confirmations` 数组的所有条目
- 去重（同一 `step` + `timestamp` + `decision` 组合视为同一条）
- 按 `timestamp` 排序

输出汇总：
```
👤 人工确认点：{total} 条
- step-02-draft: approved (2026-05-12T10:15:00Z)
- step-03-clear-check: approved (2026-05-12T10:32:00Z)
...
```

### §6 跨数据源丰富证据链

从辅助数据源补充证据链上下文（所有辅助源为可选——不存在时标记"数据不可用"，不报错）：

**6a. 意图声明摘要**
对每个 `intent_id`，尝试读取 `.sand/intents/{intent_id}.yaml`：
- 如果存在：提取 `purpose` 字段作为意图摘要
- 如果不存在：标记 `intent_purpose: "（意图文件不可用）"`

**6b. 偏差事件**
对每个 `execution_id`，尝试读取 `.sand/executions/{execution_id}/deviations.json`：
- 如果存在：提取偏差事件列表
- 如果不存在：标记 `deviations: []`

**6c. 验证结果**
对每个 `execution_id`，尝试读取 `.sand/executions/{execution_id}/validation-report.yaml`：
- 如果存在：提取验证决策（通过/有条件通过/打回/重定向）
- 如果不存在：标记 `validation_result: "（验证报告不可用）"`

### §7 证据链完整性检测

对构建好的证据链执行完整性检查，标记以下异常：

| 异常类型 | 检测条件 | 严重级别 |
|---------|---------|---------|
| **缺失 Intent** | 有 `execution_id` 但无 `intent_id` 的事件 | WARNING |
| **缺失确认** | HIP-2/3 场景下（从 `.sand/config.yaml` 读取 `default_human_oversight`，默认 hip-2），步骤无 `human_confirmations` 记录 | WARNING |
| **链路断裂** | Intent 下有事件但无完整的 step 序列（跳号） | INFO |
| **失败事件** | `status` 为 failure 或 interrupted | HIGHLIGHT |
| **Hash 不一致** | 跨步骤 `output_hash` ≠ 下一步 `input_hash`（仅 Pipeline 场景） | WARNING |

输出完整性报告：
```
🔍 证据链完整性检查

✅ 完整链路：{complete_count} 个 Intent
⚠️ 缺失确认：{missing_conf_count} 个步骤
⚠️ 缺失 Intent 关联：{missing_intent_count} 条事件
ℹ️ 链路跳号：{gap_count} 处
🔴 失败/中断事件：{failure_count} 条
```

将完整的证据链数据结构传递给下一步骤。

## SUCCESS METRICS:

✅ 所有事件按 intent_id → execution_id → timestamp 正确分组排序
✅ Skill 调用链提取准确，保持执行顺序
✅ human_confirmations 跨事件正确合并去重
✅ 辅助数据源优雅处理（存在则丰富，不存在则标记不可用）
✅ 完整性检查识别所有异常并分级报告

## FAILURE MODES:

❌ 事件集合为空（Step 1 传递错误）→ HALT 并建议重新运行 Step 1
❌ JSON 解析失败（事件格式损坏）→ 跳过损坏事件，记录警告
❌ 辅助数据源文件格式错误 → 标记为"数据不可用"，不阻断

## NEXT STEP:

继续执行 `steps/step-03-report.md` — 生成审计追踪报告
