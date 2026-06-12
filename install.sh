#!/usr/bin/env bash
# swarmcode installer — downloads the prebuilt binary for your platform.
#   curl -fsSL https://raw.githubusercontent.com/SwarmPathAI/swarmcode/main/install.sh | bash
set -euo pipefail

REPO="${SWARMCODE_REPO:-SwarmPathAI/swarmcode}"
INSTALL_DIR="${SWARMCODE_INSTALL_DIR:-$HOME/.local/bin}"

os=$(uname -s); arch=$(uname -m)
case "$os" in
  Darwin) label="darwin-universal" ;;
  Linux)
    case "$arch" in
      x86_64)         label="linux-x64" ;;
      aarch64|arm64)  label="linux-arm64" ;;
      *) echo "unsupported arch: $arch" >&2; exit 1 ;;
    esac ;;
  *) echo "unsupported OS: $os (macOS / Linux only)" >&2; exit 1 ;;
esac

url="https://github.com/$REPO/releases/latest/download/swarmcode-$label.tar.gz"
echo "Downloading $url ..."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL "$url" -o "$tmp/swarmcode.tar.gz"
tar -xzf "$tmp/swarmcode.tar.gz" -C "$tmp"

mkdir -p "$INSTALL_DIR"
install -m 755 "$tmp/swarmcode" "$INSTALL_DIR/swarmcode"

# macOS Gatekeeper: clear the quarantine bit for a smooth first run.
command -v xattr >/dev/null 2>&1 && xattr -d com.apple.quarantine "$INSTALL_DIR/swarmcode" 2>/dev/null || true

echo "Installed: $INSTALL_DIR/swarmcode"
"$INSTALL_DIR/swarmcode" --version || true

case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *) echo "NOTE: add to PATH →  export PATH=\"$INSTALL_DIR:\$PATH\"" ;;
esac
echo "Get started:  swarmcode model   (configure a channel)   then:  swarmcode"
