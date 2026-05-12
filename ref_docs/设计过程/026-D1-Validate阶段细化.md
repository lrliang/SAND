# D1：验证（Validate）阶段细化

## Validate 的核心职责

### [Framework DNA #50]：Validate 不是"测试"，是"意图对齐验证"

Concept：传统测试回答的是"代码有没有 Bug"。Validate 回答的是更高层的问题——"Build 的产出是否真正实现了 Intent 声明的意图，且在 Constraint 定义的边界内"。这包含但远超传统测试——

| 传统测试 | SAND Validate |
|----------|---------------|
| 代码是否按预期运行 | 产出是否实现了意图声明的 desired_outcome |
| 测试用例是否通过 | 执行契约的 must_pass/should_pass/must_not_violate 全面核验 |
| 代码覆盖率 | 意图覆盖率——意图声明的每条要求是否都有对应的验证 |
| 功能测试/性能测试/安全测试 | 加上：架构合规性验证、AI 产出溯源审计、上下文一致性检查 |

---

## V1：三通道验证架构（Three-Channel Validation）

### [Framework DNA #51]：Validate 的三条平行验证通道

Concept：不是串行地"先功能测试再安全测试再合规审计"，而是三条通道并行运行——

```
Build 产出
    │
    ├──→ [通道一：契约验证] ──→ 执行契约通过/失败判定
    │     自动化测试 + AI辅助验证
    │
    ├──→ [通道二：安全合规验证] ──→ 安全/合规风险报告
    │     安全扫描 + 合规规则检查 + 许可证审计
    │
    └──→ [通道三：架构对齐验证] ──→ 架构偏离度报告
          AI分析产出与架构规范的一致性
          │
          ▼
    [三通道结果汇总] → 综合验证决策
```

Novelty：三通道并行大幅缩短了验证时间。并且每条通道有独立的"否决权"——安全通道发现 critical 漏洞可以直接否决，无需等其他通道完成

---

## V2：验证决策矩阵（Validation Decision Matrix）

### [Framework DNA #52]：结构化的验证判定规则

Concept：三通道结果汇总后，用决策矩阵做最终判定——

| 契约验证 | 安全合规 | 架构对齐 | 判定结果 | 下一步 |
|----------|----------|----------|----------|--------|
| 全部 must_pass 通过 | 无 critical/high | 偏离度 < 阈值 | 通过 | Operate |
| must_pass 通过，部分 should_pass 未满足 | 无 critical，有 medium | 偏离度 < 阈值 | 有条件通过 | Operate + 记录技术债 |
| 任何 must_pass 失败 | — | — | 打回 | Build（微调） |
| — | 有 critical | — | 紧急打回 | Build（安全修复） |
| — | — | 偏离度 > 阈值 | 重定向 | Intent（可能意图本身有问题） |

Novelty：不同的失败类型路由到不同的回退目标——代码问题回 Build，安全问题紧急回 Build，架构偏离回 Intent。这比"测试不通过就返工"精细得多

---

## V3：意图偏差追踪（Intent Deviation Tracking）

### [Framework DNA #53]：每次验证失败都是一个学习信号

Concept：Validate 阶段不仅做判定，还记录"偏差事件"——

```yaml
deviation_event:
  id: "DEV-2026-0042-03"
  intent_ref: "SAND-2026-0042"
  pulse_ref: 3
  deviation_type: "intent_misalignment"  # | contract_failure | security_violation | architecture_drift

  description: "AI 实现了同步支付确认，但意图要求的是异步确认+通知"
  root_cause_hypothesis: "意图声明中 desired_outcome 的描述不够具体，'支付确认'未明确同步/异步"

  severity: medium
  resolution: "回退到Intent，补充约束：'支付确认必须采用异步模式+邮件通知'"

  learning_signal: "支付领域的意图声明需要明确同步/异步模式——候选纳入意图模式库"
```

Novelty：偏差事件是 Learn 阶段最有价值的原材料。它不是"Bug 报告"，而是"系统改进信号"——每次偏差都指向意图定义、编排设计或 AI 能力的某个可改进点

---

## V4：验证资产的累积效应

### [Framework DNA #54]：验证越做越快、越做越准

Concept：每一轮 Validate 都在积累验证资产——

- 自动化测试套件持续扩展（每个 Build 脉冲产生的测试被保留）
- 安全扫描规则持续更新（每次发现的新问题类型加入规则库）
- 架构合规检查持续精炼（每次架构偏离的模式被纳入检查逻辑）

这意味着第N+1轮循环的 Validate 阶段比第N轮更全面、更快速——验证资产是飞轮加速的关键推力之一
