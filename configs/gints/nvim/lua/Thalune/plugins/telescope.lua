return {
  {
    'nvim-telescope/telescope.nvim',
    lazy=false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function()
      local builtin = require('telescope.builtin')
      require('telescope').load_extension('file_browser')
      vim.keymap.set('n', '<leader>fe', function()
        require('telescope').extensions.file_browser.file_browser({
          select_buffer = true,
          path = "%:p:h",    -- start in current file's directory
          hidden = true,     -- show hidden files (dotfiles)
          grouped = true,    -- groups files and folders separately (optional)
          previewer = true, -- optionally disable previewer for speed
        })
      end)
      vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function ()
      require('telescope').setup({
        extension = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {

            }
          }
        }
      })
      require("telescope").load_extension('ui-select')
    end
  }
}
