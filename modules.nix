{ pkgs, lib, config, ... }:
let
  cfg = config;
  mans-plymouth = pkgs.callPackage ./default.nix {
    theme = cfg.mans-plymouth.theme;
  };
in
{
  options.mans-plymouth.enable = lib.mkEnableOption "mans-plymouth";
  
  config.boot.plymouth = lib.mkIf cfg.mans-plymouth.enable {
    enable = true;
    themePackages = [ mans-plymouth ];
    theme = cfg.mans-plymouth.theme;
  };

  options.mans-plymouth.theme = lib.mkOption {
    type = lib.types.enum [ "neko-spin" ];
    default = "neko-spin";
  };
}