{
  pkgs,
  lib,
  ...
}:
{
  fonts = {
    fonts = [ 
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) 
      (pkgs.iosevka.override { set = "comfy"; }) 
    ] ++ lib.attrValues { inherit (pkgs) ubuntu_font_family; };
  fontconfig.enable = true;
  };

}
