# 构建阶段（Build）

> "AI 生成，人类审查，协作构建"

Build 阶段面临 AI 原生开发特有的"速度悖论"——AI 生产极快但人类审查未等比加速。SAND 通过脉冲式构建模式和分层审查策略正面应对这一挑战。

## 目录

- [pulse-build-pattern.md](./pulse-build-pattern.md) — 脉冲式构建模式
- [delivery-package.md](./delivery-package.md) — 综合交付包标准
- [review-strategy.md](./review-strategy.md) — 三层审查策略（L1自动化/L2 AI辅助/L3深度人工）
- [rollback-mechanism.md](./rollback-mechanism.md) — 增量回退机制

## 核心产出工件

- 可工作软件增量
- 综合交付包（代码+测试+文档+安全扫描+契约验证+AI自评）
- 架构决策记录（ADR）

## 脉冲式节奏

```
[AI 生成脉冲] → [人类审查窗口] → [AI 精炼脉冲] → ...
 (10-30min)      (30-60min)       (10-30min)
```
