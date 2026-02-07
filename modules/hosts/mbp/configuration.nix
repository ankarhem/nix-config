{
  inputs,
  ...
}:
{
  flake.modules.darwin.mbp =
    { config, ... }:
    {
      nixpkgs.config = {
        allowUnfree = true;
      };
      imports =
        with inputs.self.modules.darwin;
        [
          ai
          fish
          chat
          colemak
          firefox
          norcevpn
          home-manager
        ]
        ++ (with inputs.self.modules.generic; [
          constants
        ]);

      home-manager.sharedModules = [
        inputs.self.modules.generic.constants
      ];

      # backwards compat; don't change
      system.stateVersion = 5;
    };
}
