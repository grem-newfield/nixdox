{
  pkgs,
  lib,
  ...
}: {
  fonts = {
    fonts =
      [
        (pkgs.nerdfonts.override {
          fonts = [
            "FiraCode"
            "Monoid"
            "VictorMono"
          ];
        })
        (pkgs.iosevka-comfy.comfy)
      ]
      ++ lib.attrValues {inherit (pkgs) ubuntu_font_family;};
    fontconfig.enable = true;
  };
}
