{
  config,
  lib,
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  mkRayCastExtension = (
    {
      name,
      sha256,
      rev,
    }:
    let
      src =
        pkgs.fetchgit {
          inherit rev sha256;
          url = "https://github.com/raycast/extensions";
          sparseCheckout = [
            "/extensions/${name}"
          ];
        }
        + "/extensions/${name}";
    in
    (pkgs.buildNpmPackage {
      inherit name src;
      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -r /build/.config/raycast/extensions/${name}/* $out/

        runHook postInstall
      '';
      npmDeps = pkgs.importNpmLock { npmRoot = src; };
      npmConfigHook = pkgs.importNpmLock.npmConfigHook;
    })
  );
in
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  services.vicinae = {
    enable = true;
    package = pkgs-unstable.vicinae;
    systemd = {
      enable = true;
      autoStart = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    settings = {
      close_on_focus_loss = true;
      consider_preedit = true;
      pop_to_root_on_close = true;
      favicon_service = "twenty";
      search_files_in_root = true;
      font = {
        normal = {
          size = 12;
          normal = "Maple Nerd Font";
        };
      };
      theme = {
        light = {
          name = "vicinae-light";
          icon_theme = "default";
        };
        dark = {
          name = "vicinae-dark";
          icon_theme = "default";
        };
      };
      launcher_window = {
        opacity = 0.98;
      };
    };

    # https://github.com/vicinaehq/extensions/tree/main/extensions
    extensions =
      (with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        bluetooth
        case-converter
        firefox
        fuzzy-files
        it-tools
        kde-system-settings
        nix
        port-killer
        power-profile
        spongebob-text-transformer
      ])
      ++ [
        (mkRayCastExtension {
          name = "gif-search";
          sha256 = "NKmNqRqAnxtOXipFZFXOIgFlVzc0c3B5/Qr4DzKzAx4=";
          rev = "3ec994afcd05b2b6258b3b71ab8b19d6b6f1e0e4";
        })
      ];
  };
}
