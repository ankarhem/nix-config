{pkgs, ...}: {
  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      starship init fish | source
    '';
    # Reorders stuff so that nix can override system binaries
    loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";
  };

  users.users.ankarhem.shell = pkgs.fish;

  environment.shells = with pkgs; [bash zsh fish];
  environment.shellAliases = {
    vim = "nvim";
    ls = "eza --color=auto -F";
    nixswitch = "darwin-rebuild switch --flake ~/nix-config/.#";
    nixup = "pushd ~/nix-config; nix flake update; nixswitch; popd";
  };
}
