{
  flake.modules.homeManager.zed = {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "angular"
        "csharp"
        "just"
        "nix"
        "svelte"
      ];
      userSettings = {
        agent_servers = {
          OpenCode = {
            type = "custom";
            command = "opencode";
            args = [ "acp" ];
          };
        };
        agent = {
          always_allow_tool_actions = true;
          model_parameters = [ ];
        };
        theme = "One Dark";
        session.trust_all_worktrees = true;
        vim_mode = true;
        base_keymap = "VSCode";
      };
    };
  };
}
