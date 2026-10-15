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
- abstract and aggregation but practical models over concretes

### Language

Unix and Capability oriented language to descrive agentic workflows

#### grammar

state - share amid agents, persisted amid runs

shell - set of tools provided to agent

tool - functions for the AI model to execute

task

goal

agent - has its own context and acts as some role

context

reasoning - build plan, breakdown problems, solve each part, check solutions, combine parts, draft solution, reivew solution,

???resources: Context and data, for the user or the AI model to use

prompts: Templated messages and workflows for users

sampling: requests for LLM from agents, given agetnts context

roots: Server-initiated inquiries into URI or filesystem boundaries to operate in

elicitation - agent requests for additional information from agents

rights - for resource, read, write, 

specific agent instances are 
- user (human in the loop) whihc is interacvie
- coordinator

decision - addditioonal check if agent not sure

effect - patch, edit, delete, add, new, fork
goal - ???
roles - auditor, senior engineer
rules - ???

effort - how many resourcs to spend on goal
task ????
speed - how was resources are consumed

effecit model size

skill OR orchestration can speciffy minimal require effort, or specify what to be done depending on effort

decion - probablistic classificator OR binary