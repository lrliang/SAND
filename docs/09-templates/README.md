# 可执行模板库

SAND "方法论即代码"理念的核心体现。这些模板可以直接复制使用，是 [04-artifacts](../04-artifacts/) 中工件规格的可执行实现。

## 模板清单

| 模板文件 | 对应工件 | 用于SDC阶段 |
|---------|---------|------------|
| [intent-statement.yaml](./intent-statement.yaml) | 意图声明 | Intent |
| [execution-contract.yaml](./execution-contract.yaml) | 执行契约 | Intent |
| [orchestration-plan.yaml](./orchestration-plan.yaml) | 编排方案 | Orchestrate |
| [delivery-package.yaml](./delivery-package.yaml) | 综合交付包 | Build |
| [agent-capability-card.yaml](./agent-capability-card.yaml) | Agent能力卡 | Orchestrate |
| [deviation-event.yaml](./deviation-event.yaml) | 意图偏差记录 | Validate |
| [maturity-assessment.yaml](./maturity-assessment.yaml) | 成熟度评估问卷 | Assess |
| [ai-retrospective.yaml](./ai-retrospective.yaml) | AI复盘议程 | Learn |
| [clear-checklist.yaml](./clear-checklist.yaml) | CLEAR检查清单 | Intent |

## 使用方式

1. 复制对应的 YAML 模板到你的项目中
2. 根据实际需求填写字段
3. 可被 AI Agent 直接解析和执行
