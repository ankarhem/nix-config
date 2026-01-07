_: {
  home.file.ghostty = {
    target = ".config/ghostty/config";
    text = ''
      font-size = 16
      theme = dark:Catppuccin Frappe,light:Catppuccin Latte
      shell-integration-features = ssh-terminfo,ssh-env
    '';
  };
}
