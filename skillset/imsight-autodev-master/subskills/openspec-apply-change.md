# OpenSpec Apply-Change Dispatch

Use this subskill when the master wants a Houmao-managed slave to implement tasks from an existing OpenSpec change.

## Workflow

1. Read [inspect-slave.md](inspect-slave.md) and recover slave metadata.
2. Preserve the implementation request, including change name/path, repository/workspace, verification expectations, and any constraints.
3. Render the slave command from the inspected tool lane:
   - Codex slave:
     ```text
     $openspec-apply-change <change-or-request>
     ```
   - Claude slave:
     ```text
     /openspec-apply-change <change-or-request>
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

- Do not implement the change in the master workspace when the request is slave dispatch.
- Do not inspect tests, logs, TUI state, or slave output after delivery unless explicitly asked.
