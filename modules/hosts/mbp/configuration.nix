{
  inputs,
  ...
}:
{
  flake.modules.darwin.mbp =
    { config, ... }:
    {
      imports = with inputs.self.modules.darwin; [
        ai
        fish
        chat
      ];
    };
}
