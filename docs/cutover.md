# Tailscale Cutover

Dragonscale must roll out in parallel with Tailscale until private Kuzuryu access is verified.

## Cutover Order

1. Deploy Dragonscale at `https://dragonscale.kuzuryu.ai`.
2. Register Dan's laptop.
3. Register the Kuzuryu host.
4. Verify laptop-to-Kuzuryu private service access over Dragonscale.
5. Register the Hawaii Surface.
6. Add Noah after his exact Google account is confirmed.
7. Move `orchestrator.kuzuryu.ai` from the old Tailscale IP to the Dragonscale address only after validation.
8. Keep Tailscale installed but deprioritized until one full operating day passes without access issues.

## Rollback

If Dragonscale fails:

- leave `orchestrator.kuzuryu.ai` on the current Tailscale address
- keep public `kuzuryu.ai` and `boards.kuzuryu.ai` unchanged
- stop the Dragonscale container
- preserve `/opt/dragonscale/data` for analysis

## Completion Criteria

- Dan laptop can authenticate through Google OAuth.
- Kuzuryu host appears in `headscale nodes list`.
- Hawaii Surface can join and reach the private Kuzuryu service.
- Unauthorized Google account cannot join.
- Tailscale is still available as rollback.
