## Why

The Imsight skill suite still contains guardrails written with the former mixed `DO NOT ...` and `MUST ...` template, which turns many Guardrails sections into duplicate procedure lists and obscures which rules prevent harmful actions. The suite needs one consistent contract that keeps negative-action prevention in Guardrails while placing positive operations in workflows, contracts, and other substantive skill content.

## What Changes

- Define negative-only guardrail authoring in both the suite style guide and the bundled runtime guide used by `imsight-agent-skill-handling`.
- Remove runtime `MUST ...` guardrail clauses by converting genuine prevention rules to `DO NOT ...`, absorbing positive operations into substantive content, or deleting requirements already stated there.
- Remove disguised operation steps such as `DO NOT forget ...` and positive imperative clauses appended to guardrails.
- Add a concise negative-only Guardrails section to the one Imsight entrypoint that lacks it.
- Preserve immutable migration provenance under `org/src/` while excluding it from runtime guardrail conformance checks.
- Validate every Imsight skill entrypoint and the executable Markdown pages affected by the migration.

## Capabilities

### New Capabilities

- `imsight-skill-guardrail-authoring`: Defines how Imsight skills separate negative-action guardrails from positive workflows, procedures, contracts, and output requirements.

### Modified Capabilities

None.

## Impact

The change affects Markdown skill entrypoints and executable support pages under `skillset/imsight-skills/`, plus the suite and bundled skill-writing guides. It changes instructional structure but does not rename public subcommands, alter output paths, add dependencies, or modify immutable migration snapshots.
