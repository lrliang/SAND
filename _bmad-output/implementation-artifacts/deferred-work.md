# Deferred Work

## Deferred from: code review of 4-0-orchestrate-theory-foundation (2026-05-14)

- **W1: Schema vs 扩展模板结构不兼容** — `schemas/orchestration-plan.schema.json` 设置 `additionalProperties: false` 且仅定义 7 个顶层属性，但 `docs/09-templates/orchestration-plan.yaml` 引入 `context_strategy`、`agent_selection`、`failure_mode_plan` 等 Schema 未定义字段。预先存在的设计差异，需在 Phase 2 Schema 演进时统一。
- **W2: context_quality_check 理论 4 维 vs 模板 3 字段** — 理论定义 4 个质量维度（completeness/accuracy/conciseness/discoverability），扩展模板仅有 3 个字段（缺 discoverability）。Story 4-1 实现时需决定是否扩展模板。
- **W3: 扩展模板 parent_intent vs Schema intent_id 格式不兼容** — 扩展模板用 `parent_intent: "SAND-YYYY-NNNN"`，Schema 用 `intent_id` pattern `^INT-\d{8}-\d{3,}$`。预先存在的 ID 格式冲突。
- **W4: Swarm/Hierarchy 最少 Agent 数量未定义** — 1 Agent Swarm 退化为 2 节点 Pipeline（1 worker + aggregator），1 Worker Hierarchy 退化为带额外开销的 Solo。无最小 Agent 数量约束。Story 4-1 实现 topology-rules.yaml 时需定义。
- **W5: HIP 信任降级阈值 N 未量化** — 信任降级机制触发条件"连续 N 次"的 N 值未定义。运行时配置参数，Story 4-1 step-03-hip.md 需定义默认值或范围。
- **W6: Domain-Reset 的"领域"定义未明确** — "新领域"判定标准为".sand/ 中无该领域的历史执行记录"，但"领域"本身（代码目录？技术栈？业务功能？capability_domain 值？）未定义。运行时操作化。
- **W7: FR 可追溯性跨文档不一致** — context-engineering.md 显式引用 FR32-FR33，human-intervention.md 引用 FR17，但 topology-patterns.md、agent-selection.md、failure-modes.md 未引用 FR 编号。非阻塞一致性议题。

## Deferred from: code review of 3-1-sand-validate-delivery-skill (2026-05-13)

- **D1: 空 must_pass 数组产生空 PASS** — schema 允许 minItems:0，空契约会 vacuously pass。运行时需添加 must_pass 非空验证或警告。
- **D2: Session ID seq 碰撞** — 无文件系统扫描机制确定当日序号，并发运行可能碰撞。运行时需扫描 .sand/executions/ 确定下一个序号。
- **D3: verification method 无工具降级路径** — 若 verification="performance_benchmark" 但无基准测试工具，step-01 无降级逻辑。参考 step-02 的降级模式。
- **D4: 零依赖项目 CVE 检查未定义** — 无依赖清单时 step-02 check 4 行为未明确。建议输出 "not_applicable"。
- **D5: 无法检测前序 step 部分完成** — 用户中途中止后跳到 step-04，部分完成的通道可能被视为完整。需运行时状态检查。
- **D6: 重复运行 deviations.json 覆盖** — 同一 session 重新验证时无幂等性保证。建议追加或版本化。
- **D7: 扁平项目依赖方向检查误报** — 无分层架构的项目可能在 blocking 级检查上误报。step-03 FAILURE MODES 有降级提示但未覆盖此具体场景。
- **D8: FR32 检查假设 audit.jsonl 存在** — 若 Build 阶段未启用审计，audit.jsonl 缺失被视为 blocking fail 而非 benign。

## Deferred from: code review of 3-0-validate-theory-foundation (2026-05-13)

- **D1: 意图偏差信号在非 contract-FAIL 场景下未定义** — 意图对齐度分析产生偏差信号时，若 contract 通道非 FAIL（如 PASS_W），该信号被判定表忽略。Story 3-1 实现设计时需明确处理。
- **D2: 三通道无 ERROR/TIMEOUT/INDETERMINATE 状态处理** — 通道结果仅定义 PASS/PASS_WITH_WARNINGS/FAIL 三态，无法表示通道执行失败或超时。Story 3-1 实现设计时需定义 fallback 策略。
- **D3: source_channel 为单值枚举，跨通道偏差不可表示** — 同一问题可能跨越安全和架构两个通道，当前数据结构无法表示。Story 3-1 实现时考虑多偏差事件 + 交叉引用。
- **D4: info 级偏差自动 resolved 后无法被人类重新分类** — 自动处理发生在人类审查之前，无重新分类机制。Story 3-1 实现增强。
- **D5: learning_signal 可选导致飞轮静默退化** — 无完整度指标追踪 learning_signal 填充率。Phase 3 Learn 阶段完善。
- **D6: 通道内计算控制与推断控制冲突未定义** — 同一检查项内两种控制类型结果不一致时无优先级规则。Story 3-1 实现设计。

