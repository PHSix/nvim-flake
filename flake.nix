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

  outputs =
    inputs@{ nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        cocPluginsOverlay = import ./cocPlugins;
        nvimPluginsOverlay = import ./nvimPlugins;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.neovim-nightly-overlay.overlays.default
            cocPluginsOverlay
            nvimPluginsOverlay
          ];
        };
        nvimProfile = import ./nvim.nix;
        minimalProfile = import ./minimal.nix;
        nixvim' = inputs.nixvim.legacyPackages.${system};
        minimal = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = minimalProfile;
          extraSpecialArgs = {
            inherit inputs;
          };
        };
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
          neovim = nvim;
          cocPlugins = pkgs.cocPlugins;
          nvimPlugins = pkgs.nvimPlugins;
          minimal = minimal;
        };
      }
    );
}
