{pkgs}:{
  getGithubKeys = {username, sha256}: let
    authorizedKeysFile = builtins.fetchurl {
      url = "https://github.com/${username}.keys";
      inherit sha256;
    };
    keys = pkgs.lib.splitString "\n" (builtins.readFile authorizedKeysFile);
  in keys;
}
