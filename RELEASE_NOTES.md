## swarmcode v0.5.4

**Model & provider setup, overhauled** — plus a handful of input-box fixes. Every item audited end-to-end (whole-workspace build + lint clean + full test suite green).

**A real provider catalog.** `swarmcode model` now opens a **two-tier menu** — the common channels up front, the long tail behind **"More providers…"** — with your currently-active channel always pinned to the top and marked. Provider **base URLs and API-key env vars resolve live from the models.dev registry** (already cached locally), so a freshly-added channel gets the correct endpoint without you typing it, and a known channel never re-asks for a protocol it already knows. New built-in channels: **OpenRouter**, **AI Gateway (Vercel)**, **Nous Portal** (all API-key), plus OpenAI Codex / Copilot ACP listed for reference.

**`/model`, sharper.** It now lists **every usable channel** — any provider whose API-key env var is set, or that you've configured — alongside its models, switchable in place. New **`/model <model> --provider <id>`** flag form jumps straight to a model on a given channel; the `provider/model` shorthand still works.

**Context % for any model.** The context-usage bar resolves the window size for models that aren't in the built-in table by consulting the models.dev catalog — a newly-added model now shows a real **percentage** instead of a dash.

**Keep typing across a turn.** Text you type into the input box **while the agent is working** no longer vanishes when the turn ends — your in-progress draft carries into the next prompt, fully editable. (Enter-queued messages still send as before.)

**Install / Update**

```bash
# new install:
curl -fsSL https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.sh | bash
# already installed:
swarmcode update
```

`darwin-universal` runs on Apple Silicon and Intel Macs. Linux x64/arm64 are static (musl) — zero-dependency, run on any distro. Verify downloads against `SHA256SUMS`.
