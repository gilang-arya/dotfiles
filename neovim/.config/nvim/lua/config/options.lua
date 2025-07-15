local g = vim.g
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.undofile = true

opt.wrap = true
opt.smartindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
opt.cursorline = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 300
opt.timeoutlen = 500
opt.splitright = true
opt.splitbelow = true

if vim.fn.has("unix") == 1 then
	opt.clipboard = "unnamedplus" -- Gunakan clipboard sistem pada Linux/Unix
end
