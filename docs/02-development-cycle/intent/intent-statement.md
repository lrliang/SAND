# 意图声明 7 字段标准

7 个标准字段：purpose、desired_outcome、acceptance_criteria、constraints、context_references、meta、intent_type。双受众设计（人类理解 + AI 执行）。

---

## 概述

意图声明（Intent Statement）是 SAND SDC 循环中 Intent 阶段的核心产出工件。它不是一段自然语言 prompt，而是一份**结构化的认知协作契约**——同时服务两个受众：

- **人类受众**：技术负责人和 FDE+ 通过意图声明明确"要解决什么问题"和"成功长什么样"
- **AI 受众**：AI Agent 通过意图声明获得足够的上下文来执行实现，并在执行过程中基于契约**主动识别未覆盖的边界条件**

意图声明的质量决定了整个 SDC 循环的上限。AI 的高效率反而使"意图错误"的代价成倍增加——AI 会忠实地、高效地、大规模地执行一个错误的意图。

### 与 SDD 的关系

SAND 的意图声明对应 SDD（Spec-Driven Development）的 Spec-Anchored 层级。详见 [认知协作与 SE 3.0](../../01-foundations/cognitive-collaboration.md) §SDD 章节。

### 关于 intent_id

`intent_id`（格式：`INT-YYYYMMDD-{seq}`，如 `INT-20260512-003`）是**系统自动生成**的标识符，用于在 `.sand/intents/` 目录中唯一标识每个意图声明。它不属于用户定义的 7 字段标准——用户在创建意图声明时不需要手动指定 intent_id。

---

## 字段分组逻辑

7 个字段按认知功能分为 5 组，遵循"从 Why 到 What 到 How to Verify 到 What Not to Do 到 Context"的认知路径：

| 分组 | 认知功能 | 包含字段 |
|------|---------|---------|
| **第一组：人类决策域** | Why + What | purpose, desired_outcome |
| **第二组：契约域** | How to Verify | acceptance_criteria |
| **第三组：约束域** | What NOT to Do | constraints |
| **第四组：上下文域** | Related Knowledge | context_references |
| **第五组：元数据域** | Classification + Metadata | meta, intent_type |

这一分组同时体现在 YAML 模板结构中（参见 `docs/09-templates/intent-statement.yaml`）。

---

## 7 字段完整定义

### 1. purpose（目的）

**语义说明：** 回答"为什么要做这件事？"——描述业务问题或用户痛点，必须关联到一个可追溯的投资假设或业务目标。

**格式要求：**
- 类型：多行文本（YAML `|` 块标量）
- 长度：2-5 句，100-300 字
- 必须包含：问题描述 + 业务关联

**示例：**
```yaml
purpose: |
  多租户 SaaS 应用中，租户 A 的管理员可以看到租户 B 的用户列表。
  这违反了数据隔离的合规要求（SOC2 CC6.1），如果不修复将阻碍
  企业客户的安全审计通过。关联投资假设：IH-2026-Q2-003。
```

**反模式：**
- "实现一个权限系统"——缺少业务问题描述，只有实现方案
- "优化性能"——过于模糊，没有具体痛点
- 包含技术实现细节——purpose 回答"Why"，不回答"How"

---

### 2. desired_outcome（期望结果）

**语义说明：** 回答"成功之后，世界应该变成什么样子？"——用可观测的状态变化描述，而非实现细节。

**格式要求：**
- 类型：多行文本（YAML `|` 块标量）
- 长度：2-5 句，100-300 字
- 必须描述**可观测的状态变化**，而非技术实现

**示例：**
```yaml
desired_outcome: |
  租户 A 的管理员在任何 API 端点和 UI 页面中只能看到
  属于租户 A 的数据。跨租户数据访问请求返回 403 错误
  并记录安全审计事件。现有的 API 性能不因隔离逻辑而
  显著降级（具体阈值见 acceptance_criteria）。
```

