# Repository Contents

Use this reference to read, create, update, or delete files through Gitee API v5.

## Read Contents

Endpoint:

```text
GET /v5/repos/{owner}/{repo}/contents(/{path})
```

Read a file:

```bash
python3 - <<'PY'
import base64, os, requests
owner = "OWNER"
repo = "REPO"
path = "path/to/file"
token = os.environ["GITEE_ACCESS_TOKEN"]
r = requests.get(
    f"https://gitee.com/api/v5/repos/{owner}/{repo}/contents/{path}",
    params={"access_token": token},
    timeout=20,
)
print("status", r.status_code)
data = r.json()
if r.status_code == 200 and data.get("encoding") == "base64":
    print(base64.b64decode(data["content"]).decode("utf-8", errors="replace"))
else:
    print(data)
PY
```

Record the returned `sha` before updating or deleting a file.

## Create File

Endpoint:

```text
POST /v5/repos/{owner}/{repo}/contents/{path}
```

Required form fields:

- `access_token`
- `content`: base64-encoded file content
- `message`: commit message

Optional form fields:

- `branch`
- `committer[name]`, `committer[email]`
- `author[name]`, `author[email]`

Python pattern:

```bash
python3 - <<'PY'
import base64, os, requests
owner = "OWNER"
repo = "REPO"
path = "path/to/new-file.md"
branch = "main"
message = "Add new file"
content = "# New file\n"
token = os.environ["GITEE_ACCESS_TOKEN"]
r = requests.post(
    f"https://gitee.com/api/v5/repos/{owner}/{repo}/contents/{path}",
    data={
        "access_token": token,
        "content": base64.b64encode(content.encode()).decode(),
        "message": message,
        "branch": branch,
    },
    timeout=30,
)
print("status", r.status_code)
print(r.json())
PY
```

## Update File

Endpoint:

```text
PUT /v5/repos/{owner}/{repo}/contents/{path}
```

Required form fields:

- `access_token`
- `content`: base64-encoded replacement content
- `sha`: current file blob SHA from the read API
- `message`: commit message

Optional form fields are the same as create.

Do not update blindly. Read the file first, preserve or intentionally modify content, then submit the current `sha`.

## Delete File

Endpoint:

```text
DELETE /v5/repos/{owner}/{repo}/contents/{path}
```

Required query fields:

- `access_token`
- `sha`: current file blob SHA
- `message`: commit message

Optional query fields:

- `branch`
- `committer[name]`, `committer[email]`
- `author[name]`, `author[email]`

Confirm exact path and branch before deleting.
