return {
	-- {
	--   "EdenEast/nightfox.nvim",
	--   priority = 1000, -- Load first
	--
	--   init = function()
	--     vim.cmd("colorscheme carbonfox")
	--   end,
	-- },
	{
		"catppuccin/nvim",
		priority = 1000,

		init = function()
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
}
