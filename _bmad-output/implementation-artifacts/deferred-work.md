# Deferred Work

## Deferred from: code review of 6-1-sand-run-retrospective-basic (2026-05-15)

- **W1: Topic 4 问题顺序微调** — learning_signal 完整度问题和已缓解模式问题的顺序与 ai-retrospective.md 略有交换。内容无遗漏，化妆品级差异。
- **W2: inputs 使用裸目录路径** — `.sand/intents/` 和 `.sand/executions/` 为裸目录路径，与 sand-governance-audit 的 glob 模式（`.sand/intents/INT-*.yaml`）约定不同。功能无影响。
- **W3: step 内议题标签编号混淆** — step-01-collect.md 内使用 [Step 1/5] 到 [Step 5/5]，与 SKILL.md 的 [Step 1/1] 形成两级编号。Phase 3 需明确约定。
- **W4: SKILL.md body 未直接引用 ai-asset-taxonomy.md** — 通过 customize.toml persistent_facts 间接可用，但 SKILL.md body 的理论基础仅列 3 个来源。

## Deferred from: code review of 6-0-learn-theory-foundation (2026-05-15)

- **W1: source_topic 枚举不完整** — 仅展示 intent_quality 值，其余 4 个议题（orchestration_effectiveness, ai_leverage, failure_mode, assetization_nomination）的映射值未定义。Skill 实现时定义完整枚举。
- **W2: Phase 2/3 边界条件** — L2b-L2d 的触发机制未明确定义，assetization-process.md 仅说明 Phase 2 执行 L2a。Phase 3 Story 6-2 实现时需定义完整触发链。
- **W3: learning_signal 字段可选性导致数据饥饿风险** — deviation-tracking.md 定义 learning_signal 为 nullable。Learn 阶段对此字段有强依赖但无强制填充机制。Deferred Work D5 已追踪。
- **W4: 飞轮指标采集依赖团队主动引用资产** — 资产复用率计算依赖意图声明 context_references 中的 AST-* 引用，但无强制填充机制。MVP 可能报告偏低的复用率。
- **W5: 重复失败模式检测冷启动** — ai-retrospective.md 议题 4 要求对比"历史复盘中已记录的失败模式"，但首轮 SDC 循环无历史数据。首轮复盘应跳过对比步骤。
- **W6: 资产过期审查触发流程未定义** — asset-lifecycle.md 定义了过期周期（90-365 天）和审查决策（刷新/归档/延期），但未定义谁触发审查、触发频率、审查 SLA。运行时实现细节。
- **W7: asset_type 编程值未在总览表展示** — ai-asset-taxonomy.md 总览表仅有 type_code（CTX/INT/ORC/VAL/FAI），未展示对应的 `asset_type` 字段值（context/intent_pattern/orchestration_recipe/validation_rule/failure_case）。Skill 实现时需完整映射。

## Deferred from: code review of 5-1-sand-governance-audit-skill (2026-05-14)

- **W1: human_confirmations 去重键不含 event_id** — step-02 §5 按 step+timestamp+decision 去重，同毫秒同决策的理论碰撞会丢失确认记录。Schema 无 confirmation_id 字段，需架构级扩展。
- **W2: .sand/audits/reports/ 子目录无架构文档先例** — 架构仅定义 .sand/audits/audit.jsonl，reports 子目录为 sand-governance-audit 新增约定。需在架构文档中补充。
- **W3: human_oversight hip-2 硬编码 vs 运行时动态读取** — SKILL.md 固定 hip-2 但 step-02 §7 运行时从 config.yaml 读取。所有 Skill 均此模式，非 bug，但文档应说明覆盖优先级。

## Deferred from: code review of 5-0-governance-theory-foundation (2026-05-14)

- **W1: quality_gates TOML 块无 Schema 定义** — quality-governance.md 中 `[quality_gates]` 配置块（clear_check_min_pass, contract_check_must_pass 等）为说明性示例，无对应 Schema 或 customize.toml 验证。未来 Skill 实现时需定义。
- **W2: .sand/config.yaml 无 risk-level 字段** — compliance-governance.md 引用 `.sand/config.yaml` 配置风险等级和 HIP 默认值，但 `templates/sand-config.yaml` 模板无此字段。Schema 增强议题。
- **W3: Validation Results 层无直接 Schema 字段** — audit-governance.md 六层证据链模型的第六层"验证结果"数据来自 decision-matrix/deviations.json 而非 audit-event.schema.json。Story 5-1 需跨数据源聚合。
- **W4: decision-governance.md 行数 (~125 行) 低于 150-200 行目标** — 内容实质完整，篇幅略低于文档编写规范要求。
- **W5: compliance-governance.md 行数 (~131 行) 低于 150-200 行目标** — 内容实质完整，篇幅略低于文档编写规范要求。

