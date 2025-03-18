{
  description = "PH's nvim dstro created by nixvim.";

  nixConfig = {
    extra-experimental-features = "pipe-operators";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        cocPluginFiles = builtins.attrNames (builtins.readDir ./cocPlugins);
        cocPluginNames = builtins.filter (name: builtins.match ".*\.nix" name != null) cocPluginFiles;

        cocPluginsOverlay = final: prev: {
          cocPlugins = builtins.listToAttrs (map
            (name:
              {
                name = builtins.replaceStrings [ ".nix" ] [ "" ] name;
                value = prev.callPackage (./. + "/cocPlugins/${name}") { };
              }
            )
            cocPluginNames);
        };
        nvimPluginsOverlay = import ./plugins;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.neovim-nightly-overlay.overlays.default
            cocPluginsOverlay
            nvimPluginsOverlay
          ];
        };
        nvimProfile = import ./nvim.nix;
        nixvim' = inputs.nixvim.legacyPackages.${system};
        nvim = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = nvimProfile;
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      in
      {
        packages = {
          default = nvim;
          nvim = nvim;
        };
      }
    );
}
