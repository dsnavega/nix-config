{
  description = "NixOS Flake Configuration (Unstable Branch)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin (macOS)
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      nix-darwin,
      nix-homebrew,
      llm-agents,
      ...
    }@inputs:
    {
      nixosConfigurations = {

        cogitator = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs self; };
          modules = [
            # host
            ./hosts/cogitator/configuration.nix
            ./hosts/cogitator/hardware-configuration.nix
            # home-manager
            home-manager.nixosModules.home-manager
            # stylix
            stylix.nixosModules.stylix
            # overlays
            { nixpkgs.overlays = import ./modules/overlays inputs; }
          ];
        };
      };

      darwinConfigurations = {
        macos = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs self; };
          modules = [
            # host
            ./hosts/configuration.nix
            # home-manager
            home-manager.darwinModules.home-manager
            # nix-homebrew
            nix-homebrew.darwinModules.nix-homebrew
          ];
        };
      };
    };
}
