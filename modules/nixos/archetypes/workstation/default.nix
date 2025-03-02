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
  cfg = config.${namespace}.archetypes.workstation;
in {
  options.${namespace}.archetypes.workstation = with types; {
    enable = mkBoolOpt false "Whether or not to enable the workstation archetype.";
  };

  config = mkIf cfg.enable {
    crate = {
      suites = {
        common = enabled;
        desktop = enabled;
        development = enabled;
        #        art = disabled;
        video = enabled;
        social = enabled;
        media = enabled;
      };

      cli-apps = {
        nvf = enabled;
      };

      tools = {
        #        appimage-run = enabled;
      };
    };
  };
}
