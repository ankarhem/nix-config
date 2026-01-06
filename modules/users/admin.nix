{
  lib,
  ...
}:
let
  getGithubKeys =
    { username, sha256 }:
    let
      authorizedKeysFile = builtins.fetchurl {
        url = "https://github.com/${username}.keys";
        inherit sha256;
      };
      keys = lib.splitString "\n" (builtins.readFile authorizedKeysFile);
    in
    builtins.filter (s: s != "") keys;
  shared =
    { pkgs }:
    let
      homeDirectory = if pkgs.stdenv.isLinux then "/home/${username}" else "/Users/${username}";
    in
    {
      users.users.${username} = {
        isNormalUser = true;
        description = "Jakob Ankarhem";
        extraGroups = [
          "networkmanager"
          "wheel"
          "podman"
          "docker"
        ];
        openssh.authorizedKeys.keys = getGithubKeys {
          inherit username;
          sha256 = "1i0zyn1jbndfi8hqwwhmbn3b6akbibxkjlwrrg7w2988gs9c96gi";
        };
        shell = pkgs.fish;
      };
      nix.settings.trusted-users = [ username ];
      nix.settings.extra-trusted-users = [ username ];
      age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
    };
  createAdminUserModule =
    { username }:
    {
      flake.modules.nixos.${username} = shared;
      flake.modules.darwin.${username} = {
        imports = [ shared ];
        system.primaryUser = username;
      };
      flake.modules.home.${username} =
        { pkgs, ... }:
        let
          homeDirectory = if pkgs.stdenv.isLinux then "/home/${username}" else "/Users/${username}";
        in
        {
          home.username = username;
          home.homeDirectory = homeDirectory;
          home.sessionVariables = {
            SOPS_AGE_KEY_FILE = "${homeDirectory}/.config/sops/age/keys.txt";
          };
        };
    };

in
{
  imports = [
    createAdminUserModule
    { username = "ankarhem"; }
    createAdminUserModule
    { username = "idealpink"; }
  ];
}
