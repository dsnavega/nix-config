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

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
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
      llm-agents,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        zenbook = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs self; };
          modules = [
            # host
            ./hosts/zenbook/configuration.nix
            ./hosts/zenbook/hardware-configuration.nix
            # overlays
            { nixpkgs.overlays = import ./modules/overlays inputs; }
            # stylix
            stylix.nixosModules.stylix
            # home-manager
            home-manager.nixosModules.home-manager
            ./home-manager/nixos
            {
              home-manager.users.navega =
                import ./home-manager/users/navega/profiles/desktop;
            }
          ];
        };
        strix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs self; };
          modules = [
            # host
            ./hosts/strix/configuration.nix
            ./hosts/strix/hardware-configuration.nix
            # overlays
            { nixpkgs.overlays = import ./modules/overlays inputs; }
            # stylix
            stylix.nixosModules.stylix
            # home-manager
            home-manager.nixosModules.home-manager
            ./home-manager/nixos
            {
              home-manager.users.navega =
                import ./home-manager/users/navega/profiles/desktop;
            }
          ];
        };
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
        # Placeholder name -- rename this attribute and hosts/darwin/ together.
        darwin = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs self; };
          modules = [
            # host
            ./hosts/darwin/configuration.nix
            # home-manager
            home-manager.darwinModules.home-manager
          ];
        };
      };
    };
}
