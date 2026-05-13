# Step 2: 7 维度结构化对话

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous

## YOUR TASK:

按 7 个维度依次引导结构化对话，基于 `./data/dimension-rubrics.yaml` 中的行为指标评估每个维度的成熟度等级。

## EXECUTION SEQUENCE:

### 1. 加载评估量表

读取 `./data/dimension-rubrics.yaml`，加载全部 7 维度 × L1-L5 的行为指标和证据标准。

### 2. 逐维度引导对话

对每个维度（D1 → D2 → D3 → D4 → D5 → D6 → D7），执行以下对话模式：

---

**对话模板（每个维度重复）：**

> **[Step 2/5] 维度评估 — {D编号}: {维度名称}**
>
> **维度定义：** {definition}
>
> 我将通过几个问题帮助评估你们团队在这个维度的成熟度。请基于**实际情况**回答，而非期望或计划。
>
> **关于 L{当前检查等级} — {等级名称}：**
>
> 1. {行为指标 1}
>    - 你们团队是否如此？请描述具体情况或提供证据。
>
> 2. {行为指标 2}
>    - 同上。
>
> **判定：** 是否满足 L{N} 的所有行为指标？
> - `[Y]` 是，两条都满足 → 继续检查 L{N+1}
> - `[N]` 否，至少一条不满足 → 该维度评级为 L{N-1}
> - `[P]` 部分满足 → 请描述具体情况，我来帮助判断

---

### 3. 等级判定规则

- 从 L1 开始逐级检查
- **达到某等级**要求该等级的**所有**行为指标都已满足
- **部分满足不提升等级**——仅在当前等级行为指标全部满足时才检查下一级
- 评估以**证据为导向**——自我感知不计入评级，需要可验证的证据
- 如果 L1 的指标都不满足，等级仍记为 L1（最低等级）

### 4. 记录每维度评估结果

每个维度评估完成后，记录：

```yaml
dimension_result:
  id: "{D编号}"
  name: "{维度名称}"
  level: {评定等级 1-5}
  evidence:
    - "{用户提供的证据摘要}"
  notes: "{评估过程中的重要观察}"
```

### 5. 对话风格指导

- **引导式问答**，而非让用户填写问卷
- 根据用户回答**追问细节**——"你提到有 AI 使用指南，它覆盖了哪些场景？"
- 帮助用户**区分愿望和现实**——"你说计划引入 CLEAR 检查，但目前实际在用吗？"
- 对不确定的回答**建议保守评级**——"如果证据不充分，建议保持在较低等级，后续可以校准"
- 每个维度评估完成后给出**即时反馈**——"D1 评估完成：L3（已定义/系统化）。你的 AI 工具覆盖面不错，但缺少量化度量。"

### 6. 汇总所有维度结果

7 个维度全部评估完成后，汇总为完整结果集：

```yaml
assessment_results:
  dimensions:
    - id: D1
      name: "AI 工具采纳度"
      level: {N}
    - id: D2
      name: "意图驱动成熟度"
      level: {N}
    - id: D3
      name: "编排能力"
      level: {N}
    - id: D4
      name: "人类审查体系"
      level: {N}
    - id: D5
      name: "学习与资产化"
      level: {N}
    - id: D6
      name: "治理与合规"
      level: {N}
    - id: D7
      name: "组织文化"
      level: {N}
```

## SUCCESS METRICS:

✅ 7 个维度全部完成评估，每个维度有明确的 L1-L5 等级
✅ 每个维度有至少 1 条证据记录
✅ 评估基于结构化对话而非问卷填写
✅ 汇总结果集已生成

## FAILURE MODES:

❌ 用户无法回答某个维度的问题 → 建议该维度标记为 L1 并注明"待进一步调查"
❌ 用户对评级结果有异议 → 尊重用户判断，记录异议原因
❌ 评估时间超过预期 → 建议跳过详细证据收集，先完成全部维度再回补

## NEXT STEP:

Read fully and follow `./step-03-data-collect.md`
