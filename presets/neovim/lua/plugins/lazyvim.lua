return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
		},
	},
	{
		"folke/snacks.nvim",
		opts = {
			scroll = { enabled = false },
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "auto", -- latte, frappe, macchiato, mocha
			background = { -- :h background
				light = "latte",
				dark = "frappe",
			},
		},
	},
	{
		"mtrajano/tssorter.nvim",
		version = "*", -- latest stable version, use `main` to keep up with the latest changes
		opts = {
			-- leave empty for the default config or define your own sortables in here. They will add, rather than
			-- replace, the defaults for the given filetype
		},
	},
}
