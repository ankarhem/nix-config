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

    keymaps = [
      {
        mode = "n";
        key = "<leader>q";
        action = "setloclist";
        options = {
          desc = "Open diagnostic list";
        };
      }
      # Find references for the word under your cursor.
      {
        mode = "n";
        key = "gr";
        action.__raw = "require('telescope.builtin').lsp_references";
        options = {
          desc = "Goto References";
        };
      }
      # Jump to the implementation of the word under your cursor.
      #  Useful when your language has ways of declaring types without an actual implementation.
      {
        mode = "n";
        key = "gi";
        action.__raw = "require('telescope.builtin').lsp_implementations";
        options = {
          desc = "Goto Implementation";
        };
      }
      # Jump to the definition of the word under your cursor.
      #  This is where a variable was first declared, or where a function is defined, etc.
      #  To jump back, press <C-t>.
      {
        mode = "n";
        key = "gd";
        action.__raw = "require('telescope.builtin').lsp_definitions";
        options = {
          desc = "Goto Definition";
        };
      }
      # Fuzzy find all the symbols in your current workspace.
      # Similar to document symbols, except searches over your entire project.
      {
        mode = "n";
        key = "<leader>sS";
        action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
        options = {
          desc = "Search Symbols";
        };
      }
      # Jump to the type of the word under your cursor.
      #  Useful when you're not sure what type a variable is and you want to see
      #  the definition of its *type*, not where it was *defined*.
      {
        mode = "n";
        key = "gt";
        action.__raw = "require('telescope.builtin').lsp_type_definitions";
        options = {
          desc = "Goto Type Definition";
        };
      }
      # Rename the variable under your cursor.
      #  Most Language Servers support renaming across files, etc.
      {
        key = "<leader>cr";
        action = "rename";
        options = {
          desc = "Rename Symbol";
        };
      }
      # Execute a code action, usually your cursor needs to be on top of an error
      # or a suggestion from your LSP for this to activate.
      {
        mode = [
          "n"
          "x"
        ];
        key = "<leader>ca";
        action = "code_action";
        options = {
          desc = "Code Action";
        };
      }
      # WARN: This is not Goto Definition, this is Goto Declaration.
      #  For example, in C this would take you to the header.
      {
        key = "<leader>cd";
        action = "declaration";
        options = {
          desc = "Goto Declaration";
        };
      }
    ];

    onAttach = ''
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
      ---@param client vim.lsp.Client
      ---@param method vim.lsp.protocol.Method
      ---@param bufnr? integer some lsp support methods only in specific files
      ---@return boolean
      local function client_supports_method(client, method, bufnr)
        if vim.fn.has 'nvim-0.11' == 1 then
          return client:supports_method(method, bufnr)
        else
          return client.supports_method(method, { bufnr = bufnr })
        end
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    '';
  };
}
