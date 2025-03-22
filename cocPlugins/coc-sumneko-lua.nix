{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-sumneko-lua";
  version = "0.0.42";
  src = fetchurl {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-O3rTenTejBkTZQa4iXeCL6v8DrzQcx0Z54jbmKtL4ew=";
  };

  nativeBuildInputs = [ pkgs.jq ];

  prePatch = ''
    jq '.contributes.configuration.properties."sumneko-lua.serverDir".default = "${pkgs.lua-language-server}/share/lua-language-server"' package.json > package.json.tmp && mv package.json.tmp package.json
    jq '.contributes.configuration.properties."Lua.misc.parameters".default = [ "--metapath", "~/.cache/sumneko_lua/meta", "--logpath", "~/.cache/sumneko_lua/log" ]' package.json > package.json.tmp  && mv package.json.tmp package.json
  '';

  meta = with pkgs.lib; {
    description = "Tsserver extension for coc.nvim that provide rich features like VSCode for javascript & typescript ";
    homepage = "https://github.com/neoclide/coc-tsserver";
    license = licenses.mit;
  };
}
