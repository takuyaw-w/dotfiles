{
  description = "takuyaw-w dotfiles";

  inputs = {
    hunk.url = "github:modem-dev/hunk";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hunk, nixGL, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      envUsername = builtins.getEnv "NIX_USERNAME";
      envHomeDirectory = builtins.getEnv "NIX_HOME_DIRECTORY";
      runtimeUsername = if envUsername != "" then envUsername else "dotfiles";
      runtimeHomeDirectory =
        if envHomeDirectory != "" then
          envHomeDirectory
        else if runtimeUsername == "root" then
          "/root"
        else
          "/home/${runtimeUsername}";
      profiles = {
        desktop-x86_64-linux = {
          system = "x86_64-linux";
          username = runtimeUsername;
          homeDirectory = runtimeHomeDirectory;
          enableGui = true;
        };
        desktop-aarch64-linux = {
          system = "aarch64-linux";
          username = runtimeUsername;
          homeDirectory = runtimeHomeDirectory;
          enableGui = true;
        };
        test = {
          system = "x86_64-linux";
          username = "test";
          homeDirectory = "/home/test";
          enableGui = false;
        };
      };
      mkHome = profile:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit (profile) system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit hunk nixGL;
            inherit (profile) username homeDirectory enableGui;
          };
          modules = [ ./home-manager/home.nix ];
        };
    in
    {
      homeConfigurations = nixpkgs.lib.mapAttrs (_: mkHome) profiles;

      formatter = forAllSystems (system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );

      checks = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          profileNames = builtins.filter
            (name: profiles.${name}.system == system)
            (builtins.attrNames profiles);
        in
        {
          home-activation = pkgs.linkFarm "home-activation-checks"
            (map
              (name: {
                inherit name;
                path = self.homeConfigurations.${name}.activationPackage;
              })
              profileNames);

          shell-tests = pkgs.runCommand "dotfiles-shell-tests"
            {
              nativeBuildInputs = with pkgs; [
                bash
                coreutils
                findutils
                gawk
                gnugrep
                gnused
              ];
            } ''
            cd ${self}
            bash tests/install-ci-control.sh
            bash tests/docker-runner-test.sh
            bash tests/dotfiles-cli-test.sh
            touch $out
          '';
        }
      );
    };
}
