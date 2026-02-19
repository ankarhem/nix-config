{ inputs, ... }:
let
  appleFontsModule =
    { pkgs, ... }:
    {
      fonts.packages = with inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}; [
        sf-pro
        sf-pro-nerd
        sf-mono
        sf-mono-nerd
        ny
        ny-nerd
      ];
    };
  fontPackagesModule =
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

  flake.modules.nixos.fonts =
    { pkgs, ... }:
    {
      imports = [
        appleFontsModule
        fontPackagesModule
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

  flake.modules.darwin.fonts = fontPackagesModule;
in
{
  inherit flake;
}
