{ pkgs ? import <nixpkgs> { }, ... }:
{
  run = command: pkgs.stdenv.mkDerivation {
    name = "run";
    src = ./.;
    installPhase = "mkdir $out";
    shellHook = ''
      exec 1>&2
      ${command}
      exit 0
    '';
  };
}
