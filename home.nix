{ config, pkgs, ... }: {

  home.username = "bored";
  home.homeDirectory = "/home/bored";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    git
    htop
    curl
    wget
    gcc
    tree-sitter
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    corefonts
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

  home.file.".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-conf/dotfiles/.emacs.d";

  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-conf/dotfiles/nvim";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Vaibhav3284";
        email = "boredpenguin05@gmail.com";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true; # Automatically push to tracking branch
      pull.rebase = true;          # Prefer rebasing when pulling
    };
  };

  programs.home-manager.enable = true;
}

