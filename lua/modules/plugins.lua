local fn = vim.fn
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
  { "nvim-lua/plenary.nvim", lazy = false },
  { "ellisonleao/gruvbox.nvim" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-lualine/lualine.nvim" },
  { "preservim/tagbar" },
  { "phaazon/hop.nvim" },
  { "powerman/vim-plugin-ruscmd" },
  { "tpope/vim-surround" },
  { "dense-analysis/ale" },
  { "numToStr/Comment.nvim" },
  { "tpope/vim-fugitive" },
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "saadparwaiz1/cmp_luasnip" },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("snippets.init")
    end,
  },
  { "nvie/vim-flake8" },
  { "preservim/nerdtree" },
  { "Xuyuanp/nerdtree-git-plugin" },
  { "ryanoasis/vim-devicons" },
  { "mg979/vim-visual-multi" },
  { "iamcco/markdown-preview.nvim" },
  { "puremourning/vimspector" },
  { "mbbill/undotree" },
  { "folke/neodev.nvim" },
  { "ray-x/lsp_signature.nvim" },
  { "voldikss/vim-floaterm" },
  { "airblade/vim-gitgutter" },
  { "petobens/poet-v" },
  { "aklt/plantuml-syntax" },
  { "weirongxu/plantuml-previewer.vim" },
  { "previm/previm" },
  { "tyru/open-browser.vim" },
  { "backdround/neowords.nvim" },
  { "MunifTanjim/nui.nvim" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "sindrets/diffview.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
            },
          },
        },
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown({}),
        },
      })
      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
    end,
  },
}

require("lazy").setup(plugins, {
  ui = {
    border = "rounded",
  },
})
