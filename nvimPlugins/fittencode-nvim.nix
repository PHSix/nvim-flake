{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "fittencode-nvim";
  version = "master";
  src = fetchFromGitHub {
    owner = "luozhiya";
    repo = "fittencode.nvim";
    rev = "be2e6e8345bb76922fae37012af10c3cc51585b5";
    hash = "sha256-5uwphoIaDyf4R4ZjZz4IWnaG7E3iPHyztYDbD3twbFA=";
  };
  meta.homepage = "https://github.com/luozhiya/fittencode.nvim";
}
