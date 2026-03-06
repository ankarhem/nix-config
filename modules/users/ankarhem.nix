{
  self,
  lib,
  inputs,
  ...
}:
let
  username = "ankarhem";
  sopsKeyModule =
    { pkgs, ... }:
    {
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
      };

      darwin.${username} = {
        imports = [
          sopsKeyModule
        ];
      };
      homeManager.${username} = {
        home.sessionVariables = {
          SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/age.key";
        };
        imports =
          (with inputs.self.modules.homeManager; [
            ghostty
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
