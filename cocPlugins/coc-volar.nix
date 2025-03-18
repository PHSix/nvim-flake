{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-volar";
  version = "0.37.4";
  src = fetchurl {
    url = "https://registry.npmjs.org/@yaegassy/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-yz86y6KPOHwHaWpTAFvJkmB4wHXN/iZlaR1ephLn3mI=";
  };

  nativeBuildInputs = [ pkgs.jq ];

  prePatch = ''
    # Modify the tsdk path in package.json
    jq '.contributes.configuration.properties."vue.server.path".default = "${pkgs.vue-language-server}/bin/vue-language-server"' package.json > package.json.tmp
    mv package.json.tmp package.json
  '';

  meta = with pkgs.lib; {
    description = "Volar (Fast Vue Language Support) extension for coc.nvim ";
    homepage = "https://github.com/yaegassy/coc-volar";
    license = licenses.mit;
  };
}

