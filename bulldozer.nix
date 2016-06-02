# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./common/common.nix
      ./roles/emacs.nix
      ./roles/X11.nix
      ./roles/desktop.nix
      ./roles/console.nix
      ./roles/gaming.nix
      ./users.nix
      ./envs/golang.nix
    ];

  nixpkgs.config = {
     allowBroken = true;  # Until ansible will be fixed
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.grub.device = "nodev";
  boot.loader.grub.version = 2;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.kernelParams = ["reboot=w,a" "radeon.dpm=1" "radeon.audio=1"  "cgroup_enable=memory" "swapaccount=1"];
  #boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelPackages = pkgs.linuxPackages_4_5;
  boot.kernelModules = [ "r8169" ];
  boot.initrd.availableKernelModules = ["btrfs"];

  powerManagement.cpuFreqGovernor = "ondemand";
  time.timeZone = "Europe/Vilnius";

  networking.hostName = "bulldozer"; # Define your hostname.
  networking.domain = "home";
  networking.search = ["home"];
  networking.hostId = "2f78bb0d";
  networking.interfaces.enp9s0.ip4 = [ { address = "172.16.228.3"; prefixLength = 24;} ];
  networking.defaultGateway = "172.16.228.1";
  networking.nameservers  = [ "172.16.228.1" ];
  networking.firewall.enable = false;

  hardware = {
      opengl = {
          driSupport32Bit = true;
          s3tcSupport = true;
      };
      enableKSM = true;
      pulseaudio = {
          enable = true;
          systemWide = true;
      };
  };

  hardware.cpu.amd.updateMicrocode = true;
 
  # networking.wireless.enable = true;  # Enables wireless.

  fileSystems = {
    "/efi"={
       device="/dev/sda1";
       fsType="vfat";
    };
    "/home"={
        device="/dev/vg0/home";
        fsType="ext4";
    };
    "/mnt/data"={
        device="/dev/vg0/data";
        fsType="btrfs";
    };
    "/mnt/raid"={
        device="/dev/vg0/raid";
        fsType="xfs";
    };
    "/mnt/games"={
        device="/dev/vg0/games";
        fsType="xfs";
    };
    "/mnt/systems"={
        device="/dev/vg0/systems";
        fsType="btrfs";
    };
    "/mnt/fast"={
        device="/dev/vg0/video";
        fsType="xfs";
    };
    "/mnt/video"={
    	device="/mnt/fast/video";
	    fsType="none";
    	options=["bind"];
    };
    "/mnt/debian"={
        device="/dev/vg0/root";
	    fsType="ext4";
    };
    "/etc/nixos/nixpkgs"={
    	device="/home/avn/nixos/nixpkgs";
	    fsType="none";
    	options=["bind"];
    };
    "/var/lib/rkt"={
        device="/dev/vg0/rkt";
        fsType="xfs";
    };
  };

  # List services that you want to enable:
virtualisation = {
    virtualbox.host.enable = true;
    docker = {
        enable = true;
        storageDriver = "btrfs";
    };
#    rkt.enable = true;
};

services = {
  postfix = {
      enable = true;
      hostname = "bulldozer";
      domain = "avnik.info";
      destination = [ "bulldozer.avnik.info" "bulldozer.home" "daemon.hole.ru"  "avnik.info"  "mareicheva.info" "master"];
      rootAlias = "avn";
      postmasterAlias = "avn";
      origin = "bulldozer.avnik.info";
      relayHost = "frog.home";
  };

  rspamd.enable = true;
  rmilter.postfix.enable = true;

  syslog-ng.enable = true;
  klogd.enable = false;

  nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nixos/secrets/nix-bulldozer.key";
  };

  nfs.server = {
     enable = true;
     exports = ''
/mnt/raid   boomer(rw,no_subtree_check)
/mnt/video   boomer(rw,no_subtree_check)
'';
  };
};

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  environment = {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
    systemPackages = with pkgs; [
      pandoc gnumake
      neovim
      svtplay-dl
      rtorrent
      irssi
      mercurial nix-prefetch-scripts
      gitAndTools.git-imerge gitAndTools.gitflow gitAndTools.git-remote-hg
      gitAndTools.gitRemoteGcrypt gitAndTools.hub gist
      nox
      vagrant ansible
      lm_sensors
      imagemagick
      vcsh mr fasd rcm renameutils
      manpages posix_man_pages iana_etc
      perl pythonFull ruby bundix
      mumble_git teamspeak_client pidgin-with-plugins
      mutt-kz procmail notmuch maildrop
      pass
      texlive.combined.scheme-full
#      rethinkdb
      go_1_6 go16Packages.glide.bin
      ghc cabal-install stack cabal2nix
#      calibre
      npm2nix nix-repl
#      rkt acbuild
  ];

#      haskellngPackages.xmonad haskellngPackages.xmonad-contrib haskellngPackages.xmonad-extras
#
#      haskellPackages.cabal-install haskellPackages.cabal-meta
#      (haskellPackages.ghcWithPackages (self: with self; [
#        lens
#      ]))
  sessionVariables =
      { 
      };


    etc = {
	  "hosts".source = ./verbatim/hosts;
    };
  };
}
