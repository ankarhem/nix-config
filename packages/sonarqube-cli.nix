{
  stdenv,
  fetchurl,
  system,
}:

let
  version = "0.8.1.798";
  pname = "sonarqube-cli";

  binaries = {
    "x86_64-linux" = {
      platform = "linux-x86-64";
      os = "linux";
      hash = "sha256-vdvyIHk4zvgEqK+qi46sQR57xwSJQnb6o1coTcKdNgY=";
    };
    "aarch64-darwin" = {
      platform = "macos-arm64";
      os = "macos";
      hash = "sha256-8ohg2icOQhIm67m6hjateRwZhC2D/riI2H26+L5UEWA=";
    };
  };

  binary = binaries.${system};
in
stdenv.mkDerivation {
  inherit pname version;
  meta.mainProgram = "sonar";

  src = fetchurl {
    url = "https://binaries.sonarsource.com/Distribution/sonarqube-cli/${version}/${binary.os}/sonarqube-cli-${version}-${binary.platform}.exe";
    inherit (binary) hash;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src $out/bin/sonar
    chmod +x $out/bin/sonar
    runHook postInstall
  '';
}
