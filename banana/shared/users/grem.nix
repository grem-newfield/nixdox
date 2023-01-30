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
    openssh.authorized.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFwUJa91Ge1Yctw7ayNoKpu6JE3lEzpg74Xylp05z8B1 novoger123@gmail.com"];
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
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFwUJa91Ge1Yctw7ayNoKpu6JE3lEzpg74Xylp05z8B1 novoger123@gmail.com
