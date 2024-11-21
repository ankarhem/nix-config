{...}: {
  networking.networkmanager.enable = true;
  networking.hosts = {
    "192.168.1.163" = ["disketten.local"];
  };
  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };

  fileSystems."/mnt/DISKETTEN_media" = {
    device = "disketten.local:/volume1/media";
    fsType = "nfs";
    options = [
      "nfsvers=3"
      "x-systemd.automount"
      "noauto"
    ];
  };
}
