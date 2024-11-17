{...}: {
  networking.networkmanager.enable = true;
  networking.hosts = {
    "192.168.1.163" = ["disketten.local"];
  };

  # fileSystems."/mnt/DISKETTEN_media" = {
  #   device = "disketten.local:/volume1/media";
  #   fsType = "nfs";
  #   options = [
  #     "x-systemd.automount"
  #     "noauto"
  #   ];
  # };
}
