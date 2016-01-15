{ config, pkgs, ...}:
{
  users.extraUsers.avn = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["audio" "docker" "pulse" "video" "wheel"];
    shell = "/run/current-system/sw/bin/zsh";
  };
  users.extraUsers.olga = {
    isNormalUser = true;
    uid = 1001;
    shell = "/run/current-system/sw/bin/zsh";
  };
}