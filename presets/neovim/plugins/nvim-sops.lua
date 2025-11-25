return {
	{
		"lucidph3nx/nvim-sops",
		event = { "BufEnter" },
		keys = {
			{ "<leader>fse", vim.cmd.SopsEncrypt, desc = "[S]ops [E]ncrypt" },
			{ "<leader>fsd", vim.cmd.SopsDecrypt, desc = "[S]ops [D]ecrypt" },
		},
		opts = {
			-- enabled = true,
			-- debug = false,
			-- binPath = 'sops',
			defaults = {
				-- awsProfile = 'AWS_PROFILE',
				-- ageKeyFile = 'SOPS_AGE_KEY_FILE',
				-- gcpCredentialsFile = 'GOOGLE_APPLICATION_CREDENTIALS',
			},
		},
	},
}
