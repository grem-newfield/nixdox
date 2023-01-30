{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./network.nix
    #TODO : add more imports for packasd
  ];
  console = {
    keyMap = "fi";
  };

  i18n = {
    defaultLocale = "en_UK.UTF-8";
    supportedLocales = ["en_UK.UTF-8/UTF-8"];
  };

  environment = {
    binsh = "${pkgs.bash}/bin/bash";
    shells = [pkgs.fish];

    systemPackages = with pkgs; [
      fd
      ripgrep
      helix
      git
      curl
      zip
      wget
      unrar
      7z
      unzip
      neofetch
      brave
    ];

    variables = {
      EDITOR = "helix";
      BROWSER = "brave";
      
    };
  };

  # programs = [];

  services = {

    dbus.enable = true;
  
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
      # jack.enable = true;
    };
  };

  systemd.user.services = {
    pipewire.wantedBy = ["default.target"];
    pipewire-pulse.wantedBy = ["default.target"];
  };

  security = {
    polkit.enable = true;
  }

}
