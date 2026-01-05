{ lib, config, ... }:
{
  flake.modules.homeManager.lazyvim =
    { pkgs }:
    {
      programs.lazyvim = lib.mkIf config.programs.lazyvim.enable {
        extras = {
          lang.rust = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };

        extraPackages = with pkgs; [
          bacon
          cargo
          clippy
          rust-analyzer
          rustfmt
          rustup
        ];
      };
    };
}
