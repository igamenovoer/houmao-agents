# Find LibGen

Use this subskill when the user asks to search a LibGen-style mirror, resolve search results into direct download URLs, or produce `wget` commands for a found target.

## Bundled Script

Use the bundled stdlib-only script:

```bash
python scripts/libgen_stdlib_links.py '<query>' --mirror '<mirror-url>'
```

The script uses only Python's standard library. It searches a LibGen-style mirror, extracts result mirror pages, resolves `libgen.*` `ads.php?...` pages into direct `get.php?...` URLs, and prints wget-ready commands when requested.

Important options:

- `--mirror <url>`: Required LibGen mirror, for example `https://libgen.vg/`.
- `--proxy <url>`: Explicit HTTP/HTTPS proxy, for example `http://127.0.0.1:7990`.
- `--no-proxy`: Ignore proxy environment variables.
- `--title`, `--author`, `--year`, `--extension`: Filter matched records using additional user-provided info.
- `--limit <n>`: Maximum matched books to inspect.
- `--max-mirrors <n>`: Mirror pages to inspect per book.
- `--json`: Emit machine-readable results.
- `--wget-bytes <n>`: Print `wget` commands with a `Range` header for partial download testing.

## Workflow

1. Confirm the task includes a LibGen mirror URL. If not, ask for the mirror URL instead of guessing.
2. Build the search query from the user's keywords, title, author, ISBN, or other identifying info.
3. Add filters when the user supplied them: `--title`, `--author`, `--year`, and `--extension`.
4. Use a proxy when the user provides one or the environment requires one. For Imsight dev-box network downloads, prefer the current workspace proxy convention unless the user asks otherwise.
5. Run the script from the `imsight-info-gathering` skill directory or pass the script path explicitly:
   ```bash
   python scripts/libgen_stdlib_links.py 'king james bible' \
     --mirror 'https://libgen.vg/' \
     --proxy 'http://127.0.0.1:7990' \
     --extension pdf \
     --limit 3 \
     --max-mirrors 1 \
     --wget-bytes 1024
   ```
6. If the user wants reusable output, save JSON under the output directory selected by the parent skill's Output Contract, normally `<project-dir>/.imsight-arts/info-gather/libgen/`.
7. For download feasibility checks, prefer partial-byte tests:
   ```bash
   wget --header='Range: bytes=0-1023' -O sample.part '<direct-get-url>'
   ```
8. Report the query, mirror, filters, direct URL count, selected URL(s), and the exact `wget` command(s). If a byte-range test was run, include HTTP status, downloaded byte count, and output path.

## Guardrails

- Do not full-download large files unless the user explicitly asks for a full download.
- Use byte-range downloads for connectivity tests.
- Do not claim a URL is downloadable until the direct URL is resolved, or a partial `wget` test succeeds when requested.
- Respect user-provided output locations and the parent skill's Output Contract for any saved JSON, logs, or sample byte files.
