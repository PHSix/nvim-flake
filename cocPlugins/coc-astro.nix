{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-astro";
  version = "0.9.2";
  src = fetchurl {
    url = "https://registry.npmjs.org/@yaegassy/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-nN/wj7fBMTkglafsEkCWrwBkVvsmHB5BgcSIvsS3irY=";
  };

  prePatch = ''
    jq '.contributes.configuration.properties."astro.language-server.ls-path".default = "${pkgs.astro-language-server}/bin/astro-ls"' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  meta = with pkgs.lib; {
    description = "Astro extension for coc.nvim";
    homepage = "https://github.com/yaegassy/coc-astro";
    license = licenses.mit;
  };
}
