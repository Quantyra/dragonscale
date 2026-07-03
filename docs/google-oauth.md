# Google OAuth Setup

Create a Google OAuth web client for Dragonscale.

## Required Redirect URI

```text
https://dragonscale.example.com/oidc/callback
```

## Steps

1. Open Google Cloud Console.
2. Go to `APIs and services` -> `Credentials`.
3. Create an OAuth client ID.
4. Choose `Web application`.
5. Add the redirect URI above.
6. Save the client JSON or env fragment under your private local credential root.
7. Keep the public repo free of OAuth secrets.

## Local Credential Root

On an operator workstation, Dragonscale OAuth material can live under a private path such as:

```text
C:\Users\Example\.dragonscale\credentials\google-oauth
```

Use either:

```text
clients\dragonscale-web.json
```

or:

```text
runtime-env\dragonscale.env
```

with:

```text
DRAGONSCALE_OIDC_CLIENT_ID=...
DRAGONSCALE_OIDC_CLIENT_SECRET=...
```

## Day-One Allowlist

Start with:

- `admin@example.com`
- `operator@example.com`

Add additional exact Google accounts after confirmation.

## Notes

Headscale uses the Google issuer:

```text
https://accounts.google.com
```

The public Headscale documentation says Google OAuth clients must include the Headscale callback URL and that Headscale can authorize by explicit email allowlist.
