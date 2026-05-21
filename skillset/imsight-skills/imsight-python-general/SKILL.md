---
name: imsight-python-general
description: Imsight-authored general Python development operations skill. Use only when the prompt or surrounding context explicitly mentions `imsight` and the user asks for Python project setup, Python repo conventions, Pixi-managed Python project structure, packaging layout, source/test/docs/context organization, dependency workflow, lint/type/test operations, or a reusable Imsight Python development standard. Do not invoke for generic Python development tasks that do not mention `imsight`.
---

# Imsight Python General

## Overview

Use this skill as the entrypoint for Imsight Python development practices. Keep detailed procedures in focused subskill references and load only the reference needed for the current task.

## Subskills

| Task | Load |
| --- | --- |
| Structure or review a Pixi-managed Python project, especially a new src-layout project with tests, docs, context, scripts, and external dependency folders | `references/structure-pixi-project.md` |

## Procedure

1. Identify the Python development operation the user is asking for.
2. Load the matching reference from the subskill index.
3. Follow the reference while adapting names and tooling to the existing repository.
4. If no reference exists yet, use normal senior Python engineering judgment and consider adding a focused reference linked from this index.

## Maintenance

Name new references by operation, keep each one self-contained, and avoid duplicating detailed commands in this entrypoint.
