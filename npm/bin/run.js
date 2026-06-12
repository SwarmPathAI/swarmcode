#!/usr/bin/env node
// Thin launcher: exec the platform binary downloaded by install.js.
const { spawnSync } = require("child_process");
const path = require("path");
const fs = require("fs");

const bin = path.join(__dirname, "..", "dist", "swarmcode");
if (!fs.existsSync(bin)) {
  console.error("swarmcode binary missing — reinstall: npm install -g swarmcode");
  process.exit(1);
}
const r = spawnSync(bin, process.argv.slice(2), { stdio: "inherit" });
process.exit(r.status === null ? 1 : r.status);
