vim.pack.add {
	'https://github.com/vague-theme/vague.nvim',
	{ src = 'https://github.com/nvim-lua/plenary.nvim' },
	{ src = 'https://github.com/nvim-telescope/telescope.nvim' },
	{
		src = 'https://github.com/ThePrimeagen/harpoon',
		version = 'harpoon2',
	},
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/mbbill/undotree" },
}

vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.scrolloff = 10
vim.o.signcolumn = "yes"
vim.o.confirm = true
vim.o.tabstop = 4

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>j", "J")
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("n", "J", "<C-d>")
vim.keymap.set("n", "K", "<C-u>")
vim.keymap.set("n", "X", "d^")

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, {
    desc = "Toggle UndoTree",
})

vim.cmd.colorscheme('vague')

local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		layout_strategy = "horizontal",
		sorting_strategy = "ascending",
	},
})

vim.keymap.set("n", "<leader>sf", builtin.find_files, {
})

vim.keymap.set("n", "<leader>sp", builtin.live_grep, {
})

vim.keymap.set("n", "<leader>sb", builtin.buffers, {
})

vim.keymap.set("n", "<leader>th", builtin.help_tags, {
})

local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "Harpoon add file" })

vim.keymap.set("n", "<leader>e", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })

vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end, { desc = "Harpoon file 1" })

vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end, { desc = "Harpoon file 2" })

vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end, { desc = "Harpoon file 3" })

vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end, { desc = "Harpoon file 4" })

vim.keymap.set("n", "<leader>ff", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format current file" })

vim.lsp.enable('pyright')
vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }

		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>sh", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<leader>sr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>nd", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<leader>pd", vim.diagnostic.goto_prev, opts)
	end,
})
