{
  description = "Crates";

  inputs = {
    # NixPkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # NixPkgs Unstable
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware Configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Generate System Images
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib?ref=v3.0.3";
    # snowfall-lib.url = "path:/home/short/work/@snowfallorg/lib";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Flake
    flake.url = "github:snowfallorg/flake?ref=v1.4.1";
    flake.inputs.nixpkgs.follows = "unstable";

    # Snowfall Thaw
    thaw.url = "github:snowfallorg/thaw?ref=v1.0.7";

    # Snowfall Drift
    drift.url = "github:snowfallorg/drift";
    drift.inputs.nixpkgs.follows = "nixpkgs";

    # Comma
    comma.url = "github:nix-community/comma";
    comma.inputs.nixpkgs.follows = "unstable";
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "crate";
          title = "Crates";
        };

        namespace = "crate";
      };
    };
  in
    lib.mkFlake
    {
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
        ];
      };

      overlays = with inputs; [
        flake.overlays.default
        thaw.overlays.default
        drift.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
      ];

      #####   systems.hosts.laptop.modules = with inputs; [
      #			#TODO: laptop specific config ## nixos-hardware.nixosModules.framework-11th-gen-intel
      #       ];

      deploy = lib.mkDeploy {inherit (inputs) self;};

      checks =
        builtins.mapAttrs
        (
          system: deploy-lib: deploy-lib.deployChecks inputs.self.deploy
        )
        inputs.deploy-rs.lib;

      outputs-builder = channels: {formatter = channels.nixpkgs.nixfmt-rfc-style;};
    }
    // {
      self = inputs.self;
    };
}
