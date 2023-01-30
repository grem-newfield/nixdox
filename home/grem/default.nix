{
  config,
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./home.nix
    ./packages.nix
  ];
  # home.homeDirectory = pkgs.lib.mkForce "/home/grem";
}