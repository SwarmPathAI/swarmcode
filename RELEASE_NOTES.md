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
