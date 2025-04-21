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

  loadModules = mods: ''
    do
      local _modules = {
        ${builtins.concatStringsSep ",\n" (
          map (mod: "function () 
          ${builtins.readFile (./extra + "/${mod}.lua")}
        end") mods
        )}
      }
      
      for _, mod in ipairs(_modules) do
        mod()
      end
    end
  '';

  mkFn = content: ''
      function ()
    ${content}
      end
  '';

in
{
  package = pkgs.neovim;
  opts = {
    number = true;
    cursorline = true;

    backup = false;
    swapfile = false;
    undofile = true;

    ignorecase = true;
    smartcase = true;
    infercase = true;

    laststatus = 3;
    signcolumn = "yes";

    linebreak = true;

    whichwrap = "<,>,[,],~";
    breakindentopt = "shift:2,min:20";
    showbreak = "↳ ";

    shiftwidth = 2;
    tabstop = 2;
    softtabstop = 2;
    expandtab = true;

    termguicolors = true;

    foldcolumn = "0";

    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
    foldmethod = "manual";

    # winbar = "%=%r %f %m%=";
  };

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
  ];

  autoCmd = [
    {
      event = [
        "FileType"
      ];
      callback = helpers.mkRaw ''
        function()
          vim.keymap.set('n', 'q', '<Cmd>q<CR>', { silent = true, buffer = true })
        end
      '';
      group = "patch_augroup";
      pattern = [
        "help"
        "dashboard"
        "coctree"
      ];
    }
  ];

  autoGroups = {
    patch_augroup.clear = true;
  };

  globals = {
    mapleader = " ";
    coc_user_config = import ./coc-settings.nix { inherit pkgs helpers; };
    coc_data_home = "~/.config/coc_nvim";

    # for leaderf
    Lf_WindowPosition = "popup";

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
      (with plugins; [
        {
          pkg = nvim-spectre;
          cmd = [ "Spectre" ];
        }
        {
          pkg = lazygit-nvim;
          cmd = [ "LazyGit" ];
        }
        {
          pkg = vim-dadbod-ui;
          dependencies = [
            vim-dadbod
            vim-dadbod-completion
          ];
          cmd = [ "DBUI" ];
        }
        {
          pkg = fzf-lua;
          lazy = true;
          opts = {
            winopts = {
              height = 0.65;
              row = 0.7;
            };
          };
          cmd = "FzfLua";
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
          pkg = nvim-lastplace;
          opts = {
            lastplace_ignore_buftype = [
              "quickfix"
              "nofile"
              "help"
            ];
            lastplace_ignore_filetype = [
              "gitcommit"
              "gitrebase"
              "svn"
              "hgcommit"
            ];
            lastplace_open_folds = true;
          };
          config = true;
        }

        {
          pkg = comment-nvim;
          lazy = true;
          config = mkFn ''
            require('Comment').setup({
              mappings = {
                basic = true,
                extra = false,
              },
              pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
          '';
        }
        {
          pkg = nvim-osc52;
          # TODO: add lazy key map
          config = mkFn ''
            vim.keymap.set('v', 'fy', require('osc52').copy_visual)
          '';
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
        {
          pkg = nvim-treesitter;
          config =
            let
              nvim-plugintree = pkgs.vimPlugins.nvim-treesitter.withPlugins (
                p: with p; [
                  bash
                  go
                  javascript
                  typescript
                  tsx
                  json
                  lua
                  markdown
                  markdown_inline
                  nix
                  rust
                  yaml
                  ocaml
                  zig
                  vue
                  css
                  html
                  xml
                  scss
                  caddy
                ]
              );

              treesitter-parsers = pkgs.symlinkJoin {
                name = "treesitter-parsers";
                paths = nvim-plugintree.dependencies;
              };
            in
            mkFn ''
              vim.opt.runtimepath:append("${nvim-plugintree}")
              vim.opt.runtimepath:append("${treesitter-parsers}")

              require('nvim-treesitter.configs').setup({
                parser_install_dir = "${treesitter-parsers}",
                auto_install = false,
                indent = { 
                  enable = true,
                  disable = { "ocaml" },
                };
                highlight = {
                  enable = true,
                  additional_vim_regex_highlighting = false,
                },
              })
            '';
          dependencies = [
            nvim-treesitter-context
            nvim-ts-context-commentstring
          ];
        }
        {
          pkg = vitesse-nvim;
          enabled = false;
          config = mkFn "vim.cmd.colorscheme 'vitesse'";
        }
        {
          pkg = catppuccin-nvim;
          enabled = false;
          config = mkFn "vim.cmd.colorscheme 'catppuccin'";
        }
        {
          pkg = oh-lucy-nvim;
        }
        {
          pkg = rose-pine;
          config = mkFn "vim.cmd.colorscheme 'rose-pine-main'";
        }
        {
          pkg = toggleterm-nvim;
          opts = {
            size = 20;
            open_mapping = "<c-t>";
          };
          config = true;
        }
        {
          pkg = LeaderF;
          cmd = "Leaderf";
        }
      ])
      ++ (
        with plugins;
        [
          vim-ocaml
          vim-smoothie
          vim-surround
          fcitx-nvim
          plenary-nvim
        ]
        |> (map (p: {
          pkg = p;
        }))
      );
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
        (nmapc "<leader>bd" "bd")
        (vnmap "<C-j>" "3j")
        (vnmap "<C-k>" "3k")
        (vnmap "<C-h>" "4h")
        (vnmap "<C-l>" "4l")

        (nmapc "<leader>lg" "LazyGit")
      ];
    in
    keys ++ fzfLuaKeys ++ ufoKeys ++ cocKeys;

  extraConfigLua = ''
    vim.cmd [[set rtp+=${./.}]]
    local cache_dir = vim.env.HOME .. '/.cache/nvim/'
    local opt = vim.opt
    opt.directory = cache_dir .. 'swap/'
    opt.undodir = cache_dir .. 'undo/'
    opt.backupdir = cache_dir .. 'backup/'
    opt.viewdir = cache_dir .. 'view/'
    opt.spellfile = cache_dir .. 'spell/en.uft-8.add'
    opt.history = 2000

    ${loadModules [ "stsline" ]}
  '';
}
