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
    alsa-utils
    fzf
    luaPackages.lua
    kitty
    nil
  ];
}
