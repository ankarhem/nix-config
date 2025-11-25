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
      # nodejs_latest
      # yarn
      typescript
      # deno
      nodePackages.prettier
      # eslint_d
      # eslint
      # bun
    ];
  };
}
