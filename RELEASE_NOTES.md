## swarmcode v0.14.0

A terminal-input and provider-routing reliability release, with Claude-matched scrolling in current VS Code, explicit native-versus-client web search behavior, and a process-level macOS Bash fix.

- **Claude Code 2.1.220 mouse-wheel parity.** Streaming and settled transcript views share the full time-driven wheel state machine: native acceleration, 40 ms reset, direction-flip suppression, xterm.js/Windows decay, wheel-flood handling, fractional carry, and live `/scroll-speed` changes.
- **Current VS Code/xterm.js detection.** Every VS Code release now selects the xterm.js wheel profile directly instead of passing through an obsolete version ceiling. Black-box tmux and real VS Code comparisons match Claude Code's practical displacement for both single events and accelerated bursts.
- **Provider-aware WebSearch.** Real Anthropic-native endpoints receive `web_search_20250305`; ordinary OpenAI-compatible DeepSeek/Kimi/Qwen/MiniMax chat endpoints use AnySearch. Anthropic-shaped third-party proxies that return a normal `tool_use` are handled as client-side search rather than being mistaken for hosted search. `/nativesearch` and `/anysearch` remain independent controls.
- **macOS Bash `EPERM` fix.** Unix Bash children now rely on `setsid()` alone instead of combining it with a conflicting pre-spawn process-group setup. Whole-process-group cleanup on timeout and abort is preserved.

**Platforms:** macOS (Apple Silicon / Intel / universal), Linux (x64 / arm64, musl-static), Windows (x64). Verify downloads against `SHA256SUMS`.

## swarmcode v0.13.3

A capability-expansion release with codebase intelligence, isolated parallel worktrees, durable workflow lifecycle management, and stronger long-running-session safeguards.

- **Codebase intelligence.** The new `sc-codebase-graph` crate builds a parallel Tree-sitter index for Rust, TypeScript, JavaScript, Python, and Go, with cross-file definitions, references, and symbol navigation.
- **Fast isolated worktrees.** `sc-fast-worktree` combines reflink copies, hash sharding, and git worktrees so parallel agents can edit isolated workspaces without serializing on one checkout.
- **Durable workflow hosting.** `sc-workflow-host` persists workflow runs and supports pause, resume, complete, cancel, and JSON-Schema-validated outputs.
- **Provider and tool-loop robustness.** Anthropic OAuth credentials refresh and retry once after a 401; tool inputs receive schema-guided coercion before dispatch; PermissionDenied and PostToolBatch hooks can steer the next iteration; LSP diagnostics are reinjected through the reminder registry.
- **Safer repeated compaction.** Existing summaries are extended instead of regenerated from scratch, and warm Anthropic prompt-cache prefixes are preserved unless context pressure becomes critical.
- **Plugin supply-chain pinning.** Marketplace entries can require an exact SHA-256, verified with a constant-time comparison before install.

**Platforms:** macOS (Apple Silicon / Intel / universal), Linux (x64 / arm64, musl-static), Windows (x64). Verify downloads against `SHA256SUMS`.

## swarmcode v0.12.2

Web search and web fetch reach full parity on Anthropic-compatible endpoints, the model keeps searching until a complex question is answered, and the HUD tool tally counts every tool live — including server-side research — in both the classic and fullscreen views.

