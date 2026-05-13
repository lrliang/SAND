# Step 1: 评估范围确认

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous

## YOUR TASK:

确定评估范围（团队级/组织级）并收集基本信息，为后续 7 维度对话建立上下文。

## EXECUTION SEQUENCE:

### 1. 初始化 .sand/ 目录

检查用户项目根目录是否存在 `.sand/` 目录。如果不存在，创建 `.sand/assessments/` 目录结构。

### 2. 选择评估模式

向用户展示评估模式选项：

> **[Step 1/5] 评估范围确认**
>
> 请选择评估模式：
> 1. **首次诊断模式** — 全面组织评估，覆盖全部 7 维度（推荐首次使用）
> 2. **循环校准模式** — 基于上轮改进的快速检查（适用于已完成过评估的团队）

如果用户选择循环校准模式，询问需要重新评估哪些维度（可多选），并加载上一次评估结果作为基线。

### 3. 收集基本信息

通过对话收集以下信息：

> **基本信息收集：**
>
> 1. **团队/组织名称**（将作为 team_id）：
> 2. **评估范围**：
>    - `[A]` 单个团队（≤15 人）
>    - `[B]` 多个团队 / 部门级（15-50 人）
>    - `[C]` 组织级（>50 人）
> 3. **团队规模**（人数）：
> 4. **AI 工具使用时长**：
>    - `[1]` < 3 个月
>    - `[2]` 3-12 个月
>    - `[3]` > 12 个月
> 5. **主要使用的 AI 工具**（可多选）：
>    - `[a]` GitHub Copilot
>    - `[b]` Cursor
>    - `[c]` Claude Code
>    - `[d]` Codex CLI
>    - `[e]` 其他（请说明）

### 4. 记录评估上下文

将收集到的信息组织为评估上下文，供后续步骤引用：

```yaml
assessment_context:
  team_id: "{用户提供的名称}"
  scope: "team|department|organization"
  team_size: {人数}
  ai_tool_duration: "{时长}"
  primary_tools:
    - "{工具列表}"
  mode: "initial-diagnosis|cycle-calibration"
  timestamp: "{当前 ISO-8601 UTC 时间}"
```

## SUCCESS METRICS:

✅ 用户确认了评估模式（首次诊断 / 循环校准）
✅ 收集了 team_id、评估范围、团队规模、AI 工具使用信息
✅ 评估上下文已结构化记录

## FAILURE MODES:

❌ 用户无法确定评估范围 → 建议从单个团队开始（最小切口策略）
❌ 用户不确定 AI 工具使用情况 → 建议先做一次工具清点再评估

## NEXT STEP:

Read fully and follow `./step-02-dialogue.md`
