{
  description = "Demo flake — arbitrary names replaced with single letters";

  inputs.nixpkgs.url = "git+ssh://git@github.com/NixOS/nixpkgs.git?ref=nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      # ▲ 'packages', 'x86_64-linux' are required structure.
      # ▼ 'a' is an arbitrary name you choose.
      packages.${system}.a = pkgs.hello;

      # ▲ 'apps', 'x86_64-linux' are required.
      # ▼ 'a' arbitrary.
      # ▲ 'type', 'program' keys are required inside the app value.
      # ▼ the string "whatever" for type, and the program path are arbitrary.
      apps.${system}.a = {
        type = "whatever";
        program = "${pkgs.hello}/bin/hello";
        meta.description = "an arbitrary description string";
      };

      # ▲ 'checks', 'x86_64-linux' required.
      # ▼ 'a' arbitrary.
      checks.${system}.a = pkgs.hello;

      # ▲ 'devShells', 'x86_64-linux' required.
      # ▼ 'a' arbitrary.
      devShells.${system}.a = pkgs.mkShellNoCC {
        packages = [ pkgs.hello ];
      };

      # ▲ 'formatter', 'x86_64-linux' required.
      # ▼ value is directly a derivation (no extra naming level).
      formatter.${system} = pkgs.hello;

      # ▲ 'overlays' required.
      # ▼ 'a' arbitrary.
      overlays.a = final: prev: { };

      # ▲ 'templates' required.
      # ▼ 'a' arbitrary.
      # ▲ inside: 'path' and 'description' keys are required.
      # ▼ their values are arbitrary.
      templates.a = {
        path = ./.;
        description = "...";
      };

      # ▲ 'bundlers', 'x86_64-linux' required.
      # ▼ 'a' arbitrary.
      bundlers.${system}.a = drv: drv;

      # ▲ 'hydraJobs', 'x86_64-linux' required.
      # ▼ 'a' arbitrary.
      hydraJobs.${system}.a = pkgs.hello;

      # ▲ 'legacyPackages', 'x86_64-linux' required.
      # ▼ value is directly a package set (no extra naming level).
      legacyPackages.${system} = pkgs;
    };
}
