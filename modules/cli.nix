{ inputs, config, ... }:
let
  username = "ankarhem";
  environment = {
    systemPackages = with pkgs; [ coreutils ];
    shells = with pkgs; [
      bash
      zsh
      fish
    ];
    shellAliases = {
      ls = "eza --color=auto -F";
    };
  };
  programs = {
    bash.enable = true;
    zsh.enable = true;
    fish.enable = true;
  };

  flake.modules.nixos.cli =
    { pkgs, ... }:
    {
      inherit environment programs;
      environment.systemPackages = with pkgs; [ wl-clipboard ];
      environment.shellAliases = {
        pbcopy = "wl-copy";
        pbpaste = "wl-paste";
      };
      programs.nh = {
        enable = true;
        flake = "/home/${username}/nix-config/";
        clean.enable = true;
      };
    };
  flake.modules.darwin.cli = {
    inherit environment programs;
    programs.nh = {
      enable = true;
      flake = "/Users/${username}/nix-config/";
    };
  };

  nixpkgs.overlays = [
    (
      final: prev:
      let
        scriptPkgs = inputs.scripts.packages.${prev.system};
      in
      {
        inherit scriptPkgs;
      }
    )
  ];
  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
      ];

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.nix-index-database = {
        comma.enable = true;
      };
      programs.nix-index.enable = true;

      programs.go.enable = true;
      programs.zoxide.enable = true;
      programs.eza.enable = true;
      home.packages = with pkgs; [
        _1password-cli
        age
        alejandra
        azure-cli
        bat
        bottom
        codex
        coreutils
        curl
        deno
        dig
        fd
        git
        gitleaks
        grc
        htop
        imagemagick
        jq
        k9s
        kubelogin
        mas
        mitmproxy
        newt
        nfs-utils
        ngrok
        nodejs_24
        pup
        ripgrep
        rm-improved
        scriptPkgs.summarize
        scriptPkgs.yt-sub
        sops
        tailscale
        tree
        uv
        vim
        wget
      ];
    };
in
{
  inherit flake;
}
