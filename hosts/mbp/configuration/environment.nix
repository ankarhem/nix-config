{ pkgs, ... }:
{
  environment = {
    pathsToLink = [ "/Applications" ]; # why is this here?
  };
  environment.variables = {
    LESS = "-r";
  };
}
