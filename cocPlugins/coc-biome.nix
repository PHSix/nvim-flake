{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-biome";
  version = "1.8.0";
  src = fetchurl {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-434volxcC4tV47ErHyCj9ooUMYajUnDz/B8ARVfV9mk=";
  };

  nativeBuildInputs = [ pkgs.jq ];

  prePatch = ''
    jq '.contributes.configuration.properties."biome.bin".default = "${pkgs.biome}/bin/biome"' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  meta = with pkgs.lib; {
    description = "Biome extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-biome";
    license = licenses.mit;
  };
}