## Deferred from: code review of 4-3-plugin-validation-contributor-tools (2026-05-14)

- **W1: `get_array_items` 无法解析 inline YAML 数组** — `requires: [file_read, file_write]` 风格的 flow-sequence 不被识别。需完整 YAML 解析或添加 inline 模式支持。
- **W2: validator 未强制 additionalProperties:false** — Schema 禁止额外字段但 validator 不检查未知 key。Phase 3 lint 增强。
- **W3: dev guide 遗漏 customize_schema/dependencies 可选字段** — Schema 定义 8 个可选属性但 guide 仅列 6 个。
- **W4: dev guide 未文档化 registry.yaml 格式** — 贡献者无法了解外部 Skill 注册的集成路径。
- **W5: name regex 允许尾部 dash** — `^sand-[a-z][a-z0-9-]*$` 匹配 `sand-foo-`，Schema 同此 pattern。
- **W6: validator 未检查 name 与目录名一致性** — `sand-foo/` 下 `name: "sand-bar"` 会通过验证。
- **W7: validator 未检查 frontmatter 字段顺序** — Architecture 要求固定顺序但 validator 仅检查存在性。
- **W8: get_field 不处理单引号 YAML 值** — `sdc_phase: 'build'` 会保留引号导致 enum 不匹配。

## Deferred from: code review of 4-2-sand-run-execution-engine (2026-05-14)

- **W1: skill_chain 非 Schema required** — orchestration-plan.schema.json 仅 required plan_id/intent_id/topology/human_oversight，skill_chain 可能完全缺失。step-01 需防御性检查。
- **W2: context_scope/meta 为可选属性** — step-01 无条件读取但 Schema 允许缺失。需防御检查。
- **W3: execution.yaml failure 状态无产生路径** — step-02 仅产生 completed/partial/interrupted，failure 为 step-03 定义的未来保留状态。
- **W4: SHA-256 拼接顺序未定义** — 不同文件拼接顺序产生不同 hash，需统一为声明顺序。
- **W5: 断点恢复流程与新会话创建混合** — step-01 恢复时仍执行第 5-7 节，需条件跳过逻辑。
- **W6: session_id EXE- 前缀语义** — execution.yaml 内 session_id 含 EXE- 前缀与目录名一致但语义双重。
- **W7: deviations.json 在 sand-run 阶段不存在** — step-03 已优雅处理，正常设计。
- **W8: 并发 session_id 碰撞** — 无文件锁，单用户低概率，Phase 3 多 Agent 需解决。

## Deferred from: code review of 4-1-sand-design-orchestration-skill (2026-05-14)

- **W1: plan_id 格式无 Schema pattern 约束** — step-04 定义 `OP-YYYYMMDD-{seq}` 但 Schema 仅 `type: string`，与 intent_id 的严格 pattern 不一致。Schema 增强议题。
- **W2: Skill 本地模板与全局模板重复** — `sand/skills/sand-design-orchestration/templates/orchestration-plan.yaml` 与 `templates/orchestration-plan.yaml` 内容相同，存在维护分叉风险。Architecture 定义要求本地副本。
- **W3: .sand/orchestration-plan.yaml 为固定路径** — 多次运行会覆盖，无版本化。其他 Skill 使用动态路径（如 `{timestamp}_{team_id}.yaml`）。运行时增强，Story 4-2 范围。
- **W4: SKILL.md inputs 声明 config.yaml 但按可选处理** — `inputs` 语义应为"必需"但 step 文件容忍缺失。Schema `inputs` 字段语义定义待明确。
- **W5: 拓扑升级规则仅支持单步** — 无 Solo→Hierarchy 直达路径，需两步升级。Phase 3 扩展。
- **W6: 决策流程对不可拆分大规模任务的 scale 维度处理** — 决策树仅分支于子任务和不确定性，大规模单任务默认推 Solo 需靠矩阵复核修正。
- **W7: skill_chain items 未设 additionalProperties:false** — 顶层严格但子对象宽松，Schema 级一致性议题。
- **W8: Solo 拓扑 skill_chain 默认 skill_name 未定义** — Solo 场景用户不指定时无默认推导逻辑。

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
