{ self, username, ... }:
{
  sops = {
    defaultSopsFile = "${self}/secrets/mbp/secrets.yaml";
    age = {
      keyFile = "/Users/${username}/.config/sops/age/keys.txt";
    };
  };
}
