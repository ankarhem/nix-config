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
    LESS = "-r";
    KEYID = "529972E4160200DF";
    SOPS_AGE_KEY_FILE = "/Users/ankarhem/.config/sops/age/keys.txt";
  };
  environment.shells = with pkgs; [bash zsh fish];
  environment.shellAliases = {
    ls = "eza --color=auto -F";
    nixswitch = "darwin-rebuild switch --flake ~/nix-config/.#";
    nixup = "pushd ~/nix-config; nix flake update; nixswitch; popd";
    gcr = "git checkout --track $(git branch --format \"%(refname:short)\" -a --sort=-committerdate | fzf | tr -d '[:space:]')";
  };
}
