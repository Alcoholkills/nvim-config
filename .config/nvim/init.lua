vim.g.mapleader = " "
vim.cmd("set number")
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.wo.relativenumber = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig',dependencies = {
        {'hrsh7th/cmp-nvim-lsp'},
    }},
    {'hrsh7th/nvim-cmp', dependencies = {
        {'L3MON4D3/LuaSnip'}
    },},
    {
        'linux-cultist/venv-selector.nvim',
        dependencies = { 'neovim/nvim-lspconfig', 'nvim-telescope/telescope.nvim', 'mfussenegger/nvim-dap-python' },
        config = function()
            require('venv-selector').setup {
                -- Your options go here
                name = {"venv", ".venv"},
                auto_refresh = false
            }
        end,
        event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
        keys = {
            -- Keymap to open VenvSelector to pick a venv.
            { '<leader>vs', '<cmd>VenvSelect<cr>' },
            -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
            { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
        },
    }
}
local opts = {}

-- Lazy ; package manager
require("lazy").setup(plugins, opts)

-- Catppuccin ; color scheme
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

-- Telescope ; file finder
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

local configs = require("nvim-treesitter.configs")
configs.setup({
    ensure_installed = { "c",
        "cpp",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "elixir",
        "heex",
        "javascript",
        "html",
        "rust",
        "javascript",
        "typescript",
        "css",
        "python",
    },
    highlight = { enable = true },
    indent = { enable = true },  
})

-- LSP ; recommendation while typing
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
end)

require'lspconfig'.lua_ls.setup({})
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.tsserver.setup({})
require'lspconfig'.pylsp.setup({})
require'lspconfig'.clangd.setup({})

lsp_zero.setup_servers({'lua_ls', 'rust_analyzer', 'tsserver', 'pylsp'})
