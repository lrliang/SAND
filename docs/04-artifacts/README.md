# 工件体系

SAND 定义了贯穿 SDC 全循环的 18 种标准工件。SAND 工件的独特之处在于其**可执行度光谱**——从纯人读文档到 AI 可执行的配置/模板，体现"方法论即代码"理念。

## 目录

- [intent-statement-spec.md](./intent-statement-spec.md) — 意图声明工件规格（含7字段YAML示例）
- [execution-contract-spec.md](./execution-contract-spec.md) — 执行契约工件规格（must_pass/should_pass/must_not_violate）
- [orchestration-plan-spec.md](./orchestration-plan-spec.md) — 编排方案工件规格
- [delivery-package-spec.md](./delivery-package-spec.md) — 综合交付包工件规格
- [deviation-event-spec.md](./deviation-event-spec.md) — 意图偏差记录工件规格
- [ai-asset-specs.md](./ai-asset-specs.md) — 5类AI资产工件规格

> 可执行模板请见 [09-templates/](../09-templates/)

## 工件全景表

| 工件 | 产生阶段 | 消费阶段 | 可执行 |
|------|---------|---------|-------|
| AI成熟度评估报告 | Assess | Intent, L4治理 | 是 |
| 转型机会矩阵 | Assess | Intent | 否 |
| 投资假设 | Intent | Orchestrate, Operate, Learn | 否 |
| 意图声明 | Intent | Orchestrate, Build | 是 |
| 执行契约 | Intent | Build, Validate | 是 |
| 编排方案 | Orchestrate | Build | 是 |
| Agent拓扑图 | Orchestrate | Build | 是 |
| 上下文策略 | Orchestrate | Build | 是 |
| 人类介入点定义 | Orchestrate | Build, Validate | 是 |
| 综合交付包 | Build | Validate | 是 |
| 架构决策记录(ADR) | Build | 全循环 | 否 |
| 验证报告 | Validate | Learn | 是 |
| 意图偏差记录 | Validate | Learn | 是 |
| 质量门禁决策 | Validate | Operate/Build | 是 |
| 运营监控仪表盘 | Operate | Learn | 是 |
| 生产意图验证报告 | Operate | Learn | 是 |
| AI复盘报告 | Learn | Assess | 否 |
| AI资产（5类） | Learn | Orchestrate, 全循环 | 是 |
