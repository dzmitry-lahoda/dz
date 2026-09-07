
# Input

outpuf of domain analyss of each code piece

## When not to use

#  Prepare

- check each commit above and behind, output them
- Get whol conclict into local file.
- Identify each conflicting commit and why it was made.
- Idenfity if each conflict is conflict of code, but not of opposite semantics.
- Consider how to merge semantics together.

- check that each functional detail is in place in new commmit, if not document what changed
in this case ask for confirm


- any features on master added since branch
  created which can shortcut impl of currenct branch? less code

- lock files just use earlier

- output whole plan and wait for apporival

## Skill Trigger: Second Opinion (Compiler-Invisible Regressions)

When acting as a Second Opinion reviewer for a rebase, merge plan, or pull request, ignore any conflicts or errors that will be immediately caught by strict compiler. Do not report syntax errors, missing imports, mismatched struct fields, or duplicate protobuf tags. 

Search exclusively for compiler-invisible (silent):
- logical and business logic regressions
- missing secondary side effects
- feature dropping across architectural rewrites
- silent fallthroughs in dynamically typed or loosely typed switch statements, non total state matches

Report only bugs that will compile perfectly but fail or corrupt data at runtime.

# Execute

squash all into one commiet

ask for lint and tests to run,
make run over CI via PR if possible.

wait confirm to force push into proposed pach or send new one for existing PR

## finalize
  
  Return back all commmits as it was, stacked.

## Constraints
Use rebase on worktree



