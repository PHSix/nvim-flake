{ pkgs, fetchFromGitHub, ... }:
pkgs.vimUtils.buildVimPlugin {
  pname = "coc.nvim";
  version = "2025-03-21";
  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc.nvim";
    rev = "da20bea23b6226e5859a06137b841c6853599f22";
    hash = "sha256-O7tmZgSQeYao5T0FZ+Zeu6bCLgXEdA2M77JjfR812T4=";
  };
  meta.homepage = "https://github.com/neoclide/coc.nvim/";
}
