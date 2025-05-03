{ helpers, ... }:
rec {
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
      ];
    }
  ];

  autoGroups = {
    patch_augroup.clear = true;
  };

  globals = {
    mapleader = " ";
  };

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
