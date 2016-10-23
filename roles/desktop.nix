{ config, pkgs, ... }:
{
  nixpkgs.config.firefox = {
    enableAdobeFlash = true;
  };

  hardware = {
      opengl = {
          driSupport32Bit = true;
          s3tcSupport = true;
      };

      pulseaudio = {
          enable = true;
          systemWide = true;
      };
  };

  environment.systemPackages = with pkgs; [
    alock
    chromium
    firefox
    skype
    gimp-with-plugins
    maim
    pavucontrol
    qastools
    aumix
    mpv mplayer mpg123
    zathura
  ];

  systemd.services.pulseaudio.restartIfChanged = false;
}
