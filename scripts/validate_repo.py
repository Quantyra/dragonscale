from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "LICENSE",
    "NOTICE",
    "SECURITY.md",
    "CONTRIBUTING.md",
    "SUPPORT.md",
    "deploy/docker-compose.traefik.yml",
    "deploy/.env.example",
    "config/headscale.config.example.yaml",
    "config/acl.hujson",
    "docs/google-oauth.md",
    "docs/operations.md",
    "docs/cutover.md",
    "docs/kuzuryu-private-access.md",
    "scripts/render-config.ps1",
]

FORBIDDEN_PATTERNS = [
    re.compile(r"DRAGONSCALE_OIDC_CLIENT_SECRET=(?!replace-)[A-Za-z0-9_\-]{12,}"),
    re.compile(r"client_secret['\"]?\s*[:=]\s*['\"][A-Za-z0-9_\-]{12,}", re.IGNORECASE),
    re.compile(r"BEGIN (RSA|OPENSSH|EC|PRIVATE) KEY"),
]


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    for relative_path in REQUIRED_FILES:
        path = ROOT / relative_path
        if not path.exists():
            fail(f"missing required file: {relative_path}")
        if path.is_file() and path.stat().st_size == 0:
            fail(f"empty required file: {relative_path}")

    for path in ROOT.rglob("*"):
        if not path.is_file() or ".git" in path.parts:
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for pattern in FORBIDDEN_PATTERNS:
            if pattern.search(text):
                fail(f"possible secret in {path.relative_to(ROOT)}")

    compose = (ROOT / "deploy/docker-compose.traefik.yml").read_text(encoding="utf-8")
    if "headscale/headscale:v0.28.0" not in compose:
        fail("compose file must pin headscale/headscale:v0.28.0")
    if "orchestrator_default" not in compose:
        fail("compose file must attach to existing Kuzuryu Traefik network")

    config = (ROOT / "config/headscale.config.example.yaml").read_text(encoding="utf-8")
    for expected in [
        "https://accounts.google.com",
        "allowed_users",
        "dragonscale.kuzuryu.ai",
        "policy:",
    ]:
        if expected not in config:
            fail(f"Headscale config missing {expected}")

    print("Dragonscale repository validation passed.")


if __name__ == "__main__":
    main()
