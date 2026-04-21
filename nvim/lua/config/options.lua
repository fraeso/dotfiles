vim.g.mapleader = " "

vim.opt.cursorline = false
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2,min:40,sbr"
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 0
-- vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
-- vim.opt.smarttab = true
-- vim.opt.shiftwidth = 2
-- vim.opt.tabstop = 2
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })
-- vim.opt.mouse = ""
vim.opt.formatoptions:append({ "r" })

vim.opt.shortmess:append("A")

-- disable indent lines
vim.opt.list = false
vim.opt.listchars = ""

-- Disable LazyVim's autoformat
vim.g.autoformat = false
