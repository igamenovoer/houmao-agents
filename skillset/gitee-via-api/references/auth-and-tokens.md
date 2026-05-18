# Auth And Tokens

Use this reference to resolve a Gitee access token, validate it safely, and understand the OAuth flow for API v5.

## Token Resolution

Prefer this order:

1. Token explicitly provided by the user for the current task.
2. `GITEE_ACCESS_TOKEN` from the environment.
3. Ask the user for a token or guide them through OAuth.

Check environment presence without printing the token:

```bash
python3 - <<'PY'
import os
token = os.environ.get("GITEE_ACCESS_TOKEN")
if token:
    print(f"GITEE_ACCESS_TOKEN is set, length={len(token)}, prefix={token[:4]}...suffix={token[-4:]}")
else:
    print("GITEE_ACCESS_TOKEN is not set")
PY
```

## Validate Token

Use a read-only user call:

```bash
python3 - <<'PY'
import os, requests
token = os.environ["GITEE_ACCESS_TOKEN"]
r = requests.get("https://gitee.com/api/v5/user", params={"access_token": token}, timeout=20)
print("status", r.status_code)
data = r.json()
if r.status_code == 200:
    print("login", data.get("login"))
    print("name", data.get("name"))
    print("html_url", data.get("html_url"))
else:
    print("message", data.get("message") or data)
PY
```

Do not print the token. If a token has appeared in chat or logs, recommend revoking or rotating it after testing.

## OAuth Flow

Create a Gitee OAuth application and record:

- `client_id`
- `client_secret`
- `redirect_uri`

Request authorization:

```text
https://gitee.com/oauth/authorize?client_id=CLIENT_ID&redirect_uri=REDIRECT_URI&response_type=code&scope=user_info%20projects&state=RANDOM_STATE
```

Exchange the returned `code`:

```bash
curl -X POST "https://gitee.com/oauth/token" \
  -d "grant_type=authorization_code" \
  -d "code=AUTH_CODE" \
  -d "client_id=CLIENT_ID" \
  -d "client_secret=CLIENT_SECRET" \
  -d "redirect_uri=REDIRECT_URI"
```

Refresh when needed:

```bash
curl -X POST "https://gitee.com/oauth/token" \
  -d "grant_type=refresh_token" \
  -d "refresh_token=REFRESH_TOKEN"
```

Recommended starting scopes for private repo access:

- `user_info`
- `projects`

Add narrower task scopes when needed, such as `pull_requests`, `issues`, `notes`, `groups`, or `enterprises`.

## Common Authentication Failures

- `401`: missing, invalid, or expired token.
- `403`: token is valid but lacks permission or scope.
- `404`: repo path is wrong, or private repo is invisible to this token.

OAuth grants only the permissions of the authorizing Gitee user.
