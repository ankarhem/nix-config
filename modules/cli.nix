{ inputs, config, ... }:
let
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

  flake.modules.nixos.cli = { inherit environment; };
  flake.modules.darwin.cli = { inherit environment; };
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
        sops
        tailscale
        tree
        uv
        wget
      ];
    };
in
{
  inherit flake;
}
