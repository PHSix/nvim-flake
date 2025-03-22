{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-tailwindcss3";
  version = "0.5.26";
  src = fetchurl {
    url = "https://registry.npmjs.org/@yaegassy/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-50He/oQpm2+4HmgJLq64CIzviL5hxaURSAeQ3FqFDO4=";
  };

  nativeBuildInputs = [ pkgs.jq ];

  prePatch = ''
    # Modify the tsdk path in package.json
    jq '.contributes.configuration.properties."tailwindCSS.custom.serverPath".default = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server"' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  meta = with pkgs.lib; {
    description = "Intelligent Tailwind CSS tooling for coc.nvim";
    homepage = "https://github.com/yaegassy/coc-tailwindcss3";
    license = licenses.mit;
  };
}
