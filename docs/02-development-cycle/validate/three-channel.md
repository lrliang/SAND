# 三通道并行验证架构

通道一：契约验证（自动化测试 + AI 辅助）、通道二：安全合规验证、通道三：架构对齐验证。三通道并行，每条有独立否决权。

---

## 概述

Validate 阶段的核心机制是**三通道并行验证**（Three-Channel Parallel Validation）。这一设计源自两个理论基础：

1. **Fowler 约束工程的双控制分类**（参见 [非确定性编程范式](../../01-foundations/non-deterministic-paradigm.md)）：非确定性环境需要计算控制（确定性检查）和推断控制（语义分析）的结合
2. **Mikkonen Cargo Cult 理论**（参见 [生成式复用风险](../../01-foundations/generative-reuse-risk.md)）：单一代码审查在 AI 生成场景中存在系统性不足——Cargo Cult 盲区、维度覆盖不足、非确定性累积

三通道设计的核心原则：

- **并行执行**：三通道同时运行，不存在顺序依赖，缩短验证总时间
- **独立否决权**：任一通道的"未通过"结果足以否决整体验证
- **结果合并**：三通道结果汇总后输入决策矩阵（参见 [验证决策矩阵](./decision-matrix.md)），生成结构化决策

---

## 通道一：契约验证（Contract Verification）

### 设计原理

契约验证通道检查交付物是否满足执行契约（Execution Contract）中定义的验收条件。执行契约由意图声明的 `acceptance_criteria` 字段自动生成（参见 [执行契约标准](../intent/execution-contract.md)），包含三级结构：

| 契约级别 | 含义 | 验证行为 |
|---------|------|---------|
| **must_pass** | 必须满足的验收条件 | 任何一条未通过 → 通道判定"未通过" |
| **should_pass** | 尽量满足的验收条件 | 未通过的条目记录为警告，不阻塞通道 |
| **must_not_violate** | 不可违反的约束 | 任何一条违反 → 通道判定"未通过" |

### 检查项列表

| 检查项 | 控制类型 | 判定标准 | 阻塞级别 |
|--------|---------|---------|---------|
| must_pass 条目逐条验证 | 计算控制 | 每条必须标记为 pass/fail | blocking |
| should_pass 条目逐条验证 | 计算控制 | 未通过的记录为 warning | warning |
| must_not_violate 约束检查 | 计算控制 + 推断控制 | 每条必须确认未违反 | blocking |
| 验收标准覆盖率检查 | 计算控制 | 每条 acceptance_criteria 至少有一个对应的验证结果 | blocking |
| 意图对齐度分析（FR26） | 推断控制 | AI 分析交付物与意图声明 purpose/desired_outcome 的语义对齐度 | warning |

### 通道判定逻辑

```
IF any must_pass 条目 == fail THEN 通道结果 = FAIL
ELSE IF any must_not_violate 条目 == violated THEN 通道结果 = FAIL
ELSE IF any acceptance_criteria 无对应验证结果 THEN 通道结果 = FAIL
ELSE IF any should_pass 条目 == fail THEN 通道结果 = PASS_WITH_WARNINGS
ELSE 通道结果 = PASS
```

### 对 SAND 的实践意义

契约验证通道是三通道中最"确定性"的——大部分检查项可通过自动化测试完成。它直接体现了 Fowler 约束工程中"计算控制"的角色，确保交付物在功能层面满足意图声明的契约。

---

## 通道二：安全合规验证（Security & Compliance）

### 设计原理

安全合规通道检查交付物是否引入安全风险或合规违规。AI 生成的代码可能在功能上完全正确，但包含不明显的安全漏洞——这是 Mikkonen Cargo Cult 风险的典型表现：开发者对 AI 生成代码的安全属性缺乏深度理解。

### 检查项列表

| 检查项 | 控制类型 | 判定标准 | 阻塞级别 |
|--------|---------|---------|---------|
| 注入漏洞检查（SQL/NoSQL/Command/XSS） | 计算控制 | 不存在未转义的用户输入拼接 | blocking |
| 敏感数据泄露检查 | 计算控制 + 推断控制 | 日志/错误信息/响应体中无敏感数据暴露 | blocking |
| 认证/授权边界检查 | 推断控制 | 所有端点遵循最小权限原则 | blocking |
| 依赖安全性检查 | 计算控制 | 新增依赖无已知高危 CVE | blocking |
| 许可证合规检查（FR25） | 计算控制 | 新增依赖的许可证与项目兼容 | **warning**（非阻塞） |
| 密钥/凭证硬编码检查 | 计算控制 | 代码中不存在硬编码的 API key/password/token | blocking |
| 上下文安全检查（FR32） | 推断控制 | 若意图声明授权发送完整代码文件，验证审计事件已记录 | blocking |

### 通道判定逻辑

```
IF any blocking 检查项 == fail THEN 通道结果 = FAIL
ELSE IF 许可证检查 == warning THEN 通道结果 = PASS_WITH_WARNINGS
ELSE 通道结果 = PASS
```

**关于许可证检查（FR25）：** PRD 明确要求许可证警告为**非阻塞**——在验证输出中提示并建议手动检查工具，但不因许可证问题自动阻断交付。Phase 4+ 计划集成自动依赖扫描和许可证污染检测。

### 对 SAND 的实践意义

安全合规通道是计算控制和推断控制的混合——注入检查和密钥检查可自动化（计算控制），但认证边界和敏感数据泄露往往需要上下文理解（推断控制）。这种混合性质体现了约束工程"两种控制结合"的核心原则。

