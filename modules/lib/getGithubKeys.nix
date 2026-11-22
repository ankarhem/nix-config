{ lib, ... }:
let
  fetchGithubKeys =
    { username, sha256 }:
    let
      authorizedKeysFile = builtins.fetchurl {
        url = "https://github.com/${username}.keys";
        inherit sha256;
      };
      keys = lib.splitString "\n" (builtins.readFile authorizedKeysFile);
    in
    builtins.filter (s: s != "") keys;
in
{
  config.flake.lib.getGithubKeys = fetchGithubKeys;

  # Keys allowed to log in as our users on every host: our GitHub keys plus the
  # Herdr mobile app.
  config.flake.lib.authorizedKeys =
    fetchGithubKeys {
      username = "ankarhem";
      sha256 = "0wqcmrsff263md06nksm8zrgiyd53vh4gxyv5rqgbz9kdb0fb0zh";
    }
    ++ [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPn3Vi5Ctr8b7hT1a1+0lVKtGi65bPYzeck5EJ86jQLf herdr-mobile"
    ];
}
