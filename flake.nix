{
  description = "Python package to access MiniZinc";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication mkPoetryEditablePackage;
      in
      {
        packages = {
          minizinc-python = mkPoetryApplication { projectDir = self; };
          minizinc-python-dev = mkPoetryApplication {
            projectDir = self;
            groups = [ "dev" "test" ];
          };
          default = self.packages.${system}.minizinc-python;
        };
      }
    );
}
