# CLEAR 质量检查清单

Complete（完整）、Lean（精简）、Executable（可执行）、Assessable（可评估）、Reversible（可回退）。其中 C/E/A 三项可 AI 自动化检查。

---

## 概述

CLEAR 是 SAND 对意图声明质量的五维度检查框架。它在意图声明草案完成后、生成执行契约之前运行，确保意图声明达到 [SDD Spec-Anchored 级别](../../01-foundations/cognitive-collaboration.md) 的严谨度。

CLEAR 检查的输出格式为每项 ✓（通过）/ ⚠️（警告，需修改）/ ✗（失败，必须修改），汇总后决定意图声明是否可以转化为执行契约。

### 自动化分级

| 级别 | 含义 | 适用维度 |
|------|------|---------|
| **AI 自动** | AI 可独立判定通过/不通过 | Complete (C)、Executable (E)、Assessable (A) |
| **需人工** | 需要人类主观判断 | Lean (L)、Reversible (R) |

### 通过阈值

- **全部 ✓**：直接进入执行契约生成
- **含 ⚠️ 但无 ✗**：AI 提供修改建议，用户可选择修正后重新检查或接受风险继续
- **含 ✗**：必须修正后重新检查，不可跳过

---

## C — Complete（完整）

**检查目标：** 意图声明的 7 字段是否完整填写，信息是否充分支撑实现。

**自动化级别：** AI 自动

| # | 检查项 | 判定标准（通过） | 判定标准（不通过） |
|---|--------|---------------|----------------|
| C1 | 7 字段全部非空 | 所有字段均有实质内容（非占位符、非 TBD） | 任何字段为空、仅含占位符或 "TODO" |
| C2 | purpose 包含业务关联 | 明确提及业务问题/用户痛点/投资假设 | 仅有技术描述，无业务关联 |
| C3 | desired_outcome 可观测 | 描述可观测的状态变化（含量化指标或可判定条件） | 仅有模糊愿景（如"系统更好"） |
| C4 | acceptance_criteria ≥ 1 条 must | 至少 1 条 priority=must 的验收标准 | 全部为 should 或无验收标准 |
| C5 | constraints 非空 | 至少 1 项技术/安全/范围约束 | 全部子域为空（几乎不可能没有约束） |

---

## L — Lean（精简）

**检查目标：** 意图声明是否聚焦于单一问题，避免范围蔓延和过度规格化。

**自动化级别：** 需人工

| # | 检查项 | 判定标准（通过） | 判定标准（不通过） |
|---|--------|---------------|----------------|
| L1 | 单一 purpose | purpose 描述一个核心问题 | purpose 包含多个不相关的问题（应拆分为多个意图） |
| L2 | 无实现方案泄露 | purpose 和 desired_outcome 不包含技术实现细节 | 在 purpose/desired_outcome 中指定了具体技术方案 |
| L3 | acceptance_criteria 无冗余 | 每条标准验证不同的行为 | 多条标准验证同一行为的不同表述 |
| L4 | 范围可在一个 SDC 循环内完成 | 预估可在合理时间内完成（取决于意图类型） | 范围过大，需要分解（参见 [意图分解模式](./decomposition-patterns.md)） |

---

## E — Executable（可执行）

**检查目标：** AI Agent 是否有足够的信息来执行实现，而无需大量假设或猜测。

**自动化级别：** AI 自动

| # | 检查项 | 判定标准（通过） | 判定标准（不通过） |
|---|--------|---------------|----------------|
| E1 | acceptance_criteria 均有 verification | 每条标准指定了验证方式（automated_test/human_review/hybrid/performance_benchmark） | 任何标准缺少 verification 字段 |
| E2 | 性能标准有基线 | performance_benchmark 类标准包含量化基线（如"P95 < 200ms"） | 性能标准仅有定性描述（如"足够快"） |
| E3 | context_references 可解析 | 引用的文件/链接/意图 ID 格式合法且存在 | 引用格式错误或指向不存在的资源 |
| E4 | constraints 无矛盾 | 约束条目之间不存在逻辑矛盾 | 约束 A 和约束 B 互相冲突（如"必须兼容 MySQL"与"使用 PostgreSQL 专有特性"） |
| E5 | intent_type 已指定 | intent_type 字段有合法枚举值 | intent_type 为空或不在枚举范围内 |

> **典型案例：** PRD Journey 2 中，陈雨的意图声明在 E2 上得到 ⚠️——acceptance_criteria 缺少性能基线。补充"P95 延迟不超过 50ms 增量"后通过。

---

## A — Assessable（可评估）

**检查目标：** 意图声明是否支撑后续 Validate 阶段的验证——执行契约能否从中生成。

**自动化级别：** AI 自动

