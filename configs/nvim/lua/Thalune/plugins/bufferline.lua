return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = function(_, opts)
    local ok, catppuccin = pcall(require, "catppuccin.groups.integrations.bufferline")
    if ok and catppuccin.get then
      opts.highlights = catppuccin.get()
    end
  end

}
