{ config, pkgs, lib,  ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.enable = true;

  networking.hostName = "nixos"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "euro";
  };

  services.printing.enable = true;

services.pulseaudio.enable = false;
security.rtkit.enable = true;

# 2. PipeWire Configuration
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;

  # CRITICAL: WirePlumber manages PipeWire camera & audio streams
  wireplumber.enable = true;
};


  users.users."bored" = {
    isNormalUser = true;
    description = "bored";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "camera" ];
    packages = with pkgs; [
    ];
  };

  programs.steam = {
    enable = true;
  };
  programs.zsh.enable = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    faugus-launcher
    zed-editor
    emacs
    transmission_4-gtk
    openjdk21
    obsidian
    heroic
    adwaita-icon-theme
    stremio-linux-shell
    discord
    anki-bin
    mpv
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 4d";
  };

  # Automatically hard-link duplicate store files to save space
  nix.settings.auto-optimise-store = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour      # GNOME Tour introduction app
    gnome-connections # Remote desktop client
    geary           # Email client
    epiphany        # GNOME Web browser
    evince          # Document viewer (PDFs)
    totem           # GNOME Videos
    seahorse        # Passwords and keys
    yelp
    gnome-maps
    gnome-contacts
    gnome-music
  ];

  # Disable power-profiles-daemon
  services.power-profiles-daemon.enable = false;

  # Enable auto-cpufreq
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "always";
    };
  };

  system.stateVersion = "26.05"; # Did you read the comment?

}
