# Step 3: CLEAR 5 维质量检查

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous

## YOUR TASK:

对意图声明运行 CLEAR 5 维质量检查（20 项检查项），输出结构化检查报告。检查通过后将意图状态从 Draft 转为 Reviewed。

## EXECUTION SEQUENCE:

### 1. 加载检查清单

从 `./data/clear-checklist.yaml` 加载检查项定义和执行顺序配置。

### 2. 加载意图声明

从 `.sand/intents/{intent_id}.yaml` 读取当前意图声明内容。

### 3. 执行检查——按 C → E → A → L → R 顺序

按 `execution_order: [C, E, A, L, R]` 顺序执行。AI 自动化维度（C/E/A）直接判定，人工维度（L/R）引导用户评估。

> **[Step 3/4] CLEAR 质量检查**
>
> 正在对意图声明 `{intent_id}` 运行 CLEAR 5 维质量检查...

#### 3a. C — Complete（AI 自动判定）

逐项检查 C1-C5，对照意图声明内容和 `clear-checklist.yaml` 中的 pass/fail 标准：

- **C1**：检查 7 字段（purpose、desired_outcome、acceptance_criteria、constraints、context_references、meta、intent_type）是否全部非空且有实质内容
- **C2**：检查 purpose 是否包含业务问题/痛点/投资假设的引用
- **C3**：检查 desired_outcome 是否描述可观测的状态变化
- **C4**：检查 acceptance_criteria 中是否至少有 1 条 priority=must
- **C5**：检查 constraints 三个子域是否至少有 1 项非空

每项输出 ✓（通过）/ ⚠️（警告）/ ✗（失败）。

#### 3b. E — Executable（AI 自动判定）

逐项检查 E1-E5：

- **E1**：检查每条 acceptance_criteria 是否都有 verification 字段
- **E2**：检查 verification=performance_benchmark 的标准是否有量化基线
- **E3**：检查 context_references 中的引用格式是否合法
- **E4**：检查 constraints 条目之间是否存在逻辑矛盾
- **E5**：检查 intent_type 是否为合法枚举值

#### 3c. A — Assessable（AI 自动判定）

逐项检查 A1-A3：

- **A1**：统计 priority=must 的标准中，verification 为 automated_test 或 performance_benchmark 的比例。≥80% 可自动化 = ✓，50%-80% 可自动化 = ⚠️，<50% 可自动化（即 >50% 仅能 human_review）= ✗
- **A2**：检查 acceptance_criteria 到契约三级结构的映射是否无歧义
- **A3**：检查每条验收标准是否定义了足够清晰的"通过"状态

#### 3d. L — Lean（引导用户评估）

向用户展示 L 维度的 4 项检查，逐项引导评估：

> **L 维度（精简）— 需要你的判断：**
>
> **L1 — 单一 purpose：** 你的 purpose 是否只描述了一个核心问题？
> `(y/n)`
>
> **L2 — 无实现方案泄露：** purpose 和 desired_outcome 中是否避免了具体技术实现细节？
> `(y/n)`
>
> **L3 — 验收标准无冗余：** 每条验收标准是否验证了不同的行为？
> `(y/n)`
>
> **L4 — 范围可控：** 这个意图是否可以在一个 SDC 循环内合理完成？
> `(y/n)` 如果不确定，回答 `n`

用户回答 `y` = ✓，`n` = ✗。

#### 3e. R — Reversible（引导用户评估）

> **R 维度（可回退）— 需要你的判断：**
>
> **R1 — 无不可逆操作：** 这个意图的实现是否涉及不可逆操作（如删除生产数据、不可回滚的 schema 迁移）？
> `(y)` 不涉及 → ✓  |  `(n)` 涉及 → 检查是否在 constraints 中声明了回滚策略
>
> **R2 — 回退范围可控：** 如果实现失败，影响范围是否有限（单服务/单模块级别）？
> `(y/n)`
>
> **R3 — 已声明回退策略：** 如果涉及数据变更，constraints 中是否包含回退策略？
> `(y)` 已声明或不涉及数据变更 → ✓  |  `(n)` 涉及但未声明 → ✗

### 4. 汇总并展示报告

按以下格式展示检查报告：

> **CLEAR 质量检查报告**
>
> | 维度 | 状态 | 详情 |
> |------|------|------|
> | C — Complete | {✓/⚠️/✗} | {各项结果} |
> | E — Executable | {✓/⚠️/✗} | {各项结果} |
> | A — Assessable | {✓/⚠️/✗} | {各项结果} |
> | L — Lean | {✓/⚠️/✗} | {各项结果} |
> | R — Reversible | {✓/⚠️/✗} | {各项结果} |
>
> **Overall: {pass/warn/fail}**
> 通过: {count} | 警告: {count} | 失败: {count}

维度状态判定：维度内全部 ✓ = pass，有 ⚠️ 无 ✗ = warn，有 ✗ = fail。
Overall 判定：所有维度 pass = pass，有 warn 无 fail = warn，有 fail = fail。

### 5. 处理检查结果

**如果 overall = pass：**

> ✅ CLEAR 检查全部通过！意图声明质量达标，进入执行契约生成。

**如果 overall = warn：**

对每个 ⚠️ 项提供具体修改建议：

> ⚠️ CLEAR 检查发现以下警告：
>
> - {检查项 ID}: {具体修改建议}
>
> **选择操作：**
> `[1]` 修正后重新检查 — 我会引导你修改对应字段
> `[2]` 接受风险继续 — 警告将记录在执行契约中
> `[3]` 放弃本次意图创建

如果用户选择修正：引导修改对应字段内容，更新 `.sand/intents/{intent_id}.yaml`，然后**重新执行 CLEAR 检查**（回到步骤 3）。

如果用户选择接受风险：继续到步骤 6。

**如果 overall = fail：**

> ✗ CLEAR 检查未通过，以下项目必须修正：
>
> - {检查项 ID}: {具体问题描述 + 修改建议}
>
> 我来帮你修改——从第一个失败项开始。

引导用户逐项修正，更新意图声明文件后**重新执行 CLEAR 检查**（回到步骤 3）。不允许跳过 fail 项。

### 6. 状态变更：Draft → Reviewed

CLEAR 检查通过（pass 或用户接受 warn）后：

1. 更新 `.sand/intents/{intent_id}.yaml` 中的 `meta.status` 为 `reviewed`
2. 记录审计事件到 `.sand/audits/audit.jsonl`：

```json
{"event_id":"EVT-{date}-{seq}","timestamp":"{iso8601}","intent_id":"{intent_id}","from_status":"draft","to_status":"reviewed","trigger":"clear_check_passed","actor":"system","notes":"CLEAR overall={result}, pass={count}, warn={count}, fail={count}"}
```

## SUCCESS METRICS:

- ✅ 20 项检查全部执行
- ✅ AI 自动维度（C/E/A）由 AI 直接判定
- ✅ 人工维度（L/R）由用户评估
- ✅ 检查报告完整展示
- ✅ fail 项已全部修正
- ✅ 意图状态从 draft 更新为 reviewed
- ✅ 审计事件已记录

## FAILURE MODES:

- ❌ 意图声明文件不存在 → HALT，提示先完成 step-02
- ❌ 用户拒绝修正 fail 项 → HALT，意图创建流程终止
- ❌ 反复修正仍无法通过 → 建议用户考虑分解意图或重新定义

## NEXT STEP:

Read fully and follow `./step-04-contract.md`
