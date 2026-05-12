# 关系图谱

SAND 涉及 5 个核心实体——人（角色）、AI模型、工具、项目（意图）、组织。本章定义它们之间的多维关系。

## 目录

- [human-model-trust.md](./human-model-trust.md) — 人-模型信任度模型
- [human-tool-capability.md](./human-tool-capability.md) — 人-工具能力匹配矩阵
- [model-tool-stack.md](./model-tool-stack.md) — 模型-工具能力栈
- [cross-pod-collaboration.md](./cross-pod-collaboration.md) — 跨Pod协作机制 `[GAP-3: 待开发]`

## 核心实体关系矩阵

| | 人（角色） | AI模型 | 工具 | 项目（意图） | 组织 |
|---|---|---|---|---|---|
| **人** | 角色协作（不相容分离） | 信任度校准（HIP动态调整） | 能力匹配 | 对意图负责 | 层级位置 |
| **AI模型** | — | Agent拓扑协作 | 通过工具执行 | 执行意图 | 受章程约束 |
| **工具** | — | — | 技术栈集成 | 支撑SDC阶段 | 平台统一管理 |
| **项目** | — | — | — | 意图间依赖 | 承载投资假设 |
| **组织** | — | — | — | — | 组织间协同 |
