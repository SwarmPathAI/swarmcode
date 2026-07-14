## swarmcode v0.9.2

Self-update fixes for package-manager and Windows installs.

- **`swarmcode update` works on npm / Homebrew installs again.** v0.8.0 added a guard that hard-refused to self-update a package-manager-managed install; it's now a warning, not a refusal — the binary updates in place (pre-v0.8.0 behavior), with a note that the manager may report a stale version.
- **`swarmcode update` works on Windows.** The updater had no `windows/x86_64` case (bailed `no prebuilt binary for windows/x86_64`) and looked for `swarmcode` instead of `swarmcode.exe` in the archive. Both fixed.
- **Correct package-manager hints** — npm hint now uses the scoped `@swarmpathai/swarmcode`; Homebrew hint drops the erroneous `--cask` (it's a formula).

> Note: updating **from** v0.9.1 to v0.9.2 still uses the old (v0.9.1) updater, so npm-installed machines need one more `npm install -g @swarmpathai/swarmcode@latest`; from v0.9.2 onward `swarmcode update` works everywhere.

---

## swarmcode v0.9.1

A follow-up to the v0.9.0 membership gateway: member self-service, painless gateway migration, and a chat-input fix.

- **`swarmcode member me`** — a member sees **their own** quota/usage from their own machine: it signs `GET /membership/me` with the local device key and prints `used / limit (remaining) · today · last-30d · expires · status`. Own record only, no admin token needed — the admin's `member list --watch` stays the roster-wide view.
- **`swarmcode member set-gateway <url>`** — repoint an existing membership at a new gateway URL **without re-joining**. Keeps the member id + device key (quota / usage / device-binding preserved); only the URL changes. This is the smooth path when the admin fronts the gateway with HTTPS — members run `swarmcode member set-gateway https://gw.example.com` once. New members get TLS from the start via `--gateway https://gw.example.com` at issue time.
- **Fix — a chat message that begins with `/` and is a filesystem path** (`/Users/…`, `/etc/hosts`, `/usr/local/…`) is now sent as normal chat instead of being rejected as `unknown command`. Real slash-commands, and commands whose *arguments* are paths (`/add-dir /Users/…`), still dispatch.
- **Gateway TLS guidance** — `docs/GATEWAY_DEPLOY.md` §4 (HTTPS reverse proxy) is the recommended production front: members on `https://` (443) are far more reset-resistant on long streaming turns than plain HTTP on an odd port. Proxy the gateway path 1:1 (no rewrite) so the device signature over the request path stays valid.

---

## swarmcode v0.9.0

**Membership gateway — share ONE Codex (or any upstream) subscription with many device-bound members, without handing anyone a copy-pasteable key.**

A self-hosted, self-contained way to let a team share one authorized upstream through swarmcode itself — no separate platform, no database. The admin runs the gateway; members are provisioned with one-time activation codes, bind a local device key, and thereafter authenticate every request by signing it. There is no shared secret to forward to a non-member. All state is local JSON under `~/.swarmcode/gateway/`. See **docs/GATEWAY_DEPLOY.md** + **docs/GATEWAY_MEMBER_MANAGEMENT.md**.

**Admin** — `swarmcode member add <name> --quota 10m --expires 30d --max-devices 1 [--models gpt-5.6-sol,gpt-5.5] --gateway https://gw.example.com` issues a one-time `swarmcode join scact_…@https://gw.example.com` line carrying that member's own token quota, validity, device cap, rate limit, and **model allow-list**. `swarmcode member list --watch` is a live roster (usage / quota / status / expiry, 2s refresh); `disable` / `enable` / `set-quota` / `revoke-device` / `rm` take effect immediately (the gateway never caches). An optional `pricing.json` adds a `$used / $limit` column.

**Member** — install swarmcode, run `swarmcode join scact_…@https://gw.example.com` once. The client generates an **Ed25519 device keypair** (private key in a 0600 file, never sent, never in `config.json`), registers only the public key, and writes a `membership` channel. From then on plain `swarmcode` shares the admin's upstream. No API key is stored; access is bound to that machine — copying the config to another machine gets a non-member nowhere (the signature fails), and `max-devices` + revocation bound resale.

**Transparent parity** — the membership channel is a real transparent proxy of the upstream Codex backend: **native web search, image generation, reasoning-effort defaults + the full effort ladder, encrypted-reasoning replay, and `service_tier`** all work identically to a direct Codex login. `swarmcode serve --gateway` relays `POST /v1/responses` (streamed) and `POST /v1/images/generations`, meters each turn's `response.usage` onto the member with quota enforcement (`402` when exhausted), plus per-member rpm limits (`429`), a per-member model allow-list (`403`), and a global upstream-concurrency cap (`SWARMCODE_GATEWAY_MAX_UPSTREAM`, default 2). `--upstream` makes the relayed channel configurable.

**`--gateway-only`** — for a public internet-facing gateway, this enables the membership routes AND closes the session/task agent-driving endpoints entirely, so a leaked admin token can't run tools; only `/health`, `/membership/*`, `/v1/responses`, `/v1/models` and `/v1/images/generations` remain.

**Honest limits (documented, not hidden):** device binding stops copying the credential to another machine; it cannot stop a member proxying from their own bound machine, and sharing one subscription among many people may violate the upstream's terms of service (ban risk — the gateway's concurrency/rate caps reduce, but don't remove, exposure). Hardware-backed keys (Secure Enclave / TPM) are planned, not yet shipped.

New subcommands: `swarmcode member …` (admin), `swarmcode join <code>` (member), `swarmcode serve --gateway[-only]` (gateway).
