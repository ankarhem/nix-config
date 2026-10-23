{
  lib,
  rustPlatform,
  fetchFromGitHub,
  perl,
  git,
  cmake,
}:

# TODO: Remove this once redlib fixes their annoying issues
rustPlatform.buildRustPackage (_: {
  pname = "redlib";
  version = "0-unstable-ba116c1";

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
    rev = "ba116c1186f6b0f9d45f0ae50c827e13eb2f5ea2";
    hash = "sha256-qv7vIls9BwgwDQuKEQU72J10MpaMfcLvIGfzl628eNU=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-XgHXqH4EF8TEOI+cKJ0Z2j6QYRCwGgv8bmY8gZpPN9c=";

  doCheck = false;
  # btls-sys builds vendored BoringSSL: patches via git, cmake build, bindgen
  nativeBuildInputs = [
    perl
    git
    cmake
    rustPlatform.bindgenHook
  ];
  dontUseCmakeConfigure = true;

  meta = {
    description = "Private front-end for Reddit";
    homepage = "https://github.com/redlib-org/redlib";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "redlib";
  };
})
