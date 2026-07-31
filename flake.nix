{
  description = "NixOS configuration with Flakes and Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fjordlauncher = {
      url = "github:hero-persson/FjordLauncherUnlocked";

      # Optional: Override the nixpkgs input of fjordlauncher to use the same revision as the rest of your flake
      # Note that this may break the reproducibility mentioned above, and you might not be able to access the binary cache
      #
      # inputs.nixpkgs.follows = "nixpkgs";
    };


    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, fjordlauncher, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/hardware-configuration.nix
          ./nixos/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bored = import ./home.nix;
          }
          (
            { pkgs, ... }:
            {
              environment.systemPackages = [ fjordlauncher.packages.${pkgs.stdenv.hostPlatform.system}.fjordlauncher ];
            }
          )
        ];
      };
    };
  };
}

