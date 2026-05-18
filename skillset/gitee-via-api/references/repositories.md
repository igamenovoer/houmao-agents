# Repository Management

Use this reference for Gitee repository management: listing, discovery, creation, cloning, pulling, metadata inspection, settings updates, branch/tag management, collaborators, deploy keys, hooks, releases, downloads, and destructive repo operations.

For file-level API writes, also load `contents.md`. For pull requests, also load `issues-and-pulls.md`.

## Management Map

| Goal | Preferred operation |
| --- | --- |
| List repos visible to the token | `GET /v5/user/repos` |
| Search public repos | `GET /v5/search/repositories` |
| Inspect one repo | `GET /v5/repos/{owner}/{repo}` |
| Create personal repo | `POST /v5/user/repos` |
| Create org repo | `POST /v5/orgs/{org}/repos` |
| Create enterprise repo | `POST /v5/enterprises/{enterprise}/repos` |
| Update repo settings | `PATCH /v5/repos/{owner}/{repo}` |
| Delete repo | `DELETE /v5/repos/{owner}/{repo}` |
| Clear repo contents | `PUT /v5/repos/{owner}/{repo}/clear` |
| Clone or pull local code | Use `git clone`, `git fetch`, `git pull`; API tokens are for API access and may not work for Git remote auth |
| Download archive | `GET /v5/repos/{owner}/{repo}/tarball` or `GET /v5/repos/{owner}/{repo}/zipball` |
| Read raw file | `GET /v5/repos/{owner}/{repo}/raw/{path}` |
| Read/write API contents | `GET /contents`, `POST /contents/{path}`, `PUT /contents/{path}`, `DELETE /contents/{path}` |
| Multi-file commit | `POST /v5/repos/{owner}/{repo}/commits` |
| Branches and branch protection | `/branches`, `/branches/{branch}/protection`, `/branches/{wildcard}/setting` |
| Tags | `GET /tags`, `POST /tags` |
| Collaborators | `/collaborators` endpoints |
| Deploy keys | `/keys` endpoints |
| Webhooks | `/hooks` endpoints |
| Releases and assets | `/releases` and `/attach_files` endpoints |
| Repo labels, milestones, push rules, reviewers | `/labels`, `/project_labels`, `/milestones`, `/push_config`, `/reviewer` |
| Activity and stats | `/events`, `/contributors`, `/subscribers`, `/traffic-data` |

## Safe Defaults

- Resolve the token from the user or `GITEE_ACCESS_TOKEN`; never print the full token.
- Use `per_page=100` and paginate list endpoints.
- Validate repo access with `GET /v5/repos/{owner}/{repo}` before writes.
- For destructive actions, confirm the exact `owner/repo`, branch/path when relevant, and operation.
- For Git clone/pull, prefer SSH keys or a Git credential helper. Do not embed tokens into remote URLs that will be stored in `.git/config`.

## List Accessible Repos

Endpoint:

```text
GET /v5/user/repos
```

Useful query parameters:

- `access_token`
- `visibility`: `public`, `private`, or `all`
- `affiliation`: `owner`, `collaborator`, `organization_member`, `enterprise_member`, `admin`, comma-separated combinations
- `type`: `owner`, `personal`, `member`, `public`, or `private`; do not combine with `visibility` or `affiliation`
- `sort`: `created`, `updated`, `pushed`, or `full_name`
- `direction`: `asc` or `desc`
- `q`: search keyword
- `page`, `per_page` up to `100`

Python pagination pattern:

```bash
python3 - <<'PY'
import os, requests
token = os.environ["GITEE_ACCESS_TOKEN"]
repos = []
page = 1
while True:
    r = requests.get(
        "https://gitee.com/api/v5/user/repos",
        params={"access_token": token, "page": page, "per_page": 100, "sort": "updated"},
        timeout=30,
    )
    r.raise_for_status()
    batch = r.json()
    if not batch:
        break
    repos.extend(batch)
    if len(batch) < 100:
        break
    page += 1

for repo in repos:
    full = repo.get("full_name") or repo.get("path_with_namespace") or repo.get("human_name") or repo.get("name")
    visibility = "private" if repo.get("private") else "public"
    print(f"{full}\t{visibility}\t{repo.get('updated_at')}")
PY
```

Other listing endpoints:

```text
GET /v5/users/{username}/repos
GET /v5/orgs/{org}/repos
GET /v5/enterprises/{enterprise}/repos
GET /v5/search/repositories
```

## Inspect Repo

Endpoint:

```text
GET /v5/repos/{owner}/{repo}
```

Example:

