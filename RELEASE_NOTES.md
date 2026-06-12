## swarmcode v0.5.0

First public binary release.

- Fullscreen terminal UI with mouse support (hover, click-to-expand, wheel, precise drag-select with auto-copy), pinned input/status bar, in-viewport streaming with live markdown and tables
- 29+ model channels via the interactive `swarmcode model` wizard (Anthropic, OpenAI, Gemini, DeepSeek, Kimi, MiniMax, DashScope, GLM, custom proxies, …), models.dev-backed metadata
- Parallel agent teams, MCP servers (standard `.mcp.json`), skills, lifecycle hooks, fine-grained permissions, git-worktree isolation
- Session persistence: resume by id or name, `/rename`, fork, crash checkpoints
- Headless `exec` (text / json / stream-json), stream-json SDK control protocol, `swarmcode serve` (HTTP + WebSocket), `--ide` integration
- Persistent cross-session memory with natural-language editing

**Install**

```bash
curl -fsSL https://raw.githubusercontent.com/SwarmPathAI/swarmcode/main/install.sh | bash
```

`darwin-universal` runs on Apple Silicon and Intel Macs. Verify downloads against `SHA256SUMS`.
