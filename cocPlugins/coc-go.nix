{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-go";
  version = "1.3.35";
  src = fetchurl {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-hld6Iwx6PzEwLZycApahMXACvrOwfuIwCurrVbkenBg=";
  };

  nativeBuildInputs = [ pkgs.jq ];

  prePatch = ''
    jq '.contributes.configuration.properties."go.goplsPath".default = "${pkgs.gopls}/bin/gopls"' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  meta = with pkgs.lib; {
    description = "Go language server extension using gopls for coc.nvim.";
    homepage = "https://github.com/josa42/coc-go";
    license = licenses.mit;
  };
}
