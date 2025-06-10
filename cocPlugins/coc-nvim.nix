{ pkgs, fetchFromGitHub, ... }:
pkgs.vimUtils.buildVimPlugin {
  pname = "coc.nvim";
  version = "2025-06-10";
  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc.nvim";
    rev = "aa96f1ddd567ac117fcc5cb24559f2d7a659ec85";
    hash = "sha256-93xO8NXV1UHhznlVsnm53HeHsmAknSqLaUSkoCb3IwE=";
  };

  nativeBuildInputs = with pkgs; [
    nodejs
  ];

  meta.homepage = "https://github.com/neoclide/coc.nvim";
}
