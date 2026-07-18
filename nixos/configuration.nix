{ config, pkgs, ... }:

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

  services.xserver.xkb = {
    layout = "us";
    variant = "euro";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  users.users."bored" = {
    isNormalUser = true;
    description = "bored";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs.firefox.enable = true;
  programs.steam = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    faugus-launcher
    zed-editor
    jetbrains.pycharm
    kew
    emacs
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
  # gnome-weather
  # gnome-music
  gnome-contacts
  # gnome-clocks
  # gnome-calculator
  # gnome-font-viewer
  # gnome-logs
  # gnome-system-monitor
];

  system.stateVersion = "26.05"; # Did you read the comment?

}
