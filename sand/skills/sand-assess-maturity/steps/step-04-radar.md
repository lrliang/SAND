# Step 4: 雷达图生成

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous

## YOUR TASK:

基于 Step 2 的评估结果生成 7 维雷达图数据，应用颜色编码，计算关键比率，并将结果持久化到 `.sand/assessments/`。

## EXECUTION SEQUENCE:

### 1. 汇总评估结果

从 Step 2 的评估结果中提取 7 个维度的等级，组织为雷达图展示格式：

> **[Step 4/5] 7 维成熟度雷达图**
>
> ```
>              AI 工具采纳度 (D1)
>                    L{N}
>                     |
>     组织文化 (D7)   |   意图驱动 (D2)
>          L{N} \     |     / L{N}
>                \    |    /
>                 \   |   /
>     治理合规 (D6)---+---编排能力 (D3)
>          L{N}  /    |    \  L{N}
>               /     |     \
>     学习资产 (D5)   |   人类审查 (D4)
>          L{N}       |       L{N}
> ```

### 2. 应用颜色编码

对每个维度标注颜色：

| 维度 | 等级 | 颜色 | 状态 |
|------|------|------|------|
| D1 AI 工具采纳度 | L{N} | {红色/黄色/绿色} | {需要改进/可优化/优秀} |
| D2 意图驱动成熟度 | L{N} | ... | ... |
| D3 编排能力 | L{N} | ... | ... |
| D4 人类审查体系 | L{N} | ... | ... |
| D5 学习与资产化 | L{N} | ... | ... |
| D6 治理与合规 | L{N} | ... | ... |
| D7 组织文化 | L{N} | ... | ... |

颜色规则：
- **红色**：L1-L2（需要立即改进）
- **黄色**：L3（已标准化，可持续优化）
- **绿色**：L4-L5（优秀，维持和扩展）

### 3. 计算关键比率

> **关键比率分析：**
>
> - **红色维度占比**：{红色数量}/7 = {百分比}%
>   - 超过 50% 意味着组织急需系统性转型
> - **最大落差**：L{max} - L{min} = {差值}
>   - 落差 ≥3 级标志严重不平衡
> - **流程层 vs 基础设施差距**：D2-D7 平均 L{avg} - D1 L{N} = {差值}
>   - 正数意味着流程层评分高于基础设施，负数意味着基础设施领先但流程层未跟上

### 4. 识别组织形状

基于 `./data/pathway-rules.yaml` 中的识别规则判定组织形状：

> **组织形状诊断：{均衡型/偏科型/尖刺型}**
>
> {对应的诊断含义描述}
>
> {对应的转型策略概述}

### 5. 生成并持久化评估报告

使用 `{sand-root}/templates/maturity-assessment.yaml` 作为模板，填充实际评估数据，保存到 `.sand/assessments/` 目录：

文件名格式：`{timestamp}_{team_id}.yaml`（timestamp 使用 YYYYMMDD 日期格式，如 `20260513_team-alpha.yaml`）

```yaml
assessment_id: "ASSESS-{YYYYMMDD}-{team_id}"
team_id: "{team_id}"
timestamp: "{ISO-8601 UTC}"
mode: "{initial-diagnosis|cycle-calibration}"
dimensions:
  - id: D1
    name: "AI 工具采纳度"
    level: {N}
    evidence:
      - "{证据}"
    notes: "{备注}"
  # ... D2-D7 同上
organizational_shape: "{balanced|skewed|spiked}"
improvement_pathways: []  # 将在 Step 5 填充
assessor: "{用户名}"
```

向用户确认文件已保存：

> ✅ 评估报告已保存到 `.sand/assessments/{filename}.yaml`

## SUCCESS METRICS:

✅ 7 维雷达图已展示，每维度标注颜色
✅ 关键比率已计算（红色占比、最大落差、流程-基础设施差距）
✅ 组织形状已识别（均衡/偏科/尖刺）
✅ 评估报告已持久化到 .sand/assessments/

## FAILURE MODES:

❌ .sand/ 目录无法创建 → 提示用户检查文件系统权限
❌ 评估数据不完整（某维度缺失等级）→ 回到 Step 2 补充
❌ 用户对雷达图结果有异议 → 允许调整单个维度评级并重新生成

## NEXT STEP:

Read fully and follow `./step-05-pathways.md`
