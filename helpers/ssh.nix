{pkgs}:{
  getGithubKeys = {username, sha256}: let
    authorizedKeysFile = pkgs.fetchurl {
      url = "https://github.com/${username}.keys";
      inherit sha256;
    };
    keys = pkgs.lib.splitString "\n" (pkgs.readFile authorizedKeysFile);
  in keys;
}
