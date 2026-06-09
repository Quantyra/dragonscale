# Google OAuth Setup

Create a Google OAuth web client for Dragonscale.

## Required Redirect URI

```text
https://dragonscale.kuzuryu.ai/oidc/callback
```

## Steps

1. Open Google Cloud Console.
2. Go to `APIs and services` -> `Credentials`.
3. Create an OAuth client ID.
4. Choose `Web application`.
5. Add the redirect URI above.
6. Save the client ID and client secret into the private deployment `.env`.
7. Keep the public repo free of OAuth secrets.

## Day-One Allowlist

Start with:

- `dfredriksen@cyint.technology`
- `daniel.eric.fredriksen@gmail.com`

Add Noah's exact Google account after confirmation.

## Notes

Headscale uses the Google issuer:

```text
https://accounts.google.com
```

The public Headscale documentation says Google OAuth clients must include the Headscale callback URL and that Headscale can authorize by explicit email allowlist.
