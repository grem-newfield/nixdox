{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    /hardware-configuration.nix
    # ./nvidia.nix
    # ../shared
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      systemd.enable = true;
      supportedFilesystems = ["ext4"];
    };
    # kernelParams = [];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };
  networking = {
    networkmanager.enable = true;
    # useDHCP = false;
  };

  services = {
    xserver = {
      enable = true;
      windowManager = {
        awesome = {
          enable = true;
          luaModules = lib.attrValues {
            inherit (pkgs.luaPackages) lgi;
          };
        };
      };
      displayManager = {
        defaultSession = "none+awesome";
        lightdm.enable = true;
      };
    };
    # security.doas = {
      # enable = true;
      # extraConfig = ''
        # permit nopass :wheel
      # '';
    # };
  };

  # hardware = {}; TODO: actually wow
  
    

}