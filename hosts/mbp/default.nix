{...}: {
  imports = [
    ./nix.nix
    ./environment.nix
    ./user.nix
    ./settings.nix
    ./modules/homebrew.nix
    ../../darwinModules/default.nix
    ../../modules/default.nix
  ];
  darwin.settings.enable = true;

  modules.ghostty = {
    enable = true;
    username = "ankarhem";
    theme = "dark:catppuccin-frappe,light:catppuccin-latte";
  };
}
