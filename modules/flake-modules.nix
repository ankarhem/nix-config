# Flakes modules - merged definition of all dendritic aspects
{ inputs, lib, ... }:
{
  config.flake.modules = {
    # NixOS aspects
    nixos.docker = ./nixos/docker.nix;
    nixos.networking = ./nixos/networking.nix;

    # Darwin aspects
    darwin.settings = ./darwin/settings.nix;

    # Home Manager aspects
    homeManager = {
      scripts = ./homeManager/scripts.nix;
      fish = ./homeManager/fish.nix;
      git = ./homeManager/git.nix;
      gh = ./homeManager/gh.nix;
      gpg = ./homeManager/gpg.nix;
      vscode = ./homeManager/vscode.nix;
      neovim = ./homeManager/neovim;
      firefox = ./homeManager/firefox;
      dotnet = ./homeManager/dotnet.nix;
    };
  };
}
