{ splitString }:
{ username, sha256 }:
let
  authorizedKeysFile = builtins.fetchurl {
    url = "https://github.com/${username}.keys";
    inherit sha256;
  };
  keys = splitString "\n" (builtins.readFile authorizedKeysFile);
in
builtins.filter (s: s != "") keys
