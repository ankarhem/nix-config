{ inputs, ... }:
{
  flake.modules.homeManager.omp = {
    imports = [
      inputs.omp.homeManagerModules.default
    ];

    programs.omp = {
      enable = true;
    };
  };
}
