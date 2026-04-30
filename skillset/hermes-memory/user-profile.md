User prefers CLI tools over Python libraries or MCP servers when available. When installing research tools like tavily, default to the CLI binary (e.g., tvly) rather than Python SDK or MCP wrappers. Only fall back to Python/MCP if CLI is unavailable or insufficient.
§
User prefers uv over pip for tool installation.
§
User prefers profile-level configuration over specialist-level when scoping is important. Example: proxy env vars should go on the profile, not the specialist, to keep the specialist reusable for other profiles. User actively corrects when configuration is placed at the wrong inheritance level.
§
User delegates investigative tasks to sub-agents (e.g., "ask alex to find out") rather than having the main assistant do the research directly. User expects sub-agents to investigate Houmao internals, API behavior, and configuration details.
