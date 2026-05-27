{
  description = "Demo flake — each standard validated output attribute";

  inputs.nixpkgs.url = "git+ssh://git@github.com/NixOS/nixpkgs.git?ref=nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # 1. packages — `nix build .#name`
      packages.${system}.default = pkgs.hello;

      # 2. apps — `nix run .#name`  (needs type + program)
      apps.${system}.default = {
        type = "app";
        program = "${pkgs.hello}/bin/hello";
        meta.description = "Say hello";
      };

      # 3. checks — `nix flake check` builds these
      checks.${system}.hello-builds = pkgs.hello;

      # 4. devShells — `nix develop`
      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = [ pkgs.hello ];
      };

      # 5. formatter — `nix fmt` (single derivation per system)
      formatter.${system} = pkgs.hello;

      # 6. overlays — lambda with arg 'final' (or '_')
      overlays.default = final: prev: { };

      # 7. nixosModules — NixOS module (any value)
      nixosModules.default = { config, lib, pkgs, ... }: { };

      # 8. templates — `nix flake init -t` (needs path + description)
      templates.default = {
        path = ./.;
        description = "Demo flake template";
      };

      # 9. bundlers — `nix bundle` (each is a function)
      bundlers.${system}.default = drv: drv;

      # 10. hydraJobs — Hydra CI (recursive attrsets, leaves are derivations)
      hydraJobs.${system}.hello = pkgs.hello;

      # 11. legacyPackages — like packages but unvalidated per-attribute
      legacyPackages.${system} = pkgs;
    };
}
