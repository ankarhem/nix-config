{
  inputs,
  ...
}:
{
  flake.modules.darwin.mbp =
    { config, ... }:
    {
      imports =
        with inputs.self.modules.darwin;
        [
          ai
          ankarhem
          chat
          colemak
          dev-tools
          firefox
          fish
          home-manager
          nix
          norcevpn
          secrets
          sshd
        ]
        ++ (with inputs.self.modules.generic; [
          constants
        ]);

      home-manager.sharedModules = [
        inputs.self.modules.generic.constants
        inputs.self.modules.homeManager.mbp
      ];

      # backwards compat; don't change
      system.stateVersion = 5;
    };
  flake.modules.homeManager.mbp = {
    home.stateVersion = "23.11";
  };
}
