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
    gnomeExtensions.caffeine
    gnome-tweaks
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

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      # Audio output for modern Linux systems running PipeWire
      audio_output {
        type        "pipewire"
        name        "PipeWire Sound Server"
      }

      # Visualizer pipeline output (Required for ncmpcpp visualizer)
      audio_output {
        type        "fifo"
        name        "my_fifo"
        path        "/tmp/mpd.fifo"
        format      "44100:16:2"
      }
    '';
  };

  # 2. Configure ncmpcpp (The terminal user interface)
  programs.ncmpcpp = {
    enable = true;
    bindings = [
      { key = "space"; command = "pause"; }
    ];
    settings = {
      ncmpcpp_directory = "${config.xdg.configHome}/ncmpcpp";
      lyrics_directory = "${config.xdg.configHome}/ncmpcpp/lyrics";
      mpd_music_dir = "${config.home.homeDirectory}/Music";
      progressbar_look = "─> ";
      user_interface = "alternative";
      alternative_header_first_line_format = "$b$1%t$/b";
      alternative_header_second_line_format = "$b$8%a$/b - $5%b$/b $8(%y)$/b";
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "wave"; # Can be spectrum, wave, or wave_filled
      visualizer_look = "▮●";
    };
  };
  programs.home-manager.enable = true;
}

