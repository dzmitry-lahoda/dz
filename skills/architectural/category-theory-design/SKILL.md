---
name: category-theory-design
description: Use category theory as a short search routine for coding design and daily research. Identify compositional structure, preservation laws, and useful tests in pipelines, containers, adapters, joins, and data models.
---

# Category theory for design

Search: concrete problem → objects/arrows → candidate structure → law → test.
Prefer equations and concrete types over terminology. Keep the scan brief and
expand only where a structure changes an implementation or research decision.

## Routine

1. Identify objects (types/states), arrows (operations), and composition.
   State equality: values, observable effects, ordering, errors, or another
   explicit equivalence. Account for partiality and effects when composing.
2. Match the problem to the table. Select only useful candidates; report when
   none fits. For research, pair the concept with domain terms to form a search
   query, then check the assumptions of any theorem before transferring it.
3. State a law or universal property using actual types and operations.
4. Derive a property test or counterexample. Distinguish a tested instance,
   a conjecture, a proved structure, and an analogy.
5. Recommend the smallest design change justified by the result, or no change.

## Search reference

Notation: g ∘ f applies f first, then g.

| Signal                            | Structure                       | Concrete check                                                                                         |
|-----------------------------------|---------------------------------|--------------------------------------------------------------------------------------------------------|
| Chain operations                  | Category                        | Identity exists; h ∘ (g ∘ f) = (h ∘ g) ∘ f. Include failures/effects in the composition model.         |
| Transform inside a container      | Functor                         | map(id) = id; map(g ∘ f) = map(g) ∘ map(f).                                                            |
| Convert representations uniformly | Natural transformation η: F ⇒ G | G(f) ∘ η_A = η_B ∘ F(f). Example: Option<A> → List<A> as empty/singleton.                              |
| Combine independent components    | Product A × B                   | For f: X → A, g: X → B, the unique pairing u satisfies π₁ ∘ u = f and π₂ ∘ u = g.                      |
| Match through a shared key        | Pullback A → K ← B              | P = {(a,b) \| keyA(a) = keyB(b)}. Matching maps into A and B factor uniquely through P.                |
| Choose alternatives               | Coproduct A + B                 | Handlers f: A → X and g: B → X determine one handler agreeing on both injections; use tagged unions.   |
| Glue along shared structure       | Pushout A ← K → B               | Maps out of A and B that agree on K factor uniquely through the glued object; specify identifications. |

## Checks that prevent misleading applications

- A matching shape does not establish the laws. For limits/colimits, check
  existence and uniqueness of the mediating map, not just the stored fields.
- SQL joins with duplicates, NULL, or ordering need an explicit model beyond
  the set pullback. Pushouts do not automatically resolve arbitrary merge conflicts.
- Generic adapters need not be natural: inspect type-specific behavior and
  observable effects. Round-trip tests alone do not establish naturality.
- Use Lean/Mathlib when a formal proof is requested or materially useful;
  ordinary design scans can use equations, examples, and property tests.

## Output

Give the concrete objects/arrows, applicable structure, one law, one useful
test or counterexample, and the design consequence. For a research request,
also give a focused search query and the assumptions that need verification.
