# Kuzuryu Private Access

Dragonscale exists to expose internal Kuzuryu services over a private mesh while keeping public endpoints stable.

## Public Endpoints That Stay Public

- `https://kuzuryu.ai`
- `https://boards.kuzuryu.ai`

## Private Endpoint Target

- `orchestrator.kuzuryu.ai`

Current DNS evidence before Dragonscale rollout shows `orchestrator.kuzuryu.ai` pointing to a Tailscale address. The Dragonscale cutover should update that record only after the Kuzuryu host is registered and reachable over Dragonscale.

Dragonscale MagicDNS names use the internal suffix:

```text
mesh.dragonscale.internal
```

## Validation

From an enrolled client:

```powershell
tailscale status --login-server=https://dragonscale.kuzuryu.ai
Resolve-DnsName orchestrator.kuzuryu.ai
Invoke-WebRequest https://orchestrator.kuzuryu.ai -UseBasicParsing
```

The private service must not require a public IPv4 allowlist exception for normal operator use.
