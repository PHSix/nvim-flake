{
  plugins,
  mkFn,
  pkgs,
  ...
}:
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
    pkg = fzf-lua;
    lazy = true;
    config = mkFn ''
      require('fzf-lua').setup({
        winopts = {
          preview = {
            layout = vim.o.lines * 2 > vim.o.columns and 'vertical' or 'horizontal',
          },
        },
      })
    '';
    cmd = "FzfLua";
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
    config = mkFn ''
      vim.keymap.set('v', 'fy', require('osc52').copy_visual)
    '';
  }
  {
    pkg = nvim-treesitter;
    config =
      let
        nvim-plugintree = plugins.nvim-treesitter.withPlugins (
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
    config = mkFn "vim.cmd.colorscheme 'rose-pine-moon'";
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
    pkg = bufdelete-nvim;
    cmd = "Bdelete";
  }
])
++ (
  (with plugins; [
    vim-ocaml
    vim-smoothie
    vim-surround
    fcitx-nvim
    plenary-nvim
  ])
  |> (map (pkg: {
    inherit pkg;
  }))
)
