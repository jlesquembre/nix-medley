{ lib ? import <nixpkgs/lib> }:
{
  exportVars = (vars:
    lib.concatStringsSep "\n"
      (lib.mapAttrsToList (n: v: ''export ${n}="${v}"'') vars)
    + "\n"
  );
}
