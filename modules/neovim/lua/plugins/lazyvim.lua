return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-latte",
		},
	},

	-- Languages
	{ import = "lazyvim.plugins.extras.vscode" },
	{ import = "lazyvim.plugins.extras.lang.angular" },
	{ import = "lazyvim.plugins.extras.lang.git" },
	-- { import = "lazyvim.plugins.extras.lang.go" },
	{ import = "lazyvim.plugins.extras.lang.json" },
	-- { import = "lazyvim.plugins.extras.lang.markdown" },
	{ import = "lazyvim.plugins.extras.lang.nix" },
	{ import = "lazyvim.plugins.extras.lang.omnisharp" },
	-- { import = "lazyvim.plugins.extras.lang.rust" },
	-- { import = "lazyvim.plugins.extras.lang.svelte" },
	{ import = "lazyvim.plugins.extras.lang.tailwind" },
	{ import = "lazyvim.plugins.extras.lang.toml" },
	{ import = "lazyvim.plugins.extras.lang.typescript" },
	{ import = "lazyvim.plugins.extras.lang.yaml" },
	-- Linting
	{ import = "lazyvim.plugins.extras.linting.eslint" },
	-- Lsp
	{ import = "lazyvim.plugins.extras.lsp.none-ls" },
	{ import = "lazyvim.plugins.extras.ai.copilot" },
	-- Test
	{ import = "lazyvim.plugins.extras.test.core" },
}
