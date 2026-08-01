# swarmcode

> 🌐 English · 中文在下方

**swarmcode** is a provider-agnostic AI coding agent for your terminal: a fullscreen TUI that orchestrates teams of LLM agents across 29+ model channels (Anthropic, OpenAI, Gemini, DeepSeek, Kimi, MiniMax, DashScope, GLM, custom proxies, …).

**New in v0.9.0 — membership gateway:** share ONE authorized Codex (or any upstream) subscription with many **device-bound** members, without handing anyone a copy-pasteable key. The admin runs `swarmcode serve --gateway`, issues each member a one-time `swarmcode join` code (with its own quota / validity / device-cap / model allow-list), and watches usage live — while members get a fully transparent proxy (web search, image generation, reasoning effort all work identically). See the release notes and `docs/GATEWAY_DEPLOY.md`.

**v0.9.1** adds member self-service — `swarmcode member me` (see your own quota/usage) and `swarmcode member set-gateway <url>` (move to a new gateway URL, e.g. an HTTPS front, without re-joining) — and fixes chat messages that begin with a filesystem path (`/Users/…`) being rejected as an unknown command.

**v0.9.2** fixes `swarmcode update`: it works on Windows now, and no longer hard-refuses on npm/Homebrew installs (warns and updates in place instead). Updating *to* v0.9.2 still needs the package manager one time (`npm install -g @swarmpathai/swarmcode@latest`, or the Windows `install.ps1`); after that `swarmcode update` works everywhere.

**New in v0.10.0 — one-approval autonomous tasks + a quieter auto mode.** Plan mode can now approve one bounded task in a single confirmation — with frozen scope, budgets, and expiry — including, on Linux, sandboxed patch-producing edits and offline Cargo build/test. Auto mode stops prompting for read-only tools (fixed allow-list, checked before the classifier). New TUI: **Shift+Tab** cycles the permission mode, **Ctrl+T** opens a persistent Tasks panel, **Ctrl+B** sends running foreground work to the background. Tool loading is aligned tool-for-tool with the leading coding agents (stable schema order restores prompt caching; MCP tools no longer 400 on OpenAI Responses), and image generation through the membership gateway no longer times out on long renders (250s budget + automatic retry).

**New in v0.10.1 — no flicker, and codex/membership channels work end-to-end.** The post-generation black flash, the send-time flash, and the per-Shift+Tab flash are eliminated at the root (a single state-guarded alternate-screen owner). A wide-reaching silent failure on **codex / membership channels** is fixed at its source: the ChatGPT Codex backend rejects `max_output_tokens` with a `400`, which was quietly breaking the **auto-mode classifier** (so auto mode kept prompting for approval on nearly every tool), `/compact`, session auto-naming, memory recall, and `/goal` — one adapter fix restores them all. Image generation over a membership gateway is now an **async job** (fast job id + short polls) that survives proxies with a ~30s idle timeout. Plus: a right-aligned **conversation-title chip** on the input border after turn 1, auto mode runs `GenerateImage` without prompting, permission grants persist to swarmcode's own **`.swarmcode/settings.json`** (still reading `.claude/` for compatibility), and code previews are legible on light-background terminals.

**New in v0.12.0 — managed Artifact publishing, one implicit team, and a self-describing agent.** `/publish` now accepts Markdown or full HTML (`--file`), adds `--template morning-brief|plan|dataviz`, and can `--enhance` into a polished self-contained page; the model can drive publish / update / list / visibility / delete through the `Artifact` tool, backed by a private canonical source so an artifact can be updated without changing its share URL. Multi-agent work collapses to **one implicit team per session** — named `Agent` calls, `Task*`, `SendMessage`, and `ListPeers` resolve automatically, agents run asynchronously by default, and shared per-session caps bound spawning and web search. MCP tool catalogs **refresh live** (`RefreshMcpTools`) without restarting; `/auto-mode-setup` proposes strictly typed settings for explicit review before applying; product-feedback drafts stay fully local. The system prompt now carries a **self-describing capability overview** generated from the tools actually enabled, so "what can you do?" stays complete and current, and running a skill or custom command as `/name` shows the typed command instead of dumping its whole body into scrollback.

