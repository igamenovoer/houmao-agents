# Activity And Subscribers

Use this reference for repo activity-style reads, especially listing users who watch a repository.

## List Repository Subscribers

Endpoint:

```text
GET /v5/repos/{owner}/{repo}/subscribers
```

Swagger operation:

```text
getV5ReposOwnerRepoSubscribers
```

Purpose:

```text
List users who watch the repository.
```

Parameters:

- `owner`: required path parameter, repo namespace path.
- `repo`: required path parameter, repo path.
- `access_token`: query parameter; required for private repos.
- `page`: optional, default `1`.
- `per_page`: optional, default `20`, maximum `100`.

Example:

```bash
python3 - <<'PY'
import os, requests
owner = "OWNER"
repo = "REPO"
token = os.environ["GITEE_ACCESS_TOKEN"]
r = requests.get(
    f"https://gitee.com/api/v5/repos/{owner}/{repo}/subscribers",
    params={"access_token": token, "page": 1, "per_page": 100},
    timeout=20,
)
print("status", r.status_code)
data = r.json()
if r.status_code == 200:
    for user in data:
        print(user.get("login"), user.get("name"), user.get("html_url"), user.get("watch_at"))
else:
    print(data.get("message") or data)
PY
```

Expected successful response: an array of user objects with fields such as:

- `id`
- `login`
- `name`
- `avatar_url`
- `url`
- `html_url`
- `type`
- `member_role`
- `watch_at`

## Interpreting Results

- Empty array: endpoint worked but no watchers are returned for that page.
- `403`: token lacks permission.
- `404`: repo path is wrong, inaccessible, or no related data is available.

For private repos, validate with `GET /v5/repos/{owner}/{repo}` before assuming the subscribers endpoint is broken.
