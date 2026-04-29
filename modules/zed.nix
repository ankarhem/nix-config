{
  flake.modules.homeManager.zed = {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "angular"
        "csharp"
        "just"
        "nix"
        "opencode"
        "svelte"
      ];
      userSettings = {
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
