# D1：构建（Build）阶段细化

## Build 的核心悖论

### [Framework DNA #45]：Build 的"速度悖论"

Concept：在 AI 原生开发中，Build 阶段出现了一个前所未有的悖论——生产速度极快，但审查速度没有等比加快。AI 可以在几分钟内生成过去需要几天的代码量，但人类审查代码的速度受限于认知带宽。这导致了两个风险：
1. 审查瓶颈：AI 产出堆积等待人类审查，抵消了 AI 带来的速度优势
2. 审查疲劳：面对大量 AI 产出，人类审查者可能"走马观花"式审查，遗漏关键问题

SAND 的 Build 阶段必须正面应对这个悖论，而不是假装它不存在。

---

## B1：构建节奏管理（Build Rhythm Management）

### [Framework DNA #46]：脉冲式构建模式（Pulse Build Pattern）

Concept：Build 不应该是"AI 持续生成，人类持续审查"的平行流，而是有节奏的脉冲——

```
┌──────────┐   ┌──────────┐   ┌──────────┐
│ AI 生成脉冲 │→│ 人类审查窗 │→│ AI 精炼脉冲 │→ ...
│ (10-30min) │  │ (30-60min)│  │ (10-30min) │
└──────────┘   └──────────┘   └──────────┘
```

- AI 生成脉冲：AI 基于意图声明和编排方案生成一个"交付包"（代码+测试+文档）
- 人类审查窗口：FDE+ 集中审查 AI 产出，做出"接受/修改/重定向"决策
- AI 精炼脉冲：基于人类反馈，AI 精炼产出

脉冲的间隔和长度根据意图类型和复杂度动态调整——简单 Fix 可能只需一个脉冲，复杂 Feature 可能需要 5-8 个脉冲。

Novelty：这解决了速度悖论——不是让人类跟上 AI 的速度，而是让 AI 的产出节奏匹配人类的审查带宽

---

## B2：综合交付包（Comprehensive Delivery Package）

### [Framework DNA #47]：AI 产出的不是"代码"而是"交付包"

Concept：在 Build 阶段，AI 的每次产出应该是一个综合交付包，而非零散的代码片段——

```yaml
delivery_package:
  intent_ref: "SAND-2026-0042"
  pulse_number: 3  # 第3个脉冲

  artifacts:
    code:
      files_changed: ["src/payment/checkout.ts", "src/payment/validation.ts"]
      diff_summary: "新增支付校验逻辑，重构结账流程"

    tests:
      unit_tests: ["tests/unit/payment/checkout.test.ts"]
      integration_tests: ["tests/integration/payment-flow.test.ts"]
      test_coverage_delta: "+12% (payment module: 78% → 90%)"

    documentation:
      updated_docs: ["docs/api/payment.md"]
      adr: "ADR-0045: 选择异步支付确认而非同步等待"

    security_scan:
      tool: "OWASP dependency-check + custom rules"
      findings: "0 critical, 1 medium (已标记处理建议)"

    contract_verification:
      must_pass: { total: 3, passed: 3, failed: 0 }
      should_pass: { total: 1, passed: 0, note: "P95延迟2.3s，未达<2s目标" }
      must_not_violate: { total: 2, violated: 0 }

  ai_confidence: 0.82
  ai_notes: "支付确认使用了异步模式，这是架构层面的决策，建议人类重点审查 ADR-0045"
  recommended_hip: "HIP-2 (同步审查，重点关注架构决策)"
```

Novelty：交付包自带了"AI 自评"——包括置信度评分、重点审查建议、已通过的验证。这让 FDE+ 的审查变得有针对性——不需要逐行审代码，而是先看 AI 自评，重点审查 AI 标记为"不确定"的部分

---

## B3：审查策略（Review Strategy）

### [Framework DNA #48]：分层审查策略

Concept：面对综合交付包，FDE+ 不需要审查所有内容。Build 阶段定义三层审查策略——

| 审查层 | 审查内容 | 审查方式 | 触发条件 |
|--------|----------|----------|----------|
| L1 自动化层 | 测试通过率、安全扫描、合规检查、代码规范 | 全自动，AI 执行 | 每个交付包必须通过 |
| L2 AI辅助层 | 架构一致性、设计模式合理性、边界情况覆盖 | AI 标记疑点 + 人类判断 | AI 置信度 < 0.85 或涉及架构变更 |
| L3 深度人工层 | 业务逻辑正确性、安全关键路径、架构决策 | 人类逐行审查 | HIP-3 级别的关键决策 |

审查效率公式：在一个成熟的 SAND 团队中，预期 ~70% 的交付包只需 L1 自动通过，~25% 需要 L2 AI辅助审查，~5% 需要 L3 深度人工审查。这使人类审查的带宽集中在最关键的 5-30% 产出上。

Novelty：这是对"速度悖论"的系统性解答——不是让人类审查所有 AI 产出，而是让 AI 先帮人类过滤，人类只审查"AI 不确定的部分"

---

## B4：增量构建与回退机制

### [Framework DNA #49]：每个脉冲都是可独立回退的

Concept：Build 阶段的每个 AI 生成脉冲都必须是可独立回退的——

- 每个脉冲对应一个 Git 提交（或提交组）
- 如果第3个脉冲的审查发现问题，可以回退到第2个脉冲的状态而不影响前序成果
- 回退操作本身由 AI 辅助执行（自动化 revert + 影响分析），人类确认

Novelty：传统开发中回退单位是"版本/发布"，SAND 中回退单位是"脉冲"——颗粒度更细，回退成本更低，鼓励更大胆的 AI 生成尝试
