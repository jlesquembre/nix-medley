{
  description = "Helper functions for Nix";

  outputs = { self, nixpkgs }: {
    lib = pkgs: import ./. { inherit pkgs; };
  };
}
