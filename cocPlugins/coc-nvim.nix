{ pkgs, fetchFromGitHub, ... }:
pkgs.vimUtils.buildVimPlugin {
  pname = "coc.nvim";
  version = "2025-06-02";
  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc.nvim";
    rev = "9f7f280194f70229ec667721373a74d238618220";
    hash = "sha256-w56LuUr30ubqvby6FppMlyhBZQwxvUhebSadpltgty4=";
  };
  meta.homepage = "https://github.com/neoclide/coc.nvim";
}
