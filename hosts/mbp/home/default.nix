{
  self,
  library,
  pkgs,
  pkgs-unstable,
  inputs,
  username,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      openssh
      yubikey-manager
      yubikey-personalization

      age
      alejandra
      azure-cli
      bat
      bottom
      codex
      coreutils
      curl
      deno
      fd
      git
      gitleaks
      grc
      htop
      imagemagick
      jq
      k9s
      kubelogin
      mas
      mitmproxy
      newt
      ngrok
      nodejs_24
      pup
      ripgrep
      rm-improved
      sops
      tree
      uv # dependency for ddg-mcp
      wget

      obsidian
    ]
  );
}
