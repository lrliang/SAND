# Step 3: 资产入库建议

## MANDATORY EXECUTION RULES (READ FIRST):

1. 读完整个步骤文件后再执行——不要边读边做
2. 按编号顺序执行每个子节——不跳步
3. 遇到不确定性时请求人类确认——不猜测用户意图
4. 每个子节完成后向用户汇报进度——保持透明
5. 失败时快速报错并说明原因——不静默降级或继续

## YOUR TASK:

引导用户完成 L2b-L2d 资产化流程（人工评审 → 结构化 → 入库建议），为每个接受的候选生成完整的结构化资产入库建议。

## EXECUTION SEQUENCE:

### §1 L2b 人工评审

逐个展示 Step 2 分类后的候选，按类型分组展示，引导用户做出评审决策。

**对于每个候选，展示：**

```
📝 候选评审 [{current}/{total}]

类型：{asset_type_chinese}（{type_code}）
来源议题：{source_topic}
描述：{description}
关联意图：{source_intent_id or "无"}
建议者：{suggested_by}
预期复用频率：{expected_reuse_frequency}
保鲜期：{expected_shelf_life}
初始置信度：{confidence}

评审标准：
- 准确性：模式与实际执行数据一致，证据链完整？
- 通用性：适用于类似场景的多个实例？
- 时效性：基于当前有效的技术栈和业务规则？

请做出评审决策：
[A] 接受（accepted）
[R] 拒绝（rejected）— 请说明原因
[M] 修改后接受（accepted_with_changes）— 请说明修改建议
```

**记录评审结果：**

```yaml
review:
  reviewer: "{user_name}"
  reviewed_at: "{ISO-8601 UTC}"
  decision: "accepted"           # accepted / rejected / accepted_with_changes
  notes: "{评审意见}"
```

**评审约束：**
- `suggested_by: ai` 的候选必须经过人工评审才能进入 L2c——这是 Mikkonen "人类审查不可削减" 原则的直接体现
- 拒绝的候选记录拒绝原因但不进入后续步骤
- `accepted_with_changes` 的候选在进入 L2c 前需先完成修改

**展示评审汇总：**

```
✅ L2b 人工评审完成

📊 评审结果：
- 接受：{accepted_count}
- 修改后接受：{changed_count}
- 拒绝：{rejected_count}

继续对 {accepted_count + changed_count} 个候选进行结构化...
```

如果所有候选被拒绝：输出"所有候选未通过评审。本轮无资产入库。"→ 跳到 §4 输出汇总。

### §2 L2c 结构化

对所有 accepted（含 accepted_with_changes 已修改后）的候选，填充完整的标准元数据，转化为结构化资产。

**自动填充的字段：**

| 字段 | 填充规则 |
|------|---------|
| `asset_id` | 自动生成：`AST-{type_code}-{YYYYMMDD}-{seq}`（扫描已有资产 ID 确定 seq） |
| `asset_type` | 从候选继承 |
| `version` | `1.0.0`（新资产初始版本） |
| `confidence` | 从候选继承，评审时可调整 |
| `source_intent_id` | 从候选继承 |
| `source_retro_date` | 当前复盘日期 |
| `created_at` | 当前时间（ISO-8601 UTC） |
| `updated_at` | 同 created_at |
| `expires_at` | 基于类型默认周期计算（见下表） |
| `tags` | AI 从描述中提取关键词 + 请用户补充 |
| `created_by` | `ai+human` |
| `usage_count` | `0` |
| `last_used_at` | `null` |

**过期周期表：**

| 资产类型 | type_code | 默认过期周期 |
|---------|-----------|------------|
| 上下文资产 | CTX | 90 天 |
| 意图模式 | INT | 180 天 |
| 编排配方 | ORC | 120 天 |
| 验证规则 | VAL | 180 天 |
| 失败案例 | FAI | 365 天 |

**对每个候选生成完整的结构化资产 YAML：**

