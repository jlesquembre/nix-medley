{ pkgs ? import <nixpkgs> { } }:
let
  lib = pkgs.lib;
in
{
  exportVars = (vars:
    lib.concatStringsSep "\n"
      (lib.mapAttrsToList (n: v: ''export ${n}="${v}"'') vars)
    + "\n"
  );

  /**
    Injects a certificate in the default jdk trust store (the cacerts file)

    Usage:

    my-jdk = jdk-with-cert
      {
        jdk = pkgs.jdk15;
        cert = pkgs.fetchurl {
          name = "my-cert.pem";
          url = "https://test.com/ca.pem";
          sha256 = "1111111111111111111111111111111111111111111111111111";
        };
      };
    NOTE: Instead, you could set the javax.net.ssh.trustStore to a different dir, e.g.:
    JDK_JAVA_OPTIONS = ''-Djavax.net.ssl.trustStore=${project-dir}/cacerts'';
  */
  jdk-with-cert = { jdk ? pkgs.adoptopenjdk-hotspot-bin-15, cert }:
    let
      alias = lib.strings.sanitizeDerivationName cert;
    in
    jdk.overrideAttrs
      (oldAttrs: {
        postFixup =
          ''
            ${oldAttrs.postFixup}
            cacerts=$(find $out -name cacerts -print0)
            ${jdk}/bin/keytool -importcert -trustcacerts \
              -storepass changeit \
              -alias '${alias}' \
              -keystore $cacerts \
              -file '${cert}' \
              -noprompt
          '';
      });

  neovim = import ./neovim.nix { inherit pkgs; };

  # From https://discourse.nixos.org/t/wrapping-a-program-symlinking-at-same-time/8256
  writeShellScriptBinAndSymlink =
    { pkg, text, name ? pkgs.lib.strings.getName pkg }:
    pkgs.symlinkJoin {
      name = name;
      paths = [
        (pkgs.writeShellScriptBin name text)
        pkg
      ];
    };
}
