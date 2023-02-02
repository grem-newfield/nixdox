{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    killall
    fzf
    luaPackages.lua
    kitty

    #nixy
    any-nix-shell
    nil
  ];
}
