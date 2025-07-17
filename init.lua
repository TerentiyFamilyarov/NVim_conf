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
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true

-- Отсутпы прокрутки
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4

-- Поиск
vim.opt.ignorecase = true
vim.opt.smartcase = true

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
      -- Тема (Catppuccin)
      {
         "catppuccin/nvim",
         name = "catppuccin",
         priority = 1,
         lazy = true
         -- config = function()
         --    vim.cmd.colorscheme("catppuccin-mocha")
         -- end,
      },
      --
      {
         "dasupradyumna/midnight.nvim",
         name = "midnight",
         priority = 2,
         lazy = false,
         config = function()
            vim.cmd.colorscheme("midnight")
         end,
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
               ensure_installed = { "clangd" }
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
                  { name = "nvim_lsp" },
                  { name = "buffer" },
                  { name = "path" },
               }),
            })
         end,
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
               "<Leader>?",
               function()
                  require("which-key").show({global = false})
               end,
               desc = "Buffer Local Keymaps (which-key)",
            },
            {
               "<Leader>e",
               function()
                  vim.keymap.set("n","<Leader>e",":NvimTreeToggle<CR>", {silent = true})
               end,
               desc = "Toggle NvimTree",
             },
             {
               "<Leader>cp",
               function()
                  vim.keymap.set('n', '<leader>cp', ':let @+ = expand("%:p")<CR>', { silent = true })
               end,
               desc = "Copy full path",
             },
             {
               "<Leader>cf",
               function()
                  vim.keymap.set('n', '<leader>cf', ':let @+ = expand("%:t")<CR>', { silent = true })
               end,
               desc = "Copy file name",
             },
             {
               "<Leader>cr",
               function()
                  vim.keymap.set('n', '<leader>cr', ':let @+ = expand("%")<CR>', { silent = true })
               end,
               desc = "Copy relative path",
             },
         },
      },
   })
