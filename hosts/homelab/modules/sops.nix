{...}:{
  sops = {
    defaultSopsFile = ../../../secrets/homelab/secrets.yaml;
    age = {
      keyFile = "/home/idealpink/.config/sops/age/keys.txt";
    };
  };
}
