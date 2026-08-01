{ config, pkgs, ... }: {

  home.username = "bored";
  home.homeDirectory = "/home/bored";
  home.stateVersion = "26.05";

  home.file.".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-conf/dotfiles/.emacs.d";
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-conf/dotfiles/nvim";

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
    gnomeExtensions.caffeine
    gnome-tweaks
    devenv
  ];

  programs.brave = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "brave";
      paths = [ pkgs.brave ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/brave \
          --add-flags "--disable-features=WebRtcAllowInputVolumeAdjustment"
      '';
    };

    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; }
    ];
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Vaibhav3284";
        email = "boredpenguin05@gmail.com";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
  };

  dconf = {
    enable = true;
    settings = {
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
        text-scaling-factor = 0.75;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    initContent = ''
      # Enable interactive tab completion menu
      zstyle ':completion:*' menu select

      # Keybindings: Use Right Arrow key to accept autosuggestion
      bindkey '^[[C' forward-word
    '';
    syntaxHighlighting.enable = true;

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-conf#nixos";
    };
  };
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "json"; # Replace with your preferred theme name
  };

  programs.home-manager.enable = true;
}
