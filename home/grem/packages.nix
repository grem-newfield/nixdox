{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    fish
    htop
    killall
    pipewire
    alsa
    fzf
    luaPackages.lua
  ];
}
