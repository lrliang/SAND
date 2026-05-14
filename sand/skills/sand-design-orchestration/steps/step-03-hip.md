# Step 3: HIP 级别配置

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HIP 方向不可反转：HIP-1 = 最低介入，HIP-3 = 最高介入
5. 降级需显式人类确认，升级自动生效

## YOUR TASK:

通过 3 层计算 + 用户覆盖计算 HIP 推荐值，显示计算过程，允许用户覆盖（含降级保护），确定编排方案中的审查点位置。

## EXECUTION SEQUENCE:

### 1. 加载 HIP 决策链输入

**层 1：角色推荐值（Role Default）**

根据当前用户角色或默认能力卡的 `default_hip`：

| 角色 | Skill 路径 | default_hip |
|------|-----------|------------|
| 问题域负责人 | sand-agent-domain-lead | hip-2 |
| FDE+ | sand-agent-fde | hip-2 |
| 变革催化师 | sand-agent-catalyst | hip-3 |

默认使用 FDE+（hip-2）除非用户明确指定角色。

**层 2：项目默认值**

检查 `.sand/config.yaml` 中的 `default_human_oversight` 字段：
- 如果存在 → 使用该值
- 如果不存在 → 保留层 1 的值

**层 3：意图类型关联推荐**

| 意图类型 | 推荐 HIP | 可调范围 |
|---------|---------|---------|
| feature | hip-2 | hip-1 ~ hip-3 |
| fix | hip-1 / hip-2 | hip-1 ~ hip-2 |
| refactor | hip-2 | hip-2 ~ hip-3 |
| exploration | hip-1 | hip-1 ~ hip-2 |
| optimization | hip-2 | hip-1 ~ hip-2 |

如果意图类型推荐值与前两层计算值不同，取**较高介入**的值。

### 2. 展示 HIP 计算过程

```
[Step 3/4] HIP 级别配置

HIP 决策链计算：
  层 1 — 角色推荐值（FDE+）：       hip-2
  层 2 — 项目默认值（config.yaml）：  {value 或 "未配置"}
  层 3 — 意图类型（{intent_type}）：  {value}
  ──────────────────────────────
  计算结果：                         {final_value}

可调范围：{min} ~ {max}

请确认或覆盖：
[C] 确认 {final_value}
[1] 设为 hip-1（异步知晓/全自主）
[2] 设为 hip-2（同步审查/关键决策）
[3] 设为 hip-3（人类主导/全程监督）
```

### 3. 覆盖链保护

如果用户选择的 HIP 级别**低于**计算结果（降级）：

```
⚠️ 降级保护

当前计算推荐 {computed_hip}，您选择了 {user_hip}（降级）。

降级意味着减少人类审查，可能增加 AI 失误未被发现的风险。
确认降级到 {user_hip}？(y/n)
```

- 用户确认 → 接受降级，记录审计事件
- 用户取消 → 保留计算结果

如果用户选择的 HIP 级别**高于**计算结果（升级）：
- 自动接受，无需额外确认

### 4. 动态调整提示

根据已知信号提示可能的动态调整：

- **新领域检测**：如果 `.sand/` 中无当前领域的历史执行记录 → 建议 HIP-2 或更高
- **信任降级提示**：如果同类任务连续成功 ≥ 5 次（默认阈值，可通过 `.sand/config.yaml` 的 `trust_de_escalation_threshold` 覆盖） → 提示用户可考虑降级
- **异常信号**：如果最近执行有偏差事件 → 建议升级

### 5. 确定审查点位置

根据最终 HIP 级别，确定编排方案中的人类审查点：

| 审查维度 | HIP-1 | HIP-2 | HIP-3 |
|---------|-------|-------|-------|
| 编排方案审查 | 事后查阅 | 执行前确认 | 逐步参与设计 |
| 拓扑选型确认 | 自动应用 | 推荐后确认 | 人类直接指定 |
| Skill 链确认 | 自动配置 | 审查后确认 | 逐步选择 |
| 验证决策确认 | 自动执行 | 审查后确认 | 人类裁决 |
| 偏差处理 | 自动记录 | 审查并标记 | 逐条裁定 |
| 外部 Skill 引入 | 仅限已验证 Skill | 审查后引入 | 人类逐一审批 |

### 6. 输出结果

```yaml
# Step 3 输出
human_oversight: "{hip-1/hip-2/hip-3}"
hip_decision_chain:
  role_default: "{hip-N}"
  project_default: "{hip-N 或 null}"
  intent_type_recommendation: "{hip-N}"
  computed_value: "{hip-N}"
  user_override: "{hip-N 或 null}"
  final_value: "{hip-N}"
  override_was_downgrade: false  # true 如果用户降级
human_intervention_points:
  - point_id: "HIP-01"
    location: "编排方案确认"
    level: "{hip-N}"
  - point_id: "HIP-02"
    location: "验证决策确认"
    level: "{hip-N}"
```

## SUCCESS METRICS:

- 3 层计算 + 用户覆盖完整执行并向用户可视化展示
- HIP 方向正确：HIP-1=最低介入，HIP-3=最高介入
- 覆盖链保护已执行：降级需确认，升级自动
- human_oversight 值为 Schema 合法 enum（hip-1/hip-2/hip-3）
- 审查点列表已根据 HIP 级别生成

## FAILURE MODES:

- `.sand/config.yaml` 不存在 → 跳过层 2，使用层 1 默认值
- intent_type 不在关联表中 → 使用默认 hip-2
- 用户输入非法值 → 重新提示，仅接受 hip-1/hip-2/hip-3

## NEXT STEP:

Read fully and follow `./step-04-plan.md`
