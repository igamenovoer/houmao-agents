# Init Slave for OpenSpec

Use this subskill when the master wants a Houmao-managed slave to initialize OpenSpec in the slave's own target workdir. The master dispatches the request; the slave performs the filesystem mutation locally.

## Workflow

1. Read [inspect-slave.md](inspect-slave.md) and recover slave metadata.
2. Preserve any target-workdir hint from the master request, but do not directly access or mutate the slave workdir from the master.
3. Render the slave command from the inspected tool lane:
   - Codex slave:
     ```text
     $imsight-autodev-slave init-openspec <request>
     ```
   - Claude slave:
     ```text
     /imsight-autodev-slave init-openspec <request>
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

- Do not run `openspec init` from the master for the slave.
- Do not copy files into the slave workdir from the master.
- Do not assume the master can see the same filesystem as the slave.
- Do not monitor, poll, or inspect the slave after delivery unless explicitly asked.
