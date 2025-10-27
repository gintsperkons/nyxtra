return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
        },
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "clang-format",
        "ruff",
        "stylua",
        "black",
        "cpplint",
        "codelldb",
        "prettier"
      },
      auto_update = true,
      run_on_start = true,
    },
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = { "clangd", "--compile-commands-dir=." },
      })

      -- vim.diagnostic.config({
      --   virtual_text = {
      --     prefix = "●", -- Could be ">>", "●", "", or even an emoji
      --     spacing = 2,
      --   },
      --   signs = true,             -- Show sign column symbols (e.g. ❌ on the left)
      --   underline = true,         -- Underline the text with problems
      --   update_in_insert = false, -- Don’t update while typing (optional)
      --   severity_sort = true,
      -- })
      --
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
      vim.keymap.set("", "<leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
    end,
  },
}
