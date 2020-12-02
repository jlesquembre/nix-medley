{ pkgs ? import <nixpkgs> { }, nixt }:
let
  utils = import ../default.nix { };
in
nixt.mkSuite "test utils" {
  "export var" =
    (utils.exportVars { foo = "bar"; } ==
      ''
        export foo="bar"
      '');

  "export multiple vars" =
    let
      input = {
        bar = "bar";
        foo = "foo";
      };
      expected =
        ''
          export bar="bar"
          export foo="foo"
        '';
      result = utils.exportVars input;
    in
    expected == result || throw result;

}
