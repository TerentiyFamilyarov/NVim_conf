-- =============================================
-- Настройки NeoWim
-- =============================================

-- Установка <Leader> (пробел)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Буфер обмена
vim.g.clipboard = {
  name = 'wl-clipboard',
  copy = {
    ["+"] = 'wl-copy --foreground --type text/plain',
    ["*"] = 'wl-copy --foreground --primary --type text/plain'
  },
  paste = {
    ["+"] = 'wl-paste --no-newline',
    ["*"] = 'wl-paste --no-newline --primary'
  },
  cache_enabled = true
}

-- Относительная нумерация + обычная
vim.opt.number = true
vim.opt.relativenumber = true

-- Подсветка синтаксиса
vim.opt.syntax = on

-- Табы и отступы
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Отсутпы прокрутки
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4

-- Поиск
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Дефолт тема
vim.cmd.colorscheme("retrobox")


-- =============================================
-- Плагины (через lazy.nvim)
-- =============================================

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
require("lazy").setup({
   -- Тема onedarkpro
   {
      "olimorris/onedarkpro.nvim",
       name = "onedarkpro"
   },
   -- Комментарии
   {
      "numToStr/Comment.nvim",
      config = function()
         require("Comment").setup()
      end,
   },
   -- Файловый менеджер (nvim-tree)
   {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
         require("nvim-tree").setup()
            vim.keymap.set("n", "<Leader>e", ":NvimTreeToggle<CR>", { silent = true })
      end,
   },
   -- Подсветка синтаксиса (tree-sitter)
   {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
         require("nvim-treesitter.configs").setup({
            ensure_installed = { "python", "javascript", "lua", "json", "cpp" },
            highlight = { enable = true },
         })
      end,
   },
   -- LSP сервер
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         "williamboman/mason.nvim",
         "williamboman/mason-lspconfig.nvim",
      },
   },
   -- Mason для управления LSP
   {
      "williamboman/mason.nvim",
      dependencies = {
         "williamboman/mason-lspconfig.nvim",
      },
      config = function()
         require("mason").setup()
         require("mason-lspconfig").setup({
            ensure_installed = { "clangd", "pylsp" }
         })
      end,
   },
   -- Автодополнение (nvim-cmp)
   {
      "hrsh7th/nvim-cmp",
      dependencies = {
         "hrsh7th/cmp-nvim-lsp",  -- LSP-источник
         "hrsh7th/cmp-buffer",    -- Дополнение из буфера
         "hrsh7th/cmp-path",      -- Дополнение путей
      },
      config = function()
         local cmp = require("cmp")
         cmp.setup({
            mapping = cmp.mapping.preset.insert({
               ["<C-Space>"] = cmp.mapping.complete(),
               ["<Tab>"] = cmp.mapping.confirm({ select = true }),
               ["<CR>"] = cmp.mapping.confirm({select = true}),
               ["<Esc>"] = cmp.mapping.abort(),
            }),
            sources = cmp.config.sources({
               { name = "nvim_lsp"},
               { name = "buffer" },
               { name = "path" },
            }),
         })
      end,
   },
   -- Инфа об затупах Trouble
   {
     "folke/trouble.nvim",
     opts = {}, -- for default options, refer to the configuration section for custom setup.
     cmd = "Trouble",
     keys = {},
   },
-- =============================================
-- Горячие клавиши
-- =============================================
   -- Запоминалка кеймапов
   {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
             --your  config here
      },
      keys = {
         {
            "<Leader>e",
            "<cmd>NvimTreeToggle<cr>",
            desc = "Toggle NvimTree",
          },
          {
            "<Leader>cp",
            '<cmd>let @+ = expand("%:p")<cr>',
            desc = "Copy full path",
          },
          {
            "<Leader>cf",
            '<cmd>let @+ = expand("%:t")<cr>',
            desc = "Copy file name",
          },
          {
            "<Leader>cr",
            '<cmd>let @+ = expand("%")<cr>',
            desc = "Copy relative path",
          },
          {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
          },
          {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
          },
          {
            "<leader>cs",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
          },
          {
            "<leader>cl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
          },
          {
            "<leader>xL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
          },
          {
            "<leader>xQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
          },
      },
   },
})