---

## 通道三：架构对齐验证（Architecture Alignment）

### 设计原理

架构对齐通道检查交付物是否符合项目的架构约束和规范。AI 生成的代码可能功能正确且安全，但以不符合架构规范的方式实现——命名不一致、目录结构违规、依赖方向错误等。这类问题在短期内不会导致失败，但会累积为架构腐化。

这一通道主要依赖**推断控制**——架构对齐是语义层面的判断，无法完全通过确定性规则覆盖。

### 检查项列表

| 检查项 | 控制类型 | 判定标准 | 阻塞级别 |
|--------|---------|---------|---------|
| 命名规范一致性 | 计算控制 | 新增文件/函数/变量遵循项目命名约定 | warning |
| 目录结构规范 | 计算控制 | 新增文件位于正确的目录层级 | blocking |
| 依赖方向检查 | 推断控制 | 不存在反向依赖（如 domain 层依赖 infrastructure 层） | blocking |
| 架构模式一致性 | 推断控制 | 实现方式与项目既有架构模式一致（如 MVC/CQRS） | warning |
| API 契约一致性 | 计算控制 + 推断控制 | 新增/修改的 API 与已有 API 契约兼容 | blocking |
| 代码复用检查 | 推断控制 | 无重复实现已有功能（anti-Cargo Cult） | warning |

### 通道判定逻辑

```
IF any blocking 检查项 == fail THEN 通道结果 = FAIL
ELSE IF any warning 检查项 == fail THEN 通道结果 = PASS_WITH_WARNINGS
ELSE 通道结果 = PASS
```

### 对 SAND 的实践意义

架构对齐通道是三通道中最"推断性"的——大部分检查需要 AI 辅助的语义分析。它直接对应 Mikkonen 理论中"语义漂移风险"——代码在表面上正确但在架构语义上渐进偏离。这一通道的存在确保 AI 生成的代码不仅"能用"，而且"合规"。

---

## 三通道结果合并

三通道并行完成后，结果合并为统一的验证状态：

| 合并规则 | 条件 | 合并结果 |
|---------|------|---------|
| 全部通过 | 三通道均为 PASS | **PASS** |
| 有警告 | 三通道均无 FAIL，但存在 PASS_WITH_WARNINGS | **PASS_WITH_WARNINGS** |
| 任一失败 | 任一通道为 FAIL | **FAIL** |

合并结果输入 [验证决策矩阵](./decision-matrix.md) 生成最终决策。

**关键设计约束：**
- 三通道之间没有优先级——安全通道的 FAIL 和契约通道的 FAIL 具有同等否决权
- PASS_WITH_WARNINGS 中的 warning 条目全部记录到验证报告中，供人类审查
- 每个通道的详细检查结果（逐条 pass/fail/warning 状态）保存到 `.sand/executions/EXE-{session_id}/validation-report.yaml`

---

## 验证报告输出结构

三通道验证完成后，输出结构化验证报告：

```yaml
validation_report:
  session_id: "EXE-{session_id}"
  intent_id: "INT-YYYYMMDD-{seq}"
  timestamp: "ISO-8601"
  overall_result: "pass | pass_with_warnings | fail"
  channels:
    contract:
      result: "pass | pass_with_warnings | fail"
      must_pass_results: [...]
      should_pass_results: [...]
      must_not_violate_results: [...]
      intent_alignment_score: null  # 推断控制输出
    security:
      result: "pass | pass_with_warnings | fail"
      check_results: [...]
      license_warnings: [...]
    architecture:
      result: "pass | pass_with_warnings | fail"
      check_results: [...]
  deviations: [...]  # 引用 deviation-tracking
  human_review_required: true  # 恒为 true——所有决策均需 HIP 对应级别的人类确认
  hip_level: "hip-1 | hip-2 | hip-3"
```

---

## 与 SDC 其他阶段的关系

| 前置阶段 | 提供给 Validate 的输入 |
|---------|---------------------|
| **Intent** | 意图声明（purpose, acceptance_criteria, constraints）→ 契约验证的参照基准 |
| **Build** | 交付物（代码、配置、文档）→ 三通道的验证对象 |

| 后继阶段 | Validate 提供的输出 |
|---------|-------------------|
| **Operate** | 验证通过的交付物 → 部署 |
| **Build**（回退） | FAIL 结果 → 打回 Build 修复 |
| **Intent**（重定向） | 意图偏差 → 重定向 Intent 修正意图 |
| **Learn** | 偏差事件 → 飞轮学习（参见 [意图偏差追踪](./deviation-tracking.md)） |

---

## 引用来源

- Fowler, M. (2026). "Harness engineering for coding agent users." [martinfowler.com](https://martinfowler.com/articles/harness-engineering.html)
- Mikkonen, T. & Taivalsaari, A. (2025). "Software Reuse in the Generative AI Era." *Internetware '25*. DOI: [10.1145/3755881.3755981](https://dl.acm.org/doi/10.1145/3755881.3755981)
- [生成式复用风险](../../01-foundations/generative-reuse-risk.md) — SAND Foundations 文档
- [非确定性编程范式](../../01-foundations/non-deterministic-paradigm.md) — SAND Foundations 文档
- [执行契约标准](../intent/execution-contract.md) — SAND Intent 阶段文档
- [验证决策矩阵](./decision-matrix.md) — SAND Validate 阶段文档
