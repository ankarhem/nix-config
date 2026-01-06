{
  self,
  pkgs,
  pkgs-unstable,
  scriptPkgs,
  inputs,
  username,
  helpers,
  ...
}:
let
  spotify = pkgs.spotify.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = "https://web.archive.org/web/20251029235406/https://download.scdn.co/SpotifyARM64.dmg";
      hash = "sha256-gEZxRBT7Jo2m6pirf+CreJiMeE2mhIkpe9Mv5t0RI58=";
    };
  });
in
{
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "23.11";
  home.sessionVariables = {
    PATH = "$PATH:$GOPATH/bin";
    SOPS_AGE_KEY_FILE = "/Users/ankarhem/.config/sops/age/keys.txt";
  };

  imports = [
    ./ghostty.nix
    ./npm.nix
    inputs.nix-index-database.homeModules.nix-index
  ];

  modules.custom-scripts.enable = true;

  programs.dotnet = {
    enable = true;
    enableAzureArtifactsCredProvider = true;
  };

  programs.nix-index-database = {
    comma.enable = true;
  };
  programs.nix-index.enable = true;

  home.packages =
    (with pkgs; [
      bruno
      slack
      obsidian
    ])
    ++ (with pkgs-unstable; [
      element-desktop
    ])
    ++ (with scriptPkgs; [
      yt-sub
      summarize
    ])
    ++ [ spotify ];
  programs.nh = {
    enable = true;
    flake = "/Users/${username}/nix-config";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh.enable = true;
  programs.fish = {
    loginShellInit = ''
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

      function secret
        set output (string join . $argv[1] (date +%s) enc)
        gpg --encrypt --armor --output $output -r $KEYID $argv[1]
        and echo "$argv[1] -> $output"
      end

      function reveal
        set output (echo $argv[1] | rev | cut -c16- | rev)
        gpg --decrypt --output $output $argv[1]
        and echo "$argv[1] -> $output"
      end

      function copy-term-info
        infocmp -x | ssh $argv[1] -- tic -x -
      end
    '';
  };
  programs.zoxide = {
    enable = true;
  };
  programs.eza.enable = true;
  programs.starship = {
    enable = true;
  };

  programs.go = {
    enable = true;
    env = {
      GOPATH = ".go";
    };
  };
}
