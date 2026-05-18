---
name: gitee-via-api
description: Operate Gitee through API v5 using a provided access token or the GITEE_ACCESS_TOKEN environment variable. Use when listing, creating, cloning, pulling, inspecting, updating, deleting, or otherwise managing Gitee repositories; accessing private repos through API calls; reading or writing repository contents; checking branches, tags, collaborators, deploy keys, webhooks, releases, watchers/subscribers, issues, or pull requests; testing OAuth/API tokens; or translating a Gitee task into concrete API requests.
---

# Gitee Via API

Use this skill as the entrypoint for Gitee API v5 operations. Keep token handling consistent, load only the reference needed for the requested task, and prefer API calls over browser-only workflows when the user asks to automate or inspect Gitee.

## Token Handling

Use an access token provided by the user, or read `GITEE_ACCESS_TOKEN` from the environment when no token is provided.

Never print full tokens in responses, logs, generated docs, or command output. When checking a token, report only whether it is set and optionally a masked prefix/suffix.

For private repos, include the token as `access_token` because Gitee API v5 documents authentication that way.

## Reference Index

| Task | Load |
| --- | --- |
| Resolve token source, validate a token, understand OAuth token flow | `references/auth-and-tokens.md` |
| Manage repositories: list, search, create, clone, pull, inspect, update, delete, branches, tags, collaborators, hooks, keys, releases, downloads | `references/repositories.md` |
| Read, create, update, or delete files through the repository contents API | `references/contents.md` |
| List watchers/subscribers and other repo activity-style data | `references/activity.md` |
| Work with issues or pull requests | `references/issues-and-pulls.md` |
| Discover undocumented or less-used operation details from Gitee Swagger/OpenAPI | `references/swagger-discovery.md` |
| Browse the full Gitee API v5 endpoint list with one-line descriptions | `references/endpoints.md` |

## Operating Procedure

1. Identify the requested Gitee task and load the matching reference.
2. Resolve the token from the user request or `GITEE_ACCESS_TOKEN`.
3. Validate permissions with a small read-only call such as `GET /v5/user` or `GET /v5/user/repos` before destructive operations.
4. Use paginated requests with `page` and `per_page=100` for list endpoints.
5. For writes or deletes, summarize the exact target and payload before executing unless the user already gave explicit approval.
6. Return concise results and do not expose token values.

## Base URL

Use:

```text
https://gitee.com/api/v5
```

When constructing examples, use placeholders such as `OWNER`, `REPO`, `ACCESS_TOKEN`, and `PATH`. Do not bake real tokens into skill files.
