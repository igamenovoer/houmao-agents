User's remote skill store: https://github.com/igamenovoer/houmao-agents/tree/main/skillset (owner: igamenovoer, repo: houmao-agents, path: skillset/). New skills published there only under user's explicit command "add xxx skill to the remote skill store". Do NOT push skills automatically.
§
When pushing skills to remote store, prefer gh api for direct remote file operations via GitHub API. Avoid local git workflows (clone, checkout, commit, push) entirely when possible. Use gh api repos/{owner}/{repo}/contents/{path} with PUT method to create/update files directly. Only fall back to local git if gh api unavailable or blocked.
§
User's Houmao working directory is /mnt/data/huangzhe/houmao-project. This is the primary project workspace for Houmao-related tasks.
§
The CUDA coding project at /mnt/data/huangzhe/houmao-project/agentic-cuda-general is referred to as "cuda-agent project" by the user. Use this name when discussing it.
§
Houmao env vars can be set at three levels: Specialist → Profile → Launch. Lower levels override higher levels. Clear with `--clear-env`.
§
To find a Houmao agent's true runtime home: look under `.houmao/runtime/homes/<tool>-brain-<timestamp>-<id>/`. Example: `.houmao/runtime/homes/codex-brain-20260429-121424Z-afdea7/`. This contains the agent's live skills (Houmao skills copied, project skills symlinked from `.houmao/agents/skills/`), config, and runtime state.
§
GPU cluster hosts run two persistent tmux sessions: (1) `clash` - HTTP/SOCKS5 proxy on 127.0.0.1:7990, (2) `ssh-tunnel-<port>` - SSH reverse tunnel `-R <port>:127.0.0.1:22 ali-relay-user` exposing local port 22 to relay server. Reverse tunnel port pattern: 51 + host-last-2-digits (h20-162→5162, h20-164→5164, h20-169→5169, h20-170→5170). Hosts use `setup-ssh-reverse-tunnel.sh` script in home dir for tunnel setup. After host reboot, both sessions must be restarted. h20-164 is currently broken - no tmux sessions, mihomo proxy running outside tmux on non-standard ports 19090/17890. Relay server is ali-relay-user (112.74.107.214). SSH access to hosts from relay: `ssh -p 51<xx> ali-relay-user`.
