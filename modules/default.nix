# Dendritic modules - imports all aspect modules
{ inputs, ... }:
{
  imports = [
    ./helpers
    ./users
    ./hosts
    ./nixos
    ./darwin
    ./homeManager
  ];
}
