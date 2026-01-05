# Helpers module - provides utility functions used across configurations
{ inputs, lib, ... }:
{
  options.helpers = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "Helper functions available across all configurations";
  };

  config.helpers = {
    # Get SSH keys from GitHub
    ssh.getGithubKeys =
      { username, sha256 }:
      let
        authorizedKeysFile = builtins.fetchurl {
          url = "https://github.com/${username}.keys";
          inherit sha256;
        };
        keys = lib.splitString "\n" (builtins.readFile authorizedKeysFile);
      in
      builtins.filter (s: s != "") keys;
  };
}
