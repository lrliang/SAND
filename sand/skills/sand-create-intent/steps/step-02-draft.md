# Step 2: 7 字段意图声明草案

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous

## YOUR TASK:

通过结构化对话引导用户逐步填写意图声明的 7 个字段，生成意图声明草案并持久化到 `.sand/intents/`。

## EXECUTION SEQUENCE:

### 1. 生成 intent_id

根据当前日期和已有意图文件生成唯一 ID：

1. 获取当前日期（YYYYMMDD 格式）
2. 扫描 `.sand/intents/` 目录中以 `INT-{today}-` 开头的文件
3. 找到最大序号，+1 作为新序号（最小 001）
4. 格式：`INT-YYYYMMDD-{seq}`（如 `INT-20260512-003`）

### 2. 加载模板

从 `{sand-root}/templates/intent-statement.yaml` 加载意图声明模板。将 `intent_id` 填入模板，`intent_type` 从 step-01 的 `scope_context.intent_type` 填入。

### 3. 引导式对话——按 5 组顺序填写

按以下顺序引导用户填写，每组完成后展示当前字段内容并确认。**不要求用户了解字段格式——通过问题引导获取信息，然后帮助用户结构化。**

#### 第一组：人类决策域（Why + What）

> **[Step 2/4] 意图声明草案 — 第 1/5 组：Why + What**
>
> **purpose（目的）：**
> 你在 step-01 提到的问题是："{scope_context.problem_summary}"
>
> 帮我补充一下：
> 1. 这个问题**具体影响了谁**？（用户群体/团队/系统）
> 2. 如果不解决，**最坏情况**是什么？
> 3. 解决这个问题和 {scope_context.business_linkage} 的关系是什么？
>
> 我会根据你的回答组织成 purpose 字段。

完成 purpose 后：

> **desired_outcome（期望结果）：**
>
> 假设这个意图已经成功完成了——
> 1. 用户/系统会有什么**可观测的变化**？
> 2. 你怎么知道它"好了"？（用状态描述，不用技术细节）
> 3. 有什么**量化指标**可以衡量成功吗？（可选）

将用户回答结构化为 `desired_outcome`，注意：如果用户给出了技术实现细节（如"添加一个 middleware"），温和引导转换为状态描述（如"请求只返回当前租户的数据"）。

#### 第二组：契约域（How to verify）

> **[Step 2/4] 意图声明草案 — 第 2/5 组：验收标准**
>
> **acceptance_criteria（验收标准）：**
>
> 基于你描述的期望结果，我们来定义具体的验收标准。
> 每条标准需要回答三个问题：
>
> 1. **什么条件被满足？**（具体、可测试的描述）
> 2. **怎么验证？**
>    - `[1]` 自动化测试（automated_test）
>    - `[2]` 人工审查（human_review）
>    - `[3]` 混合（hybrid）
>    - `[4]` 性能基准测试（performance_benchmark）
> 3. **这条是必须满足的还是尽量满足的？**
>    - `[M]` must — 不满足则交付失败
>    - `[S]` should — 尽量满足，不满足可有条件接受
>
> 先说第一条验收标准：

逐条收集，直到用户表示"够了"。至少需要 1 条 priority=must 的标准（C4 检查要求）。

如果用户设定了 performance_benchmark 类型的标准，提醒补充量化基线（E2 检查要求）：

> 这是一条性能基准标准——请给一个具体的量化阈值（如"P95 延迟 < 200ms"或"内存占用 < 512MB"）。没有量化基线的话 CLEAR 检查会标记为 ⚠️。

#### 第三组：约束域（What NOT to do）

> **[Step 2/4] 意图声明草案 — 第 3/5 组：约束**
>
> **constraints（约束）：**
>
> 在解决这个问题时，有哪些事情**绝对不能做**？分三类回答：
>
> 1. **技术约束**（如兼容性要求、不可修改的组件）：
> 2. **安全约束**（如数据保护、访问控制要求）：
> 3. **范围约束**（如"不涉及 XX 模块"、"不处理 XX 场景"）：
>
> 每类可以写多条，也可以留空（但 CLEAR 检查要求至少有 1 条约束）。

#### 第四组：上下文域（Related knowledge）

> **[Step 2/4] 意图声明草案 — 第 4/5 组：上下文引用**
>
> **context_references（上下文引用）：**
>
> 实现这个意图时需要参考哪些资料？
>
> 1. **相关架构文档**（文件路径或链接）：
> 2. **领域模型文档**（如果有的话）：
> 3. **相关的历史决策**（ADR 或讨论记录）：
> 4. **关联的其他意图 ID**（如果有的话）：
> 5. **已知风险**：
>
> 不确定的字段可以留空，但提供越多上下文 AI 越能精准协作。

#### 第五组：元数据域

> **[Step 2/4] 意图声明草案 — 第 5/5 组：元数据**
>
> **meta（元数据）：**
>
> 1. **负责人**（你的名字或 ID）：
> 2. **优先级**：
>    - `[1]` low
>    - `[2]` medium
>    - `[3]` high
>    - `[4]` critical
> 3. **关联投资假设**（可选，如 IH-2026-Q2-003）：
> 4. **AI 杠杆预期**（可选，AI 能帮多少忙？）：

将用户回答填入 meta 字段，自动填充 `created`（当前 ISO 8601 时间戳）和 `status: draft`。

### 4. 展示完整草案

将完成的意图声明以 YAML 格式完整展示给用户，按 5 组分隔：

> **意图声明草案完成！**
>
> ```yaml
> {完整 YAML 内容}
> ```
>
> 请检查以上内容。有需要修改的字段吗？
> - 输入字段名称（如 `purpose`）直接修改
> - 输入 `ok` 确认草案，进入 CLEAR 质量检查

允许用户反复修改直到满意。

### 5. 持久化意图声明

将确认的意图声明写入 `.sand/intents/{intent_id}.yaml`。

记录审计事件到 `.sand/audits/audit.jsonl`（追加一行 JSON）：

```json
{"event_id":"EVT-{date}-001","timestamp":"{iso8601}","intent_id":"{intent_id}","from_status":"","to_status":"draft","trigger":"intent_created","actor":"{meta.owner}","notes":"Intent statement created via sand-create-intent"}
```

## SUCCESS METRICS:

- ✅ 7 个字段全部填写（至少有实质内容）
- ✅ 至少 1 条 priority=must 的 acceptance_criteria
- ✅ 至少 1 条 constraint
- ✅ 意图声明已写入 .sand/intents/{intent_id}.yaml
- ✅ 创建审计事件已记录

## FAILURE MODES:

- ❌ 用户无法描述期望结果 → 提示"想象这个问题已经解决了，你会怎么验证？"
- ❌ 用户给出的验收标准全部是 should 无 must → 提醒至少需要 1 条 must
- ❌ 用户坚持不写约束 → 记录并继续，CLEAR C5 会标记为 ✗

## NEXT STEP:

Read fully and follow `./step-03-clear-check.md`
