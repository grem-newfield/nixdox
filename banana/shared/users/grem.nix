# specific user config -> grem

{
  pkgs,
  config,
  lib,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = true;
  users.users.grem = {
    description = "Oh, veru cute! ;3";
    isNormalUser = true;
    shell = pkgs.fish;
    initialPassword = "user";
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "nix"
      "systemd-journal"
    ]
    ++ ifTheyExist [
      "git"
      "docker"
      "libvirtd"
    ];
  };
}