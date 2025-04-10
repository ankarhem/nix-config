{ ... }: {
  imports = [
    ./nix.nix
    ./environment.nix
    ./user.nix
    ./settings.nix
    ./homebrew.nix
    ../../../darwinModules/default.nix
    ../../../modules/default.nix
  ];
  darwin.settings.enable = true;

  sops = {
    defaultSopsFile = ../../../../secrets/mbp/secrets.yaml;
    age = { keyFile = "/Users/ankarhem/.config/sops/age/keys.txt"; };
  };

  modules.ghostty = {
    enable = true;
    username = "ankarhem";
    theme = "dark:catppuccin-frappe,light:catppuccin-latte";
  };
}
