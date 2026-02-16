{
  flake.modules.homeManager.ghostty =
    { lib, pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isLinux then pkgs.ghostty else pkgs.ghostty-bin;
        enableFishIntegration = true;

        settings = {
          font-size = 16;
          theme = "dark:Catppuccin Frappe,light:Catppuccin Latte";
          shell-integration-features = "ssh-terminfo,ssh-env";
        };
      };
    };
}
