

Use when coding creating new code.

Review code quality is thinkin about how to write code better. 
Which is creating new code.

## Requies

Runs only if model is high enabled. Abort if not.


## Commont flow

Basically it analuzes code structure,
depndenciesy, calls, layers, 

And uses in orchestation.

## Orchestration

Map commont flow setup to discover installed skills which are relevant for this code.

### Decide if rquest is complicated

Do quick check of implementation is trivial. If it is just, rout to trivial impl without planning.


### Shared setup

Consider using filess as medium for communciaiton of agents and sharing context.

I assume this is big orchestartion, so make separation clear via proper namings.

Check how to properly use and setup repostitry and setup proper env for all research required for implememntation.

### Setup

Sequecnetiall go over next steps to gather context.

#### Build Code Context

Depends on: GitHub/change context.

Produce one concise code context artifact that all focused must use. 

- Load and use `trailmark-structural`
- Record the changed entry points, affected call paths, important invariants, related tests, and any unresolved context gaps in the artifact.
- Output all artifacts into files.

#### Code type and domain

Use `code-domain-identification` with the shared change and code context and the run directory. Separate documented requirements from inferred conventions and record intentional divergences from external references.

Outputs `code-domain-identification.md`


#### Product Engineering

- reads all md files in docs/** and all README.md files in directories
- finds possible bugs of interaction of this feature added or modified in this PR with all others 
- Rads and depends on `code-domain-identification.md` output.
- Uses the domain and component information to guide focused review passes.

### Act


#### Plan

Time to plan

Consumes `Shared setup`() and `Setup` output.

Plan implentation.

Check spec or issue for implementation.

Split plan into semantic plan, what are to lock at.

Split plan into steps and layers you will go.

On each implemendtion step thinl of and find option of possible implenetaion.

Pick most good options, analyze pros and cons.

#### Review

Wait for human approval to go with plan or repeate plan loop until human approvs or ask for cahnges in plan.

#### Implementation

If any of assumption duing impl fails, go to plan again.
If finding is high confidentr and change do it atonomus.


### Coding


Use fp best practices, 

- search this repo for review 

- control-code-quality-skill
