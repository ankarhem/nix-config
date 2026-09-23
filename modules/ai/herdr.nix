{ inputs, ... }:
let
  frappe = {
    mantle = "#292c3c";
    surface0 = "#414559";
    surface1 = "#51576d";
    overlay0 = "#737994";
    overlay1 = "#838ba7";
    subtext0 = "#a5adce";
    text = "#c6d0f5";
    mauve = "#ca9ee6";
    red = "#e78284";
    peach = "#ef9f76";
    yellow = "#e5c890";
    green = "#a6d189";
    teal = "#81c8be";
    blue = "#8caaee";
  };
  latte = {
    mantle = "#e6e9ef";
    surface0 = "#ccd0da";
    surface1 = "#bcc0cc";
    overlay0 = "#9ca0b0";
    overlay1 = "#8c8fa1";
    subtext0 = "#6c6f85";
    text = "#4c4f69";
    mauve = "#8839ef";
    red = "#d20f39";
    peach = "#fe640b";
    yellow = "#df8e1d";
    green = "#40a02b";
    teal = "#179299";
    blue = "#1e66f5";
  };
  herdrTheme = flavor: {
    inherit (flavor)
      surface0
      surface1
      overlay0
      overlay1
      text
      subtext0
      mauve
      red
      peach
      yellow
      green
      teal
      blue
      ;
    accent = flavor.blue;
    panel_bg = flavor.mantle;
    sidebar_bg = flavor.mantle;
    active_row_bg = flavor.surface0;
    surface_dim = flavor.surface0;
    selection_bg = flavor.surface1;
  };
in
{
  flake.modules.homeManager.herdr =
    { pkgs, ... }:
    {
      imports = [ "${inputs.home-manager-unstable}/modules/programs/herdr.nix" ];
      programs.herdr = {
        enable = true;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
        settings = {
          onboarding = false;
          theme = {
            auto_switch = true;
            dark_name = "catppuccin";
            light_name = "catppuccin-latte";
            custom = {
              dark = herdrTheme frappe;
              light = herdrTheme latte;
            };
          };
          ui.toast.delivery = "system";
        };
      };
    };
}
