{
  config,
  lib,
  pkgs,
  ...
}:
let
  version = "v1.4.1";
  src = pkgs.fetchFromGitHub {
    owner = "microsoft";
    repo = "artifacts-credprovider";
    rev = version;
    hash = "sha256-MYOl+UfRExeZsozcPJynWbx5JpYL0dxTADycAt6Wm7o=";
  };

  credentialProvider = pkgs.stdenv.mkDerivation {
    pname = "azure-artifacts-credprovider";
    inherit version;
    inherit src;

    buildCommand = ''
      mkdir -p $out
      tar -xzf $src
      mv plugins $out/
    '';
  };
in
{
  options = {
    azure-artifacts-credprovider.enable = lib.mkEnableOption "Azure Artifacts credential provider";
  };

  config = lib.mkIf config.azure-artifacts-credprovider.enable {
    home.file.".nuget/plugins".source = "${credentialProvider}/plugins";
  };
}
