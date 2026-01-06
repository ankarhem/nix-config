{ inputs, config, ... }:
{
  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        _1password-cli
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
        nfs-utils
        ngrok
        nodejs_24
        pup
        ripgrep
        rm-improved
        sops
        tailscale
        tree
        uv
        wget
      ];
    };
}
