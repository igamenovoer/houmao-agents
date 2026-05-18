# Swagger Discovery

Use this reference when the requested Gitee operation is not covered by another reference file or when exact parameters are uncertain.

## Source Documents

Gitee API v5 Swagger UI:

```text
https://gitee.com/api/v5/swagger
```

Machine-readable OpenAPI/Swagger JSON:

```text
https://gitee.com/api/v5/swagger_doc
https://gitee.com/api/v5/doc_json
```

The observed Swagger version during skill creation was `5.4.92`.

## Find An Endpoint

Search by path, operation id, or summary:

```bash
python3 - <<'PY'
import json, requests
needle = "subscribers"
spec = requests.get("https://gitee.com/api/v5/swagger_doc", timeout=30).json()
for path, methods in spec.get("paths", {}).items():
    for method, op in methods.items():
        text = json.dumps(op, ensure_ascii=False)
        if needle.lower() in path.lower() or needle.lower() in text.lower():
            print(method.upper(), path, op.get("operationId"), "-", op.get("summary"))
PY
```

Print parameters for one operation:

```bash
python3 - <<'PY'
import json, requests
operation_id = "getV5ReposOwnerRepoSubscribers"
spec = requests.get("https://gitee.com/api/v5/swagger_doc", timeout=30).json()
for path, methods in spec.get("paths", {}).items():
    for method, op in methods.items():
        if op.get("operationId") == operation_id:
            print(method.upper(), path)
            print(json.dumps(op.get("parameters", []), ensure_ascii=False, indent=2))
            print(json.dumps(op.get("responses", {}), ensure_ascii=False, indent=2))
PY
```

## Request Construction Rules

- Path parameters go into the URL, such as `/v5/repos/{owner}/{repo}`.
- Read endpoints usually use query parameters.
- Create/update endpoints often use `formData`.
- Gitee API v5 commonly accepts `access_token` as a query or form field depending on the endpoint.
- For list endpoints, include `page` and `per_page=100` unless the user wants a smaller sample.

## Safety

Treat Swagger as authoritative for method, path, required parameters, and response schemas. For destructive methods such as `DELETE` or broad updates such as repo settings, confirm target and payload before execution.
