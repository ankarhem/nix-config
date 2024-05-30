{ pkgs, ... }:
{
  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
  };

  users.users.ankarhem.shell = pkgs.fish;

  environment.shells = with pkgs; [ bash zsh fish ];
  environment.shellAliases = {
    vim = "nvim";
  };
}
