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
          gh
          gpg
          home-manager
          lazyvim
          nix
          norcevpn
          secrets
          sshd
          cli
        ]
        ++ (with inputs.self.modules.generic; [
          constants
        ]);

      home-manager.sharedModules = [
        inputs.self.modules.generic.constants
        inputs.self.modules.homeManager.mbp
      ];

      system.stateVersion = 5;
    };
  flake.modules.homeManager.mbp = {
    home.stateVersion = "23.11";
  };
}
