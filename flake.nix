{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };
  outputs = { self, nixpkgs, systems }:
    let
      pkgsFor = system: import nixpkgs { inherit system; };
      eachSystem = f:
        nixpkgs.lib.genAttrs (import systems)
          (system: f {
            inherit system;
            pkgs = pkgsFor system;
          });
    in
    {
      packages = eachSystem (args: {
        default = import ./. args;
      });
      formatter = eachSystem ({ pkgs, ... }:
        pkgs.nixpkgs-fmt);
    };
}
