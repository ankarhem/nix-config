{
  config,
  lib,
  pkgs,
  ...
}:
let
  version = "v1.4.1";
  src = pkgs.fetchurl {
    url = "https://github.com/microsoft/artifacts-credprovider/releases/download/${version}/Microsoft.NuGet.CredentialProvider.tar.gz";
    hash = "sha256-4rUihn7GLyov6wTFn2hNoPsehaRF4RM8wDgiHa5txcI=";
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
