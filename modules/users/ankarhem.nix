{
  lib,
  inputs,
  config,
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

  username = "ankarhem";

  homeDirectory = { pkgs }: if pkgs.stdenv.isLinux then "/home/${username}" else "/Users/${username}";

  shared =
    { pkgs, ... }:
    {
      users.users.${username} = {
        home = homeDirectory { inherit pkgs; };
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
      };
      nix.settings.trusted-users = [ username ];
      nix.settings.extra-trusted-users = [ username ];
    };

  flake.modules.nixos.ankarhem = shared;
  flake.modules.darwin.ankarhem = shared;
  flake.modules.home.ankarhem =
    { pkgs, ... }:
    let
      homeDirectory = homeDirectory { inherit pkgs; };
    in
    {
      home.username = username;
      home.homeDirectory = homeDirectory;
      home.sessionVariables = {
        SOPS_AGE_KEY_FILE = "${homeDirectory}/.config/sops/age/keys.txt";
      };
    };
in
{
  inherit flake;
}
