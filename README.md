# Dragonscale

Dragonscale is an open-source deployment kit for running a self-hosted WireGuard mesh with Headscale as the control plane.

Dragonscale does not implement cryptography or a VPN protocol; it packages and documents an opinionated Headscale deployment with Google OAuth onboarding, private service access, and a Tailscale-compatible rollback path.

## Status

Initial release target: `v0.1.0`.

Day-one goals:

- deploy Headscale at your domain of choice
- authorize only explicit Google accounts
- connect an operator laptop, the control-plane host, and a secondary client device
- keep Tailscale available until Dragonscale is validated
- keep secrets and production state out of this public repository

## Architecture

- Data plane: WireGuard via Tailscale-compatible clients
- Control plane: Headscale
- Identity: Google OAuth / OIDC
- Edge: Traefik on an existing edge host
- Mesh DNS suffix: `mesh.dragonscale.internal`
- Private service target: internal services over the mesh

## Repository Contents

- `deploy/docker-compose.traefik.yml`: Headscale service behind an existing Traefik edge.
- `config/headscale.config.example.yaml`: safe example Headscale configuration.
- `config/acl.hujson`: minimal day-one policy.
- `docs/`: operating and OAuth runbooks.
- `scripts/`: validation and smoke-test helpers.

## Quick Start

1. Copy `deploy/.env.example` to a private `.env` outside this repository.
2. Create a Google OAuth web client with redirect URI:

   ```text
   https://dragonscale.example.com/oidc/callback
   ```

3. Fill `DRAGONSCALE_OIDC_CLIENT_ID` and `DRAGONSCALE_OIDC_CLIENT_SECRET`.
4. Render the private Headscale config:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts/render-config.ps1 -EnvFile .env -Template config/headscale.config.example.yaml -Output config/config.yaml
   ```

5. Deploy with:

   ```powershell
   docker compose --env-file .env -f deploy/docker-compose.traefik.yml up -d
   ```

6. Validate with:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts/smoke-dragonscale.ps1 -BaseUrl https://dragonscale.example.com
   python scripts/validate_repo.py
   ```

## License

Dragonscale project code and documentation are licensed under AGPL-3.0-only.

Headscale is an upstream dependency licensed under BSD-3-Clause. See `NOTICE`.
