{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs = { self, nixpkgs }:
    let
      defaultSystems = [ "x86_64-linux" "x86_64-darwin" ];
      perSystem = nixpkgs.lib.genAttrs defaultSystems;
      pkgsFor = system: import nixpkgs { inherit system; };

      nixshFor = system:
        let
          pkgs = pkgsFor system;
        in
        pkgs.stdenv.mkDerivation rec {
          name = "nixsh";
          buildInputs = [ pkgs.makeWrapper ];
          unpackPhase = "true";
          installPhase = ''
            mkdir -p $out/bin
            makeWrapper ${pkgs.nix}/bin/nix $out/bin/nixsh --argv0 nixsh --add-flags "repl ${./lib.nix}"
          '';
        };
    in
    rec {
      packages = perSystem (system: rec {
        nixsh = nixshFor system;
        default = nixsh;
      });
      apps = perSystem (system: rec {
        nixsh = {
          type = "app";
          program = "${packages.${system}.nixsh}/bin/nixsh";
        };
        default = nixsh;
      });
    };
}
