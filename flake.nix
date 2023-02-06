# flake
{
  description = "Banana flavoured NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
    };

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-f2k,
    rust-overlay,
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
      #   overlays = with inputs; [

      #  (builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").overlays.default
      #   ];
    };
  in rec {
    inherit lib pkgs;
    nixosConfigurations = import ./banana {inherit pkgs inputs outputs nixpkgs-f2k;};

    # devShells.${system}.default = pkgs.mkShell {
    #   packages = with pkgs; [
    #     alejandra
    #     git
    #   ];
    #   name = "dotfiles";
    # };

    # formatter
    # formatter.${system} = pkgs.${system}.alejandra;
  };
}
