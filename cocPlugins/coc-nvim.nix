{ pkgs, fetchFromGitHub, ... }:
pkgs.vimUtils.buildVimPlugin {
  pname = "coc.nvim";
  version = "2025-03-28";
  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc.nvim";
    rev = "4f1199b195b4baabc1cede645c138c14336be604";
    hash = "sha256-jpBk1M7cvwfhRChsBtB66AToTXvQ2kpLdhSBWkOm3zs=";
  };
  meta.homepage = "https://github.com/neoclide/coc.nvim/";
}
