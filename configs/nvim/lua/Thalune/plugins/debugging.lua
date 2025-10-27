return {
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"nvim-dap",
		},
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			require("dapui").setup()

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.cpp = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
			vim.keymap.set("n", "<F5>", function()
				dap.continue()
			end)
			vim.keymap.set("n", "<F10>", function()
				dap.step_over()
			end)
			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end)
			vim.keymap.set("n", "<F12>", function()
				dap.step_out()
			end)
			vim.keymap.set("n", "<Leader>b", function()
				dap.toggle_breakpoint()
			end)
			--   vim.keymap.set("n", "<Leader>B", function()
			--     dap.set_breakpoint()
			--   end)
			--   vim.keymap.set("n", "<Leader>lp", function()
			--     dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			--   end)
			vim.keymap.set("n", "<Leader>dr", function()
				dap.repl.open()
			end)
			vim.keymap.set("n", "<Leader>dl", function()
				dap.run_last()
			end)
			--   vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
			--     require("dap.ui.widgets").hover()
			--   end)
			--   vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
			--     require("dap.ui.widgets").preview()
			--   end)
			--   vim.keymap.set("n", "<Leader>df", function()
			--     local widgets = require("dap.ui.widgets")
			--     widgets.centered_float(widgets.frames)
			--   end)
			--   vim.keymap.set("n", "<Leader>ds", function()
			--     local widgets = require("dap.ui.widgets")
			--     widgets.centered_float(widgets.scopes)
			--   end)
		end,
	},
}
