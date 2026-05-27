{
  fetchurl,
  lib,
  makeWrapper,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openchamber-desktop";
  version = "1.11.7";

  src = fetchurl {
    url = "https://github.com/openchamber/openchamber/releases/download/v${finalAttrs.version}/OpenChamber-${finalAttrs.version}-darwin-aarch64.app.tar.gz";
    hash = "sha256-d6O8Q91V+BS4SVTLcLbJDRB5Xs+CwfIyYMEI+CciSjg=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    tar -xzf $src -C $out/Applications/

    makeWrapper $out/Applications/OpenChamber.app/Contents/MacOS/OpenChamber \
      $out/bin/openchamber-desktop

    runHook postInstall
  '';

  meta = {
    description = "OpenChamber Desktop";
    homepage = "https://github.com/openchamber/openchamber";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "openchamber-desktop";
  };
})
