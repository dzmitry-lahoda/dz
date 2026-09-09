# Overview


Helps to rebase vcs branch onto divereged base.


## Input

Desired input domain, features, and product analysis codebase and semanticxs of each change in this branch.

## When not to use

- There are no conflicts with base

## When to use

- you have conflcits with base
- you bracnch changes are many commits, but for one holistic featrue/component

##  Prepare

- create work tree
- Validate that local lints pass on the branch, if not - stop.
- Check each commit in base and branch as they diverged.
- Identify each conflicting commit and why it was made.
- Get whole conflict into local file.
- Identify if each conflict is conflict of code, but not of opposite semantics (mergable without breaking both).
- Consider how to merge semantics together.


## Act

- Squash branch all into one commit

- Check that each functional detail is in place in, if not document what changed
in this case ask for confirm


- any features on master added since branch
  created which can shortcut impl of current branch? less code

- lock files just use earlier

- output whole plan and wait for apporival

## Before final

- executed plan, linted passes
- ask second opinion of other agent on merge

Search  for compiler-invisible (silent):
- logical and business logic regressions
- missing secondary side effects
- feature dropping across architectural rewrites
- silent fallthroughs in dynamically typed or loosely typed switch statements, non total state matches


## Final 

-   Return back all commmits as it was, stacked.
DO NOT PUSH

## Skill Trigger: Second Opinion (Compiler-Invisible Regressions)

When acting as a Second Opinion reviewer for a rebase, merge plan, or pull request, ignore any conflicts or errors that will be immediately caught by strict compiler. Do not report syntax errors, missing imports, mismatched struct fields, or duplicate protobuf tags. 



Report only bugs that will compile perfectly but fail or corrupt data at runtime.
