{
  self,
  ...
}:
{
  config.flake.factory.user =
    { username, isAdmin }:
    {
      nixos."${username}" =
        {
          lib,
          pkgs,
          ...
        }:
        {
          nix.settings = lib.mkIf isAdmin {
            trusted-users = [ username ];
            extra-trusted-users = [ username ];
          };

          users.users."${username}" = {
            isNormalUser = true;
            home = "/home/${username}";
            extraGroups = lib.optionals isAdmin [
              "wheel"
            ];
            shell = pkgs.fish;
          };
          programs.fish.enable = true;

          home-manager.users."${username}" = {
            imports = [
              self.modules.homeManager."${username}"
            ];
          };
        };

      darwin."${username}" =
        { lib, pkgs, ... }:
        {
          users.users."${username}" = {
            home = "/Users/${username}";
            shell = pkgs.fish;
          };
          programs.fish.enable = true;

          home-manager.users."${username}" = {
            imports = [
              self.modules.homeManager."${username}"
            ];
          };

          system.primaryUser = lib.mkIf isAdmin "${username}";
        };

      homeManager."${username}" = {
        home.username = "${username}";
        home.homeDirectory = "/home/${username}";
      };
    };
}
