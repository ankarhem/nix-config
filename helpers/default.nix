{ pkgs ? import <nixpkgs> {} }:
{
  ssh = import ./ssh.nix { inherit pkgs; };
}
