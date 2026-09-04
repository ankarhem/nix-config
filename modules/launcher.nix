{ inputs, ... }:
{
  flake.modules.nixos.launcher = {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.launcher
    ];
  };
  flake.modules.darwin.launcher =
    { config, ... }:
    {
      home-manager.sharedModules = [
        inputs.self.modules.homeManager.launcher
      ];

      system.defaults.CustomUserPreferences = {
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # Disable spotlight with cmd+space
            "64" = {
              enabled = false;
            };
          };
        };
      };

      system.activationScripts = {
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

  flake.modules.homeManager.launcher =
    {
      lib,
      pkgs,
      ...
    }:
    let
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      imports = [
        inputs.vicinae.homeManagerModules.default
      ];

      programs.vicinae = {
        enable = true;
        # nixpkgs only packages vicinae for linux; on darwin use the flake's
        # package which assembles the Vicinae.app bundle
        package = if isDarwin then inputs.vicinae.packages.${system}.default else pkgs.vicinae;

        systemd = lib.mkIf (!isDarwin) {
          enable = true;
          autoStart = true;
          environment = {
            USE_LAYER_SHELL = 1;
          };
        };
        launchd = lib.mkIf isDarwin {
          enable = true;
          autoStart = true;
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
        }
        // lib.optionalAttrs isDarwin {
          global_shortcuts.toggle = "cmd+space";
        };

        # https://github.com/vicinaehq/extensions/tree/main/extensions
        extensions =
          (with inputs.vicinae-extensions.packages.${system}; [
            case-converter
            firefox
            fuzzy-files
            it-tools
            nix
            port-killer
            spongebob-text-transformer
          ])
          ++ lib.optionals (!isDarwin) [
            # wraps power-profiles-daemon, linux only
            inputs.vicinae-extensions.packages.${system}.power-profile
          ]
          ++ [
            # https://github.com/raycast/extensions/tree/main/extensions
            (inputs.vicinae.lib.${system}.mkRayCastExtension {
              name = "gif-search";
              hash = "sha256-NKmNqRqAnxtOXipFZFXOIgFlVzc0c3B5/Qr4DzKzAx4=";
              rev = "3ec994afcd05b2b6258b3b71ab8b19d6b6f1e0e4";
            })
          ];
      };
    };
}