```bash
python3 - <<'PY'
import os, requests
owner = "OWNER"
repo = "REPO"
token = os.environ["GITEE_ACCESS_TOKEN"]
r = requests.get(f"https://gitee.com/api/v5/repos/{owner}/{repo}", params={"access_token": token}, timeout=20)
print("status", r.status_code)
data = r.json()
if r.status_code == 200:
    print(data.get("full_name"), "private=", data.get("private"), "default_branch=", data.get("default_branch"))
else:
    print(data.get("message") or data)
PY
```

## Create Repos

Personal repo:

```text
POST /v5/user/repos
formData: access_token, name, description?, homepage?, has_issues?, has_wiki?, can_comment?, auto_init?, gitignore_template?, license_template?, path?, namespace?, public?, private?
```

Organization repo:

```text
POST /v5/orgs/{org}/repos
```

Enterprise repo:

```text
POST /v5/enterprises/{enterprise}/repos
```

Minimal personal repo example:

```bash
python3 - <<'PY'
import os, requests
token = os.environ["GITEE_ACCESS_TOKEN"]
r = requests.post(
    "https://gitee.com/api/v5/user/repos",
    data={
        "access_token": token,
        "name": "REPO_NAME",
        "description": "Created via Gitee API v5",
        "private": "true",
        "auto_init": "true",
    },
    timeout=30,
)
print("status", r.status_code)
print(r.json())
PY
```

## Clone, Pull, And Local Updates

Gitee API access and Git remote access are separate concerns. Use the API token for API calls. For `git clone`, `git fetch`, `git pull`, and `git push`, prefer:

- SSH remote with configured Gitee SSH keys.
- HTTPS with a credential helper or Gitee personal access token.

Clone:

```bash
git clone git@gitee.com:OWNER/REPO.git
```

or:

```bash
git clone https://gitee.com/OWNER/REPO.git
```

Pull an existing checkout:

```bash
git -C /path/to/repo fetch --all --prune
git -C /path/to/repo pull --ff-only
```

If only API access is available, download an archive instead of using Git remotes:

```text
GET /v5/repos/{owner}/{repo}/tarball
GET /v5/repos/{owner}/{repo}/zipball
```

## Update Repo Settings

Endpoint:

```text
PATCH /v5/repos/{owner}/{repo}
```

Common form fields:

- `access_token`
- `name`
- `description`
- `homepage`
- `has_issues`
- `has_wiki`
- `can_comment`
- `private`
- `path`
- `default_branch`
- `pull_requests_enabled`
- `online_edit_enabled`
- `lightweight_pr_enabled`
- `merge_enabled`, `squash_enabled`, `rebase_enabled`
- `default_merge_method`: `merge`, `squash`, or `rebase`

Example:

```bash
python3 - <<'PY'
import os, requests
owner = "OWNER"
repo = "REPO"
token = os.environ["GITEE_ACCESS_TOKEN"]
r = requests.patch(
    f"https://gitee.com/api/v5/repos/{owner}/{repo}",
    data={"access_token": token, "name": repo, "description": "Updated via API"},
    timeout=30,
)
print("status", r.status_code)
print(r.json())
PY
```

## Branches

List branches:

```text
GET /v5/repos/{owner}/{repo}/branches
```

Get branch:

```text
GET /v5/repos/{owner}/{repo}/branches/{branch}
```

Create branch:

```text
POST /v5/repos/{owner}/{repo}/branches
formData: access_token, refs, branch_name
```

Create/update/delete protection:

```text
PUT /v5/repos/{owner}/{repo}/branches/{branch}/protection
DELETE /v5/repos/{owner}/{repo}/branches/{branch}/protection
PUT /v5/repos/{owner}/{repo}/branches/setting/new
PUT /v5/repos/{owner}/{repo}/branches/{wildcard}/setting
DELETE /v5/repos/{owner}/{repo}/branches/{wildcard}/setting
```

## Tags

```text
GET /v5/repos/{owner}/{repo}/tags
POST /v5/repos/{owner}/{repo}/tags
```

Use `POST /tags` to create repository tags when the API task needs a tag object. For local Git tags, use normal Git commands and push the tag through Git remote auth.

## Code, Commits, And Downloads

Read content and raw files:

```text
GET /v5/repos/{owner}/{repo}/contents(/{path})
GET /v5/repos/{owner}/{repo}/raw/{path}
GET /v5/repos/{owner}/{repo}/readme
GET /v5/repos/{owner}/{repo}/git/blobs/{sha}
GET /v5/repos/{owner}/{repo}/git/trees/{sha}
```

Write content:

```text
POST /v5/repos/{owner}/{repo}/contents/{path}
PUT /v5/repos/{owner}/{repo}/contents/{path}
DELETE /v5/repos/{owner}/{repo}/contents/{path}
POST /v5/repos/{owner}/{repo}/commits
```

Inspect commits:

```text
GET /v5/repos/{owner}/{repo}/commits
GET /v5/repos/{owner}/{repo}/commits/{sha}
GET /v5/repos/{owner}/{repo}/compare/{base}...{head}
GET /v5/repos/{owner}/{repo}/blame/{path}
```

