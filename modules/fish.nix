{ inputs, lib, ... }:
let
  systemModule =
    { pkgs, ... }:
    {
      programs.fish.enable = true;
      environment.shells = [
        pkgs.fish
      ];

      home-manager.sharedModules = [
        inputs.self.modules.homeManager.fish
      ];
    };
  flake.modules.nixos.fish = systemModule;
  flake.modules.darwin.fish = systemModule;
  flake.modules.homeManager.fish =
    { pkgs, ... }:
    {
      # Not sure if this is still needed but keep for now
      programs.fish.loginShellInit = lib.mkIf pkgs.stdenv.isDarwin ''
        fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin
      '';

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
          fish_vi_key_bindings # Set vi key bindings
        '';

        functions = {
          secret = ''
            set output (string join . $argv[1] (date +%s) enc)
            gpg --encrypt --armor --output $output -r $KEYID $argv[1]
            and echo "$argv[1] -> $output"
          '';
          reveal = ''
            set output (echo $argv[1] | rev | cut -c16- | rev)
            gpg --decrypt --output $output $argv[1]
            and echo "$argv[1] -> $output"
          '';
          copy-term-info = ''
            infocmp -x | ssh $argv[1] -- tic -x -
          '';
          backup = ''
            cp $argv[1] $argv[1].bak
          '';
        };

        plugins =
          with pkgs.fishPlugins;
          map
            (pkg: {
              name = pkg.pname;
              inherit (pkg) src;
            })
            [
              bang-bang
              fzf-fish
              git-abbr
              grc
              colored-man-pages
            ];
      };
      programs.fzf.enable = true;
    };
in
{
  inherit flake;
}
