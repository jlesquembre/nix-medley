let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  nixt = import "${sources.nixt}/package.nix" { };

  tests =
    let
      cmd = "nixt -v ${toString ./.}/tests";
    in
    pkgs.writeScriptBin "t" ''
      #!${pkgs.bash}/bin/bash
      echo ${cmd}
      echo "-----"
      echo
      ${cmd}
    '';

in
pkgs.mkShell {
  buildInputs = [
    tests
    nixt
  ];
  NIX_PATH = "nixpkgs=${sources.nixpkgs}";
}
