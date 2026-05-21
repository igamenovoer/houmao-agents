## 1. Suite Contract Documentation

- [x] 1.1 Review `skillset/imsight-skills/README.md` and ensure it defines Imsight-context invocation, explicit/internal routing, non-automatic generic triggering, command/subcommand invocation, task-only invocation, universal `help`, and `SKILL.md` entrypoint style.
- [x] 1.2 Ensure the README skill index still lists every `imsight-*` skill after entrypoint changes.

## 2. Entrypoint Alignment

- [x] 2.1 Update `imsight-autodev-master/SKILL.md` so its user-facing routes are presented as subcommands, include `help`, and document task-only selection of subcommands or workflow sequences.
- [x] 2.2 Update `imsight-autodev-slave/SKILL.md` so its operations are presented as subcommands, include `help`, and default missing subcommand behavior to `help` unless a task prompt can be routed.
- [x] 2.3 Update `imsight-dev-box-init/SKILL.md` so setup topics are named subcommands, include `help`, and route task-only installation/setup prompts to the matching reference.
- [x] 2.4 Update `imsight-dev-box-network/SKILL.md` so networking actions and reference topics are named subcommands, include `help`, and route task-only networking prompts to a subcommand or sequence.
- [x] 2.5 Update `imsight-info-gathering/SKILL.md` so search, download, source-ledger, source-pack, and report-synthesis behaviors are named subcommands, include `help`, and route task-only research prompts to a subcommand or sequence.
- [x] 2.6 Update `imsight-python-general/SKILL.md` so Python development workflows are named subcommands, include `help`, and route task-only Python prompts to the matching reference.

## 3. Metadata Alignment

- [x] 3.1 Review all `skillset/imsight-skills/imsight-*/agents/openai.yaml` files and add or preserve `policy.allow_implicit_invocation: false` where needed to match the suite triggering contract.
- [x] 3.2 Update default prompts where needed so they demonstrate the command/subcommand style without implying broad automatic triggering.

## 4. Validation

- [x] 4.1 Run skill validation for every `skillset/imsight-skills/imsight-*` skill.
- [x] 4.2 Search the Imsight skill entrypoints for stale section names or missing `help`/task-only routing language.
- [x] 4.3 Run OpenSpec validation/status checks for `align-imsight-skills-subcommand-contract`.
