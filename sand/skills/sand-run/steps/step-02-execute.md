# Step 2: 按拓扑执行 Skill 链

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. **每个 Skill 完成后必须更新 execution.yaml 和 audit.jsonl**——不可延迟到所有 Skill 完成后批量写入
5. 跳过 `steps_completed` 中已完成的 Skill（断点续传）
6. MVP 仅支持 Pipeline 拓扑——Skill 按 order 严格顺序执行

## YOUR TASK:

按 Pipeline 拓扑顺序执行 `skill_chain` 中的每个 Skill。对每个 Skill：HostChecker 检查 → Executor 执行 → StateManager 更新状态 → HashComputer 计算 hash → AuditWriter 记录审计事件。支持断点续传和 HIP 审查。

## EXECUTION SEQUENCE:

### 1. 加载执行状态

从 `execution.yaml` 加载：
- `skill_chain` — 待执行的 Skill 列表
- `steps_completed` — 已完成步骤（断点续传用）
- `steps_remaining` — 待执行步骤
- `human_oversight` — HIP 级别

### 2. 断点续传：确定起始 Skill

如果 `steps_completed` 非空：
```
断点续传模式
  已完成: {steps_completed 的 skill_name 列表}
  跳过已完成步骤，从 Skill #{next_order} ({next_skill_name}) 继续
```

如果 `steps_completed` 为空：
```
全新执行，从 Skill #1 ({first_skill_name}) 开始
```

### 3. 对每个待执行 Skill 执行以下循环

对 `steps_remaining` 中的每个 Skill（按 `order` 顺序）：

---

#### 3a. HostChecker — 宿主能力校验

读取目标 Skill 的 SKILL.md frontmatter，提取 `requires[]` 字段。

与当前宿主能力对比：

| requires 值 | 检查方式 |
|------------|---------|
| `file_read` | 当前环境是否支持文件读取（通常始终满足） |
| `file_write` | 当前环境是否支持文件写入（通常始终满足） |
| `shell_exec` | 当前环境是否支持 shell 命令执行 |
| `network_access` | 当前环境是否支持网络访问 |
| `agent_subprocess` | 当前环境是否支持子 Agent 调用 |
| `mcp_support` | 当前环境是否支持 MCP 工具 |

```
[Skill {order}/{total}] HostChecker: {skill_name}
  ✅ file_read — 满足
  ✅ file_write — 满足
  ❌ network_access — 不满足
```

**如果任一 requires 不满足**：
- 显示不满足项
- 提示用户选择：`[S] 跳过此 Skill / [A] 中止执行`
- 跳过时记录 status=skipped 到 execution.yaml（**不发审计事件**——`skipped` 不是 `audit-event.schema.json` 的 status enum 合法值，跳过的 Skill 未实际执行因此无需审计）

---

#### 3b. Executor — 执行 Skill

读取目标 Skill 的 SKILL.md：
- 提取 `entry_point`（通常为 SKILL.md）
- 提取 `sdc_phase`（记入审计事件）
- 提取 `version`（记入审计事件）
- 提取 `inputs[]` 和 `outputs[]`（用于状态传递和 hash 计算）

**状态传递（input_mapping）：**

如果当前 Skill 的 `input_mapping` 非空：
- 将前序 Skill 的 `output_artifacts` 路径替换到当前 Skill 的 `inputs` 模板中
- 模板替换规则：`{intent_id}` → 实际 intent_id，`{session_id}` → 实际 session_id

引导用户执行目标 Skill：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Skill {order}/{total}] 执行: {skill_name}
  SDC Phase: {sdc_phase}
  Version:   {version}
  Inputs:    {inputs 列表}
  Outputs:   {outputs 列表}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

请打开以下文件并按步骤执行：
  {sand-root}/sand/skills/{skill_name}/SKILL.md

完成后请确认：
[D] 已完成  [F] 执行失败  [S] 跳过
```

记录 Skill 开始时间。

---

#### 3c. StateManager — 更新执行状态

用户确认完成后：

**如果 [D] 已完成：**
```yaml
# 追加到 steps_completed
- skill_name: "{skill_name}"
  order: {order}
  status: "success"
  started_at: "{开始时间}"
  completed_at: "{当前时间}"
  output_artifacts:
    - "{Skill 声明的 outputs 实际路径}"
```
从 `steps_remaining` 中移除该 Skill。更新 `execution.yaml`。

**如果 [F] 执行失败：**
```yaml
- skill_name: "{skill_name}"
  order: {order}
  status: "failure"
  started_at: "{开始时间}"
  completed_at: "{当前时间}"
  output_artifacts: []
