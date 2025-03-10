{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.suites.common;
in {
  options.${namespace}.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.crate.list-iommu];

    crate = {
      nix = enabled;

      # TODO: Enable this once Attic is configured again.
      # cache.public = enabled;

      #      cli-apps = {
      #        flake = enabled;
      #        thaw = enabled;
      #      };

      tools = {
        git = enabled;
        #        misc = enabled;
        comma = enabled;
        #        bottom = enabled;
      };

      hardware = {
        audio = enabled;
        storage = enabled;
        networking = enabled;
      };

      services = {
        #        printing = enabled;
        openssh = enabled;
        tailscale = enabled;
      };

      security = {
        gpg = enabled;
        doas = enabled;
        keyring = enabled;
      };

      system = {
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
  };
}
