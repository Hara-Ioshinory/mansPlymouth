{ pkgs, lib, config, ... }:
let
  cfg = config;
  mans-plymouth = pkgs.callPackage ./default.nix {
    # theme = cfg.mans-plymouth.theme;
  };
in
{
  options.mans-plymouth.enable = lib.mkEnableOption "mans-plymouth";
  
  config.boot.plymouth = lib.mkIf cfg.mans-plymouth.enable {
    enable = true;
    themePackages = [ mans-plymouth ];
    # theme = cfg.mans-plymouth.theme;
  };

  options.mans-plymouth.duration = lib.mkOption {
    type = lib.types.float;
    default = 0.0;
  };
  config.systemd.services.plymouth-quit = lib.mkIf (cfg.mans-plymouth.enable && cfg.mans-plymouth.duration > 0.0) {
    preStart = "${pkgs.coreutils}/bin/sleep ${toString config.mans-plymouth.duration}";
  };
}