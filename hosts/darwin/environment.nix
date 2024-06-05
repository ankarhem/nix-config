{pkgs, ...}: {
  environment = {
    pathsToLink = ["/Applications"];
    systemPackages = with pkgs; [
      coreutils
    ];
  };
  environment.variables = {
    EDITOR = "nvim";
    GNUPGHOME = "~/.gnupg";
  };
  environment.shells = with pkgs; [bash zsh fish];
  environment.shellAliases = {
    vim = "nvim";
    ls = "eza --color=auto -F";
    nixswitch = "darwin-rebuild switch --flake ~/nix-config/.#";
    nixup = "pushd ~/nix-config; nix flake update; nixswitch; popd";
  };
}
