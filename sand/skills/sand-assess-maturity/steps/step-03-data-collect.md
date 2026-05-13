# Step 3: 数据辅助采集

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous

## YOUR TASK:

可选步骤——引导用户从 Git/CI 系统采集量化信号，辅助校准 Step 2 的评估结果。此步骤不改变评级，仅提供数据参考。

## EXECUTION SEQUENCE:

### 1. 询问是否需要数据辅助

> **[Step 3/5] 数据辅助采集（可选）**
>
> Step 2 的评估基于结构化对话。如果你想用 Git/CI 数据来校准评估结果，可以在这一步采集量化信号。
>
> - `[Y]` 是，我想用数据校准
> - `[S]` 跳过，直接生成雷达图
>
> 如果选择跳过，将直接进入 Step 4。

如果用户选择跳过，直接跳转到 NEXT STEP。

### 2. Git 信号采集引导

引导用户在终端运行以下命令并回报结果：

> **Git 信号采集**（请在你的项目终端中运行）：
>
> **PR 周期时间**（最近 30 天 PR 从创建到合并的中位天数）：
> ```bash
> # GitHub CLI
> gh pr list --state merged --limit 50 --json createdAt,mergedAt
> ```
>
> **AI 参与度**（最近 50 条 commit 中包含 AI 相关标记的占比）：
> ```bash
> git log --oneline -50 | grep -ci "copilot\|claude\|ai\|cursor"
> ```
>
> **变更失败率**（最近 30 天回滚或修复 commit 的占比）：
> ```bash
> git log --oneline --since="30 days ago" | grep -ci "revert\|hotfix\|fix:"
> ```

### 3. CI 信号采集引导（如果可用）

> **CI 信号**（如果你的团队有 CI/CD 管线）：
>
> - **部署频率**：最近 30 天的部署次数
> - **构建成功率**：最近 30 天的构建成功率

如果用户无法获取 CI 数据，接受口头估计或跳过。

### 4. 校准建议

基于采集到的数据，提供校准建议：

> **数据校准参考：**
>
> | 信号 | 你的数据 | 行业基线 | 可能影响的维度 |
> |------|---------|---------|-------------|
> | PR 周期时间 | {用户数据} | 1-3 天 | D4（人类审查体系） |
> | AI 参与度 | {用户数据} | 40-60% | D1（AI 工具采纳度） |
> | 变更失败率 | {用户数据} | <15% | D4（人类审查体系） |
>
> **注意：** 这些数据仅作为参考，不自动修改评级。如果数据与对话评估结果差异较大，建议重新审视相关维度。
>
> 是否需要根据数据调整某个维度的评级？
> - `[Y]` 是，我想调整（请指定维度和新等级）
> - `[N]` 不需要，保持原评估结果

## SUCCESS METRICS:

✅ 用户做出了选择（采集数据 / 跳过）
✅ 如果采集了数据，已提供校准建议
✅ 评估结果已确定（无论是否校准）

## FAILURE MODES:

❌ 用户无法运行 Git 命令 → 接受口头估计
❌ 数据与评估差异巨大 → 建议重新审视但尊重用户最终判断

## NEXT STEP:

Read fully and follow `./step-04-radar.md`
