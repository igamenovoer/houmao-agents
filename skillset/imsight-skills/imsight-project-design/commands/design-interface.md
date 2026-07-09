# Design Interface

## Workflow

When this subcommand is invoked, execute these steps in order.

1. **Resolve the feature design directory** and read `feature-requirement.md`, all relevant `usecases/uc-*.md` files, and existing docs under `design/`.
2. **Derive interface needs** from the use cases: commands, routes, request and response models, file formats, artifact identifiers, storage contracts, client APIs, service events, admin operations, and compatibility boundaries.
3. **Choose the design target**. Default to `design/public-interfaces.md`; update module-specific files only when they already exist, the interface surface clearly belongs in separate modules, or the user asks for module files.
4. **Route skill targets to local skill design guidance** when the feature being designed is an agent skill, AI assistant skill, or agent-facing instruction workflow. See **Skill Target Routing**.
5. **Write or update the interface design**. Include public surface, required and optional fields, validation rules, lifecycle or state behavior, errors, persistence behavior, compatibility notes, and open questions.
6. **Update `design/README.md`** with links and a short map of interface or module responsibilities.
7. **Report interface coverage**. Name the use cases covered, gaps still not represented, and any open user decisions.

If the task does not map cleanly to these steps, create a partial interface design with explicit assumptions and ask which use case or boundary should drive the next revision.

## Skill Target Routing

When the design target is an agent skill, use the locally bundled `references/skill-design.md` to generate a `design-overview.md` inside the project-design feature directory. Do not route to `imsight-agent-skill-handling`; this skill is self-contained for feature planning.

1. **Detect a skill target** when:
   - `feature-requirement.md` states the feature is an agent skill, AI assistant skill, or agent-facing instruction workflow;
   - use cases include `## Example Prompt And Expected AI Response` sections; or
   - the user explicitly asks to design a skill.
2. **Resolve the project-design feature directory** using the entrypoint **Feature Planning Output Directory** rules.
3. **Load `references/skill-design.md`** and follow its `## Workflow`.
4. **Write the skill design overview** to `<feature-dir>/design/<slug>/design-overview.md`, where `<slug>` is derived from the proposed skill name in no more than six words.
5. **After the design overview is written**, read it and summarize it in the project-design chat report alongside any other interface or design artifacts.

## Interface Style

Use the clearest format for the feature: type definitions for data models, YAML examples for request documents that need comments, route tables for HTTP APIs, command examples for CLI surfaces, lifecycle tables for async jobs or retained artifacts, event tables for messaging systems, and file-layout examples for filesystem contracts.

For skill targets, the locally generated `design-overview.md` covers the skill process model; use `design/public-interfaces.md` only for any feature-level contracts that sit outside the skill itself (for example, how the skill is discovered, invoked, or versioned in the host project).
