# swarmcode

> 🌐 English · 中文在下方

**swarmcode** is a provider-agnostic AI coding agent for your terminal: a fullscreen TUI that orchestrates teams of LLM agents across 29+ model channels (Anthropic, OpenAI, Gemini, DeepSeek, Kimi, MiniMax, DashScope, GLM, custom proxies, …).

**New in v0.9.0 — membership gateway:** share ONE authorized Codex (or any upstream) subscription with many **device-bound** members, without handing anyone a copy-pasteable key. The admin runs `swarmcode serve --gateway`, issues each member a one-time `swarmcode join` code (with its own quota / validity / device-cap / model allow-list), and watches usage live — while members get a fully transparent proxy (web search, image generation, reasoning effort all work identically). See the release notes and `docs/GATEWAY_DEPLOY.md`.

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

以预编译二进制发行。✦ 本仓库只承载**发布产物与文档**。

## 安装

**平台支持**:macOS(Apple Silicon 与 Intel)、Linux(x64 与 arm64)原生支持;Windows 请在 **WSL2** 中使用 Linux 版(原生 Windows 支持在路线图上)。

**curl(推荐)**

```bash
curl -fsSL https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.sh | bash
```

**Homebrew(macOS)**

```bash
brew tap swarmpathai/swarmcode https://github.com/SwarmPathAI/swarmcode
brew install swarmcode
```

**npm**

```bash
npm install -g @swarmpathai/swarmcode
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
