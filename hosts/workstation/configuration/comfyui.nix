{ inputs, ... }:
{
  imports = [
    inputs.comfyui-nix.nixosModules.default
  ];
  nixpkgs.overlays = [ inputs.comfyui-nix.overlays.default ];

  nix.settings = {
    substituters = [
      "https://comfyui.cachix.org"
    ];
    trusted-public-keys = [
      "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
    ];
  };

  services.comfyui = {
    enable = true;
    cuda = true; # Enable NVIDIA GPU acceleration (recommended for most users)
    enableManager = true; # Enable the built-in ComfyUI Manager
    port = 8188;
    listenAddress = "127.0.0.1"; # Use "0.0.0.0" for network access
    dataDir = "/var/lib/comfyui";
    openFirewall = false;
    # extraArgs = [ "--lowvram" ];
    # environment = { };
  };
}
