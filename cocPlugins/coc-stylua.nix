{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-stylua";
  version = "0.0.11";
  src = fetchurl {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-Y69InZ96evUoWC09ZltHNwtfiES8UR82gX3CFOYjA8A=";
  };

  nativeBuildInputs = [ pkgs.jq ];

  prePatch = ''
    jq '.contributes.configuration.properties."stylua.styluaPath".default = "${pkgs.stylua}/bin/stylua"' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  meta = with pkgs.lib; {
    description = "StyLua extension for coc.nvim.";
    homepage = "https://github.com/xiyaowong/coc-stylua";
    license = licenses.mit;
  };
}
