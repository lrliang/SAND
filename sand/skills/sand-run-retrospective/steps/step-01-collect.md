# Step 1: 5 议题结构化回顾

## MANDATORY EXECUTION RULES (READ FIRST):

1. 读完整个步骤文件后再执行——不要边读边做
2. 按编号顺序执行每个子节——不跳步
3. 遇到不确定性时请求人类确认——不猜测用户意图
4. 每个子节完成后向用户汇报进度——保持透明
5. 失败时快速报错并说明原因——不静默降级或继续

## YOUR TASK:

按 5 个标准议题引导用户完成 AI 复盘，采集结构化数据并输出复盘日志到 `.sand/retrospectives/{YYYYMMDD}_retro_{seq}.md`。

## EXECUTION SEQUENCE:

### §1 检查数据源可用性

检查以下数据源的可用性，记录每个数据源的状态：

| 数据源 | 检查路径 | 状态记录 |
|--------|---------|---------|
| 审计日志 | `.sand/audits/audit.jsonl` | available / unavailable |
| 意图声明 | `.sand/intents/` 目录下 `INT-*.yaml` 文件 | available (N files) / unavailable |
| 执行记录 | `.sand/executions/` 目录下 `EXE-*/` 子目录 | available (N sessions) / unavailable |
| 偏差记录 | `.sand/executions/EXE-*/deviations.json` | available (N files) / unavailable |

**输出数据源可用性摘要：**

```
📊 数据源可用性检查

✅ 审计日志：{N} 条事件          （或 ⚠️ 审计日志：不可用）
✅ 意图声明：{N} 个文件          （或 ⚠️ 意图声明：不可用）
✅ 执行记录：{N} 个会话          （或 ⚠️ 执行记录：不可用）
✅ 偏差记录：{N} 个文件          （或 ⚠️ 偏差记录：不可用）
```

**如果所有数据源均不可用：**
- 输出：`⚠️ 所有数据源不可用——进入"人工回忆模式"。复盘将完全依赖您的观察和回忆，不提取自动数据摘要。`
- **不 HALT**——继续执行，所有议题跳过数据采集部分，仅引导结构化问题。

### §2 确认复盘类型和元数据

提示用户选择复盘类型：

```
🔄 AI 复盘——SDC Learn 阶段

请选择复盘类型：
[1] 微循环复盘（15-30 分钟，快速扫描议题 1-4，不含资产候选）
[2] 宏循环复盘（1-2 小时，完整 5 议题 + 资产候选清单）
[3] 深度复盘（半天，全面回溯 + 根因分析 + 改进路径）
```

收集复盘元数据：
- **SDC 循环 ID**：请用户提供本轮循环标识（如 `CYCLE-20260515-001`，或自由输入描述）
- **参与者**：列出参与复盘的人员
- **时间范围**：本轮 SDC 循环的起止日期

记录：`retro_type`（micro/macro/deep）、`cycle_id`、`participants`、`time_range_from`、`time_range_to`

**关键规则：** 如果用户选择微循环复盘（micro），§7（议题 5 资产化提名）跳过。

### §3 议题 1：意图质量回顾

**[Step 1/5] 意图质量回顾** `source_topic: intent_quality`

**数据采集（如 `.sand/intents/` 可用）：**
1. 扫描时间范围内的意图声明文件（`INT-*.yaml`）
2. 统计 CLEAR 检查通过率（从 frontmatter 或关联审计事件提取，如可用）
3. 计算意图首通率（Draft → Validated 无回退的比率）

**引导问题：**

向用户依次提问，记录每个问题的回答：

1. 本轮 CLEAR 检查的通过率如何？哪些维度（Complete/Lean/Executable/Assessable/Reversible）最常出现问题？
2. 有多少意图声明一次通过检查（首通率）？与上一轮相比有什么变化？
3. 对于需要返修的意图，最常见的返修原因是什么？
4. 是否有特别好的意图声明值得提炼为可复用模板？

**记录输出：**
- 数据摘要：CLEAR 维度通过率分布（如数据可用）、首通率数值
- 发现：用户回答的要点提炼
- 资产候选（仅 macro/deep 类型）：从回答中识别的意图模式候选

### §4 议题 2：编排有效性回顾

**[Step 2/5] 编排有效性回顾** `source_topic: orchestration_effectiveness`

**数据采集（如 `.sand/executions/` 可用）：**
1. 扫描时间范围内的执行会话目录
2. 提取编排方案中的拓扑类型和 HIP 配置（如有 orchestration-plan.yaml）
3. 统计 Skill 链执行中断率（从 execution.yaml 的 status 字段）

**引导问题：**

1. 本轮选择的编排拓扑（Solo/Pipeline/Swarm/Hierarchy）是否合适？是否有需要中途调整的情况？
2. HIP 级别配置是否合理？HIP-1 场景是否需要更多人工介入？HIP-3 是否成为瓶颈？
3. Skill 链执行中是否有中断？中断的原因是什么（输入不匹配、超时、宿主问题）？
4. 是否有可复用的编排组合——特定任务类型 + 拓扑 + HIP 的组合证明效果良好？

