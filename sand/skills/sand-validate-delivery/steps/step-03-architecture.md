# Step 3: 架构对齐验证通道（Architecture Alignment）

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous
5. If this step encounters an execution error, record a deviation with `deviation_type: architecture_deviation` and `severity: blocking`, then default channel result to FAIL

## YOUR TASK:

对交付物运行 6 项架构对齐检查，确保 AI 生成的代码不仅功能正确，且符合项目架构约束。本通道主要依赖推断控制（AI 语义分析）。

## EXECUTION SEQUENCE:

向用户显示：
```
[Step 3/4] 架构对齐验证通道
```

### 1. 命名规范一致性检查

**控制类型：** 计算控制
**阻塞级别：** warning

- 新增文件名遵循项目命名约定（kebab-case/snake_case/camelCase，取决于项目规范）
- 新增函数/方法名遵循语言约定
- 新增变量/常量名遵循项目约定
- 检查方法：对比交付物中的新增标识符与项目已有代码的命名模式

输出格式：
```yaml
- check: "naming_convention"
  status: "pass"  # or "warning"
  detail: "All 15 new identifiers follow project snake_case convention"
  violations: []  # or list of non-conforming names
```

### 2. 目录结构规范检查

**控制类型：** 计算控制
**阻塞级别：** blocking

- 新增文件位于正确的目录层级（如 controllers/ 下放控制器，models/ 下放模型）
- 不在根目录或不相关目录放置新文件
- 检查方法：读取项目目录结构，对比新增文件路径与已有模式

### 3. 依赖方向检查

**控制类型：** 推断控制
**阻塞级别：** blocking

- 不存在反向依赖（如 domain 层直接导入 infrastructure 层）
- 新增 import/require 语句遵循项目的依赖层级约束
- 检查方法：分析交付物中的 import 语句，对比项目架构定义的层级关系

常见反向依赖模式：
| 违规方向 | 说明 |
|---------|------|
| domain → infrastructure | 领域层不应依赖基础设施层 |
| domain → presentation | 领域层不应依赖表示层 |
| shared/utils → business | 共享工具不应依赖业务逻辑 |
| config → runtime | 配置层不应依赖运行时状态 |

### 4. 架构模式一致性检查

**控制类型：** 推断控制
**阻塞级别：** warning

- 新增代码遵循项目既有的架构模式（MVC、CQRS、Clean Architecture 等）
- 不引入与项目模式冲突的新模式（如项目用 Repository Pattern 但交付物直接在控制器中写 SQL）
- 检查方法：分析交付物的代码结构，对比项目已有的架构模式

### 5. API 契约一致性检查

**控制类型：** 计算控制 + 推断控制
**阻塞级别：** blocking

- 新增/修改的 API 端点与已有 API 契约兼容（不破坏现有客户端）
- 响应格式一致（JSON 结构、状态码使用、错误响应格式）
- 如有 API 规范文件（OpenAPI/Swagger），对比一致性

### 6. 代码复用检查（Anti-Cargo Cult）

**控制类型：** 推断控制
**阻塞级别：** warning

- 交付物未重复实现项目中已有的功能
- AI 生成的代码是否创建了与已有工具函数/类/模块功能重复的新实现
- 检查方法：搜索项目中是否存在与交付物功能相似的已有实现

此项检查直接对应 Mikkonen Cargo Cult 理论中的"重复造轮子"风险。

输出格式（如发现重复）：
```yaml
- check: "code_reuse"
  status: "warning"
  detail: "Potential duplication with existing utility"
  duplicates:
    - new_code: "src/utils/format_date.py"
      existing: "src/shared/date_helpers.py:format_iso_date()"
      recommendation: "Consider reusing existing date_helpers module"
```

### 7. 生成通道结果

根据 step 1-6 的结果，生成架构对齐通道的最终结果：

```
IF any blocking 检查项 status == "fail" THEN 通道结果 = FAIL
ELSE IF any warning 检查项 status == "warning" THEN 通道结果 = PASS_WITH_WARNINGS
ELSE 通道结果 = PASS
```

> 注：blocking 级检查输出 `status: "pass"` 或 `"fail"`；warning 级检查输出 `status: "pass"` 或 `"warning"`。两类检查使用不同的非通过状态值。

向用户显示通道结果摘要：
```
🏗️ 架构对齐通道结果: {PASS|PASS_WITH_WARNINGS|FAIL}
  命名规范: {status}
  目录结构: {status}
  依赖方向: {status}
  架构模式: {status}
  API 契约: {status}
  代码复用: {status}
```

将完整结果暂存于内存，供 step-04 合并使用。

## SUCCESS METRICS:

✅ 6 项架构检查全部执行
✅ 每项检查输出 pass/fail/warning 状态和详细说明
✅ blocking 项（目录结构、依赖方向、API 契约）正确阻塞
✅ warning 项（命名、模式、复用）不阻塞但记录
✅ 通道结果正确生成

## FAILURE MODES:

❌ 项目无明确的架构规范 → 降级为基于 AI 推断的最佳实践审查，在结果中标注"无项目架构规范参考"
❌ 交付物上下文不可用 → 使用 step-01 已加载的上下文
❌ 通道执行出错（D2）→ 记录偏差事件，默认通道结果 = FAIL

## NEXT STEP:

Read fully and follow `./step-04-decision.md`