- **Native web search on Anthropic-compatible endpoints.** Pointed at a third-party Anthropic-compatible base URL (e.g. DeepSeek's `/anthropic` endpoint) with only `ANTHROPIC_AUTH_TOKEN` set, swarmcode detects the credential, runs `web_search` server-side, and returns current-year results with a `Sources:` list — no separate search key required.
- **Web fetch degrades gracefully.** Endpoints that reject the native `web_fetch` server tool transparently fall back to a client-side fetch for that turn while keeping native web search, instead of failing the whole request.
- **The model searches until it has the answer.** The per-turn `web_search` budget is raised to 8 and the per-session ceiling stays at 200, so a complex question can drive several searches per turn across multiple rounds.
- **The HUD tool tally is live, in fullscreen, for every tool.** Provider-hosted server tools (`web_search` / `web_fetch`) now increment the `✓ Web Search ×N` / `✓ Web Fetch ×N` status-bar tally — previously only client-dispatched tools were counted, and in the fullscreen turn view they were not counted at all. The tally also updates *while* the turn streams instead of only after it ends, so every tool call is visible as it happens.
- **Read-only web tools run without a prompt.** WebSearch and WebFetch are treated as read-only and auto-approved under Default and Accept-Edits, and "allow all edits this session" switches to a deterministic accept-edits mode so file writes stop re-prompting.
- **Date awareness.** The current date is injected into the system prompt and the search-tool guidance, so "latest"/"current" queries use the present year instead of stale results.
- **Long Sources lists collapse.** A WebSearch answer with more than five sources shows a collapsed `Sources:` block that expands in place (Ctrl+O) to the full list.

**Platforms:** macOS (Apple Silicon / Intel / universal), Linux (x64 / arm64, musl-static), Windows (x64). Verify downloads against `SHA256SUMS`.

## swarmcode v0.12.1

A fullscreen-rendering and interaction polish release on top of v0.12.0.

- **No end-of-turn flicker.** The fullscreen turn view could repaint a byte-identical final frame twice at the end of a turn, reading as a brief full-screen flash. Identical frames are now suppressed at the single flush point (a modal opening/closing still forces the repaint through; a resize always changes the bytes), so unchanged content is never repainted.
- **No residue on send.** The inline progress spinner could splice cursor-relative writes into the fullscreen screen and blank a row until the next repaint. A process-wide guard now keeps it byte-silent whenever the resident fullscreen renderer owns the screen, so sending a message no longer leaves a stale separator behind it.
- **`/compact` and auto-compaction render in place.** Compaction no longer drops to the primary screen (briefly revealing stale scrollback) and back. It stays in the fullscreen view and shows its progress in-frame — the transcript, an animated `✽ Compacting conversation…` line, the block progress bar, and the pinned composer + status bar — like a normal turn's thinking indicator.
- **`/cost` opens the status panel.** `/cost` now opens the tabbed `Settings · Status · Config · Usage` panel at the **Usage** tab (turns, tokens, estimated cost, context), consistent with `/status` and `/usage`.
- **Bare skill invocation is helpful.** Invoking a skill with no task (e.g. `/ego-browser`) now confirms it is loaded, lists a few concrete example tasks, and asks what you'd like to do — instead of a generic greeting.
- **Pasted images keep a consistent label.** A pasted image shows as `[Image #N]` in the composer and keeps that label in the sent transcript instead of flipping to `[image: clipboard]`. The model still receives the marker and the attached image; text-only models still gracefully drop the image with a placeholder.

**Platforms:** macOS (Apple Silicon / Intel / universal), Linux (x64 / arm64, musl-static), Windows (x64). Verify downloads against `SHA256SUMS`.

## swarmcode v0.12.0

End-to-end managed Artifact publishing, one implicit team per session, live MCP tool refresh, and a self-describing capability overview.

- **First-class Artifact publishing, managed end to end.** `/publish` accepts Markdown or full HTML via `--file`, adds `--template morning-brief|plan|dataviz`, and can `--enhance` into a polished self-contained page. The model can drive publish / update / list / source-read / visibility / delete through the `Artifact` tool. A private canonical source is stored under `<native-config-root>/artifacts/<origin-id>/<artifact-hash>/`, so an existing artifact can be updated from its managed source without changing its hash or share URL; Markdown, templates, direct HTML, and enhanced pages all flow through the same local render + visual-QA pipeline with Mermaid / syntax-highlighting / Chart.js runtimes injected as needed.
- **One implicit team per session.** Named `Agent` calls, `Task*`, `SendMessage`, and `ListPeers` resolve to the same lazily, race-safely created session team — no explicit team setup step, and older persisted teammate sessions stay compatible. Agents run asynchronously by default, nested progress is routed under the correct parent call, and shared per-session caps bound sub-agent spawning and web search.
- **Live MCP tool refresh.** `RefreshMcpTools` re-runs `tools/list` over connected servers and publishes changed schemas before the next request; a failed refresh keeps the previous catalog, stale concurrent results can't overwrite newer ones, and it never silently redials a disconnected server.
- **Reviewed auto-mode setup and private feedback drafts.** `/auto-mode-setup` proposes strictly typed settings for explicit user review before applying only the selected file. `SendFeedback` / `/feedback` keep factual product-feedback drafts fully local — nothing is uploaded automatically.
- **Explicit native configuration boundaries.** The native root resolves as `SWARMCODE_CONFIG_DIR > SWARMCODE_HOME > ~/.swarmcode`; an explicitly present `SWARMCODE_*` value always wins. Session-wide safety budgets and richer live progress / queued-input handling keep long agent runs predictable.
- **Self-describing capability overview.** The system prompt carries a grouped "what you can do" section generated from the tools actually enabled for the session, so introductions stay complete and current; newly registered tools appear automatically, and slash-command-only capabilities (Artifact, review, commit, autonomous goal) are covered alongside them.
- **Cleaner skill and custom-command invocation.** Running a skill as `/name` (or a user-defined `/command`) shows the typed command and injects its playbook to the model only, instead of dumping the whole body into scrollback.

**Platforms:** macOS (Apple Silicon / Intel / universal), Linux (x64 / arm64, musl-static), Windows (x64). Verify downloads against `SHA256SUMS`.

## swarmcode v0.10.0

One-approval autonomous tasks, a quieter auto mode, and tool loading aligned tool-for-tool across leading coding agents.

- **Plan mode can approve one bounded autonomous task in a single confirmation.** `ExitPlanMode` can carry a host-validated TaskGrant: frozen directory roots, an explicit reviewed tool scope, expiry, and hard budgets (default 128 turns / 2 h / 512 tool calls / $10 estimated model cost). Read/search scope works on macOS and Linux; on **Linux** a coding task can additionally produce **patch-only edits** in a disposable shadow workspace (clean completion seals a `manifest.json` + content-addressed blobs — the real workspace is never touched) and run **sandboxed offline Cargo build/test** (`BuildTest`: cgroup v2, cleared environment, no network; requires explicit operator provisioning). Everything unprovable stays fail-closed, and ordinary Auto/manual behavior is completely unchanged.
- **Auto mode stops prompting on read-only tools.** A fixed allow-list (Read/Grep/Glob/LSP, task/TODO orchestration, MCP resource reads, …) is checked before the safety classifier — so it keeps working even when the classifier can't be reached — and two bugs that made auto mode fall closed on Codex/OpenAI providers are fixed (classifier output cap 256 → 2048 tokens; forced-High reasoning effort → Low).
- **Tool loading parity, cheaper requests.** Tool schemas are stably sorted by name (restores prompt-cache hits on the tools block); dynamic discovery (`ToolSearch`) gained full OpenAI-Responses support (MCP namespace coalescing + BM25 deferred-tool search); `--disallowed-tools` entries can no longer be re-added by discovery; the `LSP` tool (renamed from `Lsp`) is deferred by default; and MCP tools no longer 400 on OpenAI Responses (JSON-Schema lowering to the Responses subset).
- **Image generation through the membership gateway no longer times out.** Both the client and the gateway relay now use a dedicated 250 s image HTTP client (was the 120 s SSE client, which cut off long renders as a `502`), and the relay automatically retries transient upstream transport failures.
- **New TUI.** **Shift+Tab** cycles the permission mode (`default → acceptEdits → plan`); **Ctrl+T** opens a persistent Tasks panel; **Ctrl+B** sends running foreground Bash/Agents to the background with session-resident completion notices. AskUserQuestion "Other" answers are now typed inline in the option row (fixes custom text disappearing after Enter), and modal panels match key+modifier exactly (Ctrl/Alt+Enter can no longer confirm a destructive action).
- **Reliability.** `/rewind` uses one consistent restore-and-truncate path across teammate panes and headless runs; `exec --json` / `--stream` stdout is completely free of renderer output; idle compaction is no longer suppressed across concurrent agents; background-agent completion notices are delivered exactly once to the right recipient.

**Platforms:** macOS (Apple Silicon / Intel / universal), Linux (x64 / arm64, musl-static), Windows (x64). Verify downloads against `SHA256SUMS`.
