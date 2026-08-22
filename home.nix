{ config, pkgs, ... }: {

  home.username = "bored";
  home.homeDirectory = "/home/bored";
  home.stateVersion = "26.05";

  # CRITICAL: Allows Home Manager to discover user-installed fonts (like Nerd Fonts)
  fonts.fontconfig.enable = true;
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.adwaita-icon-theme; # Provides default GNOME cursors
    name = "Adwaita";
    size = 24;
  };

  home.file.".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-conf/dotfiles/.emacs.d";
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-conf/dotfiles/nvim";


  home.packages = with pkgs; [
    git
    htop
    curl
    wget
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
    gnomeExtensions.caffeine
    gnome-tweaks
    devenv
  ];

  # ... [your programs.brave, git, zsh, oh-my-posh config stays here] ...

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        cursor-theme = "Adwaita";
        cursor-size = 24;
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          dash-to-dock.extensionUuid
          appindicator.extensionUuid
          clipboard-indicator.extensionUuid
          "caffeine@patapon.info"
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
        history-size = 50;
        preview-size = 30;
        clear-history-confirmation = true;
      };

      "org/gnome/shell/extensions/caffeine" = {
        show-notifications = false;
      };

      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
      };

      "org/gnome/desktop/interface" = {
        # SET MONOSPACE FONT FOR GTK / GNOME APPLICATIONS
        monospace-font-name = "JetBrainsMono Nerd Font 10";
        text-scaling-factor = 0.75;
      };

      # FOR PTYXIS (Default Terminal in GNOME 46+)
      "org/gnome/Ptyxis" = {
        font-name = "JetBrainsMono Nerd Font 10";
        use-system-font = false;
      };

      # FOR CLASSIC GNOME TERMINAL
      "org/gnome/terminal/legacy/profiles:/::\${profile-id}" = {
        font = "JetBrainsMono Nerd Font 10";
        use-system-font = false;
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Vaibhav3284";
        email = "boredpenguin05@gmail.com";
      };
    };
  };
  programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
      # NixOS shortcuts
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-conf#nixos";
      nob = "sudo nixos-rebuild build";
      nclean = "sudo nix-collect-garbage -d";
      nconf = "sudo nvim ~/nix-conf/nixos/configuration.nix";

      # Navigation & Core utility replacements
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";

      # Additional Git shortcuts in Zsh (optional short-form wrappers)
      g = "git";
      gst = "git status";
      glg = "git log --graph --oneline --decorate --all";
      gdiff = "git diff";
    };

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
    };
  };

  programs.starship = {
  enable = true;
  enableZshIntegration = true;
  settings = pkgs.lib.importTOML ./dotfiles/starship.toml;
};

  programs.brave = {
      enable = true;
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; }
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
      ];
    };
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      useTheme = "agnoster"; # Oh My Posh automatically renders active Git branches & dirty status!
    };

  programs.home-manager.enable = true;
}
