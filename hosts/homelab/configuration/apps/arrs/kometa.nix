{ ... }: {
  virtualisation.oci-containers.containers = {
    kometa = {
      image = "kometateam/kometa:nightly";
      volumes = [ "/var/lib/kometa/config:/config:rw" ];
    };
  };
}
