## swarmcode v0.9.0

**Membership gateway — share ONE Codex (or any upstream) subscription with many device-bound members, without handing anyone a copy-pasteable key.**

A self-hosted, self-contained way to let a team share one authorized upstream through swarmcode itself — no separate platform, no database. The admin runs the gateway; members are provisioned with one-time activation codes, bind a local device key, and thereafter authenticate every request by signing it. There is no shared secret to forward to a non-member. All state is local JSON under `~/.swarmcode/gateway/`. See **docs/GATEWAY_DEPLOY.md** + **docs/GATEWAY_MEMBER_MANAGEMENT.md**.

**Admin** — `swarmcode member add <name> --quota 10m --expires 30d --max-devices 1 [--models gpt-5.6-sol,gpt-5.5] --gateway https://gw.example.com` issues a one-time `swarmcode join scact_…@https://gw.example.com` line carrying that member's own token quota, validity, device cap, rate limit, and **model allow-list**. `swarmcode member list --watch` is a live roster (usage / quota / status / expiry, 2s refresh); `disable` / `enable` / `set-quota` / `revoke-device` / `rm` take effect immediately (the gateway never caches). An optional `pricing.json` adds a `$used / $limit` column.

**Member** — install swarmcode, run `swarmcode join scact_…@https://gw.example.com` once. The client generates an **Ed25519 device keypair** (private key in a 0600 file, never sent, never in `config.json`), registers only the public key, and writes a `membership` channel. From then on plain `swarmcode` shares the admin's upstream. No API key is stored; access is bound to that machine — copying the config to another machine gets a non-member nowhere (the signature fails), and `max-devices` + revocation bound resale.

**Transparent parity** — the membership channel is a real transparent proxy of the upstream Codex backend: **native web search, image generation, reasoning-effort defaults + the full effort ladder, encrypted-reasoning replay, and `service_tier`** all work identically to a direct Codex login. `swarmcode serve --gateway` relays `POST /v1/responses` (streamed) and `POST /v1/images/generations`, meters each turn's `response.usage` onto the member with quota enforcement (`402` when exhausted), plus per-member rpm limits (`429`), a per-member model allow-list (`403`), and a global upstream-concurrency cap (`SWARMCODE_GATEWAY_MAX_UPSTREAM`, default 2). `--upstream` makes the relayed channel configurable.

**`--gateway-only`** — for a public internet-facing gateway, this enables the membership routes AND closes the session/task agent-driving endpoints entirely, so a leaked admin token can't run tools; only `/health`, `/membership/*`, `/v1/responses`, `/v1/models` and `/v1/images/generations` remain.

**Honest limits (documented, not hidden):** device binding stops copying the credential to another machine; it cannot stop a member proxying from their own bound machine, and sharing one subscription among many people may violate the upstream's terms of service (ban risk — the gateway's concurrency/rate caps reduce, but don't remove, exposure). Hardware-backed keys (Secure Enclave / TPM) are planned, not yet shipped.

New subcommands: `swarmcode member …` (admin), `swarmcode join <code>` (member), `swarmcode serve --gateway[-only]` (gateway).
