# 验证决策矩阵

基于三通道结果的结构化判定：通过→Operate、有条件通过→Operate+技术债、打回→Build、重定向→Intent。安全通道 FAIL 作为打回的高优先子场景处理。

---

## 概述

验证决策矩阵是三通道并行验证（参见 [三通道并行验证架构](./three-channel.md)）的下游处理逻辑。它将三通道的合并结果转化为**结构化决策**，明确交付物的下一步流向。

决策矩阵的设计原则：

- **无歧义**：每种三通道结果组合都有且仅有一个决策输出
- **可审计**：决策过程的每一步都记录到审计日志
- **人类最终确认**：所有决策（包括自动通过）都经过 HIP 级别对应的人类确认

---

## 四种决策结果

### 决策结果定义

| 决策 | 代码标识 | 含义 | 后续流向 |
|------|---------|------|---------|
| **通过** | `pass` | 交付物满足所有验证条件 | → Operate（部署） |
| **有条件通过** | `conditional_pass` | 交付物基本满足要求但存在非阻塞性问题 | → Operate + 技术债记录 |
| **打回 Build** | `reject_to_build` | 交付物存在功能性或架构性缺陷 | → Build（修复并重新验证） |
| **重定向 Intent** | `redirect_to_intent` | 偏差源自意图声明本身的问题 | → Intent（修正意图） |

---

## 判定逻辑

### 决策树

```
三通道合并结果
  │
  ├── PASS（三通道全部通过）
  │   └── 决策: pass → Operate
  │
  ├── PASS_WITH_WARNINGS（无 FAIL，存在 warning）
  │   ├── 安全通道有许可证警告 AND 其他均通过
  │   │   └── 决策: conditional_pass → Operate + 技术债
  │   ├── 架构通道有命名/模式 warning AND 其他均通过
  │   │   └── 决策: conditional_pass → Operate + 技术债
  │   ├── 契约通道有 should_pass 未通过 AND 其他均通过
  │   │   └── 决策: conditional_pass → Operate + 技术债
  │   └── 多通道存在 warning
  │       └── 决策: conditional_pass → Operate + 技术债
  │
  └── FAIL（任一通道失败）
      ├── 安全通道 FAIL（注入/凭证/敏感数据等 blocking 项）
      │   └── 决策: reject_to_build（安全修复优先）
      ├── 契约通道 FAIL + 意图对齐度分析显示偏差源自意图声明
      │   └── 决策: redirect_to_intent
      ├── 契约通道 FAIL + 意图对齐度正常（实现错误）
      │   └── 决策: reject_to_build
      ├── 架构通道 FAIL（目录结构/依赖方向违规）
      │   └── 决策: reject_to_build
      └── 多通道 FAIL
          ├── 含意图偏差信号
          │   └── 决策: redirect_to_intent
          └── 纯实现问题
              └── 决策: reject_to_build
```

### 结构化判定表

**优先级规则：** 表中行按优先级从高到低排列。匹配第一条命中的规则即停止。

| # | 契约通道 | 安全通道 | 架构通道 | 意图偏差信号 | 决策 |
|---|---------|---------|---------|-----------|------|
| 1 | PASS | PASS | PASS | — | **pass** |
| 2 | PASS | PASS_W | PASS | — | **conditional_pass** |
| 3 | PASS | PASS | PASS_W | — | **conditional_pass** |
| 4 | PASS_W | PASS | PASS | — | **conditional_pass** |
| 5 | PASS | PASS_W | PASS_W | — | **conditional_pass** |
| 6 | PASS_W | PASS | PASS_W | — | **conditional_pass** |
| 7 | PASS_W | PASS_W | PASS | — | **conditional_pass** |
| 8 | PASS_W | PASS_W | PASS_W | — | **conditional_pass** |
| 9 | — | FAIL | — | — | **reject_to_build** |
| 10 | — | — | FAIL | — | **reject_to_build** |
| 11 | FAIL | PASS/PASS_W | PASS/PASS_W | 有 | **redirect_to_intent** |
| 12 | FAIL | PASS/PASS_W | PASS/PASS_W | 无 | **reject_to_build** |
| 13 | FAIL | FAIL | — | — | **reject_to_build** |
| 14 | FAIL | — | FAIL | — | **reject_to_build** |

