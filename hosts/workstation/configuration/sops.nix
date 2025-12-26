{ self, ... }:
{
  sops = {
    defaultSopsFile = "${self}/secrets/workstation/secrets.yaml";
    age = {
      keyFile = "/home/idealpink/.config/sops/age/keys.txt";
    };
  };
}
