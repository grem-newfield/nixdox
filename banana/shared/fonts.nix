{
  pkgs,
  lib,
  ...
}:
{
  fonts = {
    fonts = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) ]
    ++  lib.attrValues { inherit (pkgs) ubuntu_font_family; };
  fontconfig.enable = true;
  };

}
