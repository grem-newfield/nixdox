# set OS to linux, add HM and User modules
{
  inputs,
  outputs,
  pkgs,
  nixpkgs-f2k,
  ...
}: let
  sharedModules = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit inputs outputs;};
        users.grem = ../home/grem;
      };
    }
  ];
in {
  banana-machine = outputs.lib.nixosSystem {
    modules =
      [
        ./banana-machine
        {networking.hostName = "banana-machine";}

        ({pkgs, ...}: {
          nixpkgs.overlays = [
            inputs.rust-overlay.overlays.default
            nixpkgs-f2k.overlays.compositors
            nixpkgs-f2k.overlays.window-managers
            nixpkgs-f2k.overlays.stdenvs
          ];
          environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
        })
      ]
      ++ sharedModules;
    specialArgs = {inherit inputs;};
    system = "x86_64-linux";
  };
}
