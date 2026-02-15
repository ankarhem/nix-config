{ inputs, ... }:
let
  sharedModule =
    { pkgs, ... }:
    {
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
      home-manager.sharedModules = [
        inputs.self.modules.homeManager.cli
      ];
    };
in
{
  flake.modules.nixos.cli =
    { pkgs, ... }:
    {
      imports = [ sharedModule ];
      environment.systemPackages = with pkgs; [ wl-clipboard ];
      environment.shellAliases = {
        pbcopy = "wl-copy";
        pbpaste = "wl-paste";
      };
    };
  flake.modules.darwin.cli = {
    imports = [ sharedModule ];
  };
  flake.modules.homeManager.cli =
    { lib, pkgs, ... }:
    {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
      ];

      programs.starship = {
        enable = true;
      };
      programs.nh = {
        enable = true;
        flake = "$HOME/nix-config/";
        clean.enable = true;
      };
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.nix-index-database = {
        comma.enable = true;
      };
      programs.nix-index.enable = true;
      programs.zoxide.enable = true;
      programs.eza.enable = true;
      home.packages =
        with pkgs;
        [
          _1password-cli
          age
          alejandra
          bat
          bottom
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
          newt
          ngrok
          nodejs_24
          pup
          ripgrep
          rm-improved
          # scriptPkgs.summarize
          # scriptPkgs.yt-sub
          sops
          tailscale
          tree
          uv
          vim
          wget
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [ nfs-utils ];
    };
}
