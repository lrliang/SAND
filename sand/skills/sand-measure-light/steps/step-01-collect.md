# Step 1: 信号采集

## MANDATORY EXECUTION RULES (READ FIRST):

1. 读完整个步骤文件后再执行——不要边读边做
2. 按编号顺序执行每个子节——不跳步
3. 遇到不确定性时请求人类确认——不猜测用户意图
4. 每个子节完成后向用户汇报进度——保持透明
5. 失败时快速报错并说明原因——不静默降级或继续

## YOUR TASK:

运行 `git-metrics.py` 和 `ci-metrics.py` 采集 5 个轻量信号（PR 周期时间、AI 参与度、变更失败率、部署频率、事故标签），合并输出到 `.sand/metrics/{YYYYMMDD}_metrics.json`。

## EXECUTION SEQUENCE:

### §1 环境检查

验证运行环境满足采集前置条件：

1. **Git 仓库检查**：运行 `git rev-parse --git-dir`
   - 成功 → 继续
   - 失败 → `❌ 当前目录不是 Git 仓库。请在 Git 仓库根目录运行 sand-measure-light。` → **HALT**

2. **Python 3 检查**：运行 `python3 --version`
   - 成功 → 继续
   - 失败 → `❌ Python 3 不可用。sand-measure-light 需要 Python 3 运行采集脚本。` → **HALT**

3. **输出目录准备**：检查 `.sand/metrics/` 目录
   - 存在 → 继续
   - 不存在 → 创建 `mkdir -p .sand/metrics/`

4. **采集参数确认**：向用户展示默认参数并允许调整

```
📊 sand-measure-light 信号采集

默认参数：
- PR 周期时间样本数：最近 50 个合并
- AI 参与度时间窗口：最近 30 天
- CI 度量时间窗口：最近 30 天

是否使用默认参数？
[Y] 是，开始采集（默认）
[N] 否，我要调整参数
```

如用户选择调整，依次询问各参数值。

### §2 Git 信号采集

运行 Git 度量采集脚本：

```bash
python3 {skill_dir}/scripts/git-metrics.py --days {days} --pr-count {pr_count} --output /tmp/sand-git-metrics.json
```

其中 `{skill_dir}` 为 `sand/skills/sand-measure-light`（相对于仓库根目录）。

**解析输出并展示结果：**

```
📈 Git 信号采集结果：

信号 1 — PR 周期时间（PR Cycle Time）
  定义：从首次提交到合并的时长中位数
  结果：{value} 小时（样本 {sample_size} 个 PR）
  状态：{status}

信号 3 — AI 参与度（AI Involvement Rate）
  定义：代码变更中 AI 辅助生成的占比
  结果：{value * 100}%（{ai_commits}/{total_commits} 提交）
  状态：{status}
```

**退出码处理：**
- 0 = 全部成功
- 1 = 全部失败 → 报告错误但继续（CI 信号可能仍可采集）
- 2 = 部分成功 → 报告哪些信号不可用

### §3 CI 信号采集

向用户确认 CI 数据源：

```
🔌 CI 信号采集

请选择 CI 数据源：
[1] CI API（提供 API URL）
[2] CSV 文件导入（FR36 fallback）
[3] 跳过 CI 信号（标记为 unavailable）
```

**选项 1 — CI API：**
- 询问 API URL
- 运行：`python3 {skill_dir}/scripts/ci-metrics.py --api-url {url} --days {days} --output /tmp/sand-ci-metrics.json`
- 如果 API 不可达，自动提示切换到 CSV fallback

**选项 2 — CSV fallback：**
- 询问 CSV 文件路径
- 展示 CSV 格式要求：
  ```
  CSV 格式（3 列，含标题行）：
  signal,value,detail
  change_failure_rate,0.12,
  deployment_frequency,3.5,per_week
  incident_labels,,{"ai_related":2,"non_ai":5,"mixed":1}
  ```
- 运行：`python3 {skill_dir}/scripts/ci-metrics.py --csv {path} --output /tmp/sand-ci-metrics.json`

**选项 3 — 跳过：**
- 3 个 CI 信号标记为 unavailable
- 继续执行（Git 信号仍有价值）

**展示 CI 采集结果：**

```
📈 CI 信号采集结果：

信号 4 — 变更失败率（Change Failure Rate）
  定义：导致生产问题的变更占比
  结果：{value * 100}%（{failed}/{total} 变更）
  DORA 级别：{Elite/High/Medium/Low}
  状态：{status}

信号 5 — 部署频率（Deployment Frequency）
  定义：向生产环境部署的频率
  结果：每周 {value} 次
  DORA 级别：{Elite/High/Medium/Low}
  状态：{status}

信号 2 — 事故标签（Incident Labels）
  定义：生产事故按根因分类
  AI 相关：{ai_related} 次
  非 AI：{non_ai} 次
  混合：{mixed} 次
  AI 相关占比：{ratio * 100}%
  状态：{status}
```

### §4 合并输出

将 Git 和 CI 采集结果合并为最终的度量 JSON 文件：

1. 读取 `/tmp/sand-git-metrics.json` 和 `/tmp/sand-ci-metrics.json`
2. 按 `templates/metrics-output.json` 结构合并 5 个信号
3. 填充 metadata（collected_at、git_repo、time_window_days）
4. 写入 `.sand/metrics/{YYYYMMDD}_metrics.json`

**展示采集汇总：**

```
✅ 信号采集完成

📊 采集汇总：
| # | 信号 | 值 | 状态 |
|---|------|-----|------|
| 1 | PR 周期时间 | {value} 小时 | {status} |
| 2 | 事故标签 | AI:{ai} / 非AI:{non} / 混合:{mix} | {status} |
| 3 | AI 参与度 | {value}% | {status} |
| 4 | 变更失败率 | {value}% | {status} |
| 5 | 部署频率 | {value}/周 | {status} |

输出文件：.sand/metrics/{YYYYMMDD}_metrics.json
```

清理临时文件（`/tmp/sand-git-metrics.json`、`/tmp/sand-ci-metrics.json`）。

## SUCCESS METRICS:

✅ Git 仓库环境验证通过
✅ git-metrics.py 成功运行并产出 PR 周期时间和/或 AI 参与度数据
✅ CI 度量通过 API 或 CSV fallback 采集（或明确标记为 unavailable）
✅ 5 个信号合并输出到 `.sand/metrics/{YYYYMMDD}_metrics.json`
✅ 信号名称和采集方法与 signal-collection.md 定义一致

## FAILURE MODES:

❌ 非 Git 仓库 → HALT 并提示在 Git 仓库根目录运行
❌ Python 3 不可用 → HALT 并提示安装 Python 3
❌ git-metrics.py 全部失败且 CI 也全部不可用 → 报告 5 个信号均 unavailable，生成空 metrics JSON（仍继续到 step-02 以生成"无数据"报告）
❌ 临时文件写入失败 → 使用内存传递数据，跳过文件 I/O

## NEXT STEP:

继续执行 `steps/step-02-report.md` — 认知失调报告生成
