# Issues And Pull Requests

Use this reference to list and create Gitee issues or pull requests through API v5.

## Issues

List repository issues:

```text
GET /v5/repos/{owner}/{repo}/issues
```

Useful query parameters:

- `access_token`
- `state`: `open`, `progressing`, `closed`, `rejected`; default `open`
- `labels`: comma-separated labels
- `sort`: `created` or `updated_at`
- `direction`: `asc` or `desc`
- `since`: ISO 8601 timestamp
- `milestone`: milestone title, `none`, or `*`
- `assignee`: username, `none`, or `*`
- `creator`: username
- `q`: search keyword
- `page`, `per_page` up to `100`

Example list:

```bash
python3 - <<'PY'
import os, requests
owner = "OWNER"
repo = "REPO"
token = os.environ["GITEE_ACCESS_TOKEN"]
r = requests.get(
    f"https://gitee.com/api/v5/repos/{owner}/{repo}/issues",
    params={"access_token": token, "state": "open", "page": 1, "per_page": 100},
    timeout=20,
)
print("status", r.status_code)
for issue in r.json() if r.status_code == 200 else []:
    print(issue.get("number"), issue.get("state"), issue.get("title"))
if r.status_code != 200:
    print(r.json())
PY
```

Before creating or changing issues, inspect the Swagger operation for the exact required fields because Gitee issue schemas can vary by repo/enterprise configuration.

## Pull Requests

List pull requests:

```text
GET /v5/repos/{owner}/{repo}/pulls
```

Useful query parameters:

- `state`
- `head`: source branch, either `branch` or `username:branch`
- `base`: target branch
- `sort`
- `since`: ISO 8601 timestamp
- `direction`
- `milestone_number`
- `labels`
- `author`
- `assignee`
- `tester`
- `page`, `per_page` up to `100`

Create pull request:

```text
POST /v5/repos/{owner}/{repo}/pulls
formData: title, head, base, body?, labels?, assignees?, testers?, draft?, squash?, ...
```

Gitee's Swagger listing for pull requests does not show `access_token` in the extracted parameter list for this operation, but authenticated calls still require a token for private repos. Use the same token pattern and verify against the live endpoint.

Example list:

```bash
python3 - <<'PY'
import os, requests
owner = "OWNER"
repo = "REPO"
token = os.environ["GITEE_ACCESS_TOKEN"]
r = requests.get(
    f"https://gitee.com/api/v5/repos/{owner}/{repo}/pulls",
    params={"access_token": token, "state": "open", "page": 1, "per_page": 100},
    timeout=20,
)
print("status", r.status_code)
for pr in r.json() if r.status_code == 200 else []:
    print(pr.get("number"), pr.get("state"), pr.get("title"))
if r.status_code != 200:
    print(r.json())
PY
```

For creating PRs, confirm `owner/repo`, `head`, `base`, and title before execution.
