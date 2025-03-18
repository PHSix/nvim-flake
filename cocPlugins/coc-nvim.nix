{pkgs, fetchFromGitHub, ...}: 
pkgs.vimUtils.buildVimPlugin {
  pname = "coc.nvim";
  version = "2025-03-07";
  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc.nvim";
    rev = "373623b1fe26f9f1955d7b307f635b13ec1d7093";
    hash = "sha256-eNSPXwlBVAyCxSWaUjfVHo6naZjHTDbOfr3hcsfSu8Q=";
  };
  meta.homepage = "https://github.com/neoclide/coc.nvim/";
}

