{
  pkgs,
  helpers,
  ...
}:
let
  cocPlugins = pkgs.cocPlugins;
  vimPlugins = pkgs.vimPlugins;
  nvimPlugins = pkgs.nvimPlugins;
  plugins = vimPlugins // cocPlugins // nvimPlugins;

  # make config from lua file module
  mkConf =
    mod:
    mkFn ''
      ${builtins.readFile (./extra + "/${mod}.lua")}
    '';

  misc = import ./commonMisc.nix { inherit helpers mkFn plugins; };

  mkFn = content: ''
      function ()
    ${content}
      end
  '';

in
{
  package = pkgs.neovim;
  opts = misc.opts;

  withNodeJs = true;
  extraPackages = with pkgs; [
    ocamlPackages.ocamlformat # for coc-ocaml format dependence
    nixfmt-rfc-style

    watchman # for coc watch dependence

    postgresql

    gopls
    sumneko-lua-language-server
    stylua
    biome
    vscode-langservers-extracted
    nixd
    nixfmt-rfc-style
    ripgrep
  ];

  autoCmd = misc.autoCmd;

  autoGroups = misc.autoGroups;

  globals = misc.globals // {
    coc_user_config = import ./coc-settings.nix { inherit pkgs helpers; };
    coc_data_home = "~/.config/coc_nvim";

    coc_global_extensions = [
      "coc-git"
      "coc-pairs"
      "coc-lists"
      "coc-snippets"
      "coc-explorer"
      "coc-tsserver"
      "coc-sumneko-lua"
      "coc-stylua"
      "coc-biome"
      "coc-css"
      "coc-json"
      "coc-highlight"
      "@ph_chen/coc-nix"
      "@ph_chen/coc-ocaml"
    ];

  };

  plugins.lazy = {
    enable = true;
    plugins =
      (import ./commonPlugins.nix {
        inherit
          plugins
          mkFn
          mkConf
          pkgs
          ;
      })
      ++ (with plugins; [
        {
          pkg = vim-dadbod-ui;
          dependencies = [
            vim-dadbod
            vim-dadbod-completion
          ];
          cmd = [ "DBUI" ];
        }
        {
          pkg = supermaven-nvim;
          event = [ "InsertEnter" ];
          opts = {
            keymaps = {
              accept_suggestion = "<C-f>";
            };
          };
          config = true;
        }
        {
          pkg = hlsearch-nvim;
          config = true;
        }
        {
          pkg = nvim-ufo;
          dependencies = [ promise-async ];
          config = true;
        }
        {
          pkg = cocPlugins.coc-nvim;
          config = mkConf "coc";
          dependencies = [
            coc-eslint-tools
            # coc-rust-analyzer
          ];
        }
        {
          pkg = nvim-bqf;
          config = mkConf "bqf";
        }

        {
          pkg = codecompanion-nvim;
          config = mkConf "codecompanion";
        }
      ]);
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
      nmapl = k: a: nmap k "<CMD>lua ${a}<CR>";
      nmapc = k: a: nmap k "<CMD>${a}<CR>";
      nmapp = k: a: nmap k "<Plug>(${a})";

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

      ufoKeys = [
        (nmapl "zR" "require('ufo').openAllFolds")
        (nmapl "zM" "require('ufo').closeAllFolds")
      ];

      cocKeys = [
        (nmapc "<C-n>" "Explorer")
        (nmapc "<leader>cf" "Format")
        (nmapp "<leader>ca" "coc-codeaction-cursor")
        (nmapp "<leader>rn" "coc-rename")
        (nmapp "<leader>j" "coc-diagnostic-next")
        (nmapp "<leader>k" "coc-diagnostic-prev")
        (nmapp "gd" "coc-definition")
        (nmapp "gr" "coc-references")
        (nmapp "gy" "coc-type-definition")
        (nmapp "gi" "coc-implementation")
        (nmapc "<leader>fs" "CocList symbols")
        (nmapp "gk" "coc-git-prevchunk")
        (nmapp "gj" "coc-git-nextchunk")
        (nmapp "<leader>gp" "coc-git-chunkinfo")

        (nmapc "<leader>gb" "GitBlameDoc")
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
    keys ++ fzfLuaKeys ++ ufoKeys ++ cocKeys;

  extraConfigLua = misc.extraConfigLua;
}
