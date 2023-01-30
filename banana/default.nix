
{
  inputs,
  outputs,
  ...
}:
let   
  sharedModules = [
    inputs.home-manager.nixosModules.home-manager {
     home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs outputs;};
      users.grem = ../home/grem;
    }; 
    }
  ];
in {
  banana = outputs.lib.nixosSystem {
    modules = [
      ./banana-machine
      {networking.hostName = "banana";}
    ] ++ sharedModules;
    specialArgs = {inherit inputs;};
    system = "x86_64-linux";
  };
}
