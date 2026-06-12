## swarmcode v0.5.1

Quality-of-life release for terminal behavior.

- **Ctrl+Z now suspends cleanly**: the terminal is fully handed back to your shell before suspending (no more striped leftovers / stuck scroll regions); `fg` rebuilds the screen automatically
- **Clean exit**: `/exit` and Ctrl+D clear the screen and leave a single line with your session's resume handle
- **Welcome card**: branded startup banner with version, model, and working directory
- macOS builds now include the `swarmcode update` self-updater (Linux builds already had it)

**Install / Update**

```bash
# new install:
curl -fsSL https://github.com/SwarmPathAI/swarmcode/releases/latest/download/install.sh | bash
# already installed:
swarmcode update
```

`darwin-universal` runs on Apple Silicon and Intel Macs. Verify downloads against `SHA256SUMS`.