| # | 检查项 | 判定标准（通过） | 判定标准（不通过） |
|---|--------|---------------|----------------|
| A1 | must 标准可自动化 | priority=must 的标准中，≥80% 的 verification 为 automated_test 或 performance_benchmark | must 标准中 >50% 仅能 human_review（50%-80% 区间判定为 warn） |
| A2 | 契约三级可映射 | acceptance_criteria(must) → must_pass，acceptance_criteria(should) → should_pass，constraints → must_not_violate 映射无歧义 | 标准内容模糊，无法明确归类到契约层级 |
| A3 | 偏差可检测 | 每条验收标准定义了足够清晰的"通过"状态，使得偏差（deviation）可被识别 | 标准过于主观（如"代码质量高"），无法程序化检测偏差 |

---

## R — Reversible（可回退）

**检查目标：** 如果实现结果不满意，是否可以安全回退。

**自动化级别：** 需人工

| # | 检查项 | 判定标准（通过） | 判定标准（不通过） |
|---|--------|---------------|----------------|
| R1 | 无不可逆操作 | 意图实现不涉及不可逆操作（如删除生产数据、不可回滚的 schema 迁移） | 涉及不可逆操作且 constraints 未声明回滚策略 |
| R2 | 回退范围可控 | 实现失败时的影响范围有限（单服务/单模块级别） | 失败影响跨多个服务或系统，无隔离机制 |
| R3 | 已声明回退策略 | 对于涉及数据变更的意图，constraints 中包含回退策略说明 | 涉及数据变更但未说明回退方案 |

---

## CLEAR 检查流程

### 执行顺序

执行顺序为 C-E-A-L-R，与 CLEAR 缩写的字母顺序不同。这是因为 AI 可自动化的维度（C/E/A）先行，人工判断维度（L/R）后行，最大化自动化效率：

1. **C（Complete）** → 先检查完整性，如果字段缺失则后续检查无意义
2. **E（Executable）** → 检查可执行性，确保 AI 有足够信息
3. **A（Assessable）** → 检查可评估性，确保能生成执行契约
4. **L（Lean）** → 检查精简性，需要人工判断范围是否合适
5. **R（Reversible）** → 检查可回退性，需要人工评估风险

### 输出格式

每次 CLEAR 检查输出一份结构化报告：

```yaml
clear_result:
  timestamp: "2026-05-12T14:30:00Z"
  intent_id: "INT-20260512-003"
  overall: pass  # pass | warn | fail
  dimensions:
    complete:
      status: pass  # pass | warn | fail
      items:
        C1: { status: pass }
        C2: { status: pass }
        C3: { status: pass }
        C4: { status: pass }
        C5: { status: pass }
    lean:
      status: pass
      items:
        L1: { status: pass }
        L2: { status: warn, suggestion: "desired_outcome 中的'使用 RLS 策略'是实现方案" }
        L3: { status: pass }
        L4: { status: pass }
    executable:
      status: warn
      items:
        E1: { status: pass }
        E2: { status: warn, suggestion: "性能标准缺少量化基线，建议补充 P95 阈值" }
        E3: { status: pass }
        E4: { status: pass }
        E5: { status: pass }
    assessable:
      status: pass
      items:
        A1: { status: pass }
        A2: { status: pass }
        A3: { status: pass }
    reversible:
      status: pass
      items:
        R1: { status: pass }
        R2: { status: pass }
        R3: { status: pass }
  summary:
    pass_count: 18
    warn_count: 2
    fail_count: 0
```

### 汇总规则

| overall 判定 | 条件 |
|-------------|------|
| **pass** | 所有维度 status 为 pass |
| **warn** | 至少 1 个维度 status 为 warn，且无 fail |
| **fail** | 至少 1 个维度 status 为 fail |

---

## 对 SAND Intent Skill 的实践意义

1. **CLEAR 是 SDD 规格质量验证的 SAND 形式化**：它确保意图声明达到 Spec-Anchored 级别，而非仅是一段自然语言描述
2. **C/E/A 自动化降低摩擦**：3 个维度可 AI 自动检查，FDE+ 只需关注 L（精简性判断）和 R（风险评估）
3. **检查项结构直接支持 `data/clear-checklist.yaml`**：上述表格可直接 YAML 化，作为 `sand-create-intent` Skill 的 step-03-clear-check 数据源
4. **CLEAR ⚠️ 是学习机会**：每个 warn 附带的修改建议是帮助 FDE+ 提升意图定义能力的教学手段

---

## 引用来源

- [PRD §FR10: CLEAR 质量检查定义](../../_bmad-output/planning-artifacts/prd.md)
- [PRD §Journey 2 陈雨: CLEAR 检查场景（Executable ⚠️）](../../_bmad-output/planning-artifacts/prd.md)
- [认知协作与 SE 3.0 §SDD 行业验证](../../01-foundations/cognitive-collaboration.md)
