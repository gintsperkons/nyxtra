return {
  "Exafunction/windsurf.nvim",
  lazy = false,
  events = { "BufEnter" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("codeium").setup({
      autotrigger = true, -- continuous inline suggestions
      filetypes = "*",    -- enable for all filetypes
    })
  end,
}
