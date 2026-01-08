{ pkgs, pkgs-unstable, ... }:
{
  fonts = {
    packages =
      with pkgs;
      [
        # packages = with pkgs; [
        # icon fonts
        material-design-icons
        font-awesome
      ]
      ++ [
        pkgs-unstable.nerd-fonts.symbols-only
        pkgs-unstable.nerd-fonts.fira-code
        pkgs-unstable.nerd-fonts.jetbrains-mono
        pkgs-unstable.nerd-fonts.iosevka
      ];
  };
}
