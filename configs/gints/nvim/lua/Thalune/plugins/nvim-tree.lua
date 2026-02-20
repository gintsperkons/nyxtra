return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      view = {
        float = {
          enable = true,
          open_win_config = function()
            return {
              relative = "editor",
              border = "rounded",
              width = math.floor(vim.o.columns * 0.5),
              height = math.floor(vim.o.lines * 0.6),
              row = math.floor(vim.o.lines * 0.2),
              col = math.floor(vim.o.columns * 0.25),
            }
          end,
        },
        width = 30, -- ignored when float is enabled
      },
      renderer = {
        highlight_opened_files = "name",
        highlight_git = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    }

    -- Keymap to toggle nvim-tree
    vim.keymap.set("n", "<leader>-", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
  end,
}


