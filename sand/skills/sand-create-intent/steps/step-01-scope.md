# Step 1: 需求收集与意图范围确认

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous

## YOUR TASK:

确定意图类型并收集意图范围信息，为后续 7 字段填写建立上下文。

## EXECUTION SEQUENCE:

### 1. 初始化 .sand/ 目录

检查用户项目根目录是否存在 `.sand/intents/` 和 `.sand/intents/contracts/` 目录。如果不存在，创建完整目录结构：

```
.sand/
├── intents/
│   └── contracts/
└── audits/
```

同时确认 `.sand/audits/audit.jsonl` 文件存在（如不存在则创建空文件）。

### 2. 选择意图类型

向用户展示意图类型选项：

> **[Step 1/4] 意图范围确认**
>
> 你想创建什么类型的意图？
>
> `[A]` **Feature** — 新增功能或能力（推荐编排: Pipeline/Swarm, HIP-2）
> `[B]` **Fix** — 修复不正确的行为（推荐编排: Solo, HIP-1）
> `[C]` **Refactor** — 改善内部结构，不改变外部行为（推荐编排: Pipeline, HIP-2）
> `[D]` **Exploration** — 验证技术可行性或探索方案（推荐编排: Solo, HIP-1）
> `[E]` **Optimization** — 改善非功能特性（推荐编排: Solo/Pipeline, HIP-2）
>
> 不确定？描述你想做的事，我来帮你分类。

如果用户不确定类型，通过以下问题引导判断：
- "你要添加新功能还是修复现有问题？" → Feature vs Fix
- "你要改善代码质量还是改善性能？" → Refactor vs Optimization
- "这是一个技术验证还是需要上线的功能？" → Exploration vs Feature

### 3. 收集意图概要

通过对话收集核心信息：

> **意图概要收集：**
>
> 1. **用一句话描述你要解决的问题：**
>    （这将成为 purpose 字段的基础）
>
> 2. **这个问题关联到什么业务目标？**
>    - `[1]` 有明确的投资假设/OKR 关联
>    - `[2]` 关联到已知的用户反馈/Bug 报告
>    - `[3]` 是技术债务/内部优化
>    - `[4]` 还不确定（我会帮你找到关联点）
>
> 3. **预期范围有多大？**
>    - `[a]` 小范围（单文件/单模块，< 1 天）
>    - `[b]` 中等范围（多文件/多模块，1-3 天）
>    - `[c]` 大范围（跨服务/跨系统，> 3 天）

### 4. 范围预检

根据收集到的范围信息进行预检：

- **如果选择了"大范围"**：提醒用户意图可能需要分解。建议查阅意图分解模式（垂直切片/能力分层/风险梯度），但不强制——用户可以选择继续并在 CLEAR L4 检查时再决定。

- **如果问题描述包含多个不相关的关注点**：温和提示"这听起来可能包含多个独立的意图"，建议拆分但不阻断。

### 5. 记录范围上下文

将收集到的信息组织为范围上下文，供 step-02 引用：

```yaml
scope_context:
  intent_type: "{用户选择}"
  problem_summary: "{一句话描述}"
  business_linkage: "{关联类型和描述}"
  estimated_scope: "{small/medium/large}"
  decomposition_needed: false  # step-03 CLEAR L4 可能修改
```

向用户确认：

> **范围确认：**
>
> - 意图类型：{intent_type}
> - 问题概要：{problem_summary}
> - 业务关联：{business_linkage}
> - 预估范围：{estimated_scope}
>
> 确认无误？`(y/n)` 输入 `n` 可修改任何字段。

## SUCCESS METRICS:

- ✅ 意图类型已选定
- ✅ 问题概要已收集
- ✅ 业务关联已识别
- ✅ 范围预检已完成
- ✅ .sand/intents/ 目录结构已就绪

## FAILURE MODES:

- ❌ 用户无法描述问题 → 引导用户思考"如果这个问题不解决，什么会发生？"
- ❌ 无法确定意图类型 → 默认选择 Feature，可在 step-02 修改
- ❌ 范围明显过大但用户坚持不拆分 → 记录 `decomposition_needed: deferred`，CLEAR L4 会再次评估

## NEXT STEP:

Read fully and follow `./step-02-draft.md`
