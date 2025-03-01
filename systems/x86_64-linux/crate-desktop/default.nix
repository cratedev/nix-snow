{
  pkgs,
  config,
  lib,
  channel,
  namespace,
  inputs,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [
    ./hardware.nix
    #"${inputs.unstable}/nixos/modules/services/misc/ollama.nix"
  ];

  disabledModules = [
    #"${inputs.nixpkgs}/nixos/modules/services/misc/ollama.nix"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "crate-desktop"; # Define your hostname.
  networking.networkmanager.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
