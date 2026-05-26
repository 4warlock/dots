-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Basic settings
vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Keymaps
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- tmux-sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<M-j>", "<cmd>silent !tmux-sessionizer $HOME/java<CR><CR>")
vim.keymap.set("n", "<M-k>", "<cmd>silent !tmux-sessionizer $HOME/python<CR><CR>")
vim.keymap.set("n", "<M-l>", "<cmd>silent !tmux-sessionizer $HOME/notes/fysik/<CR><CR>")
vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux-sessionizer $HOME<CR><CR>")
vim.keymap.set("n", "<M-c>", "<cmd>silent !tmux-sessionizer $HOME/.config<CR><CR>")

-- Plugins
require("lazy").setup({
  -- Theme
  {
    "RRethy/base16-nvim",
    priority = 1000,
    config = function()
      require("base16-colorscheme").setup({
        base00 = "#000000",
        base01 = "#121212",
        base02 = "#222222",
        base03 = "#333333",
        base04 = "#999999",
        base05 = "#c1c1c1",
        base06 = "#999999",
        base07 = "#c1c1c1",
        base08 = "#5f8787",
        base09 = "#aaaaaa",
        base0A = "#a06666",
        base0B = "#dd9999",
        base0C = "#aaaaaa",
        base0D = "#888888",
        base0E = "#999999",
        base0F = "#444444",
      })

      -- Transparency
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
    end,
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
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
      end)

      vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
      end)

      vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
      end)

      vim.keymap.set("n", "<leader>4", function()
        harpoon:list():select(4)
      end)
    end,
  },

  -- Oil
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
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

      vim.keymap.set(
        "n",
        "<leader>o",
        "<cmd>lua require('oil').toggle_float()<CR>",
        { desc = "[O]pen Oil" }
      )
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",
        },
      })

      pcall(function()
        telescope.load_extension("fzf")
      end)

      vim.keymap.set("n", "<leader>sf", builtin.find_files, {
        desc = "Project files",
      })

      vim.keymap.set("n", "<leader>sp", builtin.live_grep, {
        desc = "Search project",
      })

      vim.keymap.set("n", "<leader>sb", builtin.buffers, {
        desc = "Buffers",
      })

      vim.keymap.set("n", "<leader>sh", builtin.help_tags, {
        desc = "Help",
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),

        sources = {
          { name = "nvim_lsp" },
        },
      })
    end,
  },

  -- Mason + LSP
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "lua_ls",
          "rust_analyzer",
        },
      })

      -- Pyright
      vim.lsp.config("pyright", {
        capabilities = capabilities,
      })

      -- Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
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

      -- Rust
      vim.lsp.config("rust_analyzer", {
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      })

      -- Enable servers
      vim.lsp.enable("pyright")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("rust_analyzer")
    end,
  },
})
