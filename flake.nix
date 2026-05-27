{
  description = "Demo flake demonstrating all standard validated output attributes";

  inputs.nixpkgs.url = "git+ssh://git@github.com/NixOS/nixpkgs.git?ref=nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
    in
    {
      # 1. packages — buildable package derivations, used by `nix build`
      packages = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.hello;
        hello   = nixpkgs.legacyPackages.${system}.hello;
      });

      # 2. apps — runnable applications, used by `nix run`
      #    Must have {type, program}. Optional meta.description
      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${nixpkgs.legacyPackages.${system}.hello}/bin/hello";
          meta.description = "Say hello";
        };
      });

      # 3. checks — tests/verifications, built by `nix flake check`
      checks = forAllSystems (system: {
        hello-builds = nixpkgs.legacyPackages.${system}.hello;
      });

      # 4. devShells — development environments, entered via `nix develop`
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShellNoCC {
          packages = [ nixpkgs.legacyPackages.${system}.hello ];
        };
      });

      # 5. formatter — single derivation per system, invoked by `nix fmt`
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.hello);

      # 6. overlays — Nixpkgs overlay functions (lambda with arg 'final')
      overlays.default = final: prev: { };

      # 7. nixosModules — NixOS module functions
      nixosModules.default = { ... }: { };

      # 8. templates — project scaffolds, used by `nix flake init -t`
      #    Must have `path` (existing) and `description` (string)
      templates.default = {
        path = ./.;
        description = "Demo flake template";
      };

      # 9. bundlers — create self-contained bundles, used by `nix bundle`
      #    Each must be a function (lambda)
      bundlers = forAllSystems (system: {
        default = drv: drv;
      });

      # 10. hydraJobs — for Hydra CI; recursive attrsets of derivations
      hydraJobs = forAllSystems (system: {
        hello = nixpkgs.legacyPackages.${system}.hello;
      });

      # 11. legacyPackages — like packages, but unvalidated per-attribute
      legacyPackages = forAllSystems (system: nixpkgs.legacyPackages.${system});
    };
}
