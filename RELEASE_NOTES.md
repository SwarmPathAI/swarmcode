## swarmcode v0.5.2

Quality-of-life release for the pinned status bar and clean exit.

- **Resize-adaptive status bar**: the pinned bottom bar now reflows to the new terminal width/height the moment you resize the window — even while it's waiting for input. Previously only the top scrollback reflowed and the bottom bar stayed clipped at the old width until the next turn.
- **Instant model switch**: after `/model`, the bottom bar reflects the new model immediately instead of waiting for the next turn to run.
- **Fully clean exit**: `/exit` and Ctrl+D now leave a completely blank screen (no lingering goodbye line). Your session is still saved — recover it anytime with `swarmcode resume`.

**Install / Update**

```bash
# new install:
curl -fsSL https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.sh | bash
# already installed:
swarmcode update
```

`darwin-universal` runs on Apple Silicon and Intel Macs. Verify downloads against `SHA256SUMS`.
