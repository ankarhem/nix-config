{
  config,
  lib,
  pkgs,
  ...
}:
let
  version = "v1.3.0";
  src = pkgs.fetchurl {
    url = "https://github.com/microsoft/artifacts-credprovider/releases/download/${version}/Microsoft.NuGet.CredentialProvider.tar.gz";
    hash = "sha256-fbpTsGm5gbUsIVPNU9UvmfXOmT9olkE2w+r4TpIhfDA=";
  };

  credentialProvider = pkgs.stdenv.mkDerivation {
    pname = "azure-artifacts-credprovider";
    inherit version;
    inherit src;

    nativeBuildInputs = with pkgs; [ unzip ];

    buildCommand = ''
      mkdir -p $out
      tar -xzf $src
      mv plugins $out/
    '';
  };
in
{
  options = {
    azure-artifacts-credprovider.enable = lib.mkEnableOption "Enable Azure Artifacts credential provider";
  };

  config = lib.mkIf config.azure-artifacts-credprovider.enable {
    home.file.".nuget/plugins".source = "${credentialProvider}/plugins";
  };
}
