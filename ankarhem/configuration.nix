# ankarhem/configuration.nix
{ pkgs, lib, ... }:
{
  imports = [
    ./settings.nix
    ./homebrew.nix
    ./nixvim.nix
  ];

  # -- Environment --
  environment = {
    shells = with pkgs; [ bash zsh fish ];
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
    shellAliases = {
      vim = "nvim";
    };
  };

  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
  };

  users.users.ankarhem = {
    home = "/Users/ankarhem";
    shell = pkgs.fish;
    # need to run manually for now: chsh -s /run/current-system/sw/bin/fish
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
