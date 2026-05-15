# AI 资产分类学

5 类资产（上下文资产、意图模式、编排配方、验证规则、失败案例），每类定义标准格式、来源阶段、消费阶段。

---

## 概述

AI 资产（AI Asset）是 SAND Learn 阶段的核心产出。它与"文档""代码""配置"有本质区别：

> **AI 资产** = 从 SDC 循环中提取的、**可机器消费的**、**经人类验证的**、**有版本管理的**知识结晶。

三个关键限定词区分了 AI 资产与一般知识产出：

| 限定词 | 含义 | 反例 |
|--------|------|------|
| **可机器消费** | 格式化为 YAML/JSON，可被 Skill 在运行时自动读取和应用 | 一段口头分享的经验（不可机器消费） |
| **经人类验证** | 通过资产化流程 L2b 人工评审，确认准确性和通用性 | AI 自动提取但未经审查的模式（未验证） |
| **有版本管理** | 包含标准元数据、变更历史、置信度评分 | 一次性使用的 prompt 片段（无版本管理） |

AI 资产的价值在于**复用**：一次提炼、多次消费。每次 SDC 循环不必从零开始，而是站在前序循环积累的知识资产之上。这就是飞轮加速的知识基础。

---

## 标准元数据结构

所有 AI 资产共享以下元数据结构：

```yaml
asset_metadata:
  asset_id: "AST-{type_code}-{YYYYMMDD}-{seq}"  # 唯一标识
  asset_type: "context"                            # 5 类之一
  version: "1.0.0"                                 # SemVer
  confidence: 0.8                                  # 0.0-1.0 置信度
  source_intent_id: "INT-YYYYMMDD-{seq}"          # 来源意图（如适用）
  source_retro_date: "YYYY-MM-DD"                  # 来源复盘日期
  created_at: "ISO-8601 UTC"
  updated_at: "ISO-8601 UTC"
  expires_at: "ISO-8601 UTC"                       # 过期审查日期
  tags: ["tag1", "tag2"]
  created_by: "human"                              # human / ai+human
  usage_count: 0                                   # 引用次数
  last_used_at: null                               # 最近引用时间
```

**type_code 映射：** CTX（上下文）、INT（意图模式）、ORC（编排配方）、VAL（验证规则）、FAI（失败案例）

---

## 类型 1：上下文资产

**定义：** 团队和项目的结构化背景知识，用于提升 AI 在后续循环中的上下文理解准确性。

| 维度 | 说明 |
|------|------|
| **来源阶段** | 全循环（任何阶段均可产出） |
| **消费阶段** | Orchestrate（编排方案设计时注入上下文） |
| **保鲜期** | 中-长期（技术栈变更时需刷新） |
| **典型体积** | 50-500 行 YAML |

**标准格式：**

```yaml
asset_type: context
content:
  domain: "项目领域描述"
  tech_stack:
    languages: ["TypeScript", "Python"]
    frameworks: ["Next.js 15", "FastAPI"]
    databases: ["PostgreSQL 16"]
  architecture_summary: "简要架构描述"
  domain_glossary:
    - term: "领域术语"
      definition: "定义"
  conventions:
    - area: "命名规范"
      rule: "规则描述"
```

**典型示例：**
- 团队技术栈描述（语言、框架、工具链版本）
- 项目架构摘要（核心模块、依赖关系、数据流）
- 领域术语表（业务概念的精确定义，防止 AI 误解）
- 代码规范集（命名约定、目录结构、错误处理模式）

---

## 类型 2：意图模式

**定义：** 经过验证的高质量意图声明模板和常见约束集，用于提升后续 Intent 阶段的意图编写效率和质量。

| 维度 | 说明 |
|------|------|
| **来源阶段** | Intent + Validate（意图创建和验证反馈） |
| **消费阶段** | Intent（意图声明起草时参考） |
| **保鲜期** | 中期（业务需求演变时需更新） |
| **典型体积** | 30-100 行 YAML |

**标准格式：**

```yaml
asset_type: intent_pattern
content:
  pattern_name: "模式名称"
  applicable_intent_types: ["feature", "fix"]    # 适用的意图类型
  template:
    purpose: "目的模板（含占位符）"
    acceptance_criteria_patterns:
      - pattern: "验收标准模式"
        rationale: "为什么这个模式有效"
    common_constraints:
      - constraint: "常见约束"
        category: "security"
    clear_tips:
      - dimension: "Executable"
        tip: "该类意图常遗漏的 Executable 检查点"
  validation_history:
    first_pass_rate: 0.85                        # 使用此模式的首通率
    sample_size: 12                              # 样本量
```

**典型示例：**
- 高首通率意图声明模板（特定领域的 7 字段最佳实践）
- 常见约束集（安全约束、性能约束、兼容性约束的标准写法）
- 验收标准模式库（按功能类型分类的验收标准编写模式）
- CLEAR 维度提示（历史数据显示的常见失败点和预防方法）

---

## 类型 3：编排配方

**定义：** 经过验证的编排方案组合（拓扑 + HIP + Skill 链），用于提升后续 Orchestrate 阶段的编排决策效率。

| 维度 | 说明 |
|------|------|
| **来源阶段** | Orchestrate + Build（编排设计和执行验证） |
| **消费阶段** | Orchestrate（编排方案设计时参考） |
| **保鲜期** | 中期（Skill 生态变化时需更新） |
| **典型体积** | 20-80 行 YAML |

