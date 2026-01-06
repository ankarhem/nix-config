{ lib, ... }:
{
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
}
