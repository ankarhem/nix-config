{
  stdenv,
  fetchurl,
  lib,
}:
stdenv.mkDerivation {
  pname = "acli";
  version = "latest";

  src =
    if stdenv.hostPlatform.isDarwin then
      fetchurl {
        url = "https://acli.atlassian.com/darwin/latest/acli_darwin_arm64/acli";
        sha256 = "sha256-CWHza5Ql+neFf+oWwZFUw09l/9rgjFznm3TNs2+pZCY=";
      }
    else
      fetchurl {
        url = "https://acli.atlassian.com/linux/latest/acli_linux_amd64/acli";
        sha256 = "sha256-9JYkwS4QmaeKMEASldFpuIr+nvenZFmOmTjTnRCjLBc=";
      };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src $out/bin/acli
    chmod +x $out/bin/acli
    runHook postInstall
  '';

  meta = {
    description = "Atlassian CLI for Jira, Confluence, and other Atlassian products";
    homepage = "https://developer.atlassian.com/cloud/acli/";
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
  };
}
