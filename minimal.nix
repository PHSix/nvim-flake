{
  pkgs,
  helpers,
  ...
}:
let
  vimPlugins = pkgs.vimPlugins;
  nvimPlugins = pkgs.nvimPlugins;
  plugins = vimPlugins // nvimPlugins;

  # make config from lua file module
  mkConf =
    mod:
    mkFn ''
      ${builtins.readFile (./extra + "/${mod}.lua")}
    '';

  mkFn = content: ''
      function ()
    ${content}
      end
  '';

  misc = import ./commonMisc.nix { inherit helpers mkFn plugins; };

in
{
  package = pkgs.neovim;
  opts = misc.opts;

  withNodeJs = true;

  extraPackages = with pkgs; [
    ripgrep
  ];

  autoCmd = misc.autoCmd;

  autoGroups = misc.autoGroups;

  globals = misc.globals;

  plugins.lazy = {
    enable = true;
    plugins = import ./commonPlugins.nix {
      inherit
        plugins
        mkFn
        mkConf
        pkgs
        ;
    };
  };

  keymaps =
    let
      map = mode: key: action: options: {
        inherit
          mode
          key
          action
          options
          ;
      };
      nmap =
        k: a:
        (map [ "n" ] k a {
          silent = true;
          nowait = true;
        });
      # nmapl = k: a: nmap k "<CMD>lua ${a}<CR>";
      nmapc = k: a: nmap k "<CMD>${a}<CR>";

      vnmap =
        k: a:
        (map [ "v" "n" ] k a {
          silent = true;
          nowait = true;
        });

      fzfLuaKeys = [
        (nmapc "<leader>fb" "FzfLua buffers")
        (nmapc "<leader>fw" "FzfLua live_grep")
        (nmapc "<leader>ff" "FzfLua files")
        (nmapc "<leader>fo" "FzfLua oldfiles")
        (nmapc "<leader>fr" "FzfLua resume")
      ];

      keys = [
        (map [ "v" "n" ] ";" ":" { })
        (nmapc "<leader>bd" "Bdelete")
        (vnmap "<C-j>" "3j")
        (vnmap "<C-k>" "3k")
        (vnmap "<C-h>" "4h")
        (vnmap "<C-l>" "4l")

        (nmapc "<leader>lg" "LazyGit")
      ];
    in
    keys ++ fzfLuaKeys;

  extraConfigLua = misc.extraConfigLua;
}