```
提示用户：
```
Skill {skill_name} 执行失败。
[R] 重试此 Skill
[S] 跳过，继续下一个
[A] 中止执行
```
- 重试 → 回到 3b 重新执行
- 跳过 → 记录 status=failure，继续下一个
- 中止 → 更新 execution.yaml status=interrupted，HALT

**如果 [S] 跳过：**
```yaml
- skill_name: "{skill_name}"
  order: {order}
  status: "skipped"
  started_at: "{当前时间}"
  completed_at: "{当前时间}"
  output_artifacts: []
```

---

#### 3d. HashComputer — SHA-256 计算

对已完成的 Skill（status=success），计算其声明的 inputs 和 outputs 文件的 SHA-256 hash：

```
input_hash 计算：
  - 拼接所有 input 文件内容
  - SHA-256({concatenated_content})
  - 格式："sha256:{64位十六进制}"

output_hash 计算：
  - 拼接所有 output 文件内容
  - SHA-256({concatenated_content})
  - 格式："sha256:{64位十六进制}"
```

如果文件不存在或不可读，**省略该字段**（不设为 `null`——Schema 定义 `input_hash`/`output_hash` 为 `type: string`，不允许 null；这两个字段不在 `required` 中，省略合法）。

---

#### 3e. AuditWriter — 记录审计事件

构造符合 `schemas/audit-event.schema.json` 的 JSON 对象：

```json
{
  "event_id": "{UUID-v4}",
  "timestamp": "{ISO-8601 UTC}",
  "sand_version": "0.1.0",
  "intent_id": "{从编排方案提取}",
  "execution_id": "EXE-{session_id}",
  "skill_name": "{执行的 Skill 名称}",
  "skill_version": "{从 SKILL.md 提取}",
  "sdc_phase": "{从 SKILL.md 提取}",
  "step": "step-{order 补零至 2 位}-{skill_name}",
  "actor": "agent",
  "host": "{当前宿主: claude-code/cursor/codex-cli/gemini-cli}",
  "model_used": "{当前使用的模型}",
  "input_hash": "{sha256:... 或省略此字段}",
  "output_hash": "{sha256:... 或省略此字段}",
  "status": "{success/failure/interrupted}",
  "human_confirmations": [],
  "error": null
}
```

追加写入 `.sand/audits/audit.jsonl`（一行一个 JSON 对象，不格式化）。

---

#### 3f. HIP 审查（Skill 间）

根据 `human_oversight` 级别决定 Skill 间行为：

**HIP-1（异步知晓）：**
- 自动继续下一个 Skill，不暂停
- 执行完所有 Skill 后一次性展示摘要

**HIP-2（同步审查）：**
- 每个 Skill 完成后展示结果摘要
- 等待用户确认：`[C] 继续下一个 / [A] 中止`
- 用户确认记入当前 Skill 审计事件的 `human_confirmations` 数组：
  ```json
  {"step": "step-{order:02d}-{skill_name}", "timestamp": "{ISO-8601}", "decision": "approved"}
  ```
  用户选 [A] 中止时 decision 为 `"rejected"`

**HIP-3（人类主导）：**
- 每个 Skill 的每个 step 都需用户逐步确认
- 用户全程参与（Executor 引导用户手动执行每步）

---

### 4. 执行循环结束

所有 Skill 执行完毕后（或用户中止后）：
- 更新 `execution.yaml` 的 `status`：
  - 所有 Skill 成功 → `completed`
  - 存在失败或跳过 → `partial`
  - 用户中止 → `interrupted`
- 设置 `completed_at` 为当前时间

## SUCCESS METRICS:

- skill_chain 中所有 Skill 按 order 顺序执行（或在断点续传中跳过已完成 Skill）
- 每个 Skill 完成后 execution.yaml 已更新（steps_completed）
- 每个 Skill 完成后审计事件已追加到 audit.jsonl
- SHA-256 hash 已计算并记入审计事件
- HIP 审查行为与 human_oversight 级别一致
- 异常情况（失败/跳过/中止）正确处理和记录

## FAILURE MODES:

- 目标 Skill 的 SKILL.md 不存在 → 跳过并标记 status=failure，记录 error
- HostChecker 不满足 → 提示跳过或中止
- 执行中用户中止 → 更新 status=interrupted，保留 steps_completed 供恢复
- audit.jsonl 不可写 → 警告但不阻塞执行（审计是辅助功能，不应阻断核心流程）
- input_mapping 中引用的文件不存在 → 警告用户并继续（前序 Skill 可能未生成预期输出）

## NEXT STEP:

Read fully and follow `./step-03-summary.md`
