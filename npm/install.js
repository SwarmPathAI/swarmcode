// Downloads the prebuilt swarmcode binary for this platform on npm install.
// Uses Node's built-in fetch (Node 18+) — no curl/wget dependency, so it
// works in slim containers and minimal servers. `tar` is used to unpack and is
// available out of the box on macOS, Linux, and Windows 10+ (bsdtar).
const { execFileSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const REPO = process.env.SWARMCODE_REPO || "SwarmPathAI/swarmcode";
const isWindows = process.platform === "win32";
const BIN_NAME = isWindows ? "swarmcode.exe" : "swarmcode";

function label() {
  if (process.platform === "darwin") return "darwin-universal";
  if (process.platform === "linux")
    return process.arch === "arm64" ? "linux-arm64" : "linux-x64";
  if (isWindows) return "windows-x64";
  console.error(`swarmcode: unsupported platform ${process.platform}`);
  process.exit(1);
}

async function main() {
  const url = `https://github.com/${REPO}/releases/latest/download/swarmcode-${label()}.tar.gz`;
  const dir = path.join(__dirname, "dist");
  fs.mkdirSync(dir, { recursive: true });
  const tarball = path.join(dir, "swarmcode.tar.gz");

  console.log(`swarmcode: downloading ${url}`);
  const res = await fetch(url, { redirect: "follow" });
  if (!res.ok) {
    console.error(`swarmcode: download failed (HTTP ${res.status})`);
    process.exit(1);
  }
  fs.writeFileSync(tarball, Buffer.from(await res.arrayBuffer()));

  execFileSync("tar", ["-xzf", tarball, "-C", dir], { stdio: "inherit" });
  fs.rmSync(tarball, { force: true });

  // chmod is meaningful only on unix; xattr quarantine clearing is macOS-only.
  if (!isWindows) {
    fs.chmodSync(path.join(dir, BIN_NAME), 0o755);
    try {
      execFileSync("xattr", ["-d", "com.apple.quarantine", path.join(dir, BIN_NAME)], { stdio: "ignore" });
    } catch (_) {}
  }

  // L1 default skills: release tarball ships `default-skills/` next to the
  // binary. Sync missing-only into ~/.swarmcode/skills (same as first launch).
  // Best-effort — never fail the npm install if this step errors.
  try {
    const binPath = path.join(dir, BIN_NAME);
    if (fs.existsSync(path.join(dir, "default-skills", "MANIFEST.toml"))) {
      console.log("swarmcode: installing default skills pack…");
      execFileSync(binPath, ["skill", "install-defaults"], {
        stdio: "inherit",
        env: {
          ...process.env,
          // Ensure the pack next to this binary is found even if PATH points
          // at an older swarmcode.
          SWARMCODE_DEFAULT_SKILLS_DIR: path.join(dir, "default-skills"),
        },
      });
    }
  } catch (e) {
    console.warn(
      `swarmcode: default skills sync skipped (${e.message || e}); run \`swarmcode skill install-defaults\` later`
    );
  }

  console.log("swarmcode: installed — run `swarmcode model` to configure a channel");
}

main().catch((e) => {
  console.error(`swarmcode: install failed: ${e.message}`);
  process.exit(1);
});