**反模式：**
- "在 middleware 层添加 tenant_id 过滤器"——这是实现方案，不是期望结果
- "系统更安全"——不可观测，没有判定标准
- 与 purpose 重复描述同一内容——desired_outcome 是"终态"，purpose 是"动机"

---

### 3. acceptance_criteria（验收标准）

**语义说明：** 定义可验证的完成条件——每条标准必须明确"如何判定通过"。这是执行契约的直接来源（参见 [执行契约标准](./execution-contract.md)）。

**格式要求：**
- 类型：结构化列表（YAML 数组）
- 每条包含：criterion（标准描述）、verification（验证方式）、priority（优先级）
- verification 枚举值：`automated_test` | `human_review` | `hybrid` | `performance_benchmark`
- priority 枚举值：`must`（必须满足） | `should`（尽量满足）

**示例：**
```yaml
acceptance_criteria:
  - criterion: "API 请求包含 tenant_id 参数时，仅返回该租户数据"
    verification: automated_test
    priority: must
  - criterion: "跨租户访问尝试返回 403 并记录 AuditEvent"
    verification: automated_test
    priority: must
  - criterion: "P95 延迟不因隔离逻辑增加超过 50ms"
    verification: performance_benchmark
    priority: should
```

**反模式：**
- "系统应该正常工作"——无法验证
- 缺少 verification 字段——无法判定如何检查
- 所有标准都标为 `must`——没有优先级区分，导致小问题阻塞整个交付
- 缺少性能基线——这是 CLEAR 检查中 Executable 维度最常见的失败点（参见 PRD Journey 2 陈雨场景）

---

### 4. constraints（约束）

**语义说明：** 定义不可违反的边界条件——"在解决问题时，哪些事情绝对不能做"。分为技术约束、安全约束和范围约束三个子域。

**格式要求：**
- 类型：结构化对象（YAML 嵌套）
- 三个子域：technical、security、scope
- 每个子域为字符串数组

**示例：**
```yaml
constraints:
  technical:
    - "不可修改 users 表的主键结构"
    - "必须兼容 PostgreSQL 14+ 和 MySQL 8+"
  security:
    - "不可在日志中输出 tenant_id 之外的租户敏感信息"
    - "不可通过 URL 参数传递 tenant_id（仅从 JWT 中提取）"
  scope:
    - "不涉及 UI 层变更，仅 API 和数据层"
    - "不处理租户迁移场景（将作为独立意图处理）"
```

**反模式：**
- 空的 constraints——几乎所有任务都有约束，空约束通常意味着遗漏
- 将实现方案写成约束——"必须使用 Redis 做缓存"是实现方案，不是约束
- 约束与 acceptance_criteria 矛盾——约束中禁止的行为不应出现在验收标准中

**特殊说明：** 如需将完整代码文件发送给 AI 模型（默认不发送），必须在 constraints 中明确授权并记录审计事件（参见 PRD FR32）。

---

### 5. context_references（上下文引用）

**语义说明：** 关联实现所需的领域知识——架构决策、领域模型、先前决策和相关意图的引用。

**格式要求：**
- 类型：结构化对象（YAML 嵌套）
- 字段：architecture、domain_model、prior_decisions、related_intents（数组）、known_risks

**示例：**
```yaml
context_references:
  architecture: "docs/architecture/multi-tenancy.md#row-level-security"
  domain_model: "docs/domain/tenant-model.md"
  prior_decisions: "ADR-007: Row-Level Security over Schema-Per-Tenant"
  related_intents:
    - "INT-20260510-001 (租户管理 API)"
    - "INT-20260511-002 (审计日志基础设施)"
  known_risks: "MySQL RLS 性能在大表上可能需要分区优化"
```

**反模式：**
- 引用不存在的文件——AI 会尝试按引用查找上下文，不存在的引用导致上下文缺失
- 过度引用——列出所有架构文档而非精确指向相关章节
- 遗漏 related_intents——意图间的依赖关系是编排阶段的关键输入

