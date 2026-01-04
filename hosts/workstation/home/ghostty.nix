_: {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      font-size = 12;
      theme = "dark:Catppuccin Frappe,light:Catppuccin Latte";
      shell-integration-features = "ssh-terminfo,ssh-env";
    };
  };
}
