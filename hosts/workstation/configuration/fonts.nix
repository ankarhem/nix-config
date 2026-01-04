{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  apple-fonts = with inputs.apple-fonts.packages.${pkgs.system}; [
    sf-pro
    sf-pro-nerd
    sf-mono
    sf-mono-nerd
    ny
    ny-nerd
  ];
in
{
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      subpixel = {
        rgba = "rgb";
      };
      hinting = {
        enable = true;
        style = "slight";
      };
      antialias = true;

      defaultFonts = {
        serif = [
          "NewYork Nerd Font"
          "DejaVu Serif"
        ];
        sansSerif = [
          "SFProDisplay Nerd Font"
          "DejaVu Sans"
        ];
        monospace = [
          "SFMono Nerd Font"
          "DejaVu Sans Mono"
        ];
      };
    };
    packages =
      with pkgs;
      [
        material-design-icons
        font-awesome
      ]
      ++ [
        pkgs-unstable.nerd-fonts.symbols-only
        pkgs-unstable.nerd-fonts.fira-code
        pkgs-unstable.nerd-fonts.jetbrains-mono
        pkgs-unstable.nerd-fonts.iosevka
      ]
      ++ apple-fonts;
  };
}
