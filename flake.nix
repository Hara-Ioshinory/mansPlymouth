{
  description = "A simple module for uploading animations to Plymouth";

  outputs = inputs:
  {
    nixosModules.default = ./modules.nix;
  };
}