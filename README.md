# Nix Medley

A collection of functions extracted from my nix projects.

It requires Nix Flakes.

Take a look to the source code to understand how to use it, I added comments
with some usage examples.

## Usage

```nix
{
  inputs.nix-medley = {
    url = github:jlesquembre/nix-medley;
    inputs.nixpkgs.follows = "nixpkgs"; # Not needed but recommneded
  };
  outputs = { self, nixpkgs, nix-medley, ... }@inputs:
    let
      pkgs = import nixpkgs {
        system = "...";
      };
      utils = nix-medley.lib pkgs;
    in
    {
      # ...
      # utils.someFn
    };
}
```

## Function list

### Neovim

[Link to file](https://github.com/jlesquembre/nix-medley/blob/master/neovim.nix)

- localVimPlugin
- compileAniseedPlugin
- compileAniseedPluginLocal
