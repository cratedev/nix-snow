{
  lib,
  pkgs,
  config,
  osConfig ? {},
  format ? "unknown",
  namespace,
  ...
}:
with lib.${namespace}; {
  crate = {
    cli-apps = {
      #      zsh = enabled;
      nvf = enabled;
      home-manager = enabled;
    };

    tools = {
      #      git = enabled;
    };
  };
}
