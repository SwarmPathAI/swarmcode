## swarmcode v0.7.0

**A reliability-and-parity release: `/compact` overhauled end-to-end, Anthropic prompt caching wired up, and a wide interaction/audit pass fixing ~30 real bugs. All new/changed subsystems are test-green.**

**`/compact` no longer fails on huge sessions, and preserves more of your recent work.** A long-overdue overhaul: (1) if the summarization call itself is too large for the model's window — previously an unrecoverable dead end — swarmcode now sheds the oldest portion of history and retries automatically; (2) the summary itself is no longer capped at a small token budget, so long recaps stop getting truncated; (3) auto-compact now keeps your most recent turns **verbatim** instead of summarizing everything, only condensing the older portion; (4) before compacting, swarmcode also clears out stale tool output (old file reads, command output) that's unlikely to matter anymore — cheaply, without an extra AI call — often avoiding a full compaction altogether; (5) a "thrashing" guard now detects when compaction keeps re-triggering every couple of turns (usually a single huge file/output that doesn't fit) and stops hammering it with a clear diagnosis instead of silently burning tokens forever; (6) the pre-compaction conversation is saved and referenced, so if you or the model need an exact code snippet or error message from before the summary, it's one `/resume` away instead of gone. The resting view also now collapses the summary behind a single line you can expand, instead of dumping the whole recap inline.

**Anthropic prompt caching is now wired up — noticeably cheaper and faster on Claude channels.** swarmcode was computing your full system prompt, tool list, and conversation history from scratch on every single turn. It now marks the stable parts of each request so Anthropic can serve them from cache — repeat turns are billed at roughly a tenth of the input cost for the cached portion, with a faster time-to-first-token too. No configuration needed; opt out with `SWARMCODE_DISABLE_PROMPT_CACHE=1` if you're on a proxy that rejects the caching field.

**Two real "your turn just vanished" bugs, fixed.** (1) If a model produced only internal reasoning with no visible answer and no tool call, that turn used to silently disappear — you'd watch the spinner stop and see nothing happen. swarmcode now detects this, discards the dead turn, and asks the model to try again once before giving up gracefully. (2) A background agent that finished while you were still mid-turn used to only show up in your terminal — the model itself had no idea it was done unless it explicitly checked. Now it's told automatically, the same way backgrounded shell commands and `Monitor` watches already work.

**Retry-After is now honored on rate limits, across every provider.** A 429/503/529 used to always fall back to swarmcode's own backoff timing, ignoring any `Retry-After` the server sent back — meaning you could get rate-limited again while still inside the server's own cooldown window. The server's stated wait time now wins when present.

**A wide interaction-parity audit fixed ~20 more bugs across the fullscreen UI.** Highlights: Esc while a message is queued mid-turn now correctly interrupts the running turn (the queued message fires next) instead of yanking it back into the input box; slash commands typed while a turn is running (like `/model`) now actually execute at the next opportunity instead of being sent to the model as literal text; `/loop` is now fully implemented including open-ended self-paced mode (no fixed interval — the model decides when to check back in) alongside the existing fixed-interval and `loop.md`-driven modes; `/goal` no longer runs one wasted extra round after the goal is already met; a dozen commands (`/add-dir`, `/branch`, `/rename`, `/remember`, `/loop`, and others) had real confirmation messages that flashed and vanished before you could read them; several multi-line info pages (`/lsp`, `/cwd`, `/cost`, and others) were rendering visibly garbled in the fullscreen view; `Ctrl+Z` now genuinely suspends to the shell; `Ctrl+O` in the transcript view now actually expands/collapses tool output as documented; and file-write permission prompts got a proper dialog instead of falling back to raw escaped JSON.

**Switching models or channels mid-session — including DeepSeek ↔ Claude ↔ other providers — no longer risks a broken next turn.** Three wire-format edge cases that could 400 immediately after a cross-provider switch are fixed; `/resume` inherits the fix automatically since it replays the same session history.

**Server hardening.** `swarmcode serve`'s task/session endpoints now refuse to run tools unattended-and-unapproved unless the server was explicitly started with a new `--allow-unattended` flag — a leaked bearer token alone can no longer bypass approval. Task-completion webhooks are checked against a new SSRF guard before firing. Concurrent background tasks are now capped with a configurable queue instead of growing unbounded.

**Also in this release:** a real keybindings system (`/keybindings`, matching Claude Code's config format) and a redesigned tabbed `/help`; `Bash`/`PowerShell` calls now require a one-line description shown in the approval prompt; a new `/commit` command drafts conventional-commit messages from your actual diff; vision/video attachments degrade gracefully on text-only models instead of failing the whole turn; new `--temperature`/`--max-output-tokens` flags for headless/exec runs; `claude-sonnet-5` added to the built-in model table (context size, output limit, pricing) so it gets a proper context gauge and auto-compaction like every other supported model.

## swarmcode v0.6.3

**A capability release: video understanding, a remote async task queue, and ACP over WebSocket — plus AI-native MCP configuration, an experimental-flags registry, and plugin marketplace trust levels. New subsystems are test-green.**

**Video understanding.** You can now hand swarmcode a video and have the model watch it. Drag a clip into the input, `@`-mention it, or paste its path; on a video-capable model (Google Gemini, Moonshot/Kimi, and other providers that accept video) the actual footage is analyzed — on-screen text, UI actions, timestamps — not just the filename. Models without video support degrade gracefully to a clear text placeholder telling you which models can view it. The inline cap is 32 MB by default and configurable with `SWARMCODE_VIDEO_MAX_MB`; larger clips are best handled by trimming or frame sampling (base64 inlining re-sends the whole file each turn).

**Remote async task queue — submit, disconnect, collect later.** `swarmcode serve` gains a fire-and-forget task API: `POST /tasks` accepts a prompt and returns a `task_id` immediately (the connection can drop), the agent runs the whole task **detached in the background**, and `GET /tasks/{id}` returns its status and result whenever you come back — so you can kick off a job from a phone, close the tab, and read the answer later. Tasks are **persisted to disk** and reloaded on startup (7-day retention), so a result survives a server restart; a task caught mid-run reloads as `interrupted`. Each task tracks **live progress** (completed tool steps + the last tool invoked), accepts optional per-task `provider` / `model` / `max_turns`, can POST its result to a completion `webhook`, and denies tool-approval prompts fail-closed when running unattended (pass `dangerously_skip_permissions` for autonomous tool use). `GET /tasks` lists everything; `/health` reports task counts.

**Agent Client Protocol over WebSocket.** `swarmcode acp` can now serve the Agent Client Protocol over the **network**, not just a local stdio subprocess: `swarmcode acp --listen host:port` accepts ACP JSON-RPC over WebSocket (`ws://…`) so a remote or custom client can drive sessions — full per-token streaming, tool cards, permissions, session list/load, and mode/model switching, identical to the stdio transport. Binds `127.0.0.1` by default (a non-loopback bind is warned about, since the agent can run shell commands); an optional `--auth-token` is enforced on the WebSocket handshake (as `Authorization: Bearer <token>` or `?token=<token>`). Dragged/`@`-mentioned files from the client are now resolved cross-platform (POSIX and Windows `file://` paths, spaces, and percent-encoding), and `swarmcode acp -p <provider> -m <model>` pins a channel for the session.

**AI-native MCP configuration.** The agent can now add, remove, and list MCP servers itself from a natural-language request — it writes the standard `.mcp.json` directly, so "connect the Notion MCP server" just works. Mutating changes are gated by the permission engine (they prompt for approval in the default mode and fail closed when there's no approver).

**Experimental-flags registry.** `swarmcode flags` lists opt-in experimental features and their state; each is toggled by an environment variable (with a master switch), keeping in-progress capabilities discoverable without exposing them by default.

**Plugin marketplace trust levels.** Installing a plugin or adding a marketplace now shows a trust tag — **official**, **local**, or **third-party** — with an advisory for third-party sources, so you can see at a glance where code you're about to run comes from. Registered-name squatting of official plugins continues to be blocked.

**Stability & interaction hardening.** A carpet audit of the TUI/interaction seams surfaced and fixed 20+ real bugs (full suite green). Highlights: a **CJK `@`-mention crash** is gone (an ideographic space before a mention no longer panics the whole TUI on repaint); wide/CJK characters no longer overflow the live input row; **model resolution is unified** across the REPL / exec / serve / ACP paths, so a custom-proxy shorthand or a `[1m]` long-context marker no longer gets rejected on the first turn; the resting fullscreen composer now honors **vim mode**, **Ctrl+Z undo/redo**, and multi-line **paste** — consistent with the inline and streaming editors (and a vim `Esc` never wipes a queued draft); `/reload-skills` and `/cd` re-recognize custom commands; `/permissions mode plan` stays in sync with `/plan`; bare status commands (`/provider`, `/experiments`, …) no longer flash-and-vanish in fullscreen; **lifecycle hooks** (SessionStart / UserPromptSubmit / Stop / SessionEnd) now fire on the serve / ACP / stream-json paths; and unattended async tasks can be **spend-capped**.

## swarmcode v0.6.2

**A focused TUI fix release.**

**Command output no longer flashes and vanishes.** The pinned bottom status bar reserves its rows with a VT100 scroll region — and a command that printed more lines than the scrollable area (`/help`, `/mcp`, `/context`, `/cost`, a `!cmd` bang, …) had its overflow discarded by that region instead of going to the terminal's scrollback, so long output "flashed once, then was gone". Resting-prompt output is now released to the full screen before it prints (the pinned bar re-arms right after), so every line lands in real, scroll-backable history. Covers all slash commands, `!cmd` bangs, `#` quick-add, and post-fullscreen rewind/summarize reports.

**`/mcp` with no servers is helpful, not blank.** Instead of an all-but-empty panel, `/mcp` now shows a short guide — how to add a stdio or URL server, where to point `swarmcode mcp --help`, and how to troubleshoot with `/mcp reconnect` if you expected servers to be there.

## swarmcode v0.6.1

**A hardening + correctness release on top of v0.6.0: a security pass plus ~40 fixes across the editor, hooks, settings, project instructions, headless CLI, tools, MCP, skills, and sessions. Fully test-green (2200+ tests, 0 failures).**

**Security hardening.** `apiKeyHelper` (a shell command) is no longer adopted from a repo-supplied `settings.json` — only your own config, the `--settings` flag, and admin policy may set it, so cloning a hostile repo can't run an arbitrary helper command. The `availableModels` organization allowlist is now enforced at every explicit model selection (`--model` / `/model` / headless). A pre-tool hook's rewritten input is re-evaluated against the deny rules, so a hook can't turn an approved call into a denied one. Custom-command `!cmd` bangs now honor Bash deny rules and run inside the OS sandbox when it's enabled. MCP OAuth requires `https` for every discovered metadata/token endpoint; extension bundles are metered by their **actual** decompressed size (zip-bomb-proof); HTTP hooks require `https` (loopback aside) and cap the response body; spilled hook/tool output files are owner-only (`0600`) and pruned.

**Rewind data-safety.** `/rewind` and summarize now purge stale file-history checkpoints, so a later code rewind can't silently restore over the edits you chose to keep.

**Vim correctness.** Fixes to `d3w` counts, find-in-visual (`vfa`), failed-motion register preservation, `diw` on whitespace, mid-turn `Ctrl+R`, coalesced `3dd` undo, and empty-register / empty-buffer edge cases (no more panics).

**Headless budget + robustness.** `--max-budget-usd` is now a **cumulative** cap across `--goal` / structured-output-retry turns (not reset each turn); an unpriced model warns instead of silently ignoring the cap; per-command tool grants no longer leak across turns in headless (`--print` / SDK) runs.

**Tools + instructions.** WebFetch no longer caches a redirect target's error page as success; the auto-compact window has a floor that prevents compaction thrash; the advisor tool is cancellable; nested / path-scoped project-instruction files honor the external-import approval prompt and exclusion list; an unterminated HTML comment no longer deletes the rest of an instruction file; teammate names/tasks are sanitized against terminal-control injection; `/copy --write` never overwrites an existing file.

## swarmcode v0.6.0

**A full-spectrum capability sweep — ~160 additions and enhancements across the editor, permissions, MCP, subagents, skills, settings, memory, hooks, the status line, tools, sessions, and CLI/headless. All test-green (1600+ unit tests, 0 failures).** Highlights:

**Vim editing mode (fullscreen input box).** `/vim` enables a full vim subset: NORMAL/INSERT with a bottom `-- NORMAL --`/`-- INSERT --` status line; motions `h j k l w b e 0 ^ $`, find-char `f/F/t/T` + `; ,`, `gg`/`G`; operators `d c y` + `dd cc yy`, operator+motion (`dw d$ cb …`), text objects (`iw aw i" i( …`); count prefixes (`3w`/`2dd`); a **VISUAL mode** (`v`/`V` char/line selection + operators); `p`/`P` paste, `u` undo, `.` repeat, `J` join, `>>`/`<<` indent. Plus an emacs kill-ring (`Ctrl+Y`/`Alt+Y`), `Ctrl+Z`/`Ctrl+Y` undo/redo, `Ctrl+S` draft-stash, `Ctrl+X Ctrl+E` external editor, and `Ctrl+R` reverse history search with scope cycling.

**Permission engine expansion.** A `dontAsk` default mode (auto-deny unmatched) and `disableAutoMode` policy veto; rule syntax gains `Cd(...)`, `Agent(name)`, `Skill(name)`, `Tool(param:value)` parameter matching, and tool-name-position globs (`*`/`mcp__*`/`B*`); file tools evaluate the **symlink target**, distinguish `//abs` vs `/project-root` anchoring, and normalize secret-deny paths; `acceptEdits` auto-allows common in-workspace filesystem commands; plus a set of managed-policy killswitches.

**MCP transports & auth.** First-class **WebSocket (ws) transport** and streamable-http; **OAuth** (interactive login, pinned scopes + metadata-URL override, insufficient-scope re-auth); dynamic auth headers via a helper; **desktop-extension (`.mcpb`) install**; `--mcp-config`/`--strict-mcp-config` flags; `@server:resource` mentions; per-server timeouts, per-tool result budgets, per-call idle abort, and an output-token cap.

**CLI / headless / scripting.** A canonical `result` envelope (`is_error`/`total_cost_usd`/`type`/`subtype`) and SDK-shaped stream-json envelopes; new `--verbose`, `--settings`/`--setting-sources` layering, **`--bare` fast-start**, **`--json-schema` structured output**, **`--max-budget-usd` spend cap**, `--agents` (ephemeral session-only subagents), `--no-session-persistence`, `--prompt-suggestions`, `--replay-user-messages`, `--include-hook-events`, and `--init`/`--maintenance` lifecycle entrypoints.

**Subagents & model config.** Model family aliases (`sonnet`/`opus`/`haiku`/`fable`) + `inherit`; interactive `/agents` create/edit/delete; per-agent memory/mcpServers/effort frontmatter scoping; an org model allowlist; a nested-spawn `(+N)` tree; teammates inherit the lead's effort/model; custom per-teammate status rows.

**Skills, custom commands & output styles.** Nested on-demand skill discovery + dir-qualified names (`apps/web:deploy`); skill placeholders; per-skill visibility overrides and a listing budget; custom-command `model` frontmatter, `!bash`/`@file` in command bodies, single-turn tool grants, and model-invocable `.md` commands; argument hints; `/output-style` picker + generator + built-in styles.

**Config, settings, memory & hooks.** A `/config` unified settings command with a non-interactive `key=value` setter; layered `settings.json` (model/fallbackModel/outputStyle/language/env precedence), an API-key helper with TTL cache, and an OS-level policy tier; quick-add memory, `.local` and nested project instructions, path-scoped rules; richer hook matchers, payloads, a canonical notification taxonomy, and killswitches.

**Status line, notifications & tools.** A greatly expanded statusLine JSON (cost/effort/thinking/session/worktree/prompt-id and more), an effort indicator, a periodic refresh, and a selectable notification channel; Bash oversized-output spill-to-file, WebFetch sub-LLM processing, WebSearch domain filters, and file-read line caps.

**Sessions & rewind.** `/rewind` conversation-only/code-only/both modes with summarize-from/up-to; a previous-session recovery entry; type-to-search `/resume`; new `/recap`, `/release-notes`, `/copy`, `/btw`, and `/plan`; a `/terminal-setup` installer for Shift+Enter and editor integration.

## swarmcode v0.5.5

**OS-level sandboxing, native Windows support, and a sweep of TUI fixes.** Every item audited end-to-end (whole-workspace build + lint clean + full test suite green).

**OS-level Bash sandbox — multi-tenant filesystem isolation (new `sc-sandbox` crate).** The Bash tool can now run confined inside an OS sandbox: **bubblewrap on Linux, Seatbelt (`sandbox-exec`) on macOS**. Writes are limited to the workspace + the agent's own HOME, **sibling tenants' directories are masked with a tmpfs** (invisible, not merely unreadable), `.git/hooks` + `.git/config` are forced read-only (hook-injection escape guard), and **network is denied by default**. This closes the cross-tenant read hole when many users share one host. **Feature-flag, default-off**: enable via a config `sandbox` block or per-spawn env (`SWARMCODE_SANDBOX=1` + `SWARMCODE_SANDBOX_HIDE=…`); with it off, Bash is byte-identical to before. Sandbox params come from the **parent (env), never the child-writable config**, so a confined agent can't widen its own jail. Verified **8/8 end-to-end on real `bwrap`**.

**Windows support — swarmcode now compiles & runs on Windows.** A new **PowerShell tool** (`pwsh` → `powershell`, `-NoProfile -NonInteractive -Command`) replaces the Bash tool on Windows, with a conservative deny-by-default read-only classifier; the permission engine recognises `PowerShell(…)` rules exactly like `Bash(…)`. Distribution gained a **PowerShell installer** (`irm …/install.ps1 | iex`, installing to `~/.local/bin` like macOS/Linux), an npm `win32` branch, and an `x86_64-pc-windows-msvc` release target.

**`swarmcode -v` prints the version.** `-v`, `-V`, and `--version` all print the version now — `swarmcode -v` no longer errors with "unexpected argument".

**Agent-teams — live display + keyboard control.** Teammates render with a **stable per-name color** in a single unified live **"Agent Team"** panel (status · last-tool · iter/tok counts, idle rows capped with "+N more"), and a summoned **`/teammates`** panel lets you, from the keyboard, **view a teammate's transcript, send it a message** (auto-resuming a finished one via the mailbox/resume path), or **stop** it.

**Mouse-report leak / flicker fixed in confirm prompts.** With the fullscreen TUI's any-motion mouse tracking on, the Bash write-confirm and the permission prompt used to strobe and leak raw `ESC[<…M` SGR bytes as visible text on every mouse move. Both prompts (and the `AskUserQuestion` picker) now **suspend mouse reporting for their lifetime**, restored on drop.

**Request-failure handling.** A failed turn now shows the **real API error** (e.g. the proxy's `401`) instead of a bare `[Request failed]`, does **not** clear the screen, and **prefills the failed message** back into the input box so you can fix the cause (e.g. a bad key via `/model`) and press Enter to retry.

**Terminal & TUI polish.** Mouse drag-to-select with copy in the streaming view; terminal tab-title status (working / done), taskbar progress indicator, and an optional completion notification; message timestamps, rotating input tips, a reduce-motion accessibility toggle, and an optional external diff tool (`git difftool`) — all configurable.

**Install / Update**

```bash
# new install (macOS / Linux):
curl -fsSL https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.sh | bash
# Windows (PowerShell):
irm https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.ps1 | iex
# already installed:
swarmcode update
```

`darwin-universal` runs on Apple Silicon and Intel Macs. Linux x64/arm64 are static (musl) — zero-dependency, run on any distro. Windows ships `swarmcode.exe` (x64). Verify downloads against `SHA256SUMS`.
