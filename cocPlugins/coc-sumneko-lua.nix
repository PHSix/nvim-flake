{ pkgs, fetchurl, ... }:
pkgs.vimUtils.buildVimPlugin rec {
  pname = "coc-sumneko-lua";
  version = "0.0.42";
  src = fetchurl {
    url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
    sha256 = "sha256-O3rTenTejBkTZQa4iXeCL6v8DrzQcx0Z54jbmKtL4ew=";
  };

  meta = with pkgs.lib; {
    description = "Tsserver extension for coc.nvim that provide rich features like VSCode for javascript & typescript ";
    homepage = "https://github.com/neoclide/coc-tsserver";
    license = licenses.mit;
  };
}
