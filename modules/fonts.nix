{ inputs, ... }:
let
  appleFonts =
    { pkgs, ... }:
    with inputs.apple-fonts.packages.${pkgs.system};
    [
      sf-pro
      sf-pro-nerd
      sf-mono
      sf-mono-nerd
      ny
      ny-nerd
    ];
  fontPackages =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        material-design-icons
        font-awesome
        nerd-fonts.symbols-only
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka
      ];
    };

  flake.modules.nixos.fonts = {
    imports = [
      appleFonts
      fontPackages
    ];

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
    };
  };

  flake.modules.darwin.fonts = fontPackages;
in
{
  inherit flake;
}
