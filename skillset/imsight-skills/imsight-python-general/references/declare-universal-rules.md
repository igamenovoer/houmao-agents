# Declare Universal Rules

Use this subskill when the task is to add Imsight universal project rules to a coding-agent native project context file such as `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, or a similar repo-level assistant instruction file.

## Source Rules

The skill-local source of truth is:

```text
references/universal-project-rules.md
```

Use that skill-local file when reading the canonical rule text. The section content is also embedded below so this subskill remains self-contained if copied or installed without extra context.

## Target Selection

1. Work from the product repository root, not a mega-workspace parent.
2. If the user names one or more target context files, update those files.
3. Otherwise, update the existing native context file for the active agent when it is clear:
   - Codex/OpenAI-style agent context: `AGENTS.md`
   - Claude-style agent context: `CLAUDE.md`
   - Gemini-style agent context: `GEMINI.md`
4. If the active agent is unclear and `AGENTS.md` exists, prefer `AGENTS.md` as the shared cross-agent context file.
5. If no native context file exists, create `AGENTS.md` unless the user requested a different agent-specific file.
6. When the user asks to update every native context file, update all existing repo-level files that match the request. Do not create extra agent-specific files unless requested.

## Update Rules

1. Read the target file before editing.
2. Preserve existing project-specific guidance and ordering.
3. Add or refresh one section titled `Universal Project Rules`.
4. Make the operation idempotent: if the section already exists, replace only that section instead of appending duplicates.
5. Place the section near other general coding or project rules. If there is no obvious location, append it near the end of the file.
6. Keep Markdown readable and do not hard-wrap normal paragraphs.
7. After editing, briefly report which file was updated and whether the section was added or refreshed.

## Section Content

Use this content for the inserted or refreshed section:

```markdown
# Universal Project Rules

## Documentation
- When writing Markdown, do not hard-wrap normal paragraphs. Let Markdown viewers and editors handle line wrapping.

## Python
- Write Python in a strongly typed style. Tighter types are preferred over vague ones.
- Repo-owned Python should pass `mypy` after edits.
- Use NumPy-style docstrings for all public-facing Python functions, classes, and data models.

## C++
- Use Doxygen-style docstrings for all public-facing C++ functions, classes, and data models or structs.

## Feature Design
- This project is in active development and accepts breaking changes.
- When designing new features, do not spend effort on compatibility with previous iterations or external users unless explicitly requested.
- Favor a clear internal design over compatibility layers.
- If a change breaks another part of this repository, fix the dependent code in the same change so repo workflows continue to work together.
```

When inserting into an existing `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, or similar file that already uses a single top-level `#` heading for the file title, demote this inserted section by one heading level so the final document outline stays coherent:

```markdown
## Universal Project Rules

### Documentation
- When writing Markdown, do not hard-wrap normal paragraphs. Let Markdown viewers and editors handle line wrapping.

### Python
- Write Python in a strongly typed style. Tighter types are preferred over vague ones.
- Repo-owned Python should pass `mypy` after edits.
- Use NumPy-style docstrings for all public-facing Python functions, classes, and data models.

### C++
- Use Doxygen-style docstrings for all public-facing C++ functions, classes, and data models or structs.

### Feature Design
- This project is in active development and accepts breaking changes.
- When designing new features, do not spend effort on compatibility with previous iterations or external users unless explicitly requested.
- Favor a clear internal design over compatibility layers.
- If a change breaks another part of this repository, fix the dependent code in the same change so repo workflows continue to work together.
```
