# Step 4: 输出编排方案

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. 输出的编排方案**必须严格符合** `schemas/orchestration-plan.schema.json`——仅 7 个顶层属性，`additionalProperties: false`
5. failure_mode_plan 等扩展信息记入 `meta.topology_rationale` 或作为注释

## YOUR TASK:

合并 Step 1-3 的所有输出，生成失败模式预案，初始化编排方案模板，填充字段，输出到 `.sand/orchestration-plan.yaml`，验证 Schema 合规，人类确认最终方案。

## EXECUTION SEQUENCE:

### 1. 合并前序步骤输出

从 Step 1 收集：
- `intent_id`、`intent_type`、`scope`
- `context_scope`（include_files + exclude_patterns）
- `context_quality_check`（completeness/accuracy/conciseness 结果——写入 `meta.topology_rationale`）

从 Step 2 收集：
- `topology`（solo/pipeline/swarm/hierarchy）
- `topology_rationale`
- `skill_chain[]`

从 Step 3 收集：
- `human_oversight`（hip-1/hip-2/hip-3）
- `human_intervention_points[]`

### 2. 生成失败模式预案

基于选定拓扑，参考失败模式×拓扑敏感矩阵：

| 失败模式 | Solo 风险 | Pipeline 风险 | Swarm 风险 | Hierarchy 风险 |
|---------|---------|-----------|---------|------------|
| hallucination | 高 | 中 | 低 | 中 |
| context_loss | 低 | 高 | 中 | 高 |
| bias_amplification | 高 | 中 | 低 | 中 |
| capability_overflow | 高 | 低 | 中 | 低 |
| cascade_failure | N/A | 高 | 低 | 高 |

对选定拓扑中风险为"高"的失败模式，生成具体预案：

为每个高风险失败模式记录：
- `failure_mode`（enum 值）
- `risk_level`（high）
- `detection_method`（具体检测方式）
- `mitigation_strategy`（具体缓解策略）

**注意：** 此预案数据**不作为独立顶层属性**输出（Schema `additionalProperties: false`），而是以结构化文本形式写入 `meta.topology_rationale` 字段。

**检测方式参考：**
- hallucination → 引用的 API/库在项目依赖中验证
- context_loss → 每步输出与原始意图对齐度检查
- bias_amplification → 要求列举 ≥2 替代方案
- capability_overflow → Agent 能力卡 capability_domain 匹配检查
- cascade_failure → Pipeline 每步中间产物验证

**缓解策略参考：**
- hallucination → 上下文中包含精确的依赖列表和 API 文档
- context_loss → Pipeline 每步重新加载关键上下文
- bias_amplification → Swarm 并行探索 + HIP-2 审查
- capability_overflow → 拓扑升级（Solo → Pipeline）
- cascade_failure → 中间验证点 + 断点续传

### 3. 生成 Plan ID

格式：`OP-YYYYMMDD-{seq}`
- `YYYY` = 当前年份
- `MM` = 当前月份
- `DD` = 当前日期
- `{seq}` = 当日序号（从 001 开始，扫描 `.sand/` 下已有编排方案确定）

### 4. 初始化编排方案

从 `./templates/orchestration-plan.yaml` 加载模板，填充所有字段：

```yaml
plan_id: "OP-{YYYYMMDD}-{seq}"
intent_id: "{从 Step 1 提取}"
topology: "{从 Step 2 选定}"
human_oversight: "{从 Step 3 确定}"
skill_chain:
  # 从 Step 2 输出
  - skill_name: "sand-{name}"
    order: 1
    input_mapping: {}
    is_external: false
context_scope:
  include_files:
    # 从 Step 1 输出
  exclude_patterns:
    # 从 Step 1 输出
meta:
  created_at: "{ISO-8601 当前时间}"
  topology_rationale: |
    选型理由：{rationale}
    失败模式预案：{failure_mode_plan 摘要}
    HIP 决策链：{hip_decision_chain 摘要}
```

### 5. Schema 验证

验证输出文件仅包含 Schema 允许的 7 个顶层属性：
- `plan_id` — 非空 string
- `intent_id` — 匹配 `^INT-\d{8}-\d{3,}$`
- `topology` — enum `["solo", "pipeline", "swarm", "hierarchy"]`
- `human_oversight` — enum `["hip-1", "hip-2", "hip-3"]`
- `skill_chain` — 每项含 `skill_name`（匹配 pattern）和 `order`（≥1）
- `context_scope` — 含 `include_files[]` 和 `exclude_patterns[]`
- `meta` — 含 `created_at` 和 `topology_rationale`

**不得添加 Schema 未定义的顶层属性**（`additionalProperties: false`）。

### 6. 展示最终编排方案

向用户展示完整编排方案摘要：

```
[Step 4/4] 编排方案

plan_id:        {plan_id}
intent_id:      {intent_id}
topology:       {topology} — {rationale 一句话}
human_oversight: {hip_level}
skill_chain:    {skill_count} 个 Skill（{external_count} 个外部）
context_scope:  {include_count} 个文件，{exclude_count} 个排除模式

失败模式预案（高风险项）：
  - {failure_mode_1}: {detection} → {mitigation}
  - {failure_mode_2}: {detection} → {mitigation}

审查点：
  - {hip_point_1}
  - {hip_point_2}
```

### 7. HIP 级别人类确认

根据当前 HIP 级别执行确认：

- **HIP-1**：方案自动生效，事后通知用户
- **HIP-2**：展示方案摘要，等待用户确认 `[C] 确认 / [M] 修改 / [R] 重新设计`
- **HIP-3**：展示完整方案，逐项与用户确认

如果用户选择修改：
- 允许修改 topology、human_oversight、skill_chain
- 修改后重新执行 Schema 验证

### 8. 保存编排方案

将最终方案写入 `.sand/orchestration-plan.yaml`。

如果 `.sand/` 目录不存在，创建它。

输出确认：
```
✅ 编排方案已保存到 .sand/orchestration-plan.yaml
   Plan ID: {plan_id}
   下一步：运行 sand-run 执行此编排方案
```

## SUCCESS METRICS:

- 前序步骤输出全部正确合并
- 失败模式预案覆盖选定拓扑的所有"高风险"模式
- plan_id 格式正确且不与已有方案冲突
- 输出文件通过 orchestration-plan.schema.json 验证（仅 7 个顶层属性）
- HIP 级别确认流程已执行
- `.sand/orchestration-plan.yaml` 成功写入

## FAILURE MODES:

- Step 1/2/3 输出缺失 → HALT，需回到对应步骤补充
- intent_id 格式不匹配 Schema pattern → 提示用户检查意图声明
- skill_chain 为空 → HALT，编排方案需要至少 1 个 Skill
- `.sand/` 不可写 → HALT，检查目录权限
- 用户在 HIP-2/3 确认时选择"重新设计" → 回到 Step 1 重新开始

## NEXT STEP:

编排方案设计完成。用户可运行 `sand-run` 执行此编排方案。
