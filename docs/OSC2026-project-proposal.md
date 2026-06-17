# MoonBit OSC2026 项目申报书

## 项目名称

moonbench：MoonBit 轻量级基准测试统计库

## 项目方向

工程基础设施与工具链 / Stopwatch / benchmark 小工具。

## 项目简介

`moonbench` 是一个面向 MoonBit 生态的轻量级 benchmark 统计库。它不绑定具体平台时钟，而是接收调用方提供的耗时纳秒数，输出样本数量、总耗时、最小值、最大值、均值、吞吐量和稳定性判断。该边界让它可以被 CLI 工具、算法库、解析器、教学示例和 CI 性能检查复用。

GitLink 仓库：https://gitlink.org.cn/sa2360/moonbit

GitHub 镜像：https://github.com/sa2360/moonbit

## 与官方 `moon bench` 的区别

官方 `moon bench` 适合严肃 benchmark：它集成在 MoonBit 构建系统中，支持包、文件、后端、release/debug 等维度，并提供批量测量和统计分析。`moonbench` 不替代官方命令，而是补充一个更轻量的“统计与 CI 报告层”：它可以接收外部测试框架、CI 脚本、日志或宿主时钟采集到的耗时样本，生成一行文本摘要，并通过 `Budget`、`meets_budget`、`budget_report` 做简单性能预算判断，适合 README 示例、教学演示、工具输出和 CI smoke check。

## 核心功能

- `Summary` 聚合模型：记录 count、total、min、max、mean。
- 单样本追加与多摘要合并：便于分批统计和多阶段 benchmark。
- 吞吐量估算：以纳秒为时间基准输出 samples/s。
- 稳定性判断：用 ppm 容差判断 min/max 波动是否在可接受范围。
- 性能预算判断：输出适合 CI 日志的 pass/fail 报告。
- 文本报告：输出适合命令行、CI 日志和 README 示例的一行摘要。

## 技术路线

项目采用纯 MoonBit 实现，根包提供可复用 API，`cmd/main` 提供最小可运行示例，`moonbench_test.mbt` 覆盖聚合、合并、吞吐、稳定性和格式化行为。项目使用 MIT 许可证，并配置 GitHub Actions 在公开仓库中执行 `moon check`、`moon test` 和 `moon run cmd/main`。

## 验收准备

- GitLink 仓库：https://gitlink.org.cn/sa2360/moonbit。
- GitHub 镜像：https://github.com/sa2360/moonbit。
- README：包含动机、API、示例、运行命令和 Mooncakes 发布步骤。
- 测试：执行 `moon test`。
- CI：`.github/workflows/ci.yml`。
- Mooncakes：执行 `moon login` / `moon publish`。

## 本次新增工作量说明

本项目为 2026 年 6 月新建项目，新增内容包括 MoonBit 源码、测试、CLI 示例、README、CI、许可证和申报书草稿。后续计划补充分位数统计、JSON 报告和平台时钟适配示例。
