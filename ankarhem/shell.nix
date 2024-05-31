{pkgs, ...}: {
  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
    loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";
  };

  users.users.ankarhem.shell = pkgs.fish;

  environment.shells = with pkgs; [bash zsh fish];
  environment.shellAliases = {
    vim = "nvim";
  };
}
