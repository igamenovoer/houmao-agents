# OpenSpec One-Pass Dispatch

Use this subskill when the master wants one Houmao-managed slave to run the slave mega-skill through the full OpenSpec lifecycle in one focused pass.

## Workflow

1. Read [inspect-slave.md](inspect-slave.md) and recover slave metadata.
2. Preserve the master request body exactly enough for the slave to understand the task, target repository, constraints, and desired mode.
3. Render the slave command from the inspected tool lane:
   - Codex slave:
     ```text
     $imsight-autodev-slave openspec-one-pass <master request>
     ```
   - Claude slave:
     ```text
     /imsight-autodev-slave openspec-one-pass <master request>
     ```
4. Deliver the rendered command through the selected Houmao messaging surface.
5. After delivery is accepted, finish the turn by default.

## Delivery

Prefer gateway prompt delivery when the slave has a live gateway:

```text
houmao-mgr agents gateway prompt --agent-name <slave> --prompt "<rendered command>"
```

When mailbox delivery is selected, include the rendered command at the top of the mail body. Keep one-off behavior in the mail body; use mail-notifier appendix text only for intentional repeated policy, following the parent skill guidance.

## Guardrails

- Do not split one-pass work into multiple OpenSpec prompts from the master.
- Do not monitor, poll, or inspect the slave after delivery unless explicitly asked.
- Do not use direct OpenSpec command prefixes for one-pass dispatch; target `imsight-autodev-slave`.
