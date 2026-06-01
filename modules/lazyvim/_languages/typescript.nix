{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.typescript = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      vtsls
      typescript
      prettier
      tailwindcss
      # eslint_d
      # eslint
    ];
  };
}
