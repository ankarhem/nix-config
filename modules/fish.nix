{
  flake.modules.homeManager.fish =
    { pkgs, ... }:
    {
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
