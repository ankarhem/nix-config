{ lib, pkgs, ... }:
let
  grammarPlugins = builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins;
  grammarPackages = builtins.attrValues pkgs.tree-sitter-grammars;
  filterNonPackage = builtins.filter lib.isDerivation;
  filterBroken = builtins.filter (n: !n.meta.broken);
  filterEmpty = builtins.filter (n: n.pname or "" != "");
  allGrammarPlugins = filterEmpty (filterBroken (filterNonPackage grammarPlugins));
  allGrammarPackages = filterEmpty (filterBroken (filterNonPackage grammarPackages));
in
{
  imports = [
    ./docker.nix
    ./dotnet.nix
    ./git.nix
    ./json.nix
    ./markdown.nix
    ./nix.nix
    ./rust.nix
    ./svelte.nix
    ./tailwind.nix
    ./toml.nix
    ./typescript.nix
    ./yaml.nix
  ];

  programs.lazyvim.extraPackages =
    with pkgs;
    [
      tree-sitter
    ]
    ++ allGrammarPlugins
    ++ allGrammarPackages;
}
