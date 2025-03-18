{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-nix";
  version = "0.1.0";
  src = fetchurl {
    url = "https://registry.npmjs.org/@ph_chen/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-mkuACvrf7BH0/2mYEdzP5TxZTdO+DQxpZ7necmx1BT4=";
  };

  buildInputs = [ pkgs.nixfmt-classic ];

  nativeBuildInputs = [ pkgs.jq ];

  prePatch = ''
    jq '.contributes.configuration.properties."nix.serverPath".default = "${pkgs.nixd}/bin/nixd"' package.json > package.json.tmp && mv package.json.tmp package.json
  '';

  meta = with pkgs.lib; {
    description = "coc nix language service.";
    homepage = "https://github.com/PHSix/coc-nix";
    license = licenses.mit;
  };
}

