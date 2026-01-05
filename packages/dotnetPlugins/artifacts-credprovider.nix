{ stdenv, fetchurl }:
let
  version = "v1.4.1";
  credProvider = stdenv.mkDerivation {
    pname = "azure-artifacts-credprovider";
    inherit version;
    src = fetchurl {
      url = "https://github.com/microsoft/artifacts-credprovider/releases/download/${version}/Microsoft.NuGet.CredentialProvider.tar.gz";
      hash = "sha256-4rUihn7GLyov6wTFn2hNoPsehaRF4RM8wDgiHa5txcI=";
    };

    buildCommand = ''
      mkdir -p $out
      tar -xzf $src
      mv plugins $out/
    '';
  };
in
"${cerdProvider}/plugins"