> 注：PASS_W = PASS_WITH_WARNINGS。"—"表示该列取任意值。"意图偏差信号"仅在契约通道 FAIL 且安全/架构通道未 FAIL 时参与判定（规则 11-12）。
>
> **关键设计决策：** 安全通道 FAIL（规则 9）和架构通道 FAIL（规则 10）优先级高于意图偏差信号——因为安全漏洞和架构违规不能通过修改意图声明解决，必须回退到 Build 修复。意图偏差信号仅在唯一的 FAIL 来源是契约通道时才触发重定向 Intent（规则 11）。

---

## 决策结果详细规范

### pass（通过）

**触发条件：** 三通道合并结果为 PASS

**行为：**
- 交付物标记为"已验证"，流转到 Operate 阶段
- 验证报告写入 `.sand/executions/EXE-{session_id}/validation-report.yaml`
- 审计事件记录 `status: success`
- HIP 对应级别的人类确认（HIP-1 下为最低介入确认）

**输出：**
```yaml
decision:
  result: pass
  timestamp: "ISO-8601"
  channels_summary:
    contract: pass
    security: pass
    architecture: pass
  next_action: operate
  human_confirmation: { required: true, hip_level: "hip-X" }
```

### conditional_pass（有条件通过）

**触发条件：** 三通道合并结果为 PASS_WITH_WARNINGS

**行为：**
- 交付物标记为"有条件验证"，可流转到 Operate 但附带技术债
- 所有 warning 条目记录为技术债项（tech_debt_items）
- 每条技术债项包含：来源通道、检查项描述、建议修复时限
- 审计事件记录 `status: success`（带 warnings 标记）
- HIP 对应级别的人类确认——人类需审查所有 warning 条目并决定是否接受

**技术债记录格式：**
```yaml
tech_debt_items:
  - source_channel: security
    check_item: "license_compatibility"
    description: "新增依赖 library-X 使用 LGPL-2.1 许可证"
    suggested_deadline: "2026-06-15"
    severity: warning
  - source_channel: architecture
    check_item: "naming_convention"
    description: "函数 getUserData 不符合 snake_case 约定"
    suggested_deadline: "2026-06-01"
    severity: warning
```

**对 SAND 的实践意义：** "有条件通过"机制防止了两个极端——既不因非关键问题阻塞交付，也不让警告被无声忽略。技术债记录确保了 warning 的可追溯性。

### reject_to_build（打回 Build）

**触发条件：** 任一通道 FAIL 且偏差源自实现层面（非意图层面）

**行为：**
- 交付物标记为"未通过验证"，回退到 Build 阶段修复
- 生成修复指引：列出所有 FAIL 检查项及其具体失败原因
- 偏差事件记录到 `.sand/executions/EXE-{session_id}/deviations.json`（参见 [意图偏差追踪](./deviation-tracking.md)）
- 审计事件记录 `status: failure`
- 修复后需重新进入 Validate 阶段（完整三通道重新执行）

**修复指引格式：**
```yaml
fix_guidance:
  failed_checks:
    - channel: contract
      check_item: "must_pass_item_3"
      failure_reason: "API 返回 200 但未包含 tenant_id 过滤"
      suggested_fix: "在 query 层添加 tenant_id WHERE 条件"
    - channel: architecture
      check_item: "dependency_direction"
      failure_reason: "domain/user.py 直接导入 infrastructure/db.py"
      suggested_fix: "通过 repository interface 间接访问"
  other_channel_warnings:  # 非失败通道的 warning 一并列出，避免修复后重验时"凭空出现"
    - channel: security
      check_item: "license_compatibility"
      description: "新增依赖 library-X 使用 LGPL-2.1 许可证"
  revalidation_required: true
```

