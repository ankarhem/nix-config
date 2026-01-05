# Hosts module - assembles host configurations from dendritic aspects
{ inputs, ... }:
{
  imports = [
    ./installer.nix
    ./homelab.nix
    ./workstation.nix
    ./mbp.nix
  ];
}