---

### 6. meta（元数据）

**语义说明：** 意图的管理元数据——所有者、优先级、投资假设关联、AI 杠杆预期和生命周期状态。

**格式要求：**
- 类型：结构化对象（YAML 嵌套）
- 必填字段：owner、priority、status、created
- 可选字段：investment_hypothesis、estimated_ai_leverage

**示例：**
```yaml
meta:
  owner: "chen.yu"
  priority: high
  investment_hypothesis: "IH-2026-Q2-003: 多租户隔离上线可解锁 3 个企业客户"
  estimated_ai_leverage: "AI 可自动生成 RLS 策略和测试，预计减少 60% 手工编码"
  created: "2026-05-12T10:30:00Z"
  status: draft
```

**反模式：**
- priority 全标 `critical`——与 acceptance_criteria 的 priority 含义不同，meta.priority 是业务优先级
- 缺少 owner——无法追溯意图的负责人
- 手动修改 status——status 应通过意图生命周期流转自动管理（参见 [意图生命周期](./intent-lifecycle.md)）

---

### 7. intent_type（意图类型）

**语义说明：** 意图的分类标签——影响后续的编排拓扑选型和审查强度配置。

**格式要求：**
- 类型：枚举字符串
- 枚举值：`feature` | `fix` | `refactor` | `exploration` | `optimization`

**示例：**
```yaml
intent_type: feature
```

**分类指南和详细定义参见 [意图类型学](./intent-taxonomy.md)。**

**反模式：**
- 混淆 `fix` 和 `refactor`——fix 修复不正确的行为，refactor 改善正确但低质量的实现
- 将 `exploration` 用于生产功能——exploration 类型的 HIP 级别较低，不适用于需要严格验证的功能

---

## 双受众设计原则

每个字段同时被两个受众消费，但侧重点不同：

| 字段 | 人类关注点 | AI 关注点 |
|------|----------|----------|
| purpose | 业务对齐、投资合理性 | 理解问题域，避免偏离意图 |
| desired_outcome | 验收预期、范围边界 | 生成代码的目标状态约束 |
| acceptance_criteria | 完成标准、测试覆盖 | 自动生成测试用例的依据 |
| constraints | 风险管控、合规要求 | 代码生成的硬约束边界 |
| context_references | 决策追溯、知识共享 | 上下文加载和关联查询 |
| meta | 项目管理、优先级排序 | 编排策略和资源配置 |
| intent_type | 工作分类、报告统计 | 拓扑选型和 HIP 级别默认值 |

---

## 对 SAND Intent Skill 的实践意义

1. **7 字段是最小完备集**：每个字段都有不可替代的认知功能。减少任何一个字段都会导致信息缺失，增加字段则引入不必要的复杂度
2. **字段分组引导对话流**：`sand-create-intent` Skill 的引导式对话应按 5 组顺序进行——先理解 Why，再定义 What，然后约束边界，最后补充上下文和元数据
3. **结构化支持 CLEAR 自动检查**：字段的结构化格式使得 Complete/Executable/Assessable 三个维度可以 AI 自动化检查（参见 [CLEAR 质量检查清单](./clear-checklist.md)）
4. **acceptance_criteria 是执行契约的源**：执行契约的 must_pass/should_pass 条目直接从 acceptance_criteria 的 priority 映射生成

---

## 引用来源

- [PRD §意图管理 FR9: 7 字段标准定义](../../_bmad-output/planning-artifacts/prd.md)
- [PRD §Journey 2 陈雨: 意图声明创建场景](../../_bmad-output/planning-artifacts/prd.md)
- [Architecture §sand-create-intent 目录结构](../../_bmad-output/planning-artifacts/architecture.md)
- [模板: docs/09-templates/intent-statement.yaml](../../09-templates/intent-statement.yaml)
