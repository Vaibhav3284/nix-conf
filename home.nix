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
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
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

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      audio_output {
        type        "pipewire"
        name        "PipeWire Sound Server"
      }

      audio_output {
        type        "fifo"
        name        "my_fifo"
        path        "/tmp/mpd.fifo"
        format      "44100:16:2"
      }
    '';
  };

  programs.ncmpcpp = {
    enable = true;
    bindings = [
      { key = "space"; command = "pause"; }
    ];
    mpdMusicDir = "${config.home.homeDirectory}/Music";
    settings = {
      ncmpcpp_directory = "${config.xdg.configHome}/ncmpcpp";
      lyrics_directory = "${config.xdg.configHome}/ncmpcpp/lyrics";
      progressbar_look = "─> ";
      user_interface = "alternative";
      alternative_header_first_line_format = "$b$1%t$/b";
      alternative_header_second_line_format = "$b$8%a$/b - $5%b$/b $8(%y)$/b";
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "wave";
      visualizer_look = "▮●";
    };
  };

  programs.home-manager.enable = true;
}
