# 审计治理

所有AI参与的决策和产出必须留下可追溯的结构化证据链。审计日志系统、定期审计机制。

---

## 概述

审计治理是 SAND 治理中心轴四根支柱中承担"证据基础设施"角色的核心支柱。它回答一个根本问题：**"AI 为什么做了这个决策？"**——不是通过解释 AI 的内部推理，而是通过结构化证据链证明决策过程的可追溯性。

**理论基础：**

1. **Mikkonen "人类审查不可削减"原则**（参见 [生成式复用风险](../../01-foundations/generative-reuse-risk.md)）：AI 生成式复用的 Cargo Cult 风险要求每段 AI 输出都可追溯至原始意图和人类审查点
2. **Wang MI9 Agent 语义遥测**（参见 [Agentic AI 治理理论](../../01-foundations/agentic-consensus.md)）：运行时治理需要步骤级行为监控，SandRuntime 的 AuditWriter 实现了等效功能
3. **ISO 42001 A.7 记录控制 + A.9 内部审计**：结构化记录是可认证 AI 管理系统的基础要求

**核心设计原则：**

- **审计对 Skill 开发者完全透明**：SandRuntime 执行引擎自动记录审计事件，Skill 开发者无需编写审计代码
- **成功和失败均记录**：`status` 字段支持 success/failure/interrupted 三种状态（NFR16）
- **步骤级粒度**：每个 step 完成时追加一条 SandAuditEvent，而非仅在 Skill 级别记录

---

## 审计证据链结构

审计证据链是连接意图（为什么）到执行（如何）到验证（结果）的完整追踪链条。

### 六层证据链模型

```
Intent ID (INT-YYYYMMDD-{seq})
  └── Execution ID (EXE-{session_id})
        └── Skill Chain [skill_1@v0.1.0 → skill_2@v0.2.0 → ...]
              └── Step-Level Events [step-01 → step-02 → ...]
                    └── Human Confirmations [{step, timestamp, decision}]
                          └── Validation Results [通过/有条件/打回/重定向]
```

**各层详细定义：**

| 层级 | Schema 字段 | 含义 | 追溯方向 |
|------|-----------|------|---------|
| **Intent** | `intent_id` | 意图声明 ID，链接到 `.sand/intents/` | 上溯：为什么启动此执行 |
| **Execution** | `execution_id` | 执行会话 ID，链接到 `.sand/executions/` | 横向：同一会话内的所有事件 |
| **Skill** | `skill_name` + `skill_version` | 执行的 Skill 及其版本 | 下溯：哪个版本的 Skill 产生了此输出 |
| **Step** | `step` | 步骤标识（`step-01-scan` 等） | 精确定位：Skill 内哪个步骤产生了此事件 |
| **Confirmation** | `human_confirmations[]` | 人工确认记录数组 | 审查：哪个人在什么时候做了什么决策 |
| **Integrity** | `input_hash` + `output_hash` | SHA-256 文件 hash | 验证：输入输出是否被篡改 |
| **Context** | `sand_version` + `host` + `model_used` | 执行环境上下文 | 环境：使用了什么框架版本/宿主/模型 |

### 证据链完整性要求

1. **无断裂**：每个 `intent_id` 必须可追溯到至少一个 `execution_id`，每个 `execution_id` 必须包含至少一条步骤级事件
2. **版本锁定**：`skill_version` 和 `sand_version` 记录在事件发生时的精确版本，而非当前版本
3. **时间连续性**：同一 `execution_id` 下的事件按 `timestamp` 排序应与 `step` 编号顺序一致

---

## 审计事件生命周期

### 阶段一：产生

SandRuntime 的 AuditWriter 模块在每个 Skill step 完成时自动追加一条 SandAuditEvent。

**写入策略：**
- 格式：JSONL（每行一个 JSON 对象）追加写入
- 存储位置：`.sand/audits/audit.jsonl`
- 原子性：依赖 OS 级 O_APPEND 原子性
- 并发：文档建议避免并行写入（MVP 不支持并发执行）
- 双向记录：成功、失败、中断三种状态均写入

**Hash 计算规则：**
- `input_hash`：对 Skill 声明的所有 `inputs` 文件内容按**声明顺序**拼接后计算 SHA-256
- `output_hash`：对 Skill 声明的所有 `outputs` 文件内容按**声明顺序**拼接后计算 SHA-256
- 拼接顺序严格遵循 SKILL.md frontmatter 中 `inputs`/`outputs` 数组的声明顺序

### 阶段二：存储

审计日志存储遵循以下规则：
- **不可删除**：审计日志是合规证据，不允许手动删除
- **不自动清理**：MVP 不实现 `sand gc`，用户自行归档到 `.sand/archive/`
- **可选 Git 提交**：审计日志默认纳入 `.sand/.gitignore` 的保留列表

### 阶段三：查询

`sand-governance-audit` Skill 的 step-01-scan 需支持以下筛选维度：

| 筛选维度 | 对应字段 | 示例 |
|---------|---------|------|
| 时间范围 | `timestamp` | 过去 4 周的事件 |
| 意图 ID | `intent_id` | 特定意图的完整链路 |
| Skill 名称 | `skill_name` | 所有 `sand-create-intent` 事件 |
| SDC 阶段 | `sdc_phase` | 所有 validate 阶段事件 |
| 执行状态 | `status` | 所有 failure 事件 |
| 执行者 | `actor` | 所有 human 触发的事件 |

