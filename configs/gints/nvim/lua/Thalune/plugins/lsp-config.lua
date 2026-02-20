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
          "lua_ls",        -- Lua
          "clangd",        -- C / C++
          "ts_ls",      -- JS / TS
          "vue_ls",         -- Vue SFC support
          "html",         -- HTML
          "cssls",       -- CSS / SCSS
          "intelephense",  -- PHP
        },
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "clang-format",        -- C / C++
        "ruff",                -- Python
        "stylua",              -- Lua
        "black",               -- Python
        "cpplint",             -- C / C++
        "codelldb",            -- C / C++
        "prettier",            -- JS / TS / CSS / HTML  
        "vue-language-server", -- Vue SFC support
        "intelephense",        -- PHP
      },
      auto_update = true,
      run_on_start = true,
    },
    dependencies = { "williamboman/mason.nvim" },
  },
  {
      "neovim/nvim-lspconfig",
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Auto-start all LSPs that Mason installs
        local servers = {
          lua_ls = {},
          clangd = {
            cmd = { "clangd", "--compile-commands-dir=." },
          },
          vue_ls = {
            filetypes = { "vue", "typescript", "javascript", "javascriptreact", "typescriptreact" },
          },
          tsserver = {
            on_attach = function(client)
              client.server_capabilities.documentFormattingProvider = false -- use prettier instead
            end,
          },
          html = {},
          cssls = {},
          intelephense = {},
        }

        for name, override in pairs(servers) do
          local base = vim.lsp.config[name]
          if base then
            vim.lsp.start(vim.tbl_deep_extend("force", base, {
              capabilities = capabilities,
              settings = override.settings,
              cmd = override.cmd or base.cmd,
              filetypes = override.filetypes or base.filetypes,
              root_dir = override.root_dir or base.root_dir,
              on_attach = override.on_attach or nil,
            }))
          end
        end

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
