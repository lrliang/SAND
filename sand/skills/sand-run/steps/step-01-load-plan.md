# Step 1: 加载编排方案 + 创建执行会话

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. 编排方案必须通过 `orchestration-plan.schema.json` 验证
5. 断点续传检测必须在创建新会话前执行

## YOUR TASK:

加载 `.sand/orchestration-plan.yaml`，验证 Schema 合规，加载关联意图声明，检测断点续传场景，创建或恢复执行会话。

## EXECUTION SEQUENCE:

### 1. 加载编排方案

读取 `.sand/orchestration-plan.yaml`。

**如果文件不存在**：HALT — 提示用户运行 `sand-design-orchestration` 先创建编排方案。

验证编排方案通过 `schemas/orchestration-plan.schema.json`：
- 4 个必填属性：`plan_id`（非空 string）、`intent_id`（匹配 `^INT-\d{8}-\d{3,}$`）、`topology`（enum）、`human_oversight`（enum）
- `skill_chain` 每项含 `skill_name`（匹配 `^sand-[a-z][a-z0-9-]*$`）和 `order`（>=1）
- 无额外顶层属性（`additionalProperties: false`）

提取关键字段：
- `plan_id` → 会话关联标识
- `intent_id` → 关联意图声明
- `topology` → 执行拓扑（MVP 仅支持 `pipeline`/`solo`）
- `human_oversight` → HIP 级别
- `skill_chain[]` → 待执行的 Skill 列表
- `context_scope` → 上下文范围
- `meta.topology_rationale` → 包含失败模式预案等设计决策

### 2. 拓扑兼容性检查

```
当前拓扑：{topology}

✅ solo — 支持（单 Skill 执行）
✅ pipeline — 支持（单链顺序执行）
❌ swarm — Phase 3 支持（并行执行需要多 Agent 协调）
❌ hierarchy — Phase 3 支持（层级执行需要管理者 Agent）
```

如果拓扑为 `swarm` 或 `hierarchy`：
HALT — 提示"当前版本仅支持 Solo 和 Pipeline 拓扑。Swarm 和 Hierarchy 将在 Phase 3 支持。"

### 3. 加载关联意图声明

从编排方案提取 `intent_id`，加载 `.sand/intents/{intent_id}.yaml`。

**如果意图声明不存在**：HALT — 提示用户检查 intent_id 是否正确或运行 `sand-create-intent`。

提取关键字段：
- `purpose` — 任务目的
- `desired_outcome` — 期望结果
- `acceptance_criteria` — 验收标准（传递给后续 Skill）

### 4. 断点续传检测

扫描 `.sand/executions/` 目录，查找与当前 `plan_id` 关联的未完成会话：

```
扫描 .sand/executions/EXE-*/execution.yaml
  → 过滤 plan_id == {当前编排方案的 plan_id}
  → 过滤 status == "running" 或 "interrupted"
```

**如果找到未完成会话：**
```
发现未完成的执行会话：
  Session ID: {existing_session_id}
  Plan ID: {plan_id}
  Status: {running/interrupted}
  已完成步骤: {N}/{total}
  最后活动: {timestamp}

请选择：
[R] 恢复此会话（从上次中断处继续）
[N] 创建新会话（保留旧会话记录）
[C] 取消
```

- 用户选 [R] → 加载已有 execution.yaml，跳到 Step 2（从 steps_completed 之后的 Skill 继续）
- 用户选 [N] → 继续创建新会话（步骤 5）
- 用户选 [C] → HALT

**如果没有未完成会话：** 继续步骤 5。

### 5. 创建执行会话

生成 session_id：
- 格式：`YYYYMMDD-{seq}`（如 `20260514-001`）
- `{seq}` 通过扫描 `.sand/executions/EXE-*` 确定当日最大序号 + 1

创建目录 `.sand/executions/EXE-{session_id}/`（如果 `.sand/executions/` 不存在也一并创建）。

初始化 `execution.yaml`：

```yaml
session_id: "EXE-{session_id}"
plan_id: "{从编排方案提取}"
intent_id: "{从编排方案提取}"
topology: "{从编排方案提取}"
human_oversight: "{从编排方案提取}"
status: "running"
started_at: "{ISO-8601 当前时间}"
completed_at: null
steps_completed: []
steps_remaining:
  # 从 skill_chain 按 order 排列
  - skill_name: "{skill_chain[0].skill_name}"
    order: 1
  - skill_name: "{skill_chain[1].skill_name}"
    order: 2
  # ...
```

### 6. 加载上下文范围

从编排方案的 `context_scope` 加载：
- `include_files[]` — 确认每个文件存在并可读
- `exclude_patterns[]` — 记录排除模式

确保 `.sand/audits/` 目录存在（如不存在则创建）。

### 7. 展示执行计划

```
[Step 1/3] 执行计划已加载

Session ID:      EXE-{session_id}
Plan ID:         {plan_id}
Intent:          {intent_id} — {purpose 一句话}
Topology:        {topology}
HIP Level:       {human_oversight}
Skill Chain:     {skill_count} 个 Skill
  1. {skill_chain[0].skill_name}
  2. {skill_chain[1].skill_name}
  ...
Context Files:   {include_count} 个
Exclude Patterns: {exclude_count} 个

准备开始执行？[C] 继续 / [A] 中止
```

## SUCCESS METRICS:

- 编排方案加载成功且通过 Schema 验证
- 关联意图声明加载成功
- 拓扑兼容性检查通过（solo 或 pipeline）
- 断点续传检测已执行
- execution.yaml 初始化完成（或已有会话恢复）
- `.sand/executions/EXE-{session_id}/` 目录已创建
- `.sand/audits/` 目录已确认存在

## FAILURE MODES:

- `.sand/orchestration-plan.yaml` 不存在 → HALT，建议运行 `sand-design-orchestration`
- 编排方案不通过 Schema 验证 → HALT，显示具体验证错误
- `intent_id` 关联的意图声明不存在 → HALT，建议检查 intent_id
- 拓扑为 swarm/hierarchy → HALT，显示 MVP 限制提示
- `.sand/executions/` 不可写 → HALT，检查目录权限
- skill_chain 为空 → HALT，编排方案无效

## NEXT STEP:

Read fully and follow `./step-02-execute.md`
