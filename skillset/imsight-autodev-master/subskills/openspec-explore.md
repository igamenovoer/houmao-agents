# OpenSpec Explore Dispatch

Use this subskill when the master wants a Houmao-managed slave to explore a development idea, problem, or change without implementing it.

## Workflow

1. Read [inspect-slave.md](inspect-slave.md) and recover slave metadata.
2. Preserve the explore request, including repository, change name if any, context, and questions to investigate.
3. Render the slave command from the inspected tool lane:
   - Codex slave:
     ```text
     $openspec-explore <request>
     ```
   - Claude slave:
     ```text
     /openspec-explore <request>
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

- Do not convert explore dispatch into proposal or implementation work.
- Do not inspect the slave's follow-up unless the user explicitly asks.
