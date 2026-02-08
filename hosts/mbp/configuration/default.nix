{
  self,
  inputs,
  config,
  pkgs,
  pkgs-darwin,
  ...
}:
{
  _module.args.pkgs-darwin = import inputs.nixpkgs-darwin {
    inherit (pkgs) system;
    inherit (config.nixpkgs) config;
  };
  imports = [
    ./environment.nix
    ./fonts.nix
    ./homebrew.nix
    ./settings.nix
  ];

  programs = {
    zsh.enable = true;
  };
}