按照 `ai-asset-taxonomy.md` 中对应资产类型的标准格式填充 `content` 节。向用户展示生成的 YAML 并请求确认：

```
📦 结构化资产 [{current}/{total}]

asset_id: AST-{type_code}-{YYYYMMDD}-{seq}
asset_type: {type}
version: 1.0.0
confidence: {value}
expires_at: {date}
tags: [{tags}]

内容预览：
{content_yaml_preview}

请确认或修改后继续。[C] 确认 / [E] 编辑
```

### §3 L2d 入库建议

为每个结构化资产生成入库建议：

**入库建议结构：**

```yaml
registration_recommendation:
  asset_id: "AST-{type_code}-{YYYYMMDD}-{seq}"
  asset_type: "{type}"
  storage_recommendation: "将此资产保存到项目的资产管理目录中（建议路径由团队约定）"
  versioning: "SemVer 1.0.0，内容微调递增 Patch，实质更新递增 Minor"
  expiry_review_date: "{expires_at}"
  expiry_action: "到期时进行人工审查：刷新（更新+重置过期时间）/ 归档 / 延期"
  relationships:
    depends_on: []               # 此资产依赖的其他资产（如有）
    related: []                  # 语义相关的资产（如有）
  review_record:
    reviewer: "{user_name}"
    decision: "{accepted/accepted_with_changes}"
    reviewed_at: "{ISO-8601}"
    notes: "{评审意见}"
```

**关联关系建议：**
- AI 基于候选的 `source_topic` 和 `description` 推荐可能的关联关系
- 向用户展示建议，用户确认或跳过

### §4 汇总输出

生成入库建议汇总，追加到当前复盘日志末尾：

1. 读取 Step 1 生成的复盘日志文件（`.sand/retrospectives/{YYYYMMDD}_retro_{seq}.md`）
2. 在文件末尾追加以下节：

```markdown
---

## 资产分类与趋势分析（Step 2）

### 分类结果
{step-02 分类摘要表}

### 飞轮趋势
{step-02 趋势分析结果}

## 资产入库建议（Step 3）

### 评审汇总
- 总候选数：{total}
- 接受：{accepted}
- 修改后接受：{changed}
- 拒绝：{rejected}

### 结构化资产清单

{每个接受资产的完整 YAML，按类型分组}

### 入库建议

{每个资产的 registration_recommendation YAML}
```

3. 保存更新后的复盘日志

**展示最终完成消息：**

```
✅ sand-run-retrospective 完整版复盘完成

📄 复盘日志：.sand/retrospectives/{YYYYMMDD}_retro_{seq}.md
📊 议题覆盖：5/5
📦 资产入库建议：{accepted_count} 个（含 {changed_count} 个修改后接受）
📈 飞轮指标：已记录 + 趋势分析

下一步操作建议：
1. 按入库建议保存资产文件到团队约定的资产目录
2. 在下一轮 SDC 循环的 Intent 阶段引用这些资产（提升复用率）
3. 定期检查资产过期日期，及时刷新或归档
```

## SUCCESS METRICS:

✅ 所有候选经过 L2b 人工评审（每个候选有明确的 accepted/rejected/changed 决策）
✅ accepted 候选填充了完整的标准元数据（asset_id、version、confidence、expires_at 等）
✅ 每条入库建议包含资产类型、来源、版本化策略、过期审查周期
✅ 入库建议汇总追加到复盘日志末尾
✅ suggested_by=ai 的候选必须经人工评审确认

## FAILURE MODES:

❌ Step 2 未产出分类结果 → HALT 并建议先运行 Step 2
❌ 所有候选被拒绝 → 输出"本轮无资产入库"汇总，正常结束（不 HALT）
❌ 复盘日志文件写入失败 → HALT 并报告权限或路径问题
❌ 用户在评审过程中中途退出 → 保存已完成的评审结果，标注未评审候选为 `pending`
