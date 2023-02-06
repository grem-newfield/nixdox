# flake
{
  description = "Banana flavoured NixOS";
  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust-overlay = {
    #   url = "github:oxalica/rust-overlay";
    # };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.rust-overlay.follows = "rust-overlay";
    };
  };

  outputs = {
    self,
    nixpkgs,
    # rust-overlay,
    ...
  } @ inputs: let
    inherit (self) outputs;

    system = "x86_64-linux";
    lib = nixpkgs.lib;

    pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        allowBroken = true;
        allowUnfree = true;
        tarball-ttl = 0;
      };
      overlays = with inputs; [];
    };
  in rec {
    inherit lib pkgs;
    #   homeConfigurations = {
    #     home-conf = { system, nixpkgs, home-manager, ... }:
    #     let
    #       username = "grem";
    #       homeDirectory = "/home/${username}";
    #       configHome = "${homeDirectory}/.config";
    #       pkgs = import nixpkgs {
    #         inherit system;
    #         config.allowUnfree = true;
    #         config.xdg.configHome = configHome;
    #         overlays = [];
    #       };
    #     in {
    #       main = home-manager.lib.homeMnagerConfiguration rec {
    #         inherit pkgs system username homeDirectory;
    #         stateVersion = "23.05";
    #         configuration = import ./home.nix {
    #           inherit pkgs;
    #           inherit (pkgs) config lib stdenv;
    #         };
    #       };
    #     };
    #   };
    nixosConfigurations = import ./banana {inherit pkgs inputs outputs;};

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        alejandra
        git
      ];
      name = "dotfiles";
    };

    # formatter
    formatter.${system} = pkgs.${system}.alejandra;
  };
}
