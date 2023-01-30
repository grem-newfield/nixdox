{
  pkgs,
  config,
  lib,
  ...
}:
let
  ifTheyExist = groups: buildins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = true;
  users.users.grem = {
    description = "Oh, veru cute! ;3";
    isNormalUser = true;
    shell = pkgs.fish;
    initialPassword = "user";
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