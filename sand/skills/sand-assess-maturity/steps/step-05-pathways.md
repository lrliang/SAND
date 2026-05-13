# Step 5: 可执行改进路径推荐

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous

## YOUR TASK:

基于 Step 4 的雷达图结果和 `./data/pathway-rules.yaml` 中的规则，为红色维度生成可执行改进路径，每条路径关联具体的 SAND Skill、预期 ROI 和时间范围。

## EXECUTION SEQUENCE:

### 1. 加载改进路径规则

读取 `./data/pathway-rules.yaml`，加载组织形状策略、维度-Skill 映射表和依赖关系。

### 2. 收集红色维度

从 Step 4 的评估结果中筛选所有红色维度（L1-L2）。如果没有红色维度，跳转到第 7 步（总结与下一步建议）。

### 3. 检查依赖关系

对每个红色维度，检查改进路径的前提条件是否满足：
- D2 改进需要 D1 ≥ L2
- D3 改进需要 D2 ≥ L2（传递依赖 D1 ≥ L2）
- D6 改进需要 D4 ≥ L2

如果前提未满足，在路径推荐中标注，并优先推荐前提维度的改进。

### 4. 排序改进路径

按 pathway-rules.yaml 中的三级优先级排序：

1. **组织形状驱动**：
   - 均衡型 → 最快见效的红色维度
   - 偏科型 → 最低的红色维度（短板）
   - 尖刺型 → 尖刺相邻的红色维度
2. **最快见效优先**：有现成 Skill 的维度排前面
3. **依赖关系**：被其他维度依赖的维度排前面

### 5. 生成并展示改进路径

对每条路径，使用以下展示格式：

> **[Step 5/5] 可执行改进路径**
>
> 基于你的组织形状（{形状}）和评估结果，以下是优先推荐的改进路径：
>
> ---
>
> **路径 {序号}：{维度名称}（{当前等级} → {目标等级}）**
>
> | 项目 | 内容 |
> |------|------|
> | **目标维度** | {D编号} {维度名称} |
> | **当前等级** | L{N}（{等级名称}） |
> | **目标等级** | L{N+1}（{等级名称}） |
> | **推荐 Skill** | `{skill_name}` |
> | **预期见效时间** | {timeframe} |
> | **预期 ROI** | {expected_roi} |
>
> **行动步骤：**
> 1. {具体行动描述}
> 2. {运行周期}
> 3. {效果评估}
>
> **前置条件：** {有/无——如有列出}
>
> ---

### 6. 更新评估报告

将改进路径写入 Step 4 保存的 `.sand/assessments/{filename}.yaml` 文件的 `improvement_pathways` 字段：

```yaml
improvement_pathways:
  - target_dimension: "{D编号}-{维度名称}"
    current_level: {N}
    target_level: {N+1}
    recommended_skill: "{skill_name}"
    timeframe: "{timeframe}"
    expected_roi: "{roi}"
```

### 7. 总结与下一步建议

> **评估完成！**
>
> **评估摘要：**
> - 团队：{team_id}
> - 组织形状：{shape}
> - 红色维度：{count} 个
> - 黄色维度：{count} 个
> - 绿色维度：{count} 个
>
> **推荐的第一步：**
> 运行 `{首条路径推荐的 Skill}` 来开始改进 {维度名称}。预期 {timeframe} 后可以重新运行 `sand-assess-maturity`（循环校准模式）查看进展。
>
> **评估报告已保存：** `.sand/assessments/{filename}.yaml`
>
> ---
>
> **下一步可选操作：**
> 1. **立即行动** — 运行推荐的第一个 Skill
> 2. **深入查看** — 查看某条路径的详细行动方案
> 3. **导出报告** — 将评估结果用于向管理层汇报
> 4. **结束** — 评估完成

## SUCCESS METRICS:

✅ 所有红色维度都有对应的改进路径
✅ 每条路径关联了具体 Skill + ROI + 时间范围
✅ 路径按组织形状策略排序
✅ 依赖关系被正确处理（前提未满足的维度有标注）
✅ 改进路径已写入评估报告文件

## FAILURE MODES:

❌ 没有红色维度 → 转为展示黄色维度的优化建议
❌ 推荐的 Skill 尚未实现（如 Phase 2/3 的 Skill）→ 标注为"即将可用"并建议替代方案
❌ 用户对路径优先级有不同看法 → 尊重用户判断，调整排序

## COMPLETED:

评估工作流结束。评估报告位于 `.sand/assessments/`。
