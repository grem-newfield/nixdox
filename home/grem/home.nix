{
  config,
  outputs,
  pkgs,
  lib,
  ...
}: {
  home =  {
    username = "grem";
    # homeDirectory = pkgs.lib.mkForce "/home/grem";
    homeDirectory = "/home/grem";
    stateVersion = "23.05";
    extraOutputsToInstall = [];
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      userName = "grem-newfield";
      userEmail = "novoger123@gmail.com";
    };

fish = {
    enable = true;
    interactiveShellInit = ''
      any-nix-shell fish --info-right | source
    '';
    shellInit = ''
      # Disable fish greeting
      set -g fish_greeting
    '';
    shellAliases = {
      commit = "git add . && git commit -m";
  };
  };
  


};
}