# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  modulesPath,
  config,
  pkgs,
  username,
  hostname,
  ...
}: {
  imports = [
    # Include the default lxc/lxd configuration.
    # "${modulesPath}/virtualisation/lxc-container.nix"
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    # ./modules/nfs.nix
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      trusted-users = [ "root" "@wheel" ];
      experimental-features = ["nix-command" "flakes"];
    };
  };

  proxmoxLXC = {
    manageNetwork = true;
  };
  boot.isContainer = true;
  networking.hostName = hostname; # Define your hostname.
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINyP+c89r1blDaX3MI8kxqFlRsUquGmI9qWMOyo9n5oV ankarhem@ankarhem"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFnDqR5H4mLaZ97/fKkNqNn6SfRk2HcTvQkdDGt39DcCAAAAC3NzaDpTU0ggS2V5 ankarhem@ankarhem"
    ];
  };
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vim
    git
    wget
    curl
    dig
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  environment.variables.EDITOR = "nvim";

  system.stateVersion = "24.05"; # Did you read the comment?
}
