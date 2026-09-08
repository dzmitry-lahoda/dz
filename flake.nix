{
  description = "Review agents development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    codegraph.url = "github:dzmitry-lahoda-forks/codegraph/codex/add-nix-flake";
    codegraph.inputs.nixpkgs.follows = "nixpkgs";
    trailmark.url = "github:trailofbits/trailmark/pull/75/head";
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agentic-awesome-skills = {
      url = "github:sickn33/agentic-awesome-skills/78acbe3f333315cfdd887c81a11aa1ffe42f8e64";
      flake = false;
    };
    asd-ste100-skill = {
      url = "github:danyuchn/asd-ste100-skill/6f7bb361ae9b97a9fcb5f5c57cbac40eacf2d438";
      flake = false;
    };
    awesome-copilot = {
      url = "github:github/awesome-copilot/f95f1b4c3b153984e3da2744cef395c2355d0a44";
      flake = false;
    };
    caveman = {
      url = "github:JuliusBrussee/caveman/15581d14007fd01fb3f132016741962f34936ca2";
      flake = false;
    };
    dba-review = {
      url = "github:dhdtech/dba-review/a43f0a60da6283ef8c8838d32e36d7a50b9ace59";
      flake = false;
    };
    i-have-adhd = {
      url = "github:ayghri/i-have-adhd/58494af57962b2d7a996b4d419474380a299af5e";
      flake = false;
    };
    trailofbits-skills = {
      url = "github:trailofbits/skills/d3323cefbcf645678b8dc481de204b02ad3d02dc";
      flake = false;
    };
    trailofbits-skills-curated = {
      url = "github:trailofbits/skills-curated/6d05be4889017b06fb15069f371afd220daffb62";
      flake = false;
    };
    wshobson-agents = {
      url = "github:wshobson/agents/a30778f8c4e6b0a87567941b7cca4f534bf642b6";
      flake = false;
    };
    mewt.url = "github:trailofbits/mewt/main";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, codegraph, trailmark, mewt, ... }:
    let
      supportedSystems = [
        "aarch64-darwin"
      ];

      agentLib = inputs.agent-skills.lib.agent-skills;
      skillConfig = import ./nix/skills.nix { inherit inputs; };
      selection = agentLib.selectSkills {
        inherit (skillConfig) sources skills;
        catalog = { };
      };
      localTargets = {
        codex = agentLib.defaultLocalTargets.codex // { enable = true; };
        claude = agentLib.defaultLocalTargets.claude // { enable = true; structure = "link"; };
      };
      skillBundle = system: agentLib.mkBundle {
        pkgs = nixpkgs.legacyPackages.${system};
        inherit selection;
      };

      # Manage individual Antigravity entries so repository-owned skills remain intact.
      skillsInstaller = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          bundle = skillBundle system;
          sharedInstaller = agentLib.mkSyncProgram {
            mode = "local";
            programName = "skills-install-local";
            inherit pkgs bundle;
            targets = localTargets;
          };
          agyInstallers = nixpkgs.lib.mapAttrsToList (name: _:
            agentLib.mkSyncProgram {
              mode = "local";
              programName = "skills-install-local";
              inherit pkgs;
              bundle = "${bundle}/${name}";
              targets.antigravity = {
                enable = true;
                dest = ".agents/skills/${name}";
                structure = "link";
              };
            }
          ) selection;
        in pkgs.writeShellApplication {
          name = "skills-install-local";
          text = nixpkgs.lib.concatMapStringsSep "\n"
            (installer: "${installer}/bin/skills-install-local")
            ([ sharedInstaller ] ++ agyInstallers);
        };

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system: {
        agent-skills-bundle = skillBundle system;
      });
      checks = forAllSystems (system: {
        skills = skillBundle system;
      });
      apps = forAllSystems (system: {
        skills-install-local = {
          type = "app";
          program = "${skillsInstaller system}/bin/skills-install-local";
        };
      });
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg: nixpkgs.lib.getName pkg == "codeql";
          };
          unstablePkgs = import nixpkgs-unstable { inherit system; };
        in
        {
          default = pkgs.mkShell {
            shellHook = "${skillsInstaller system}/bin/skills-install-local";
            packages = [
              pkgs.bashInteractive
              codegraph.packages.${system}.default
              pkgs.codeql
              pkgs.postgresql
              trailmark.packages.${system}.default
              pkgs.uv
              pkgs.sqruff
              pkgs.secretspec
              pkgs.jdk17_headless
              pkgs.nodejs_22
              pkgs.quint
              unstablePkgs.squawk
              pkgs.git
              pkgs.ripgrep
              pkgs.jujutsu
              pkgs.eza
              mewt.packages.${system}.default
              unstablePkgs.bun
              unstablePkgs.apm-cli
            ];
          };
        });
    };
}
