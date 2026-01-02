{ pkgs, ... }:
{
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
    wl-clipboard
    appmenu-glib-translator
  ];
}
