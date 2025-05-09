{ pkgs, ... }:
{
  coc = {
    preferences = {
      formatOnSave = true;
      enableMessageDialog = true;
    };
  };

  suggest = {
    removeDuplicateItems = true;
    completionItemKindLabels = {
      default = " ";
      text = "";
      method = "󰆧";
      function = "󰊕";
      constructor = "";
      field = "󰇽";
      variable = "󰂡";
      class = "󰠱";
      interface = "";
      module = "";
      property = "󰜢";
      unit = "";
      value = "󰎠";
      enum = "";
      keyword = "󰌋";
      snippet = "";
      color = "󰏘";
      file = "󰈙";
      reference = "";
      folder = "󰉋";
      enumMember = "";
      constant = "󰏿";
      struct = "";
      event = "";
      operator = "󰆕";
      typeParameter = "󰅲";
    };
    pumFloatConfig = {
      border = true;
    };
    triggerCompletionWait = 50;
  };

  snippets = {
    ultisnips.enable = false;
    snipmate.enable = true;
  };

  diagnostic = {
    floatConfig = {
      border = true;
      title = "diagnostic";
      rounded = true;
    };
    # virtualText = true;
    errorSign = " ";
    warningSign = " ";
    hintSign = " ";
    infoSign = " ";
    enableMessage = "jump";
  };

  colors.enable = true;

  # for lsp
  semanticTokens.enable = false;
  outline.autoPreview = false;
  signature.floatConfig = {
    shadow = true;
  };

  hover.floatConfig = {
    border = true;
    title = "doc";
  };

  #
  # config for coc-explorer
  #
  explorer = {
    position = "right";
    git.enable = false;
    trash.command = "nodejs:module";
    diagnostic.enableSubscriptNumber = false;
    keyMappings.global = {
      s = "open:vsplit";
      S = "open:split";
      o = [
        "wait"
        "expandable?"
        [
          "expanded?"
          "collapse"
          "expand"
        ]
        "open"
      ];
      d = "delete";
      x = "cutFile";
      H = "toggleHidden";
    };
    sources = [
      {
        name = "file";
        expand = true;
      }
    ];
    icon.customIcons = {
      icons = {
        nix = {
          code = "";
          color = "#3f5d72";
        };
        justfile = {
          code = "";
          color = "#526064";
        };
      };
      extensions = {
        nix = "nix";
      };
      filenames = {
        vimrc = "vim";
        justfile = "justfile";
      };
      dirnames = { };
      patternMatches = { };
      dirPatternMatches = { };
    };
    icon.enableNerdfont = true;
    enableFloatinput = true;
  };

  #
  # config for coc-tsserver
  #
  typescript = {
    format.enable = false;
    locale = "en";
    implementationsCodeLens.enabled = false;
    referencesCodeLens.enabled = false;
    preferences.autoImportFileExcludePatterns = [
      "node_modules/@iconify-json"
      "node_modules/@@google-cloud"
      "node_modules/@mui/icons-material"
      "node_modules/@mui/lab"
      "node_modules/@mui/system"
      "node_modules/@mui/x-*/**"
      "node_modules/**/internals"
      "node_modules/aws-sdk"
      "node_modules/framer-motion"
      "node_modules/typescript"
    ];
    suggestionActions.enabled = false;
  };
  tsserver.useLocalTsdk = true;
  javascript.suggestionActions.enabled = false;

  #
  # config for coc-nix
  #
  nixd.formattingCommand = [ "nixfmt" ];

  #
  # config for coc-lua
  #
  Lua = {
    diagnostics.globals = [ "vim" ];
    hint.enable = false;
    format.enable = false;
    misc.parameters = [
      "--metapath"
      "~/.cache/sumneko_lua/meta"
      "--logpath"
      "~/.cache/sumneko_lua/log"
    ];
  };
  sumneko-lua.serverDir = "${pkgs.lua-language-server}/share/lua-language-server";

  #
  # config for coc-stylua
  #
  stylua.styluaPath = "${pkgs.stylua}/bin/stylua";

  #
  # config for coc-git
  #

  git = {
    addedSign.text = "│";
    changedSign.text = "│";
    removedSign.text = "│";
    changeRemovedSign.text = "│";
    topRemovedSign.text = "│";
    addGBlameToVirtualText = false;
    enableGutters = true;
  };

  #
  # config for coc-eslint
  #
  eslint = {
    autoFixOnSave = true;
    format.enable = false;
    validate = [
      "javascript"
      "javascriptreact"
      "typescript"
      "typescriptreact"
      "vue"
      "html"
      "markdown"
      "json"
      "jsonc"
      "yaml"
      "toml"
      "xml"
      "gql"
      "graphql"
      "astro"
      "css"
      "less"
      "scss"
      "pcss"
      "postcss"
    ];
    rules.customizations = [
      {
        rule = "react-hooks/exhaustive-deps";
        severity = "off";
      }
    ];
    experimental.useFlatConfig = true;
  };

  #
  # config for coc-prettier
  #
  prettier = {
    enable = true;
    requireConfig = true;
  };

  #
  # config for coc-pairs
  #
  pairs.enableCharacters = [
    "("
    "["
    "{"
    "'"
    "\""
    "`"
  ];
  "[ocaml]".pairs.enableCharacters = [
    "("
    "["
    "{"
    "\""
    "`"
  ];

  #
  # config for coc-tailwindcss3
  #
  tailwindCSS = {
    colorDecorators = true;
  };

  #
  # config for coc-volar
  #
  volar.tsLocale = "en";

  #
  # config for coc-emmet
  #
  emmet.excludeLanguages = [
    "markdown"
    "typescriptreact"
    "javascriptreact"
    "javascript"
    "typescript"
  ];

  #
  # config for coc-go
  #
  go.checkForUpdates = "disabled";

  #
  # config for coc-biome
  #
  biome.bin = pkgs.biome;
}
