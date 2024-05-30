# ankarhem/configuration.nix
{ pkgs, lib, ... }:
{
  imports = [
    ./settings.nix
    ./homebrew.nix
    ./nixvim.nix
    ./fish.nix
  ];

  # -- Environment --
  environment = {
    shells = with pkgs; [ bash zsh fish ];
    pathsToLink = [ "/Applications" ];
  };

  users.users.ankarhem = {
    home = "/Users/ankarhem";
  };

  # backwards compat; don't change
  system.stateVersion = 4;
  # nix settings for flake support
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

}
