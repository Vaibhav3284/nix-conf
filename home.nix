{ config, pkgs, ... }: {

  home.username = "bored";
  home.homeDirectory = "/home/bored";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    git
    htop
    curl
    wget
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.clipboard-indicator
  ];

  dconf = {
    enable = true;
    settings = {
      # Master switch to ensure extensions are active
      "org/gnome/shell" = {
        disable-user-extensions = false;
        
        enabled-extensions = with pkgs.gnomeExtensions; [
          dash-to-dock.extensionUuid
          appindicator.extensionUuid
	  clipboard-indicator.extensionUuid
        ];
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "BOTTOM";
        dash-max-icon-size = 32;
        extend-height = false;
        autohide = true;
        dock-fixed = false;
	custom-theme-shrink = true;
      };
       
      "org/gnome/shell/extensions/clipboard-indicator" = {
        history-size = 50;           # Keep last 50 items
        preview-size = 30;           # Max characters shown in preview
        clear-history-confirmation = true;
      };
    };
  };

  home.file.".emacs.d" = {
    source = ./dotfiles/.emacs.d; # Points to the folder relative to home.nix
    recursive = true;        # Symlinks every file inside recursively
  };

  programs.git = {
  enable = true;
  userName = "Vaibhav3284";
  userEmail = "boredpenguin05@gmail.com";

  extraConfig = {
    init.defaultBranch = "main";
    push.autoSetupRemote = true; # Automatically push to tracking branch
    pull.rebase = true;          # Prefer rebasing when pulling
  };
};

  programs.home-manager.enable = true;
}

