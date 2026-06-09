# Operations

## Deployment Target

Initial deployment target:

- AWS account: CYINT account `485386182336`
- EC2 public host: `18.210.131.61`
- Host role: existing Kuzuryu Traefik edge
- Public DNS: `dragonscale.kuzuryu.ai`
- Mesh DNS suffix: `mesh.dragonscale.internal`

## Private State

Keep these outside the public repo:

- OAuth client secret
- Headscale SQLite database
- Headscale noise private key
- production `.env`
- host-specific compose overrides

Recommended host paths:

```text
/opt/dragonscale/config
/opt/dragonscale/data
```

## Deploy

```bash
cd /opt/dragonscale/src
docker compose --env-file /opt/dragonscale/.env -f deploy/docker-compose.traefik.yml up -d
```

## Inspect

```bash
docker logs dragonscale-headscale --tail=100
docker exec dragonscale-headscale headscale users list
docker exec dragonscale-headscale headscale nodes list
```

## Add a User

1. Add the user's email to the private Headscale config `oidc.allowed_users`.
2. Restart Headscale.
3. Have the user run the Tailscale client with the login server:

```bash
tailscale up --login-server=https://dragonscale.kuzuryu.ai
```

## Remove a Device

```bash
docker exec dragonscale-headscale headscale nodes list
docker exec dragonscale-headscale headscale nodes delete --identifier <node-id>
```
