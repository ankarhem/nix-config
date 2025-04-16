return {
	-- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = {}
		end,
	},
}
