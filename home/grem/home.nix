{
  home =  {
    username = "grem";
    homeDirectory = "/home/grem";
    stateVersion = "23.05";
    extraOutputsToInstall = [];
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs.home-manager.enable = true;
}
