{ inputs, config, ... }:
{
  flake.modules.nixos.ssh = {
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = true;
    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
    };
    services.desktopManager.plasma6.enable = true;
    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.ktorrent
      kdePackages.partitionmanager
      kdePackages.kolourpaint
      kdePackages.neochat
      wl-clipboard
      appmenu-glib-translator
    ];
  };

  flake.modules.darwin.ssh = {
    # MacOS config: enable MacOS builtin ssh server, etc.
  };

  flake.modules.homeManager.ssh = {
    # This wont work but solve it later
    home-manager.sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    programs.plasma =
      let
        swapMetaAndAlt = true;
        cmdKey = if swapMetaAndAlt then "Alt" else "Meta";
      in
      {
        enable = true;
        overrideConfig = true; # Discard non declarative config

        powerdevil.AC.autoSuspend.action = "nothing";

        panels = [
          # Top Bar
          {
            alignment = "left";
            height = 32;
            hiding = "none";
            lengthMode = "fill";
            location = "top";
            screen = "all";
            widgets = [
              "org.kde.plasma.appmenu"
              "org.kde.plasma.panelspacer"
              "org.kde.plasma.systemtray"
              "org.kde.plasma.digitalclock"
              "org.kde.plasma.showdesktop"
            ];
          }

          # App Bar
          {
            alignment = "center";
            height = 48;
            hiding = "none";
            lengthMode = "fit";
            location = "bottom";
            widgets = [
              "org.kde.plasma.kickoff"
              "org.kde.plasma.icontasks"
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.trashcan"
            ];
          }
        ];

        spectacle.shortcuts = {
          captureEntireDesktop = "${cmdKey}+Shift+3";
          captureRectangularRegion = "${cmdKey}+Shift+4";
          captureWindowUnderCursor = "${cmdKey}+Shift+5";
        };
        shortcuts = {
          "services/net.local.vicinae-2.desktop"._launch = "Ctrl+Alt+Space";
          "services/net.local.vicinae.desktop"._launch = "Alt+Space";
          "services/org.kde.krunner.desktop"._launch = [
            "Search"
            "Alt+F2"
          ];
        };
        configFile = {
          kcminputrc.Keyboard.RepeatDelay = 300;
          kcminputrc.Keyboard.RepeatRate = 100;
          kcminputrc."Libinput/11944/8707/Wings Tech Xtrfy M4".PointerAcceleration = 0.000;
          kcminputrc."Libinput/11944/8707/Wings Tech Xtrfy M4".PointerAccelerationProfile = 1;
          kcminputrc.Mouse.X11LibInputXAccelProfileFlat = true;
          kwinrc.Xwayland.Scale = 1.7;
          plasma-localerc.Formats.LANG = "en_US.UTF-8";
          spectaclerc.ImageSave.translatedScreenshotsFolder = "Screenshots";
          spectaclerc.VideoSave.translatedScreencastsFolder = "Screencasts";
        };
      };
  };
}