### redirect_to_intent（重定向 Intent）

**触发条件：** 契约验证通道 FAIL 且意图对齐度分析显示偏差源自意图声明本身

**触发场景：**
1. **验收标准不完整**：交付物实现了意图声明未覆盖的边界条件——说明 acceptance_criteria 遗漏了关键场景
2. **约束矛盾**：交付物无法同时满足意图声明中相互矛盾的约束
3. **期望结果模糊**：交付物的实现存在多种合理解读——说明 desired_outcome 描述不够精确
4. **范围漂移**：交付物超出或偏离意图声明定义的范围边界

**行为：**
- 交付物不部署，流程回退到 Intent 阶段
- 生成意图修正建议：指出意图声明中需要修正的具体字段和原因
- 偏差事件记录为 `deviation_type: intent_scope_deviation`
- 审计事件记录 `status: failure`
- 意图声明修正后，需重新经历 Build → Validate 完整流程

**意图修正建议格式：**
```yaml
intent_correction:
  intent_id: "INT-YYYYMMDD-{seq}"
  correction_reason: "验收标准未覆盖并发场景"
  affected_fields:
    - field: acceptance_criteria
      issue: "缺少并发数据迁移场景的验收条件"
      suggestion: "增加 '当源租户和目标租户同时操作时，迁移脚本应...' 的验收条件"
    - field: constraints
      issue: "scope 约束未排除并发场景"
      suggestion: "在 scope 中明确并发迁移是否在范围内"
  revalidation_required: true
  full_cycle_required: true  # 需要重新 Build + Validate
```

**对 SAND 的实践意义：** "重定向 Intent"是 SDC 循环中最有价值的反馈回路之一。它表明验证阶段不仅检查实现质量，还能**反向检测意图质量**——意图声明的 CLEAR 检查虽然在 Intent 阶段已执行，但实际的完备性只有在 Build 产出交付物后才能被充分验证。

---

## 决策与 HIP 级别的关系

所有决策结果都需要经过 HIP 级别对应的人类确认：

| HIP 级别 | pass | conditional_pass | reject_to_build | redirect_to_intent |
|---------|------|-----------------|----------------|-------------------|
| **HIP-1**（全自主） | 通知确认 | 审查 warning 列表 | 审查修复指引 | 审查意图修正建议 |
| **HIP-2**（关键决策审查） | 通知确认 | 逐条审查 warning | 逐条审查 FAIL 原因 | 逐条审查意图字段修正 |
| **HIP-3**（全程监督） | 完整报告审查 | 完整报告审查 + 逐条决策 | 完整报告审查 + 修复方案确认 | 完整报告审查 + 意图重写确认 |

---

## 决策输出持久化

决策结果写入 `.sand/executions/EXE-{session_id}/validation-report.yaml` 的 `decision` 部分：

```yaml
decision:
  result: "pass | conditional_pass | reject_to_build | redirect_to_intent"
  timestamp: "ISO-8601"
  channels_summary:
    contract: "pass | pass_with_warnings | fail"
    security: "pass | pass_with_warnings | fail"
    architecture: "pass | pass_with_warnings | fail"
  next_action: "operate | build | intent"
  tech_debt_items: [...]      # conditional_pass 时填充
  fix_guidance: { ... }        # reject_to_build 时填充
  intent_correction: { ... }   # redirect_to_intent 时填充
  human_confirmation:
    required: true
    hip_level: "hip-1 | hip-2 | hip-3"
    confirmed_by: null         # 人类确认后填充
    confirmed_at: null
```

---

## 引用来源

- [三通道并行验证架构](./three-channel.md) — Validate 阶段核心机制
- [意图偏差追踪](./deviation-tracking.md) — 偏差事件记录规范
- [意图声明 7 字段标准](../intent/intent-statement.md) — Intent 阶段核心工件
- [执行契约标准](../intent/execution-contract.md) — 执行契约三级结构定义
- PRD §交付验证 FR23-FR27b
- PRD §意图偏差追踪 FR27a-b
