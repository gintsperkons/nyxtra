return {
  "akinsho/bufferline.nvim",
  lazy = false,
  dependencies = "nvim-tree/nvim-web-devicons",
  keys = require("Thalune.core.keymaps").bufferline,
  opts = function(_, opts)
    local ok, catppuccin = pcall(require, "catppuccin.groups.integrations.bufferline")
    if ok and catppuccin.get then
      opts.highlights = catppuccin.get()
    end
  end

}
