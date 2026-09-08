# Prompt template

Run `code-review` orchestration on {PULL_REQUEST_LINK}.
I ask to allow delegation and parallel flow.
Stop on first infra, dependency, install, or configuration failure.
Allow me to resolve issues or agree to proecced with known hiccup.
Run with high+ thinking effort on frontier model.

# How to use

# step by step `code-review` skill setup and run 

0. :important: ALLOW AGENTS https://github.com/dzmitry-lahoda/nix-mac/blob/5a8802e136283e80b36478bf30d12316eacc1a22/modules/ai/default.nix#L167
1. clone repo and nix develop shell into https://github.com/dzmitry-lahoda/dz/blob/main/flake.nix
2. place you PR link into promt  https://github.com/dzmitry-lahoda/dz/blob/main/agents/skills/code-review/README.md add any detail if you want if they not expressed in PR comments/linked issues/nor PR description; may be some info how you handle secrets or sandboxing.
3. Run and observe, confirm access
4. In the end ASK to publish findings
5. screenshot or log me what not works

# how it works:

- it uses nix and searches nix in git repo cloned into tmp and worktrees several times from clone. 
- expect dozens of gigabytes in /tmp/<repo-something>
- ALL works via files, ALL isolated from other, does NOT shits into you env
- see `code-review`, but it is just setup/preanalysze->fork->join->verify/report
- ALL progress goes via files, so no depend on session or ad hoc tooling, just read files
- Has remote-skill installer skill via nix or apm (local into /tmp/<..) 