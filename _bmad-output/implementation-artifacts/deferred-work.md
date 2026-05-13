# Deferred Work

## Deferred from: code review of 1-0-assess-theory-foundation (2026-05-13)

- **design-principles.md 和 README.md 中 Cao 映射需更新** — `docs/01-foundations/design-principles.md` 和 `docs/01-foundations/README.md` 中"原生嵌入原则 → Cao 的 AI 原生定义"映射需要同步更新，因为 ai-native-definition.md 已将理论来源从 Cao 迁移到 Hassan SE 3.0 + 行业来源。超出 Story 1-0 范围，建议在 Story 2-0（Intent 理论基础）中一并处理。
- **"约束工程"翻译语义** — Harness Engineering 翻译为"约束工程"存在语义偏差（harness 原义更接近"驾驭"），但不影响技术准确性。可在后续文档统一审查中考虑。
- **约束工程双分类未覆盖安全合规通道** — non-deterministic-paradigm.md 将计算控制映射到契约验证通道、推断控制映射到架构对齐通道，但 SAND 三通道中的"安全合规"通道的理论对应未说明。可在 Story 3-0（Validate 理论基础）中补充。

## Deferred from: code review of 1-1-repo-skeleton-sandskill-schema (2026-05-13)

- **嵌套对象缺少 additionalProperties: false** — constraints、clear_check、meta、skill_chain items 等多处嵌套对象未设 additionalProperties: false，与顶层 schema 严格约束不一致。建议在 Phase 2 schema 完善时统一处理。
- **CLAUDE.md 和 CURSOR_RULES.md 内容重复** — 两文件高度重复，维护时需同步更新。建议后续抽取为单一 SKILLS.md 并引用。
- **host 枚举硬编码限制扩展性** — 新增宿主支持需修改 audit-event.schema.json 和 sandskill.v1.schema.json。Phase 3 扩展时考虑改为 pattern 约束。
- **entry_point 和 customize_schema 缺少路径格式约束** — 仅 type: string，无 pattern。低优先级，可在 Phase 2 验证工具开发时补充。
