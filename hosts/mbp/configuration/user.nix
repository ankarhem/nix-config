{
  pkgs,
  username,
  hostname,
  ...
}:
{
  networking.hostName = hostname;
  networking.computerName = hostname;

  system.primaryUser = username;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
    shell = pkgs.fish;
  };

  nix.settings.trusted-users = [ username ];
  nix.settings.extra-trusted-users = [ username ];
}
