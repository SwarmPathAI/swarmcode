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
