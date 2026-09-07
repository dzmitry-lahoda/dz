{
  description = "Review agents development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    codegraph.url = "github:dzmitry-lahoda-forks/codegraph/codex/add-nix-flake";
    codegraph.inputs.nixpkgs.follows = "nixpkgs";
    trailmark.url = "github:trailofbits/trailmark/pull/75/head";
    mewt.url = "github:trailofbits/mewt/main";
  };

  outputs = { nixpkgs, nixpkgs-unstable, codegraph, trailmark, mewt, ... }:
    let
      supportedSystems = [
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
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
            packages = [
              pkgs.bashInteractive
              codegraph.packages.${system}.default
              pkgs.codeql
              pkgs.postgresql
              pkgs.python3
              pkgs.uv
              pkgs.python314Packages.sqlglot
              pkgs.sqruff
              pkgs.secretspec
              unstablePkgs.squawk
              pkgs.git
              pkgs.ripgrep
              pkgs.jujutsu
              pkgs.eza
              trailmark.packages.${system}.default
              mewt.packages.${system}.default
              pkgs.tree-sitter-grammars.tree-sitter-sql
            ];
          };
        });
    };
}
