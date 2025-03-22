{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-nix";
  version = "0.2.3";
  src = fetchurl {
    url = "https://registry.npmjs.org/@ph_chen/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-rbtigJH1IFkYMDVOs1mDKHc50Fi6ZqbGcteS2K37Jxc=";
  };

  buildInputs = [ pkgs.nixfmt-classic ];

  nativeBuildInputs = [ pkgs.jq ];

  prePatch = ''
    jq '.contributes.configuration.properties."coc-nix.nixdPath".default = "${pkgs.nixd}/bin/nixd"' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  meta = with pkgs.lib; {
    description = "Simply nixd service for coc.nvim.";
    homepage = "https://github.com/PHSix/coc-nix";
    license = licenses.mit;
  };
}
