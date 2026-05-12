# 工具能力体系

SAND 的工具体系按 SDC 阶段组织，每个阶段有对应的核心工具需求。工具体系不是产品推荐清单，而是基于方法论需求的结构化能力框架。

## 目录

- [tool-selection-principles.md](./tool-selection-principles.md) — 6大工具选型原则
- [tool-sdc-mapping.md](./tool-sdc-mapping.md) — 工具-SDC阶段映射表
- [agent-capability-card.md](./agent-capability-card.md) — Agent能力卡标准
- [ai-vendor-management.md](./ai-vendor-management.md) — 外部AI生态管理 `[GAP-5: 待开发]`

## 工具-SDC 阶段映射

| SDC 阶段 | 核心工具需求 |
|---------|------------|
| Assess | 成熟度评估问卷、数据采集脚本、雷达图生成器 |
| Intent | 意图声明编辑器（含CLEAR自动检查）、意图模式库 |
| Orchestrate | Agent能力卡目录、拓扑设计器、上下文策略配置器 |
| Build | IDE集成AI、Agent执行运行时、交付包打包器 |
| Validate | 自动化测试框架、安全扫描器、架构合规分析器 |
| Operate | 部署流水线、监控平台、AI事故分析器 |
| Learn | AI复盘引导工具、资产库管理系统、飞轮度量仪表盘 |
| Governance | AI使用章程管理、审计日志系统 |

## 选型原则

1. **AI友好性原则** — 强约束强信号、规范化可发现性、短反馈回路
2. **模型无关性** — 支持多模型接入，避免供应商锁定
3. **人类审查可接入性** — 每个AI产出节点必须有人类审查接口
4. **上下文连续性** — 支持跨会话、跨团队的上下文共享
5. **标准化与治理能力** — 统一Agent构建流程
6. **不浪费原则** — 简单任务不过度使用复杂AI工具
