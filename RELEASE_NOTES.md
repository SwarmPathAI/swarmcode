## swarmcode v0.5.3

**A big sweep of interaction + infrastructure upgrades** — every item audited end-to-end (whole-workspace build + lint clean + full test suite green).

**Plan before building.** For non-trivial work the agent now drafts a plan first, then asks for sign-off with a three-way card showing the full plan: *run autonomously*, *approve each edit*, or *tell it what to change*. Pick autonomous and the mode indicator flips instantly.

**Talk to it while it works.** Type during a turn — your text shows live and **Enter queues it** (queued messages stack as visible bubbles above the input, drained at the next safe point so nothing is lost). **Alt+Enter** sends now and interrupts. **Shift+Tab** changes the permission mode mid-turn.

**Resilient generation.** Transient network/API failures now retry **visibly** (`⟳ Retrying in 16s · attempt 6/10`, up to 10 attempts with exponential backoff), and already-streamed text survives a mid-stream hiccup instead of dying.

**A real input box.** `@src/…` file-path completion, `!ls` to run a quick shell command into context, **Ctrl+R** reverse history search (across sessions), **multi-line input** (Shift/Alt+Enter, pastes keep their line breaks), and a live as-you-type **suggestion dropdown** for `/` commands and `@` mentions.

**Sharper diffs.** Deep, readable red/green diff strips with the line-number gutter inside the strip, full syntax highlighting across 60+ languages, and word-level change emphasis that lights up only the token that actually changed. Tool blocks expand per-group on click.

**Rewind code, not just chat.** `/rewind` now snapshots every turn's edited files, so rewinding rolls the files back too. **Double-Esc** opens a picker of earlier messages to edit and resend.

**More tools & automation.** Web fetch now works on every provider; a **Monitor** tool streams per-line events between turns; **`swarmcode cron daemon`** runs scheduled tasks out-of-process; **`swarmcode agent new`** scaffolds an agent profile from the CLI; large screenshots auto-downsample for vision; oversized tool sets defer behind a searchable index to save context.

**Safer by default.** A one-time per-directory **trust gate** before running an untrusted repo's shell/hooks; richer hook controls (allow/ask decisions, input rewriting, project-dir env, transcript path); and a configurable default permission mode with a bypass killswitch.

---

**Earlier in 0.5.3 — smoother streaming + `/goal`.**

- **No more streaming flicker**: the fullscreen turn view repaints are coalesced to ~30fps and presented atomically (Synchronized Update / DEC 2026). Streaming is smooth.
- **`/goal <condition>`** keeps the agent working until the job is *actually* done: after each turn a cheap model checks the transcript for evidence the condition is met, and if not, the agent keeps going (bounded by `goalMaxContinuations`, fail-closed on errors, shown as `🎯 goal` and restored on `swarmcode resume`).

**Install / Update**

```bash
# new install:
curl -fsSL https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.sh | bash
# already installed:
swarmcode update
```

`darwin-universal` runs on Apple Silicon and Intel Macs. Linux x64/arm64 are static (musl) — zero-dependency, run on any distro. Verify downloads against `SHA256SUMS`.
