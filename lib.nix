{ pkgs ? import <nixpkgs> { }, ... }:
{
  # nix repl will not run shellHook on mkShell
  sh = command: pkgs.stdenv.mkDerivation {
    name = "sh";

    # do not require src
    unpackPhase = "true";

    shellHook = ''
      # nix repl only shows stderr, so redirect stdout to stderr
      exec 1>&2

      ${command}

      # return to nix repl
      exit 0
    '';
  };
}
