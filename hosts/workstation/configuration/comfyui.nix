{ inputs, ... }:
{
  imports = [
    inputs.comfyui-nix.nixosModules.default
  ];
  nixpkgs.overlays = [ inputs.comfyui-nix.overlays.default ];

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://comfyui.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
