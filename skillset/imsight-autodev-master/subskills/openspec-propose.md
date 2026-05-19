# OpenSpec Propose Dispatch

Use this subskill when the master wants a Houmao-managed slave to create or continue OpenSpec proposal artifacts for a described change.

## Workflow

1. Read [inspect-slave.md](inspect-slave.md) and recover slave metadata.
2. Preserve the proposal request, including desired change name when provided, repository/workspace, requirements, constraints, and any exploration notes.
3. Render the slave command from the inspected tool lane:
   - Codex slave:
     ```text
     $openspec-propose <request>
     ```
   - Claude slave:
     ```text
     /openspec-propose <request>
     ```
4. Deliver the rendered command through the selected Houmao messaging surface.
5. After delivery is accepted, finish the turn by default.

## Delivery

Prefer gateway prompt delivery when the slave has a live gateway:

```text
houmao-mgr agents gateway prompt --agent-name <slave> --prompt "<rendered command>"
```

When mailbox delivery is selected, include the rendered command in the mail body so the slave sees the invocation in the notification text.

## Guardrails

- Do not ask the master to create proposal artifacts locally when the intent is slave dispatch.
- Do not inspect the slave's follow-up unless the user explicitly asks.
