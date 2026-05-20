-- Keybinds 
vim.g.mapleader = " "
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')

-- Special settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

-- Quick jumps to specific directories
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')
vim.keymap.set('n', '<M-j>', '<cmd>silent !tmux-sessionizer $HOME/java<CR><CR>')
vim.keymap.set('n', '<M-k>', '<cmd>silent !tmux-sessionizer $HOME/python<CR><CR>')
vim.keymap.set('n', '<M-l>', '<cmd>silent !tmux-sessionizer $HOME/notes/fysik/<CR><CR>')
vim.keymap.set('n', '<M-h>', '<cmd>silent !tmux-sessionizer $HOME<CR><CR>')
vim.keymap.set('n', '<M-c>', '<cmd>silent !tmux-sessionizer $HOME/.config<CR><CR>')

-- Make yanks go to system clipboard 
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Setup base16 theme
require('base16-colorscheme').setup({
  base00 = '#000000',
  base01 = '#121212',
  base02 = '#222222',
  base03 = '#333333',
  base04 = '#999999',
  base05 = '#c1c1c1',
  base06 = '#999999',
  base07 = '#c1c1c1',
  base08 = '#5f8787',
  base09 = '#aaaaaa',
  base0A = '#a06666',
  base0B = '#dd9999',
  base0C = '#aaaaaa',
  base0D = '#888888',
  base0E = '#999999',
  base0F = '#444444',
})

-- Transparency tweaks
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })

-- Harpoon setup
local harpoon = require("harpoon")

harpoon:setup()

-- Harpoon binds
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

-- Oil setup
require("oil").setup({
  float = {
    padding = 2,
    max_width = 65,
    max_height = 25,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
  },
})

-- Oil binds
vim.keymap.set(
  "n",
  "<leader>o",
 "<cmd>lua require('oil').toggle_float()<CR>",
  { desc = "[O]pen Oil" }
)

-- Telescope setup
local telescope = require("telescope")
local builtin = require("telescope.builtin")

-- Telescope binds
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Project files" })
vim.keymap.set("n", "<leader>sp", builtin.live_grep, { desc = "Search project" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })

telescope.setup({
  defaults = {
    layout_strategy = "horizontal",
    sorting_strategy = "ascending",
  },
})

-- Load the fzf extension
pcall(function()
  telescope.load_extension("fzf")
end)

local cmp = require("cmp")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),

  sources = {
    { name = "nvim_lsp" },
  },
})

-- LSP setup
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Pyright Lsp
vim.lsp.config("pyright", {
  capabilities = capabilities,
})

vim.lsp.enable("pyright")

-- Lua Lsp 
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.enable("lua_ls")

-- Rust lsp
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.enable("rust_analyzer")
