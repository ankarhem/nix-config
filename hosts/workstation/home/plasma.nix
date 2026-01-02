_: {
  programs.plasma = {
    enable = true;
    shortcuts = {
      # kwin."Window Maximize" = "Meta+PgUp";
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
