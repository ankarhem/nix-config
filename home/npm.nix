{config, ...}:{
  home.file.npmrc = {
    target = ".npmrc";
    enable = true;
    text = ''
      prefix = ''${HOME}/.npm
      init-license=MIT
      color=true
      '';
  };
  home.sessionPath = [
    "${config.xdg.dataHome}/.npm/bin"
  ];
}
