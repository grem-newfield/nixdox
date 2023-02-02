# config for specific machine
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # ./nvidia.nix
    ../shared
    ../shared/users/grem.nix
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd = {
      systemd = {
        enable = true;
        services.NetworkManager-wait-online.enable = false;
      };
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
    openssh = {
      enable = true;
      # passwordAuthentication = true;
    };
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
        lightdm = {
          enable = true;
        };
        autoLogin = {
          enable = true;
          user = "grem";
        };
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
