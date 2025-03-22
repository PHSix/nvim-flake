{ vimUtils, fetchFromGitHub, ... }:

vimUtils.buildVimPlugin {
  pname = "oh-lucy-nvim";
  version = "main";
  src = fetchFromGitHub {
    owner = "yazeed1s";
    repo = "oh-lucy.nvim";
    rev = "8f96ec851af11c327ed2449039e09f20292b5c2c";
    hash = "sha256-+kSjqw7J/BNf5qhcwuqFFTLG1jmUtnPI2X4WXzhvysk=";
  };

  meta.homepage = "https://github.com/yazeed1s/oh-lucy.nvim";
}

