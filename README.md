# Nix Medley

A collection of functions extracted from my nix projects.

Take a look to the source code to understand how to use it, I added comments
with some usage examples.

## Installation

Choose one of the following methods:

1. [niv](https://github.com/nmattia/niv)

   ```bash
   niv add jlesquembre/nix-medley
   ```

1. fetchFromGitHub:

   ```nix
   nix-medley = import
     (pkgs.fetchFromGitHub {
       owner = "jlesquembre";
       repo = "nix-medley";
       # replace this with latest commit or tag
       rev = "298b235f664f925b433614dc33380f0662adfc3f";
       # replace this with an actual hash
       sha256 = "0000000000000000000000000000000000000000000000000000";
     })
     { };
   ```

1. Clone the project and import it:

   ```nix
   nix-medley = (import /path/to/nix-medley { inherit pkgs; });
   ```

## Function list

### Neovim

[Link to file](https://github.com/jlesquembre/nix-medley/blob/master/neovim.nix)

- localVimPlugin
- compileAniseedPlugin
- compileAniseedPluginLocal
