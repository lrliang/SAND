# Step 2: 拓扑选型与 Skill 链构建

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous
5. 拓扑推荐使用规则表，**不实现**复杂推导引擎（MVP 原则）

## YOUR TASK:

基于 Step 1 输出的 intent_type 和 scope，加载 `data/topology-rules.yaml` 规则数据，执行决策流程推荐最适拓扑，用户确认或修改，然后构建 Skill 链（含外部 Skill 检查）。

## EXECUTION SEQUENCE:

### 1. 加载规则数据

加载 `./data/topology-rules.yaml`，获取：
- `topologies[]` — 4 种拓扑定义
- `selection_matrix[]` — 不确定性×规模选型矩阵
- `intent_type_mapping[]` — 意图类型关联表
- `escalation_rules[]` / `de_escalation_rules[]` — 升降级规则
- `coordination_tax` — 协调税阈值

### 2. 评估意图特征

从 Step 1 输出提取：
- `intent_type` → 查询 `intent_type_mapping` 获取 primary_topology 和 alternatives
- `scope` → 评估规模（小/中/大）
- `constraints` → 评估不确定性（低/中/高）

### 3. 执行决策流程

```
1. 意图是否涉及多个独立子任务？
   ├─ 是 → 子任务间是否有顺序依赖？
   │       ├─ 是 → 推荐 Pipeline
   │       └─ 否 → 子任务数量 ≤ 4？（协调税阈值）
   │               ├─ 是 → 推荐 Swarm
   │               └─ 否 → 推荐 Hierarchy
   └─ 否 → 评估不确定性
           ├─ 高不确定性 → 推荐 Solo（探索模式）
           └─ 低/中不确定性 → 推荐 Solo（标准模式）

2. 交叉检查：意图类型关联表是否一致？
3. 矩阵复核：不确定性×规模矩阵是否一致？
4. 如有分歧 → 向用户展示两种推荐及理由
```

### 4. 展示推荐结果

向用户展示：

```
[Step 2/4] 拓扑选型

推荐拓扑：{topology_name}
推荐理由：{rationale}

意图类型关联：
| 意图类型 | 主推拓扑 | 备选拓扑 |
|---------|---------|---------|
| {intent_type} | {primary} | {alternatives} |

替代方案：
1. {alternative_1} — {reason}
2. {alternative_2} — {reason}

请确认或选择：
[C] 确认推荐  [1-2] 选择替代  [M] 手动指定
```

### 5. 检查外部 Skill（FR18/FR21）

如果编排方案需要非 SAND 内建的 Skill：

1. 检查 `.sand/plugins/registry.yaml` 是否存在
2. 如果存在——读取已注册的外部 Skill 列表
3. 对每个候选外部 Skill 检查：
   - `verified: true` — 可引入
   - `verified: false` 或不存在 — **不可选择**，向用户说明
4. 如果 `.sand/plugins/registry.yaml` 不存在——告知用户当前无已注册的外部 Skill

```
外部 Skill 检查：
✅ {verified_skill_name} — 已验证，可引入
❌ {unverified_skill_name} — 未验证，不可使用
ℹ️ 无外部 Skill 注册（.sand/plugins/registry.yaml 不存在）
```

### 6. 构建 Skill 链

基于选定拓扑和任务需求，构建 skill_chain：

```yaml
skill_chain:
  - skill_name: "sand-{first-skill}"
    order: 1
    input_mapping: {}
    is_external: false
  - skill_name: "sand-{second-skill}"
    order: 2
    input_mapping:
      # 前序 Skill 输出 → 本 Skill 输入的映射
    is_external: false
```

规则：
- `skill_name` 必须匹配 pattern `^sand-[a-z][a-z0-9-]*$`
- `order` 从 1 开始递增
- 外部 Skill 设置 `is_external: true`
- Solo 拓扑 → skill_chain 仅含 1 个 Skill
- Pipeline 拓扑 → skill_chain 按顺序排列
- Swarm 拓扑 → 并行 Skill 可共享相同 order 值
- Hierarchy 拓扑 → 管理者 Skill order=1，Worker 依次递增

**协调税警告**：如果 Swarm/Hierarchy 中 Agent 数量超过 4，显示：
```
⚠️ 协调税警告：当前配置 {N} 个 Agent，超过经验性阈值 4。
准确率增益可能趋于平坦，建议重新评估拆分粒度。
继续？(y/n)
```

### 7. 输出结果

记录以下输出供后续步骤使用：

```yaml
# Step 2 输出
topology: "{solo/pipeline/swarm/hierarchy}"
topology_rationale: "{选型理由，含决策流程路径}"
skill_chain:
  - skill_name: "sand-{name}"
    order: 1
    input_mapping: {}
    is_external: false
```

## SUCCESS METRICS:

- 决策流程完整执行（多子任务判断 → 不确定性评估 → 矩阵复核）
- 推荐拓扑 + 理由 + 替代方案已向用户展示
- 用户确认或修改了拓扑选择
- 外部 Skill 检查已执行（仅已验证 Skill 可引入）
- skill_chain 构建完成，skill_name 匹配 Schema pattern
- 协调税阈值检查已执行（如适用）

## FAILURE MODES:

- `data/topology-rules.yaml` 不存在 → HALT，文件缺失
- intent_type 不在 intent_type_mapping 中 → 使用 selection_matrix 兜底
- 用户选择的外部 Skill 未验证 → 拒绝引入，说明原因
- Skill 链为空 → HALT，编排方案需要至少 1 个 Skill

## NEXT STEP:

Read fully and follow `./step-03-hip.md`
