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
    pistol

    #nixy
    any-nix-shell
    nil
    alejandra
    #rusty
    cargo
    rustfmt
    rust-analyzer

    shellcheck
    stylua
    luaPackages.lua
    sumneko-lua-language-server
    selene
  ];
}
