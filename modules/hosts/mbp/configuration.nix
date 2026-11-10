{
  inputs,
  ...
}:
{
  flake.modules.darwin.mbp =
    { ... }:
    {
      imports =
        with inputs.self.modules.darwin;
        [
          ai
          ankarhem
          attic-client
          auto-upgrade
          chat
          cli
          colemak
          dev-tools
          firefox
          fish
          fonts
          general
          gh
          gpg
          home-manager
          homebrew
          launcher
          lazyvim
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

      # Disable mouse acceleration (linear movement)
      system.defaults.CustomUserPreferences.NSGlobalDomain."com.apple.mouse.linear" = true;

      system.stateVersion = 5;
    };
  flake.modules.homeManager.mbp = {
    home.stateVersion = "23.11";
  };
}
