local opt = vim.opt
local map = vim.keymap

-- tab/indent
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false

-- search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- visual
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"

-- etc.
opt.encoding = "UTF-8"
opt.cmdheight = 2
opt.scrolloff = 10
opt.mouse = "a"

-- clipboard
opt.clipboard = "unnamedplus" -- enable Ctrl + C in nvim

-- keep up visual block
map.set("v", "<", "<gv")
map.set("v", ">", ">gv")
