{ pkgs, username, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
  };
  # https://nixos.wiki/wiki/Gamemode#Steam
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    lutris
    protonup-qt # Manage Proton versions
  ];

  home-manager.users.${username} = {
    programs.mangohud = {
      enable = true;
      enableSessionWide = false;

      settings = {
        no_display = true;
        toggle_hud = "Shift_R+F12";
        toggle_fps_limit = "Shift_R+F1";
        reload_cfg = "Shift_R+F4";

        fps = true;
        show_fps_limit = true;
        frametime = true;
        frame_timing = 1;
        present_mode = true;
        histogram = true;
        ram = true;
        fps_limit = [
          240
          120
          0
        ];
        gl_vsync = -1;
        vsync = 1;

        cpu_stats = true;
        cpu_temp = true;
        cpu_power = true;
        cpu_text = "CPU";
        cpu_mhz = true;

        throttling_status = true;
        gpu_stats = true;
        gpu_temp = true;
        gpu_core_clock = true;
        gpu_mem_clock = true;
        gpu_power = true;
        gpu_text = "GPU";
        vram = true;

        position = "top-left";
        font_size = 32;
        round_corners = 8;
      };
    };
  };
}
