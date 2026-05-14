# Step 1: 契约验证通道（Contract Verification）

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous
5. If this step encounters an execution error (file not found, parse failure, etc.), record a deviation with `deviation_type: contract_deviation` and `severity: blocking`, then default channel result to FAIL

## YOUR TASK:

加载执行契约和交付物，逐条验证 must_pass/should_pass/must_not_violate 条目，运行意图对齐度分析（FR26），输出契约验证通道结果。

## EXECUTION SEQUENCE:

### 1. 初始化验证会话

检查用户项目根目录是否存在 `.sand/executions/` 目录。如果不存在，创建：

```
.sand/
├── executions/
└── audits/
```

生成会话 ID：`{YYYYMMDD}-{seq}`（seq 为当日递增序号，从 001 开始。扫描 `.sand/executions/` 下已有的 `EXE-{today}-*` 目录确定下一个序号）。

创建会话目录：`.sand/executions/EXE-{session_id}/`（例如 `.sand/executions/EXE-20260513-001/`）

向用户显示：
```
[Step 1/4] 契约验证通道
会话 ID: EXE-{session_id}
```

### 2. 加载执行契约

提示用户提供意图 ID 或执行契约路径：

```
请提供要验证的意图 ID 或执行契约路径：
1. 输入意图 ID（如 INT-20260512-003）→ 自动查找 .sand/intents/contracts/{intent_id}.contract.yaml
2. 输入完整路径
```

加载执行契约文件，验证其包含必要字段：
- `contract_id`
- `intent_id`
- `must_pass[]`（数组，每条含 id、criterion、verification、source）
- `should_pass[]`（数组）
- `must_not_violate[]`（数组，每条含 id、constraint、source）

**如果执行契约不存在或格式无效：**
```
🚫 错误：执行契约文件未找到或格式无效
建议：先运行 sand-create-intent 创建意图声明并生成执行契约
```
HALT — 无法继续。

### 3. 加载交付物上下文

请用户确认 Build 阶段的交付物范围：

```
请确认交付物范围：
[A] 当前工作目录的全部变更（git diff HEAD）
[P] 指定文件/目录列表
[C] 提供变更描述（无代码直接审查）
```

加载交付物上下文，为后续检查建立审查范围。

### 4. 逐条验证 must_pass 条目

对执行契约中的每条 `must_pass` 条目：

| 步骤 | 动作 | 控制类型 |
|------|------|---------|
| 4a | 读取 criterion 描述和 verification 方法 | — |
| 4b | 在交付物中查找与该条目相关的代码/配置/文档 | 计算控制 |
| 4c | 判定该条目是否满足：`pass` 或 `fail` | 计算控制 |
| 4d | 记录判定证据（evidence）：引用具体代码行或文件 | — |

输出格式（每条）：
```yaml
- id: "MP-001"
  status: "pass"  # or "fail"
  evidence: "src/auth/middleware.py:42 — tenant_id filter applied in query"
```

**阻塞规则：** 任何一条 `must_pass` 条目 `fail` → 通道结果为 **FAIL**。

### 5. 逐条验证 should_pass 条目

对执行契约中的每条 `should_pass` 条目，执行与 step 4 相同的验证流程。

**区别：** `should_pass` 未通过记录为 `warning`，不阻塞通道。

输出格式：
```yaml
- id: "SP-001"
  status: "pass"  # or "fail"
  evidence: "P95 latency test not included — manual benchmark needed"
```

### 6. 逐条检查 must_not_violate 约束

对执行契约中的每条 `must_not_violate` 约束：

| 步骤 | 动作 | 控制类型 |
|------|------|---------|
| 6a | 读取 constraint 描述 | — |
| 6b | 在交付物中检查是否存在违反该约束的代码/行为 | 计算控制 + 推断控制 |
| 6c | 判定：`pass`（未违反）或 `violated` | — |
| 6d | 记录证据 | — |

**控制优先级（D6 处理）：** 当计算控制和推断控制对同一条目结果不一致时，**计算控制结果优先**（确定性判定），推断控制结果作为补充信息附加到 evidence 中。

**阻塞规则：** 任何一条 `must_not_violate` 被 `violated` → 通道结果为 **FAIL**。

### 7. 验收标准覆盖率检查

检查执行契约中每条 `must_pass` 和 `should_pass` 的 `source` 字段，确认原始意图声明的每条 `acceptance_criteria` 至少有一个对应的验证结果。

如有未覆盖的验收标准 → 通道结果为 **FAIL**。

### 8. 意图对齐度分析（FR26）

使用推断控制（AI 语义分析）评估交付物与意图声明 `purpose` 和 `desired_outcome` 的语义对齐度：

- 分析交付物是否实现了意图声明描述的期望结果
- 识别交付物是否偏离了意图声明的范围（实现了未预期的功能，或遗漏了核心需求）
- 如发现意图偏差信号 → 记录到通道结果中，供 step-04 决策矩阵使用

**意图偏差信号：** 此分析的结果为 `warning` 级别（不直接阻塞通道），但偏差信号会传递到 step-04 决策矩阵，可能触发 `redirect_to_intent` 决策。

### 9. 生成通道结果

根据 step 4-8 的结果，生成契约验证通道的最终结果：

```
IF any must_pass == fail THEN 通道结果 = FAIL
ELSE IF any must_not_violate == violated THEN 通道结果 = FAIL
ELSE IF any acceptance_criteria 无覆盖 THEN 通道结果 = FAIL
ELSE IF any should_pass == fail THEN 通道结果 = PASS_WITH_WARNINGS
ELSE 通道结果 = PASS
```

向用户显示通道结果摘要：
```
📋 契约验证通道结果: {PASS|PASS_WITH_WARNINGS|FAIL}
  must_pass: {pass_count}/{total} 通过
  should_pass: {pass_count}/{total} 通过（{warn_count} warnings）
  must_not_violate: {pass_count}/{total} 未违反
  覆盖率: {covered}/{total} acceptance_criteria 已覆盖
  意图对齐: {有偏差信号|无偏差信号}
```

将完整结果暂存于内存，供 step-04 合并使用。

## SUCCESS METRICS:

✅ 执行契约成功加载并解析
✅ must_pass 条目全部逐条验证并记录证据
✅ should_pass 条目全部逐条验证
✅ must_not_violate 约束全部逐条检查
✅ 验收标准覆盖率检查完成
✅ 意图对齐度分析完成（FR26）
✅ 通道结果正确生成（PASS/PASS_WITH_WARNINGS/FAIL）

## FAILURE MODES:

❌ 执行契约文件不存在 → HALT，建议运行 sand-create-intent
❌ 执行契约格式无效 → HALT，显示缺失字段
❌ 交付物上下文无法加载 → HALT，提示用户确认路径
❌ 通道执行出错（D2 处理）→ 记录偏差事件（deviation_type: contract_deviation, severity: blocking），默认通道结果 = FAIL

## NEXT STEP:

Read fully and follow `./step-02-security.md`
