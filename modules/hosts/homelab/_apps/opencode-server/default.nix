{
  config,
  inputs,
  pkgs,
  ...
}:
let
  deps =
    with pkgs;
    let
      dotnet = dotnetCorePackages.combinePackages [
        pkgs.dotnet-sdk_8
        pkgs.dotnet-sdk_9
        pkgs.dotnet-sdk_10
      ];
    in
    [
      _unstable.rtk
      bash
      bat
      bottom
      coreutils
      curl
      deno
      dig
      dotnet
      fd
      gh
      git
      gitleaks
      grc
      htop
      jira-cli-go
      jq
      local.clone_org
      nix
      nodejs_24
      openssh
      pup
      python3
      ripgrep
      strace
      tree
      uv
      wget
    ]
    ++ [
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser
      inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ck
    ];
in
{
  imports = [
    ./module.nix
  ];

  sops.secrets."happier/master_secret" = { };
  sops.templates."happier-server.env".content = ''
    OPENCODE_SERVER_PASSWORD=${config.sops.placeholder."happier/master_secret"}
  '';

  services.opencode-server = {
    enable = true;
    user = "idealpink"; # refactor to a dedicated user later
    environmentFiles = [ config.sops.templates."happier-server.env".path ];
    workingDir = "/home/idealpink/repos";
    domain = "https://opencode.internal.internetfeno.men";
    runtimeDependencies = deps;
  };

  services.nginx.virtualHosts."opencode.internal.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      extraConfig = ''
        proxy_buffering off;
        proxy_cache off;
        proxy_read_timeout 3600;
        proxy_send_timeout 3600;
        proxy_connect_timeout 60;
        proxy_hide_header Content-Security-Policy;
        add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-eval' 'wasm-unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; media-src 'self' data:; connect-src 'self' data: https://opencode.internal.internetfeno.men https://opencode.ai;" always;
      '';
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:${toString config.services.opencode-server.port}";
    };
  };
}
