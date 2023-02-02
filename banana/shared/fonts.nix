{
  pkgs,
  lib,
  ...
}:
{
  fonts = {
    fonts = [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; }) ]
    ++  lib.attrValues { inherit (pkgs) sarasa-gothic ipaexfont; };
  fontconfig.enable = true;
  };

}
