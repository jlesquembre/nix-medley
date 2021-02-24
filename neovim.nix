{ pkgs }:
let
  lib = pkgs.lib;
in
rec {

  /*
    Helper to create a symlink to a local vim plugin. Useful to work on vim plugins without a nix rebuild.

    Example:

    programs.neovim.plugins = [
      (localVimPlugin /path/to/plugin)
    ];
  */
  localVimPlugin = p:
    assert builtins.isPath p;
    assert builtins.pathExists p;
    let
      p-str = builtins.toString p;
      name = baseNameOf p-str;
    in
    {
      plugin = pkgs.runCommand name { }
        ''
          mkdir -p $out/share/vim-plugins
          ln -s ${p-str} $out/share/vim-plugins/${name}
        '';
    };


  /*
    Compiles an aniseed plugin.
    fnlDir is the root directory with the fennel source.
    name and version are required by buildVimPluginFrom2Nix, but its value is
    not important.
    It is possible to specify the aniseed version to use, e.g:
      aniseed = pkgs.fetchFromGitHub {
        owner = "olical";
        repo = "aniseed";
        rev = "v3.12.0";
        sha256 = "1wy5jd86273q7sxa50kv88flqdgmg9z2m4b6phpw3xnl5d1sj9f7";
      };

    See compileAniseedPluginLocal for an example

  */
  compileAniseedPlugin = { name, version, src, fnlDir ? "fnl", aniseed ? pkgs.vimPlugins.aniseed }:
    let
      # Required to accept pkgs.vimPlugins AND pkgs.fetchFromGitHub
      aniseed-plugin-root = aniseed + /share/vim-plugins/aniseed;
      aniseed-root = if builtins.pathExists (aniseed-plugin-root) then aniseed-plugin-root else aniseed;

      luaCode = pkgs.runCommand "${name}-compiled"
        {
          src = src;
          allowSubstitues = false;
          preferLocalBuild = true;
        }
        ''
          mkdir $out
          # Don't copy fennel src dir
          shopt -s extglob
          cp -r ${src}/!(${fnlDir}) $out

          ${pkgs.neovim}/bin/nvim -u NONE -i NONE --headless \
              -c "let &runtimepath = &runtimepath . ',${aniseed-root}'" \
              -c "lua require('aniseed.compile').glob('**/*.fnl', '${src}/${fnlDir}', '$out/lua')" \
              +q
        '';
    in
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = name;
      version = version;
      src = luaCode;
    };


  /*
    Wrapper around compileAniseedPlugin. Compiles a local aniseed plugin.
    src must a string with the absolute path to the plugin directory.

    Example:
    (compileAniseedPluginLocal {
      src = "${config.home.homeDirectory}/projects/nterm.nvim";
      fnlDir = "src";
    })

  */
  compileAniseedPluginLocal =
    { src, name ? (baseNameOf src), version ? "DEV", fnlDir ? "fnl", aniseed ? pkgs.vimPlugins.aniseed }:
    compileAniseedPlugin {
      src = pkgs.lib.cleanSource (/. + src);
      inherit name version fnlDir;
    };



}
