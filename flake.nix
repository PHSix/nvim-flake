{
  description = "PH's nvim dstro created by nixvim.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    coc-nvim-overlay.url = "github:PHSix/coc-nvim-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        nvimPluginsOverlay = import ./plugins;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.coc-nvim-overlay.overlays."${system}".default
            inputs.neovim-nightly-overlay.overlays.default
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
