{ config, ... }:
let
  nixvim = config.lib.nixvim;
in
{
  programs.nixvim.lsp = {
    inlayHints.enable = true;
    servers = {
      nil_ls.enable = true;
    };
  };
}
