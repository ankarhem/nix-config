{
  flake.modules.homeManager.ghostty =
    { lib, pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isLinux then pkgs.ghostty else pkgs.ghostty-bin;
        enableFishIntegration = true;

        settings = {
          font-size = if pkgs.stdenv.isLinux then 16 else 12;
          theme = "dark:Catppuccin Frappe,light:Catppuccin Latte";
          shell-integration-features = "ssh-terminfo,ssh-env";
        };
      };
    };
}