### 阶段四：聚合

step-02-chain 将扫描到的事件聚合为证据链：

1. 按 `intent_id` 分组
2. 每组内按 `execution_id` 分组
3. 每个执行会话内按 `timestamp` 排序
4. 提取 `human_confirmations` 汇总
5. 标记 `status` 为 failure 或 interrupted 的异常事件

### 阶段五：报告

step-03-report 将聚合后的证据链生成结构化审计追踪报告（详见下节）。

---

## 审计报告结构

审计追踪报告的设计目标是满足**模拟 SOC2 检查**需求——外部审计师可通过此报告回答"AI 为什么做了这个决策"。

### 报告模板结构（Story 5-1 将据此创建 Skill 内部模板 `sand/skills/sand-governance-audit/templates/audit-report.yaml`）

```yaml
# 审计追踪报告
report_metadata:
  report_id: "AUD-YYYYMMDD-{seq}"
  generated_at: "ISO-8601 UTC"
  time_range:
    from: "ISO-8601 UTC"
    to: "ISO-8601 UTC"
  sand_version: "0.1.0"
  total_events: 0
  total_intents: 0
  total_failures: 0

# 证据链摘要
evidence_summary:
  - intent_id: "INT-YYYYMMDD-{seq}"
    intent_purpose: "一句话意图描述"
    execution_count: 1
    skill_chain: ["sand-create-intent@0.1.0", "sand-validate-delivery@0.1.0"]
    human_confirmations_count: 3
    status: "success"
    compliance_flags: []

# 意图级明细
intent_details:
  - intent_id: "INT-YYYYMMDD-{seq}"
    executions:
      - execution_id: "EXE-{session_id}"
        events:
          - event_id: "uuid"
            timestamp: "ISO-8601"
            skill_name: "sand-create-intent"
            skill_version: "0.1.0"
            step: "step-03-clear-check"
            actor: "agent"
            status: "success"
            human_confirmations: []
            input_hash: "sha256:..."
            output_hash: "sha256:..."
    deviations: []

# 异常事件高亮
anomalies:
  failures: []
  interruptions: []
  missing_confirmations: []

# 合规标准映射（MVP 预留结构，Phase 5 填充行业映射）
compliance_mapping:
  iso_42001: []
  eu_ai_act: []
  nist_ai_rmf: []
```

### 导出格式

- **JSON**：完整结构化数据，支持程序化处理
- **CSV**：扁平化摘要表，支持 Excel/Google Sheets 查看（FR30）

---

## 审计完整性校验

### SHA-256 Hash 链验证

审计完整性通过 `input_hash` → `output_hash` 的跨步骤连续性验证：

1. **步骤内校验**：重新计算当前文件的 SHA-256 hash，与审计事件中记录的 hash 对比
2. **跨步骤连续性**：Pipeline 拓扑中，前一个 Skill 的 `output_hash` 应与后一个 Skill 的 `input_hash` 一致（当输出直接作为输入时）
3. **篡改检测**：如果文件被修改但审计事件中的 hash 未更新，校验失败

**已知限制（来自 Deferred Work W4）：** Hash 拼接顺序必须严格遵循 SKILL.md 声明顺序，目前无运行时强制机制。

---

## 赵明旅程：审计场景示例

> 参见 PRD Journey 3：赵明的审计难题——从"相信我"到"这是证据"

**场景：** 外部审计师检查"多租户权限隔离"功能的 AI 决策过程。

**审计师提问：** "这段权限隔离代码是 AI 生成的吗？决策依据是什么？谁审批的？"

**从审计报告中获取的回答：**

> 注：以下表格为审计师叙事视角，提供比六层证据链模型更丰富的上下文，不与六层模型严格一一对应。

| 追溯视角 | 证据 |
|---------|------|
| **意图** | Intent ID: `INT-20260512-003`，purpose: "实现多租户权限隔离"，含完整 7 字段声明 |
| **契约** | 执行契约 v1.2，CLEAR 检查通过（5/5 ✓），must_pass 含 3 条安全约束 |
| **编排** | Solo 拓扑，Claude Opus 4.6，HIP-2（关键决策人工审查） |
| **执行** | `sand-create-intent@v0.3.1` → `sand-validate-delivery@v0.2.0` |
| **确认** | 3 个人工确认点：意图审查 ✓（2026-05-12T10:15:00Z）、边界条件澄清 ✓（T10:32:00Z）、交付验证 ✓（T11:05:00Z） |
| **验证** | 契约验证 ✓、安全扫描 ✓、架构对齐 ✓ |
| **完整性** | input_hash: sha256:a1b2...（Intent YAML）→ output_hash: sha256:c3d4...（代码文件） |

**审计师结论：** 决策链完整——从意图到执行到验证的每个环节都有记录，人工在 3 个关键节点进行了审查。

**对 SAND 的实践意义：** 审计治理不是事后补材料，而是使用 SAND 工作流时的自动产物。每次运行 Skill，证据就自动积累。这是"治理即工作流"理念的核心体现。
