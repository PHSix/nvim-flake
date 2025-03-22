{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-ocaml";
  version = "0.1.1";
  src = fetchurl {
    url = "https://registry.npmjs.org/@ph_chen/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-fcKB0QKtuUHowJvOV3BLNzEaeTt6emXSOp3OeIX7FnE=";
  };

  nativeBuildInputs = [ pkgs.jq ];

  prePatch = ''
    jq '.contributes.configuration.properties."lspStartCommand".default = "${pkgs.opam}/bin/opam"' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  meta = with pkgs.lib; {
    description = "Simple ocaml language service for coc.nvim";
    homepage = "https://github.com/PHSix/coc-ocaml";
    license = licenses.mit;
  };
}
