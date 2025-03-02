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
  cfg = config.${namespace}.suites.social;
in {
  options.${namespace}.suites.social = with types; {
    enable = mkBoolOpt false "Whether or not to enable social configuration.";
  };

  config = mkIf cfg.enable {
    crate = {
      apps = {
        #        discord = {
        #          enable = false;
        #          chromium = enabled;
        #        };
        #        element = enabled;
      };
    };
  };
}
