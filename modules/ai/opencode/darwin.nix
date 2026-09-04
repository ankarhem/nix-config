{ ... }:
{
  flake.modules.darwin.opencode-desktop = {
    # OPENCODE_SIDECAR_V2=1 makes the OpenCode desktop app spawn its bundled v2
    # server sidecar instead of v1. Set session-wide via launchctl because
    # Finder/Spotlight-launched apps do not inherit shell environment variables.
    launchd.user.agents.opencode-desktop-v2-sidecar = {
      serviceConfig = {
        ProgramArguments = [
          "/bin/launchctl"
          "setenv"
          "OPENCODE_SIDECAR_V2"
          "1"
        ];
        RunAtLoad = true;
      };
    };
  };
}
