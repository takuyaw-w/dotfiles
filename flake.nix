{
  description = "takuyaw-w dotfiles";

  inputs = {
    hunk.url = "github:modem-dev/hunk/9ef9b2e7cad455056cfe1c10757815cb80c7d716";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, hunk, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      mkHome = system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit hunk; };
          modules = [ ./home-manager/home.nix ];
        };
    in
    {
      homeConfigurations = {
        takuya-x86_64-linux = mkHome "x86_64-linux";
        takuya-aarch64-linux = mkHome "aarch64-linux";
      };

      formatter = forAllSystems (system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );
    };
}