**记录输出：**
- 数据摘要：拓扑使用分布、Skill 链中断率（如数据可用）
- 发现：拓扑选型偏差、HIP 充分性评估
- 资产候选（仅 macro/deep 类型）：编排配方候选

### §5 议题 3：AI 杠杆分析

**[Step 3/5] AI 杠杆分析** `source_topic: ai_leverage`

**数据采集：** 本议题主要依赖人类观察。如审计日志可用，可统计 `actor=agent` 事件数量和成功率。

**引导问题：**

1. AI 在哪些步骤中提供了超预期的价值？（如主动识别未覆盖的边界条件、检测安全漏洞等）
2. AI 在哪些步骤中表现不佳，需要大量人工修正？修正成本是否高于手动完成？
3. 本轮有多少次 AI 主动暂停请求人类澄清？这些暂停是否有价值？
4. 人工覆盖（Override）AI 建议的频率和原因是什么？覆盖是否正确？
5. 从整体看，AI 杠杆率（AI 辅助节省时间 ÷ 人工修正 AI 输出的时间）是正向还是负向？

**记录输出：**
- 数据摘要：agent 事件统计（如数据可用）
- 发现：AI 高价值 / 低价值介入点
- 资产候选（仅 macro/deep 类型）：上下文改进候选

### §6 议题 4：失败模式分析

**[Step 4/5] 失败模式分析** `source_topic: failure_mode`

**数据采集（如 `.sand/audits/audit.jsonl` 可用）：**
1. 筛选时间范围内 `status=failure` 或 `status=interrupted` 的事件
2. 按 `skill_name` 和 `sdc_phase` 分类统计
3. 从 `.sand/executions/EXE-*/deviations.json` 提取偏差记录（如可用）
4. 计算 `learning_signal` 填充率（有值的偏差条数 ÷ 总偏差条数）

**引导问题：**

1. 本轮出现了哪些失败/中断事件？按 Skill 和 SDC 阶段的分布如何？
2. 是否有**重复失败模式**——与历史复盘中已知的失败模式相同或相似？（首轮复盘可跳过此问题）
3. 是否有**新增失败模式**——首次出现的失败类型？根因假说是什么？
4. 哪些之前存在的失败模式已被有效缓解——本轮未再出现？
5. 偏差事件的 `learning_signal` 是否已填充？对于未填充的偏差，现在是否可以补充？

**记录输出：**
- 数据摘要：failure/interrupted 事件分类统计（如数据可用）、learning_signal 完整度百分比
- 发现：重复 / 新增 / 已缓解失败模式清单
- 资产候选（仅 macro/deep 类型）：失败案例 + 验证规则候选

### §7 议题 5：资产化提名

**[Step 5/5] 资产化提名** `source_topic: assetization_nomination`

**如果 `retro_type` = micro，输出以下消息并跳过此议题：**
```
ℹ️ 微循环复盘不包含资产化提名。如需进行资产化，请选择宏循环或深度复盘。
```

**引导问题：**

1. 综合前 4 个议题的发现，哪些可以提炼为标准化、可复用的 AI 资产？
2. 每个候选的预期复用频率如何？是高频（每个 SDC 循环都可能用到）还是低频（特定场景才适用）？
3. 候选的保鲜期如何？是长期有效（如架构规范）还是快速衰减（如特定版本的最佳实践）？

**对于每个提名的候选，引导用户填写：**

```yaml
# 资产候选 {seq}
- candidate_id: "CAN-{YYYYMMDD}-{seq}"
  asset_type: "{type}"           # context / intent_pattern / orchestration_recipe / validation_rule / failure_case
  source_topic: "{topic}"        # intent_quality / orchestration_effectiveness / ai_leverage / failure_mode / assetization_nomination
  source_intent_id: "{id}"       # 关联的意图 ID（如适用，格式 INT-YYYYMMDD-{seq}），无关联则为 null
  description: "{一句话描述}"
  expected_reuse_frequency: "{freq}"  # high / medium / low
  expected_shelf_life: "{life}"       # long / medium / short
  confidence: {0.0-1.0}              # 初始置信度（参考：单次观察 0.3-0.5，多次观察 0.5-0.7，量化数据 0.7-0.9）
  suggested_by: "{who}"              # human / ai（AI 建议需用户确认后方可保留）
```

**AI 辅助：** 基于前 4 个议题的记录，AI 可主动建议候选（`suggested_by: ai`），用户确认或拒绝。未经用户确认的 AI 建议不写入最终日志。

**记录输出：** 完整的 `asset_candidates` YAML 列表

### §8 飞轮指标快照

**[飞轮度量] 三指标快照**

