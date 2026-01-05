{
  flake.modules.nixos.launcher =
    let
      mkRayCastExtension =
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
        pkgs.buildNpmPackage {
          inherit name src;
          installPhase = ''
            runHook preInstall

            mkdir -p $out
            cp -r /build/.config/raycast/extensions/${name}/* $out/

            runHook postInstall
          '';
          npmDeps = pkgs.importNpmLock { npmRoot = src; };
          inherit (pkgs.importNpmLock) npmConfigHook;
        };
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
    };

  flake.modules.darwin.launcher =
    { pkgs }:
    {
      homebrew.casks = with pkgs; [
        raycast
      ];

      system.activationScripts = mkIf cfg.linkHomeManagerApps {
        # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
        postActivation.text = ''
          # activateSettings -u will reload the settings from the database and apply them to the current session,
          # so we do not need to logout and login again to make the changes take effect.
          /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

          # Check if ~/Applications/Home\ Manager\ Apps exists and symlink directory to /Applications
          HMA_DIRECTORY_SOURCE=/Users/${config.system.primaryUser}/Applications/Home\ Manager\ Apps
          HMA_DIRECTORY_TARGET=/Applications
          if [ -d "$HMA_DIRECTORY_SOURCE" ] && [ ! -L "$HMA_DIRECTORY_TARGET/Home Manager Apps" ]; then
          echo "Symlinking /Users/${config.system.primaryUser}/Applications/Home\ Manager\ Apps directory to /Applications"
          ln -s "$HMA_DIRECTORY_SOURCE" "$HMA_DIRECTORY_TARGET"
          fi
        '';
      };
    };
}
