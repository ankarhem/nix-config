_: {
  home.file.ghostty = {
    target = ".config/ghostty/config";
    text = ''
      font-size = 16
      theme = dark:catppuccin-frappe,light:catppuccin-latte
      shell-integration-features = ssh-terminfo,ssh-env
    '';
  };
}
