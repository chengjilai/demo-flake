{
  description = "whatever to describe this flake";
  inputs.nixpkgs.url = "git+ssh://git@github.com/NixOS/nixpkgs.git?ref=nixos-unstable";
  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.a = pkgs.hello;
      apps.${system}.a = {
        type = "whatever";
        program = "${pkgs.hello}/bin/hello";
        meta.description = "an arbitrary description string";
      };
      checks.${system}.a = pkgs.hello;
      devShells.${system}.a = pkgs.mkShellNoCC {
        packages = [
          pkgs.hello
          pkgs.fish
          pkgs.python3
        ];
        inputsFrom = [ ];
        shellHook = ''
          exec fish
        '';
        FOO = "bar";
      };
      formatter.${system} = pkgs.nixfmt-tree;
      overlays.a = final: prev: { };
      # ▲ inside: 'path' and 'description' keys are required.
      # ▼ their values are arbitrary.
      templates.a = {
        path = ./python-starter;
        description = "A minimal Python project";
      };
      bundlers.${system}.a = drv: drv;
      hydraJobs.${system}.a = pkgs.hello;
    };
}
