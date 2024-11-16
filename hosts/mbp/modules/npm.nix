{config, ...}:{
  home.file.npmrc = {
    target = ".npmrc";
    enable = true;
    text = ''
      prefix = ${config.xdg.dataHome}/npm
      init-license=MIT
      color=true
      '';
  };
  home.sessionPath = [
    "${config.xdg.dataHome}/npm/bin"
  ];
}
