// Downloads the prebuilt swarmcode binary for this platform on npm install.
const { execFileSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const REPO = process.env.SWARMCODE_REPO || "SwarmPathAI/swarmcode";

function label() {
  if (process.platform === "darwin") return "darwin-universal";
  if (process.platform === "linux")
    return process.arch === "arm64" ? "linux-arm64" : "linux-x64";
  console.error(`swarmcode: unsupported platform ${process.platform}`);
  process.exit(1);
}

const url = `https://github.com/${REPO}/releases/latest/download/swarmcode-${label()}.tar.gz`;
const dir = path.join(__dirname, "dist");
fs.mkdirSync(dir, { recursive: true });
const tarball = path.join(dir, "swarmcode.tar.gz");

console.log(`swarmcode: downloading ${url}`);
execFileSync("curl", ["-fsSL", url, "-o", tarball], { stdio: "inherit" });
execFileSync("tar", ["-xzf", tarball, "-C", dir], { stdio: "inherit" });
fs.rmSync(tarball, { force: true });
fs.chmodSync(path.join(dir, "swarmcode"), 0o755);
try {
  execFileSync("xattr", ["-d", "com.apple.quarantine", path.join(dir, "swarmcode")], { stdio: "ignore" });
} catch (_) {}
console.log("swarmcode: installed — run `swarmcode model` to configure a channel");