## Deferred from: code review of 2-1-sand-create-intent-skill (2026-05-13)

- **must_not_violate 无 verification 字段** — 硬约束为二元判定，设计决策。
- **clear_check boolean 建模三态结果** — 无法区分"通过"和"接受 warn 后放行"。Schema 增强议题。
- **Architecture 指定 local templates/ 但 Story spec 禁止创建** — 需更新架构文档或明确约定。
- **审计事件格式与 SandAuditEvent schema 不兼容** — 两套事件格式，已在 Story 2-0 中记录。
- **用户中途取消无清理机制** — 可能产生幽灵 ID 或残留文件。运行时增强。
- **meta.status in_execution vs 架构 kebab-case 规则** — 命名约定统一议题。
- **FR12 边界条件主动识别职责边界** — 可能属于 sand-run 而非 sand-create-intent。
- **version/generated_at 非 required + additionalProperties:false** — Schema 演进议题。
- **constraints 子域无 minItems + 模板默认空数组** — DX 改善。
- **CLEAR 失败修正无最大重试次数** — 流程增强。

## Deferred from: code review of 1-0-assess-theory-foundation (2026-05-13)

- **design-principles.md 和 README.md 中 Cao 映射需更新** — `docs/01-foundations/design-principles.md` 和 `docs/01-foundations/README.md` 中"原生嵌入原则 → Cao 的 AI 原生定义"映射需要同步更新，因为 ai-native-definition.md 已将理论来源从 Cao 迁移到 Hassan SE 3.0 + 行业来源。超出 Story 1-0 范围，建议在 Story 2-0（Intent 理论基础）中一并处理。
- **"约束工程"翻译语义** — Harness Engineering 翻译为"约束工程"存在语义偏差（harness 原义更接近"驾驭"），但不影响技术准确性。可在后续文档统一审查中考虑。
- **约束工程双分类未覆盖安全合规通道** — non-deterministic-paradigm.md 将计算控制映射到契约验证通道、推断控制映射到架构对齐通道，但 SAND 三通道中的"安全合规"通道的理论对应未说明。可在 Story 3-0（Validate 理论基础）中补充。

## Deferred from: code review of 2-0-intent-theory-foundation (2026-05-13)

- **Assess 阶段在 SE 3.0 四组件映射中缺席** — cognitive-collaboration.md 将 SE 3.0 四组件映射到 Intent/Build/Operate/Agent 角色，但 Assess 阶段无对应物。理论讨论，不阻塞实现。
- **intent_id 格式冲突** — `docs/09-templates/intent-statement.yaml` 使用 `SAND-YYYY-NNNN` 格式，理论文档和架构统一使用 `INT-YYYYMMDD-{seq}`。模板修正属于 Story 2-1 范围。
- **"废弃"操作无正式终态** — 意图生命周期 6 状态不含 Abandoned/Cancelled，废弃后 meta.status 值和审计事件未定义。生命周期扩展议题。
- **CLEAR 全维度 fail 无熔断机制** — 极低质量意图声明（全维度 fail）缺少"建议废弃"短路逻辑。Skill 实现增强议题。
- **生命周期审计事件 Schema 与 Architecture SandAuditEvent Schema 不兼容** — 状态变更事件字段（from_status/to_status/trigger）与 Skill 执行事件字段不同，event_id 格式也冲突（EVT-YYYYMMDD-NNN vs uuid-v4）。需架构级统一。
- **should_pass 偏差升级阈值未定义** — "累计偏差超过阈值→人工裁决"但阈值未量化。Validate Skill 实现细节。
- **非法状态转换行为 + Validate→Build 打回循环无上限** — 非法转换的拦截/回滚行为未定义，打回循环无重试上限。运行时实现议题。
- **README 核心产出列表与文档定义不一致** — intent/README.md 列出"约束上下文"和"投资假设"为独立工件，但文档中这些是意图声明的子字段而非独立工件。README 不在本 Story 修改范围。

## Deferred from: code review of 1-1-repo-skeleton-sandskill-schema (2026-05-13)

- **嵌套对象缺少 additionalProperties: false** — constraints、clear_check、meta、skill_chain items 等多处嵌套对象未设 additionalProperties: false，与顶层 schema 严格约束不一致。建议在 Phase 2 schema 完善时统一处理。
- **CLAUDE.md 和 CURSOR_RULES.md 内容重复** — 两文件高度重复，维护时需同步更新。建议后续抽取为单一 SKILLS.md 并引用。
- **host 枚举硬编码限制扩展性** — 新增宿主支持需修改 audit-event.schema.json 和 sandskill.v1.schema.json。Phase 3 扩展时考虑改为 pattern 约束。
- **entry_point 和 customize_schema 缺少路径格式约束** — 仅 type: string，无 pattern。低优先级，可在 Phase 2 验证工具开发时补充。
