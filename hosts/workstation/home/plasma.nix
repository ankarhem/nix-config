{ pkgs, ... }:
let
  swapMetaAndAlt = true;
  cmdKey = if swapMetaAndAlt then "Alt" else "Meta";
in
{
  programs.plasma = {
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
}
