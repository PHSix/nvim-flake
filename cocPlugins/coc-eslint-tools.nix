{ vimUtils, fetchFromGitHub, ... }:

vimUtils.buildVimPlugin {
  pname = "coc-eslint-tools";
  version = "main";
  src = fetchFromGitHub {
    owner = "PHSix";
    repo = "coc-eslint-tools";
    rev = "65160ea6b4fd42f2adbf55ea517543c23166e036";
    hash = "sha256-qHewoKNwRGjiLWfq2fOjLXhElcAN+ljEdcKWRod311g=";
  };
  meta.homepage = "https://github.com/PHSix/coc-eslint-tools";
}
