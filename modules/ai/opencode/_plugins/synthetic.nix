_: {
  programs.opencode.settings = {
    provider = {
      synthetic = {
        models = {
          "syn:large:text" = {
            name = "Large Text";
          };
          "syn:small:text" = {
            name = "Small text";
          };
          "syn:large:vision" = {
            name = "Large Vision";
          };
          "syn:small:vision" = {
            name = "Small vision";
          };
        };
      };
    };
  };
}
