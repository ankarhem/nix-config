{
  self,
  lib,
  inputs,
  ...
}:
let
  username = "idealpink";
  sopsKeyModule =
    { pkgs, ... }:
    {
      sops.defaultSopsFile = "${self}/secrets/homelab/secrets.yaml";
      sops.age.keyFile =
        if pkgs.stdenv.isLinux then
          "/home/${username}/.config/sops/age/age.key"
        else
          "/Users/${username}/.config/sops/age/age.key";
    };
in
{
  flake.modules = lib.mkMerge [
    (self.factory.user {
      inherit username;
      isAdmin = true;
    })
    {
      nixos.${username} = {
        imports = [
          sopsKeyModule
        ];
        users.users.${username} = {
          extraGroups = [ "podman" ];
          openssh.authorizedKeys.keys = self.lib.getGithubKeys {
            username = "ankarhem";
            sha256 = "0by0paqz05n41firv21i2izy0mk6sxqh2nn6wkcbwsy9n3wf537w";
          };
        };
      };

      darwin.${username} = {
        imports = [
          sopsKeyModule
        ];
      };
      homeManager.${username} = {
        home.sessionVariables = {
          SOPS_AGE_KEY_FILE = "~/.config/sops/age/age.key";
        };
        imports =
          (with inputs.self.modules.homeManager; [
            git
            npm
            ssh
          ])
          ++ [
            sopsKeyModule
          ];
      };
    }
  ];
}