**New in v0.12.2 — web research that finishes the job.** Pointed at any Anthropic-compatible base URL (e.g. DeepSeek's `/anthropic` endpoint) with only `ANTHROPIC_AUTH_TOKEN` set, swarmcode detects the credential and runs `web_search` server-side, returning current-year results with a `Sources:` list — no separate search key. The per-turn search budget is raised to 8 (200 per session), so a complex question drives several searches across multiple rounds until it is answered; endpoints that reject the native `web_fetch` fall back to a client-side fetch instead of failing the request. The HUD tool tally now counts **every** tool live while the turn streams — including provider-hosted search/fetch, which the fullscreen view previously never counted at all.

**New in v0.13.3 — code intelligence and workflow isolation.** New Tree-sitter codebase-graph, fast reflink worktree, and workflow-host crates add cross-file navigation, isolated parallel-agent workspaces, and durable workflow lifecycle management. Provider credential refresh, schema-guided tool-input coercion, new hook seams, safer repeated compaction, and plugin SHA-256 pinning harden long-running agent sessions.

**New in v0.14.1 — Claude-matched scrolling and explicit provider search routing.** Mouse-wheel scrolling ports Claude Code 2.1.220's complete time-driven acceleration model, detects current VS Code/xterm.js releases without an obsolete version ceiling, and is black-box verified against Claude Code in tmux and real VS Code. True Anthropic-native endpoints use hosted `web_search_20250305`, while OpenAI-compatible channels and Anthropic-shaped proxies that return ordinary `tool_use` calls use client-side AnySearch. The Unix Bash launcher also removes a conflicting process-group setup that made `setsid()` fail with `EPERM` on macOS.

**New in v0.15.0 — xAI Grok device-code OAuth, Imagine images, Responses web search.** `swarmcode model xai-oauth` signs in with a device code (or reuses `~/.grok/auth.json`); tokens auto-refresh. `GenerateImage` uses xAI Imagine on Grok channels; `WebSearch` uses Responses `web_search`. DeepSeek V4 API ids and the mid-turn **[Send now]** / double-Enter queue polish round out the release. Docs: [swarmpathplatform.com/swarmcode-docs](https://www.swarmpathplatform.com/swarmcode-docs/).

**New in v0.16.0 — config-path flexibility, collapsible background tasks, stabler check commands.** `SWARMCODE_CONFIG_DIR` / `CLAUDE_CONFIG_DIR` select the config root (default `~/.swarmcode`). Consecutive background-task status lines collapse into one `⏺ Background tasks (N)` row (click / `Ctrl+O` to expand). Check-style commands that exit 0 with no output no longer false-fail; empty cgroups clean up more reliably; `swarmcode daemon stop-service <name> [--force]` stops a single named service.

Distributed as prebuilt binaries. ✦ This repository hosts **releases and documentation only**.

## Install

**Platforms**: macOS (Apple Silicon & Intel), Linux (x64 & arm64), and Windows (x64) — all native.

**curl (recommended)**

```bash
curl -fsSL https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.sh | bash
```

**Homebrew (macOS)**

```bash
brew tap swarmpathai/swarmcode https://github.com/SwarmPathAI/swarmcode
brew install swarmcode
```

**npm** (any OS with Node)

```bash
npm install -g @swarmpathai/swarmcode
```

**Windows (PowerShell)**

```powershell
irm https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.ps1 | iex
```

**Manual** — grab a tarball from [Releases](../../releases/latest) (`darwin-universal` runs on both Apple Silicon and Intel Macs), untar, put `swarmcode` on your PATH, verify against `SHA256SUMS`.

## Quick start

```bash
swarmcode model        # interactive channel wizard: pick a provider, paste an API key, choose a model
swarmcode              # fullscreen TUI REPL (mouse support, pinned status bar)
swarmcode "one-shot prompt"            # headless exec
swarmcode integration | less          # full guide for driving swarmcode from other programs
```

Highlights: fullscreen terminal UI with mouse support · parallel agent teams · MCP servers (standard `.mcp.json`) · skills, hooks, fine-grained permissions, git-worktree isolation · session resume/rename · stream-json SDK protocol + `swarmcode serve` (HTTP/WS) · persistent cross-session memory.

## Updating

```bash
swarmcode update           # self-update to the latest release
swarmcode update --check   # just check whether a newer version exists
```

(`brew upgrade swarmcode` / re-running the curl installer also work.)

## Uninstall

```bash
rm ~/.local/bin/swarmcode        # curl install (or wherever you installed it)
brew uninstall swarmcode         # Homebrew install
npm uninstall -g @swarmpathai/swarmcode       # npm install
rm -rf ~/.swarmcode              # optional: remove all user data (config, sessions, memory)
```

## License

Binary-only, free to use; no redistribution or reverse engineering. See [LICENSE.txt](LICENSE.txt).

---

# swarmcode（中文）

**swarmcode** 是终端里的全能 AI 编程智能体:全屏 TUI,可在 29+ 模型渠道(Anthropic、OpenAI、Gemini、DeepSeek、Kimi、MiniMax、通义、智谱、自定义代理……)上编排 LLM 智能体团队。

**v0.12.2 新增 —— 会把问题查到底的 Web 检索。** 指向任意 Anthropic 兼容 base URL(如 DeepSeek 的 `/anthropic` 端点）、仅设置 `ANTHROPIC_AUTH_TOKEN` 时,swarmcode 会识别该凭证并在服务端运行 `web_search`,返回带 `Sources:` 列表的当年结果,无需单独的搜索 key。每回合搜索预算提高到 8 次(每会话 200 次）,复杂问题可以跨多轮持续检索直到得出答案;拒绝原生 `web_fetch` 的端点会回退为客户端抓取,而不是让整个请求失败。HUD 工具计数现在会在回合进行中实时统计**每一个**工具——包括服务端托管的搜索/抓取,而全屏视图此前对它们完全不计数。

**v0.13.3 新增 —— 代码智能与工作流隔离。** 新增基于 Tree-sitter 的代码库图、快速 reflink worktree 与 workflow-host crate，提供跨文件导航、并行 agent 隔离工作区和可持久化的工作流生命周期管理。Provider 凭证刷新、工具输入按 Schema 强制转换、新的钩子缝、重复压缩保护和插件 SHA-256 锁定进一步加固长时间运行的 agent 会话。

**v0.14.1 新增 —— 与 Claude 一致的滚动及明确的 Provider 搜索路由。** 鼠标滚轮完整移植 Claude Code 2.1.220 按时间驱动的加速模型，现代 VS Code/xterm.js 版本不再受过时版本上限影响，并已通过 tmux 黑盒测试和真实 VS Code 测试与 Claude Code 对照验证。真正支持 Anthropic 原生工具的端点使用服务端 `web_search_20250305`；OpenAI 兼容渠道及返回普通 `tool_use` 的 Anthropic 外形代理使用客户端 AnySearch。Unix Bash 启动器还移除了会导致 macOS `setsid()` 返回 `EPERM` 的冲突进程组设置。

**v0.15.0 新增 —— xAI Grok 设备码 OAuth、Imagine 出图、Responses 联网。** `swarmcode model xai-oauth` 设备码登录（或复用 `~/.grok/auth.json`），token 自动刷新。Grok 渠道上 `GenerateImage` 走 Imagine，`WebSearch` 走 Responses `web_search`。DeepSeek V4 API id 与回合中 **[Send now]** / 双 Enter 队列一并打磨。文档：[swarmpathplatform.com/swarmcode-docs](https://www.swarmpathplatform.com/swarmcode-docs/)。

**v0.16.0 新增 —— 配置目录可指定、后台任务可折叠、check 命令更稳。** `SWARMCODE_CONFIG_DIR` / `CLAUDE_CONFIG_DIR` 可选配置根目录（默认 `~/.swarmcode`）。连续后台任务状态行折叠为一条 `⏺ Background tasks (N)`（点击 / `Ctrl+O` 展开）。无输出且 exit 0 的 check 类命令不再误报失败；空 cgroup 清理更可靠；`swarmcode daemon stop-service <name> [--force]` 可单独停一个命名服务。

以预编译二进制发行。✦ 本仓库只承载**发布产物与文档**。

## 安装

**平台支持**:macOS(Apple Silicon 与 Intel)、Linux(x64 与 arm64)、Windows(x64)——全部原生支持。

**curl(推荐)**

```bash
curl -fsSL https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.sh | bash
```

**Homebrew(macOS)**

```bash
brew tap swarmpathai/swarmcode https://github.com/SwarmPathAI/swarmcode
brew install swarmcode
```

**npm**(任何有 Node 的系统)

```bash
npm install -g @swarmpathai/swarmcode
```

**Windows(PowerShell)**

```powershell
irm https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.ps1 | iex
```

**手动** —— 从 [Releases](../../releases/latest) 下载压缩包(`darwin-universal` 同时支持 Apple Silicon 与 Intel Mac),解压后把 `swarmcode` 放进 PATH;用 `SHA256SUMS` 校验。

## 快速上手

```bash
swarmcode model        # 交互式渠道向导:选渠道、填 API Key、选默认模型
swarmcode              # 全屏 TUI REPL(支持鼠标、钉底状态栏)
swarmcode "一次性提示词"               # 无头 exec
swarmcode integration | less          # 外部程序接入完整手册(内嵌于二进制)
```

亮点:全屏终端 UI + 鼠标 · 并行智能体团队 · MCP(标准 `.mcp.json`)· 技能/Hooks/细粒度权限/worktree 隔离 · 会话续接与重命名 · stream-json SDK 协议 + `swarmcode serve`(HTTP/WS)· 跨会话持久记忆。

## 升级

```bash
swarmcode update           # 一键自更新到最新版
swarmcode update --check   # 只检查是否有新版
```

(`brew upgrade swarmcode` 或重跑 curl 安装命令同样有效。)

## 卸载

```bash
rm ~/.local/bin/swarmcode        # curl 安装(或你自定义的安装目录)
brew uninstall swarmcode         # Homebrew 安装
npm uninstall -g @swarmpathai/swarmcode       # npm 安装
rm -rf ~/.swarmcode              # 可选:清除全部用户数据(配置/会话/记忆)
```

## 许可

仅二进制、免费使用;禁止再分发与逆向。详见 [LICENSE.txt](LICENSE.txt)。
