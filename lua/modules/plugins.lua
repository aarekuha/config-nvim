local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
    use { "wbthomason/packer.nvim" }
    use { "ellisonleao/gruvbox.nvim" }
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }  -- расширенная подсветка синтаксиса
    use { 'nvim-telescope/telescope.nvim', requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'BurntSushi/ripgrep' }
        }
    }  -- замена fzf, ack и многих еще =)
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'nvim-lua/completion-nvim'
    use 'preservim/tagbar'  -- через ctags выводит стуктуру текущего файла (аналог vista)
    use 'phaazon/hop.nvim'  -- прыжки по тексту (аналог easymotion)
    use 'powerman/vim-plugin-ruscmd'  -- позволяет использовать русскую расскладку в normal-mode
    use 'tpope/vim-surround'  -- выбери слово и введи обрамление, напимер <h1>
    use 'dense-analysis/ale'  -- линтер, работает для всех языков
    use 'numToStr/Comment.nvim'  -- комментирует все, вне зависимости от языка
    use 'tpope/vim-fugitive'  -- Интеграция с git
    -- Автодополнения и линтеры
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'  -- LspInstallInfo
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use 'nvie/vim-flake8'
    use 'preservim/nerdtree'
    use 'Xuyuanp/nerdtree-git-plugin'
    use 'ryanoasis/vim-devicons'
    use 'mg979/vim-visual-multi'  -- мультикурсоры
    use 'iamcco/markdown-preview.nvim'
    use 'puremourning/vimspector'
    use 'mbbill/undotree'
    use 'folke/neodev.nvim'
    use "ray-x/lsp_signature.nvim"
    -- use 'wellle/context.vim'
    use 'voldikss/vim-floaterm'
    use 'airblade/vim-gitgutter'
    use 'petobens/poet-v'
end)