Download archives:

```text
GET /v5/repos/{owner}/{repo}/tarball
GET /v5/repos/{owner}/{repo}/zipball
```

## Collaborators And Access

```text
GET /v5/repos/{owner}/{repo}/collaborators
GET /v5/repos/{owner}/{repo}/collaborators/{username}
PUT /v5/repos/{owner}/{repo}/collaborators/{username}
DELETE /v5/repos/{owner}/{repo}/collaborators/{username}
GET /v5/repos/{owner}/{repo}/collaborators/{username}/permission
```

Use these to list members, check membership, add/update a collaborator, remove a collaborator, or inspect permissions.

## Deploy Keys

```text
GET /v5/repos/{owner}/{repo}/keys
POST /v5/repos/{owner}/{repo}/keys
GET /v5/repos/{owner}/{repo}/keys/available
GET /v5/repos/{owner}/{repo}/keys/{id}
PUT /v5/repos/{owner}/{repo}/keys/enable/{id}
DELETE /v5/repos/{owner}/{repo}/keys/enable/{id}
DELETE /v5/repos/{owner}/{repo}/keys/{id}
```

## Webhooks

```text
GET /v5/repos/{owner}/{repo}/hooks
POST /v5/repos/{owner}/{repo}/hooks
GET /v5/repos/{owner}/{repo}/hooks/{id}
PATCH /v5/repos/{owner}/{repo}/hooks/{id}
DELETE /v5/repos/{owner}/{repo}/hooks/{id}
POST /v5/repos/{owner}/{repo}/hooks/{id}/tests
```

## Labels, Milestones, Push Rules, And Review Settings

Issue labels:

```text
GET /v5/repos/{owner}/{repo}/labels
POST /v5/repos/{owner}/{repo}/labels
GET /v5/repos/{owner}/{repo}/labels/{name}
PATCH /v5/repos/{owner}/{repo}/labels/{original_name}
DELETE /v5/repos/{owner}/{repo}/labels/{name}
```

Project labels:

```text
GET /v5/repos/{owner}/{repo}/project_labels
POST /v5/repos/{owner}/{repo}/project_labels
PUT /v5/repos/{owner}/{repo}/project_labels
DELETE /v5/repos/{owner}/{repo}/project_labels
```

Milestones:

```text
GET /v5/repos/{owner}/{repo}/milestones
POST /v5/repos/{owner}/{repo}/milestones
GET /v5/repos/{owner}/{repo}/milestones/{number}
PATCH /v5/repos/{owner}/{repo}/milestones/{number}
DELETE /v5/repos/{owner}/{repo}/milestones/{number}
```

Push and reviewer settings:

```text
GET /v5/repos/{owner}/{repo}/push_config
PUT /v5/repos/{owner}/{repo}/push_config
PUT /v5/repos/{owner}/{repo}/reviewer
```

## Releases

```text
GET /v5/repos/{owner}/{repo}/releases
POST /v5/repos/{owner}/{repo}/releases
GET /v5/repos/{owner}/{repo}/releases/latest
GET /v5/repos/{owner}/{repo}/releases/tags/{tag}
GET /v5/repos/{owner}/{repo}/releases/{id}
PATCH /v5/repos/{owner}/{repo}/releases/{id}
DELETE /v5/repos/{owner}/{repo}/releases/{id}
GET /v5/repos/{owner}/{repo}/releases/{release_id}/attach_files
POST /v5/repos/{owner}/{repo}/releases/{release_id}/attach_files
GET /v5/repos/{owner}/{repo}/releases/{release_id}/attach_files/{attach_file_id}
DELETE /v5/repos/{owner}/{repo}/releases/{release_id}/attach_files/{attach_file_id}
GET /v5/repos/{owner}/{repo}/releases/{release_id}/attach_files/{attach_file_id}/download
```

## Activity, Metrics, And Notifications

```text
GET /v5/repos/{owner}/{repo}/events
GET /v5/repos/{owner}/{repo}/contributors
GET /v5/repos/{owner}/{repo}/subscribers
POST /v5/repos/{owner}/{repo}/traffic-data
GET /v5/repos/{owner}/{repo}/languages
GET /v5/repos/{owner}/{repo}/license
GET /v5/repos/{owner}/{repo}/git/gitee_metrics
GET /v5/repos/{owner}/{repo}/notifications
PUT /v5/repos/{owner}/{repo}/notifications
```

## Destructive Operations

Delete repo:

```text
DELETE /v5/repos/{owner}/{repo}
```

Clear repo:

```text
PUT /v5/repos/{owner}/{repo}/clear
```

Before running either, require explicit confirmation unless the user already gave an unambiguous destructive instruction. Report the exact target in `owner/repo` form.
