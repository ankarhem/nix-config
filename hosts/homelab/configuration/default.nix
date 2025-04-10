# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ modulesPath, pkgs, username, hostname, helpers, ... }: {
  imports = [
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    ./apps/default.nix
    ./sops.nix
    ./tailscale.nix
    ./fail2ban.nix
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  programs.nh = {
    enable = true;
    flake = "/home/${username}/nix-config/";
    clean.enable = true;
  };

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.publish = {
    enable = true;
    addresses = true;
  };

  proxmoxLXC = { manageNetwork = true; };
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
    extraGroups = [ "networkmanager" "wheel" "podman" "docker" ];
    packages = [ ];
    openssh.authorizedKeys.keys = helpers.ssh.getGithubKeys ({
      username = "ankarhem";
      sha256 = "1kjsr54h01453ykm04df55pa3sxj2vrmkwb1p8fzgw5hzfzh3lg0";
    });
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
