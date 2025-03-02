{
  description = "Crates";

  inputs = {
    # NixPkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
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
    flake.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Thaw
    thaw.url = "github:snowfallorg/thaw?ref=v1.0.7";

    # Snowfall Drift
    drift.url = "github:snowfallorg/drift";
    drift.inputs.nixpkgs.follows = "nixpkgs";

    # Comma
    comma.url = "github:nix-community/comma";
    comma.inputs.nixpkgs.follows = "nixpkgs";

    # System Deployment
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    niri.url = "github:sodiboo/niri-flake";
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    ghostty.url = "github:ghostty-org/ghostty";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
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
        stylix.nixosModules.stylix
        niri.nixosModules.niri
      ];

      #      systems.modules.home-manager = with inputs; [
      #        nvf.homeManagerModules.default
      #      ];

      #      home.modules = with inputs; [
      #        nvf.homeManagerModules.default
      #      ];

      systems.hosts.crate-desktop.modules = with inputs; [
        nvf.homeManagerModules.default
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
