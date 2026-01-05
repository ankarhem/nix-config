{ lib, config, ... }:
{
  flake.modules.homeManager.lazyvim =
    { pkgs }:
    {
      programs.lazyvim.plugins.colorscheme = lib.mkIf config.programs.lazyvim.enable ''
        return {
          {
            "LazyVim/LazyVim",
            opts = {
              colorscheme = "catppuccin",
            },
          },
          {
            "catppuccin/nvim",
            name = "catppuccin",
            opts = {
              flavour = "auto", -- latte, frappe, macchiato, mocha
              background = { -- :h background
                light = "latte",
                dark = "frappe",
              },
            },
          },
        }
      '';
    };
}
