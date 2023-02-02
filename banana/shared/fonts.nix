{
  pkgs,
  lib,
  ...
}:
{
  fonts = {
    fonts = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) ]
    ++  lib.attrValues { };
  fontconfig.enable = true;
  };

}
