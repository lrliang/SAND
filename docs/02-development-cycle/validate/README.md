# 验证阶段（Validate）

> "达标了吗？安全吗？合规吗？"

Validate 不是传统意义的"测试"，而是"意图对齐验证"——验证 Build 的产出是否真正实现了 Intent 声明的意图，且在 Constraint 定义的边界内。

## 目录

- [three-channel.md](./three-channel.md) — 三通道并行验证架构
- [decision-matrix.md](./decision-matrix.md) — 验证决策矩阵
- [deviation-tracking.md](./deviation-tracking.md) — 意图偏差追踪
- [validation-assets.md](./validation-assets.md) — 验证资产累积效应

## 三通道并行验证

| 通道 | 验证内容 | 产出 |
|------|---------|------|
| 契约验证 | 执行契约的 must_pass/should_pass/must_not_violate | 通过/失败判定 |
| 安全合规 | 安全扫描 + 合规规则 + 许可证审计 | 风险报告 |
| 架构对齐 | AI分析产出与架构规范的一致性 | 偏离度报告 |

## 回退路径

- 代码问题 → 回退到 Build（微调）
- 安全问题 → 紧急回退到 Build（安全修复）
- 架构偏离 → 重定向到 Intent（意图可能有问题）