**标准格式：**

```yaml
asset_type: orchestration_recipe
content:
  recipe_name: "配方名称"
  applicable_scenarios:
    task_type: "任务类型描述"
    complexity: "medium"
    team_size: "2-5"
  recommended_topology: "pipeline"
  recommended_hip: "hip-2"
  skill_chain:
    - skill: "sand-create-intent"
      notes: "关键配置说明"
    - skill: "sand-validate-delivery"
      notes: "关键配置说明"
  success_metrics:
    completion_rate: 0.92
    average_duration: "2h"
    sample_size: 8
```

**典型示例：**
- 特定任务类型的最优拓扑选型（如"多租户功能开发 → Pipeline + HIP-2"）
- HIP 配置模板（不同风险级别下的 HIP 推荐值）
- Skill 链组合模式（经过验证的 Skill 调用顺序和配置）

---

## 类型 4：验证规则

**定义：** 从验证经验中提炼的领域特定检查项，用于增强后续 Validate 阶段的三通道检查覆盖面。

| 维度 | 说明 |
|------|------|
| **来源阶段** | Validate（验证执行中发现的检查缺口） |
| **消费阶段** | Validate（验证执行时作为补充检查项） |
| **保鲜期** | 中-长期（安全规则需跟踪漏洞公告更新） |
| **典型体积** | 15-60 行 YAML |

**标准格式：**

```yaml
asset_type: validation_rule
content:
  rule_name: "规则名称"
  channel: "security"                              # contract / security / architecture
  severity: "blocking"                             # blocking / warning / info
  check_description: "检查项的具体描述"
  detection_method: "如何检测——计算控制或推断控制"
  control_type: "computational"                    # computational / inferential
  false_positive_rate: 0.05                        # 历史误报率
  origin_deviation_id: "DEV-EXE-20260515-001-02"  # 来源偏差事件（如适用）
```

**典型示例：**
- 领域特定安全检查项（如"支付模块必须检查 SQL 参数化查询"）
- 架构约束检查项（如"微服务间不允许直接数据库访问"）
- 常见偏差修复模式（如"错误响应体信息泄露 → 通用错误消息替换"）

---

## 类型 5：失败案例

**定义：** 结构化的已知失败模式及其预防策略，用于在后续循环中主动规避已知陷阱。

| 维度 | 说明 |
|------|------|
| **来源阶段** | 全循环（任何阶段的失败事件） |
| **消费阶段** | Orchestrate（编排方案设计时的风险预警） |
| **保鲜期** | 长期（失败模式的教训通常长期有效） |
| **典型体积** | 20-80 行 YAML |

**标准格式：**

```yaml
asset_type: failure_case
content:
  failure_name: "失败模式名称"
  failure_category: "security_deviation"           # 与偏差类型枚举对齐
  sdc_phase: "build"                               # 首次发生的 SDC 阶段
  root_cause: "根因分析"
  symptoms:
    - "可观察到的症状 1"
    - "可观察到的症状 2"
  prevention_strategy:
    intent_level: "在意图声明中应增加的约束"
    build_level: "在构建阶段应注意的检查"
    validate_level: "在验证阶段应增加的检查项"
  occurrence_history:
    first_seen: "YYYY-MM-DD"
    total_count: 3
    last_seen: "YYYY-MM-DD"
    status: "active"                                # active / mitigated / resolved
```

**典型示例：**
- 已知失败模式（如"AI 生成的认证中间件遗漏 token 过期检查"）
- 根因分析（如"意图声明未在 constraints 中明确 token 生命周期要求"）
- 多层预防策略（从 Intent 到 Build 到 Validate 的全链路防御）

---

## 5 类资产总览

| 类型 | type_code | 来源阶段 | 消费阶段 | 保鲜期 | 核心价值 |
|------|-----------|---------|---------|--------|---------|
| 上下文资产 | CTX | 全循环 | Orchestrate | 中-长 | 提升 AI 上下文理解准确性 |
| 意图模式 | INT | Intent + Validate | Intent | 中 | 提升意图首通率 |
| 编排配方 | ORC | Orchestrate + Build | Orchestrate | 中 | 加速编排决策 |
| 验证规则 | VAL | Validate | Validate | 中-长 | 增强验证覆盖面 |
| 失败案例 | FAI | 全循环 | Orchestrate | 长 | 主动规避已知陷阱 |

**对 SAND 的实践意义：** AI 资产分类学将"经验"从人类大脑中的隐性知识转化为文件系统中的显性资产。这不仅解决了知识流失问题（人员流动时经验不丢失），更重要的是使知识可被 AI Agent 在运行时自动消费——从而实现真正的飞轮效应：每一轮循环都站在前序循环积累的知识之上。

---

## 引用来源

- PRD §学习与资产化 FR39 — 5 类 AI 资产定义
- [Learn 阶段概述](./README.md) — 5 类资产表和飞轮核心机制
- [偏差追踪](../validate/deviation-tracking.md) — 偏差事件与资产化路径的映射
- [资产化流程](./assetization-process.md) — 资产候选如何经过 4 步精炼入库
- [资产生命周期](./asset-lifecycle.md) — 资产的衰减、刷新和版本管理
