# shared setting between all users

{
  lib,
  pkgs,
  ...
}: {
  imports = [
    # ./network.nix
    #TODO : add more imports for packasd
  ];
  console = {
    keyMap = "fi";
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = ["en_GB.UTF-8/UTF-8"];
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
      _7zz
      unzip
      neofetch
      brave
      nil
    ];

    variables = {
      EDITOR = "hx";
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
  };

}
