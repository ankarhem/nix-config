{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  deno,
  autoPatchelfHook,
  makeWrapper,
  coreutils,
  git,
  gnutar,
  sqlite,
}:
let
  system = stdenv.hostPlatform.system;
  pick = attrs: attrs.${system} or (throw "profilarr: unsupported system ${system}");

  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Dictionarry-Hub";
    repo = "profilarr";
    tag = "v${version}";
    hash = "sha256-88BT9GUEaPCPmD4pURcknaXrSzYHzjYnDResc4Uc2qY=";
  };

  bcryptPath = "/felix-schindler/deno-bcrypt/releases/download/v2.1.0/libdeno_bcrypt-${
    pick {
      x86_64-linux = "X64";
      aarch64-linux = "ARM64";
    }
  }.so";

  bcrypt = fetchurl {
    url = "https://github.com${bcryptPath}";
    hash = pick {
      x86_64-linux = "sha256-3D1r4YEv0EkWD4a8IVjdLlEU12bfFpvBHj5iDgjk6R8=";
      aarch64-linux = "sha256-uZvGQY46t/ZSWvZCzRWYKkEopJpvpY/3HwXv53ICNNg=";
    };
  };

  deps = stdenvNoCC.mkDerivation {
    pname = "profilarr-deps";
    inherit version src;

    nativeBuildInputs = [ deno ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild
      export HOME=$TMPDIR DENO_DIR=$TMPDIR/deno-dir DENO_NO_UPDATE_CHECK=1
      deno ci
      deno cache jsr:@std/http@1/file-server
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r node_modules $out/node_modules
      cp -r $DENO_DIR $out/deno-dir
      cp deno.lock $out/deno.lock
      find $out/deno-dir -maxdepth 1 -type f -delete
      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = pick {
      x86_64-linux = lib.fakeHash;
      aarch64-linux = lib.fakeHash;
    };
  };
in
stdenv.mkDerivation {
  pname = "profilarr";
  inherit version src;

  nativeBuildInputs = [
    deno
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [ stdenv.cc.cc.lib ];

  dontAutoPatchelf = true;
  dontStrip = true;
  dontPatchELF = true;

  postPatch = ''
    substituteInPlace src/lib/shared/build.ts \
      --replace-fail "version: 'dev'" "version: '${version}'" \
      --replace-fail "channel: 'dev'" "channel: 'stable'"
  '';

  configurePhase = ''
    runHook preConfigure
    export HOME=$TMPDIR DENO_DIR=$TMPDIR/deno-dir DENO_NO_UPDATE_CHECK=1
    cp -r ${deps}/node_modules node_modules
    cp -r ${deps}/deno-dir $DENO_DIR
    cp ${deps}/deno.lock deno.lock
    chmod -R u+w node_modules $DENO_DIR deno.lock
    autoPatchelf node_modules
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    export VITE_CHANNEL=stable VITE_PLATFORM=${
      pick {
        x86_64-linux = "linux-amd64";
        aarch64-linux = "linux-arm64";
      }
    }
    APP_BASE_PATH=$PWD/dist/build deno run --cached-only -A vite build
    export DENORT_BIN=${lib.getExe' (deno.denort or deno) "denort"}
    test -x "$DENORT_BIN" || {
      echo "profilarr: deno ${deno.version} ships no denort; build with a deno that has it (nixpkgs-unstable)" >&2
      exit 1
    }
    deno compile --cached-only --no-check \
      --allow-net --allow-read --allow-write --allow-env --allow-ffi --allow-run --allow-sys \
      --output dist/build/profilarr dist/build/mod.ts
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/profilarr
    install -m755 dist/build/profilarr $out/lib/profilarr/profilarr
    cp dist/build/server.js $out/lib/profilarr/server.js
    cp -r dist/build/static $out/lib/profilarr/static

    plug=$out/lib/profilarr/deno-dir/plug/https/github.com
    mkdir -p $plug
    install -m644 ${bcrypt} $plug/$(printf %s '${bcryptPath}' | sha256sum | cut -d' ' -f1).so
    autoPatchelf $out/lib/profilarr/deno-dir

    makeWrapper $out/lib/profilarr/profilarr $out/bin/profilarr \
      --set DENO_DIR $out/lib/profilarr/deno-dir \
      --set DENO_SQLITE_PATH ${lib.getLib sqlite}/lib/libsqlite3${stdenv.hostPlatform.extensions.sharedLibrary} \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          git
          gnutar
        ]
      }
    runHook postInstall
  '';

  meta = {
    description = "Configuration management for Radarr and Sonarr";
    homepage = "https://github.com/Dictionarry-Hub/profilarr";
    license = lib.licenses.agpl3Only;
    mainProgram = "profilarr";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
