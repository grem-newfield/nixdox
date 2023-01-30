# set OS to linux, add HM and User modules
{
  inputs,
  outputs,
  pkgs,
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
        ./banana-machine # {inherit pkgs;}
        {networking.hostName = "banana-machine";}
        
      ]
      ++ sharedModules;
    specialArgs = {inherit inputs;};
    system = "x86_64-linux";
  };
}
