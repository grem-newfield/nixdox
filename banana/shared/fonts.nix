{
  pkgs,
  lib,
  ...
}:
{
  fonts = {
    fonts = [ 
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) 
      (pkgs.iosevka-comfy.comfy) 
    ] ++ lib.attrValues { inherit (pkgs) ubuntu_font_family; };
  fontconfig.enable = true;
  };

}
