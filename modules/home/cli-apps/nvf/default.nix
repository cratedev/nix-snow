{
  lib,
  config,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  #  inherit (lib.${namespace}) enabled;
  #  inherit (config.lib.stylix) colors;
  cfg = config.${namespace}.cli-apps.nvf;
in {
  options.${namespace}.cli-apps.nvf = {
    enable = mkEnableOption "nvf";
  };
}