对于每个指标，尝试从 `.sand/` 数据推算。如果数据不足，请求用户手动输入或标记为 N/A：

**指标 1：资产复用率**
- 计算：引用了 AI 资产（`AST-*`）的意图数 ÷ 总意图数
- 数据源：`.sand/intents/INT-*.yaml` 中 `context_references` 字段
- 如数据不足：请用户估算或标记 `N/A（首轮循环，无资产可复用）`

**指标 2：意图首通率**
- 计算：Draft → Validated 无回退的意图数 ÷ 总完成意图数
- 数据源：意图声明 frontmatter `meta.status` 历史
- 如数据不足：请用户根据经验估算

**指标 3：循环周期压缩率**
- 计算：本轮 SDC 周期时长 ÷ 前轮 SDC 周期时长
- 数据源：执行会话时间戳
- 如数据不足（首轮或无前序数据）：标记 `N/A（无前序循环可对比）`

**向用户展示三指标并请求确认：**

```
📈 飞轮指标快照

- 资产复用率：{value}%（健康区间 30%-70%）
- 意图首通率：{value}%（目标 ≥60%，成熟 80%+）
- 循环周期压缩率：{value}（<1.0 = 加速中）

以上数值是否准确？请确认或修正。
```

### §9 生成结构化日志

**组装并输出复盘日志：**

1. 检查 `.sand/retrospectives/` 目录是否存在，不存在则创建
2. 生成文件名：`{YYYYMMDD}_retro_{seq}.md`（使用当前日期 + 序号）。扫描 `.sand/retrospectives/` 中已有的 `{YYYYMMDD}_retro_*.md` 文件，取最大序号 +1 作为 `{seq}`（首次为 `001`）。这确保同日多次复盘不会覆盖。
3. 按以下模板组装完整的复盘日志：

```markdown
# AI 复盘日志 — {YYYY-MM-DD}

## 元数据
- 复盘类型: {retro_type}
- SDC 循环 ID: {cycle_id}
- 参与者: {participants}
- 时间范围: {time_range_from} — {time_range_to}
- 数据源可用性: {available_sources_summary}

## 议题 1: 意图质量回顾
### 数据摘要
{data_summary_or_"数据不可用，基于人工回忆"}
### 发现
{findings_list}
<!-- 仅 macro/deep 类型包含以下子节 -->
### 资产候选
{asset_candidates_list}

## 议题 2: 编排有效性回顾
### 数据摘要
{data_summary}
### 发现
{findings_list}
<!-- 仅 macro/deep 类型包含以下子节 -->
### 资产候选
{asset_candidates_list}

## 议题 3: AI 杠杆分析
### 数据摘要
{data_summary}
### 发现
{findings_list}
<!-- 仅 macro/deep 类型包含以下子节 -->
### 资产候选
{asset_candidates_list}

## 议题 4: 失败模式分析
### 数据摘要
{data_summary}
### learning_signal 完整度: {completeness_percent}%
### 发现
{findings_list}
<!-- 仅 macro/deep 类型包含以下子节 -->
### 资产候选
{asset_candidates_list}

## 议题 5: 资产化提名
<!-- micro 类型: 输出"微循环复盘不含此议题" -->
<!-- macro/deep 类型: 输出 asset_candidates YAML 列表 -->
{asset_candidates_yaml_or_skip_message}

## 飞轮指标快照
- 资产复用率: {value}
- 意图首通率: {value}
- 循环周期压缩率: {value}
```

4. 写入文件到 `.sand/retrospectives/{YYYYMMDD}_retro_{seq}.md`
5. 向用户确认输出：

```
✅ 复盘日志已生成

📄 文件路径：.sand/retrospectives/{YYYYMMDD}_retro_{seq}.md
📊 复盘类型：{retro_type}
📋 议题覆盖：{5/5 或 4/5（微循环）}
📈 飞轮指标：已记录

数据收集完成。继续 Step 2 进行资产分类与趋势分析。
```

## SUCCESS METRICS:

✅ 5 个标准议题（或微循环 4 个）全部完成引导对话
✅ 结构化日志成功写入 `.sand/retrospectives/{YYYYMMDD}_retro_{seq}.md`
✅ 飞轮指标快照包含三指标（数值或 N/A）
✅ 数据源不可用时优雅降级为人工回忆模式（不 HALT）
✅ 资产候选（如有）包含完整的 YAML 结构化格式

## FAILURE MODES:

❌ `.sand/` 根目录不存在 → 创建 `.sand/retrospectives/` 目录后继续
❌ 写入权限不足 → HALT 并报告权限问题
❌ 用户在议题引导中中途退出 → 保存已收集的数据为部分复盘日志，标注 `status: partial`
❌ 所有数据源不可用且用户无法提供任何回忆 → 输出空模板复盘日志，标注 `status: empty`

## NEXT STEP:

继续执行 `steps/step-02-classify.md` — 资产分类与趋势分析
