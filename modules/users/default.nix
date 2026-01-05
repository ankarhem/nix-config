# Users module - defines user attributes used across configurations
{ lib, ... }:
{
  options.users = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Username";
            };
            description = lib.mkOption {
              type = lib.types.str;
              description = "Full name/description";
            };
            githubUsername = lib.mkOption {
              type = lib.types.str;
              description = "GitHub username for SSH keys";
            };
            githubKeysSha256 = lib.mkOption {
              type = lib.types.str;
              description = "SHA256 of GitHub keys fetch";
            };
          };
        }
      )
    );
    default = { };
    description = "User definitions";
  };

  config.users = {
    idealpink = {
      name = "idealpink";
      description = "Jakob Ankarhem";
      githubUsername = "ankarhem";
      githubKeysSha256 = "1i0zyn1jbndfi8hqwwhmbn3b6akbibxkjlwrrg7w2988gs9c96gi";
    };
    ankarhem = {
      name = "ankarhem";
      description = "Jakob Ankarhem";
      githubUsername = "ankarhem";
      githubKeysSha256 = "1i0zyn1jbndfi8hqwwhmbn3b6akbibxkjlwrrg7w2988gs9c96gi";
    };
  };
}
