# Step 1: 上下文收集与质量评估

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous
5. If intent declaration is missing, HALT and suggest running `sand-create-intent`

## YOUR TASK:

加载意图声明，收集四层次上下文（项目/意图/历史/协作），执行上下文质量评估（4 维），应用最小化原则（FR32），输出 `context_scope` 和 `context_quality_check` 结果。

## EXECUTION SEQUENCE:

### 1. 加载意图声明

询问用户提供意图声明路径，或扫描 `.sand/intents/` 目录查找最新意图声明。

```
请提供要编排的意图声明：
1. 输入意图 ID（如 INT-20260514-001）
2. 扫描 .sand/intents/ 查找最新意图
3. 手动输入路径
```

从意图声明中提取关键字段：
- `intent_type`（feature/fix/refactor/exploration/optimization）
- `scope`（任务范围描述）
- `constraints`（约束条件）
- `context_references`（上下文引用列表）
- `acceptance_criteria`（验收标准）

**如果意图声明不存在**：HALT — 提示用户运行 `sand-create-intent` 先创建意图声明。

### 2. 四层次上下文收集

按上下文金字塔从底层到顶层收集：

**第一层：项目上下文（Project Context）**
- 加载 `CLAUDE.md` / `project-context.md`（如存在）
- 加载 `.sand/config.yaml`（项目配置）
- 提取：技术栈、编码规范、目录结构

**第二层：意图上下文（Intent Context）**
- 加载意图声明和执行契约（如存在于 `.sand/intents/contracts/`）
- 提取：purpose、desired_outcome、acceptance_criteria、constraints

**第三层：历史上下文（Historical Context）**
- 检查 `.sand/audits/audit.jsonl`（如存在）——提取最近 5 条相关审计事件
- 检查 `.sand/executions/` 下最近的偏差记录（如存在）
- 提取：过往偏差模式、学习信号

**第四层：协作上下文（Collaboration Context）**
- 本步骤为初始收集，协作上下文将在执行阶段实时生成
- 记录：当前无协作上下文（首次设计）

### 3. 上下文质量评估（4 维）

对已收集的上下文执行四维质量检查：

| 维度 | 评估问题 | 判定 |
|------|---------|------|
| **完整性**（Completeness） | Agent 是否拥有完成任务所需的全部信息？ | pass / warn / fail |
| **准确性**（Accuracy） | 加载的上下文是否反映最新状态？ | pass / warn / fail |
| **精简性**（Conciseness） | 是否排除了无关信息？ | pass / warn / fail |
| **可发现性**（Discoverability） | 上下文是否通过明确路径可定位？ | pass / warn / fail |

输出质量评估结果（前 3 项写入 `context_quality_check`，第 4 项 discoverability 记入 `topology_rationale` 注释）。

### 4. 应用上下文最小化原则（FR32）

按以下规则过滤上下文：

| 上下文类型 | 默认行为 | 操作 |
|-----------|---------|------|
| 接口契约（API signatures） | 自动包含 | 加入 include_files |
| 依赖关系摘要 | 自动包含 | 加入 include_files |
| 用户标记的代码片段 | 需确认 | 询问用户后决定 |
| 完整代码文件 | **不包含** | 需用户在 constraints 中授权 + 审计记录 |
| 环境变量 / 密钥 | **禁止** | 阻断并告警 |

### 5. 输出结果

记录以下输出供后续步骤使用：

```yaml
# Step 1 输出
intent_id: "{从意图声明提取}"
intent_type: "{feature/fix/refactor/exploration/optimization}"
scope: "{任务范围}"

context_scope:
  include_files:
    - "{已批准的上下文文件路径列表}"
  exclude_patterns:
    - "{排除的模式列表}"

context_quality_check:
  completeness: "{pass/warn/fail + 说明}"
  accuracy: "{pass/warn/fail + 说明}"
  conciseness: "{pass/warn/fail + 说明}"
  # discoverability 结果记入 meta.topology_rationale

constraints: "{从意图声明提取的约束条件原文}"
```

向用户展示收集摘要并确认。

## SUCCESS METRICS:

- 意图声明成功加载，intent_type 和 scope 已提取
- 四层次上下文收集完成（至少第一层和第二层有内容）
- 4 维质量评估全部执行，无 fail 项（warn 可接受）
- 最小化原则已应用，无禁止类上下文泄露
- context_scope 和 context_quality_check 输出格式正确

## FAILURE MODES:

- 意图声明不存在（`.sand/intents/` 缺失或无匹配文件） → HALT，建议运行 `sand-create-intent`
- `.sand/` 目录存在但历史/审计子目录缺失 → 跳过第三层和第四层上下文收集，创建最小化 context_scope（仅项目 + 意图上下文）
- 质量评估中 completeness = fail → 警告用户上下文不足，建议补充后重新评估
- 意图声明缺少 intent_type 字段 → 询问用户手动指定

## NEXT STEP:

Read fully and follow `./step-02-topology.md`
