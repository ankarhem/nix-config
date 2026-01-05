# Dotnet aspect - enables Azure Artifacts Credential Provider
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.dotnet;

  credProviderVersion = "v1.4.1";
  credProviderSrc = pkgs.fetchurl {
    url = "https://github.com/microsoft/artifacts-credprovider/releases/download/${credProviderVersion}/Microsoft.NuGet.CredentialProvider.tar.gz";
    hash = "sha256-4rUihn7GLyov6wTFn2hNoPsehaRF4RM8wDgiHa5txcI=";
  };

  credProvider = pkgs.stdenv.mkDerivation {
    pname = "azure-artifacts-credprovider";
    version = credProviderVersion;
    src = credProviderSrc;

    buildCommand = ''
      mkdir -p $out
      tar -xzf $src
      mv plugins $out/
    '';
  };

  defaultDotnetPackages = pkgs.dotnetCorePackages.combinePackages [
    pkgs.dotnet-sdk_8
    pkgs.dotnet-sdk_9
    pkgs.dotnet-sdk_10
  ];
in
{
  options = {
    programs.dotnet = {
      enable = lib.mkEnableOption "dotnet";

      package = lib.mkOption {
        type = lib.types.package;
        default = defaultDotnetPackages;
        description = "The dotnet package to use";
      };

      enableAzureArtifactsCredProvider = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Azure Artifacts credential provider";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file = lib.mkIf cfg.enableAzureArtifactsCredProvider {
      ".nuget/plugins".source = "${credProvider}/plugins";
    };
  };
}
