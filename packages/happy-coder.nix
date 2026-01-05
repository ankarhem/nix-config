{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "happy-coder";
  version = "0.13.0-nixos-fix";

  # Patched by searching for claude in PATH + environment variable
  src = fetchFromGitHub {
    owner = "ankarhem";
    repo = "happy-cli";
    rev = "d94c81e49260410366b12e495cf02e0c276a21b5";
    hash = "sha256-iO0lf20SWZbITY/lEMoG4MbAQu1QzZbxpU16uw3WcLY=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-DlUUAj5b47KFhUBsftLjxYJJxyCxW9/xfp3WUCCClDY=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    makeWrapper
  ];

  # Currently `happy` requires `node` to start its daemon
  postInstall = ''
    wrapProgram $out/bin/happy \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
        ]
      }
    wrapProgram $out/bin/happy-mcp \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
        ]
      }
  '';

  meta = {
    description = "Mobile and web client wrapper for Claude Code and Codex with end-to-end encryption";
    homepage = "https://github.com/slopus/happy-cli";
    changelog = "https://github.com/slopus/happy-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onsails ];
    mainProgram = "happy";
  };
})
