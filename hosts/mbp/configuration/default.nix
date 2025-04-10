{ username, ... }: {
  imports = [
    ./nix.nix
    ./environment.nix
    ./user.nix
    ./settings.nix
    ./homebrew.nix
    ../../../darwinModules/default.nix
  ];
  darwin.settings.enable = true;

  sops = {
    defaultSopsFile = ../../../../secrets/mbp/secrets.yaml;
    age = { keyFile = "/Users/${username}/.config/sops/age/keys.txt"; };
  };
}
