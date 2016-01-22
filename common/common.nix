{ config, pkgs, ... }:
{
  imports = [
     ./nix.nix
     ./nixpkgs.nix
  ];
  boot.blacklistedKernelModules = [ "snd_pcsp" ];

  hardware.enableKSM = true;

  # Select internationalisation properties.
  i18n = {
     consoleFont = "lat9w-16";
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
     supportedLocales = ["en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" "ru_RU.KOI8-R/KOI8-R"];
  };

  services.ntp = {
    enable = true;
    servers = [ "server.local" "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
  };

  services.journald = {
    extraConfig = ''
      MaxRetentionSec=1month
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  security = {
    sudo = {
      extraConfig = ''
Defaults:root,%wheel env_keep+=NIX_PATH
      '';
    };
  };
}
