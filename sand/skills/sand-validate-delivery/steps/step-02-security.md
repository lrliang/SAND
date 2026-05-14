# Step 2: 安全合规验证通道（Security & Compliance）

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format
4. HALT and ask for clarification if any instruction is ambiguous
5. If this step encounters an execution error, record a deviation with `deviation_type: security_deviation` and `severity: blocking`, then default channel result to FAIL

## YOUR TASK:

对交付物运行 7 项安全合规检查，输出安全合规通道结果。许可证检查为非阻塞 warning（FR25）。

## EXECUTION SEQUENCE:

向用户显示：
```
[Step 2/4] 安全合规验证通道
```

### 1. 注入漏洞检查

**控制类型：** 计算控制
**阻塞级别：** blocking

检查交付物中是否存在以下注入风险：

| 检查子项 | 判定标准 |
|---------|---------|
| SQL 注入 | 不存在用户输入直接拼接到 SQL 语句（应使用参数化查询） |
| NoSQL 注入 | 不存在用户输入直接嵌入 NoSQL 查询对象 |
| 命令注入 | 不存在用户输入直接传入 shell 执行（os.system、subprocess 等） |
| XSS | 不存在未转义的用户输入渲染到 HTML/模板 |

输出格式：
```yaml
- check: "injection"
  status: "pass"  # or "fail"
  detail: "No unparameterized queries found in 12 SQL statements"
  sub_checks:
    - sql_injection: "pass"
    - nosql_injection: "pass"
    - command_injection: "pass"
    - xss: "pass"
```

### 2. 敏感数据泄露检查

**控制类型：** 计算控制 + 推断控制
**阻塞级别：** blocking

| 检查子项 | 判定标准 |
|---------|---------|
| 日志输出 | 日志语句中不包含密码、token、PII 等敏感字段 |
| 错误响应体 | 错误响应不返回内部堆栈信息、SQL 语句、文件路径 |
| API 响应体 | API 返回数据不包含不应暴露的内部字段 |

**控制优先级（D6）：** 计算控制（正则匹配敏感模式）结果优先，推断控制（AI 语义分析上下文泄露风险）作为补充。

### 3. 认证/授权边界检查

**控制类型：** 推断控制
**阻塞级别：** blocking

- 所有新增/修改的 API 端点遵循最小权限原则
- 认证中间件正确应用于受保护端点
- 授权检查覆盖数据访问路径（不仅仅是端点入口）

### 4. 依赖安全性检查

**控制类型：** 计算控制
**阻塞级别：** blocking

- 检查新增依赖是否存在已知高危 CVE（Critical/High severity）
- 如项目有 lock 文件（package-lock.json、poetry.lock 等），检查新增条目
- 提示用户使用项目内的安全扫描工具（如有配置）

### 5. 许可证合规检查（FR25）

**控制类型：** 计算控制
**阻塞级别：** **warning（非阻塞）**

- 检查新增依赖的许可证与项目许可证兼容性
- 标记 copyleft 许可证（GPL、AGPL）为潜在风险
- **不因许可证问题阻断交付**——输出 warning 并建议使用手动检查工具

输出格式：
```yaml
- check: "license_compliance"
  status: "warning"  # always "warning" if issues found, never "fail"
  detail: "1 dependency with copyleft license detected"
  license_warnings:
    - dependency: "library-x"
      license: "LGPL-2.1"
      compatible: false
      recommendation: "Review with legal team or replace with MIT-licensed alternative"
```

### 6. 密钥/凭证硬编码检查

**控制类型：** 计算控制
**阻塞级别：** blocking

- 代码中不存在硬编码的 API key、password、secret token
- 检查常见模式：字符串赋值中的 `password=`、`api_key=`、`secret=`、`token=`
- 检查配置文件中的明文凭证
- 排除测试 fixtures 中的占位值（如 `test_token`、`dummy_key`）

### 7. 上下文安全检查（FR32）

**控制类型：** 推断控制
**阻塞级别：** blocking

- 检查意图声明的 `constraints.security` 中是否授权发送完整代码文件给 AI 模型
- 如果授权：验证对应的审计事件已记录到 `.sand/audits/audit.jsonl`
- 如果未授权但检测到完整文件发送：标记为 `fail`

### 8. 生成通道结果

根据 step 1-7 的结果，生成安全合规通道的最终结果：

```
IF any blocking 检查项 == fail THEN 通道结果 = FAIL
ELSE IF 许可证检查 == warning THEN 通道结果 = PASS_WITH_WARNINGS
ELSE 通道结果 = PASS
```

向用户显示通道结果摘要：
```
🔒 安全合规通道结果: {PASS|PASS_WITH_WARNINGS|FAIL}
  注入漏洞: {status}
  敏感数据泄露: {status}
  认证/授权边界: {status}
  依赖安全性: {status}
  许可证合规: {status}（FR25 非阻塞）
  密钥硬编码: {status}
  上下文安全: {status}
```

将完整结果暂存于内存，供 step-04 合并使用。

## SUCCESS METRICS:

✅ 7 项安全检查全部执行
✅ 每项检查输出 pass/fail/warning 状态和详细说明
✅ 许可证检查为非阻塞 warning（FR25 合规）
✅ 上下文安全检查与 FR32 对齐
✅ 通道结果正确生成

## FAILURE MODES:

❌ 交付物上下文不可用 → 使用 step-01 已加载的上下文；如 step-01 未执行则 HALT
❌ 安全扫描工具不可用 → 降级为 AI 推断控制审查，在结果中标注"手动扫描建议"
❌ 通道执行出错（D2）→ 记录偏差事件，默认通道结果 = FAIL

## NEXT STEP:

Read fully and follow `./step-03-architecture.md`
