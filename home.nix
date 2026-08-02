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
