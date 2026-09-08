# Shared skills from nix-mac at 5a8802e136283e80b36478bf30d12316eacc1a22.
{ inputs }:
{
  sources = {
    agentic-awesome-skills.path = inputs.agentic-awesome-skills;
    asd-ste100-skill.path = inputs.asd-ste100-skill;
    awesome-copilot.path = inputs.awesome-copilot;
    caveman.path = inputs.caveman;
    dba-review.path = inputs.dba-review;
    i-have-adhd.path = inputs.i-have-adhd;
    trailofbits-skills.path = inputs.trailofbits-skills;
    trailofbits-skills-curated.path = inputs.trailofbits-skills-curated;
    wshobson-agents.path = inputs.wshobson-agents;
  };
  skills = {
    asd-ste100-skill = { from = "asd-ste100-skill"; path = "."; };
    audit-augmentation = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/audit-augmentation"; };
    audit-context-building = { from = "trailofbits-skills"; path = "plugins/audit-context-building/skills/audit-context-building"; };
    caveman = { from = "caveman"; path = "skills/caveman"; };
    code-improver = { from = "trailofbits-skills"; path = "plugins/code-improver/skills/code-improver"; };
    crypto-protocol-diagram = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/crypto-protocol-diagram"; };
    database-migrations-sql-migrations = { from = "agentic-awesome-skills"; path = "skills/database-migrations-sql-migrations"; };
    dba-review = { from = "dba-review"; path = "."; };
    diagramming-code = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/diagramming-code"; };
    differential-review = { from = "trailofbits-skills"; path = "plugins/differential-review/skills/differential-review"; };
    dimensional-analysis = { from = "trailofbits-skills"; path = "plugins/dimensional-analysis/skills/dimensional-analysis"; };
    fp-check = { from = "trailofbits-skills"; path = "plugins/fp-check/skills/fp-check"; };
    genotoxic = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/genotoxic"; };
    graph-evolution = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/graph-evolution"; };
    i-have-adhd = { from = "i-have-adhd"; path = "skills/i-have-adhd"; };
    mermaid-to-proverif = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/mermaid-to-proverif"; };
    modern-python = { from = "trailofbits-skills"; path = "plugins/modern-python/skills/modern-python"; };
    mutation-testing = { from = "trailofbits-skills"; path = "plugins/mutation-testing/skills/mutation-testing"; };
    openai-gh-fix-ci = { from = "trailofbits-skills-curated"; path = "plugins/openai-gh-fix-ci/skills/openai-gh-fix-ci"; };
    planning-with-files = { from = "trailofbits-skills-curated"; path = "plugins/planning-with-files/skills/planning-with-files"; };
    postgresql = { from = "agentic-awesome-skills"; path = "skills/postgresql"; };
    postgresql-code-review = { from = "awesome-copilot"; path = "skills/postgresql-code-review"; };
    postgresql-optimization = { from = "awesome-copilot"; path = "skills/postgresql-optimization"; };
    property-based-testing = { from = "trailofbits-skills"; path = "plugins/property-based-testing/skills/property-based-testing"; };
    rust-review = { from = "trailofbits-skills"; path = "plugins/rust-review/skills/rust-review"; };
    second-opinion = { from = "trailofbits-skills"; path = "plugins/second-opinion/skills/second-opinion"; };
    slicing-code-context = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/slicing-code-context"; };
    spec-to-code-compliance = { from = "trailofbits-skills"; path = "plugins/spec-to-code-compliance/skills/spec-to-code-compliance"; };
    sql-code-review = { from = "awesome-copilot"; path = "skills/sql-code-review"; };
    sql-optimization-patterns = { from = "wshobson-agents"; path = "plugins/developer-essentials/skills/sql-optimization-patterns"; };
    supply-chain-risk-auditor = { from = "trailofbits-skills"; path = "plugins/supply-chain-risk-auditor/skills/supply-chain-risk-auditor"; };
    trailmark = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/trailmark"; };
    trailmark-finding-triage = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/trailmark-finding-triage"; };
    trailmark-review-gate = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/trailmark-review-gate"; };
    trailmark-structural = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/trailmark-structural"; };
    trailmark-summary = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/trailmark-summary"; };
    trailmark-variant-neighborhood = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/trailmark-variant-neighborhood"; };
    vector-forge = { from = "trailofbits-skills"; path = "plugins/trailmark/skills/vector-forge"; };
  };
}
