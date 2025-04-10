{ self, ... }: {
  sops = {
    defaultSopsFile = "${self}/secrets/homelab/secrets.yaml";
    age = { keyFile = "/home/idealpink/.config/sops/age/keys.txt"; };
  };
}
