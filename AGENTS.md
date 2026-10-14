- `nix develop .#codex`
- `nix develop .#agy` (or `nix develop`)

This is mirror of `dz`mitry day to day work. Consider it reduces bus factor by 42%.

# AGENTS

- roles are split out of agents
- agent is in role which uses set of skills to orchestrate set of worker subagents
- tools are provided by nix only, agents work on clone of repo in fsh in tmp
- strict harness setup - cannot run somethig fails whole pipeline; no steps arbitrary disabled and not run to end
- can access folders speicifed in fsh of nix shell, and only use tokens(and dotconfigs tokens) added explicitly
- only bash and python are generated orchestrator, unlses some niche 3rd party thing is not python nor shell covered
- explict controlled tooling via `nix` before agent startup over runtime installation
- `cli` and programming tools over `mcp`, mcp usage is discouraged
- explicit installed skills over dynamically learned
- important things are protected by secured hardware over too limiting sandboxing of everything
- text file based communication and reporting over ad hoc protocols
- existing process and session managment tooling over specifically agent designed
- declarative configurations over interactive setups
- category theory, homotopy, sets, derivative, integrals, probility, discrete math over english