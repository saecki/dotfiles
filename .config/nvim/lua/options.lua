local M = {}

local util = require('util')

function M.setup()
    vim.g.mapleader = " "
    vim.opt.shell = "/bin/bash"

    -- Visuals
    vim.opt.signcolumn = "yes:2"
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.linebreak = true
    vim.opt.showbreak  =  "⮡   "
    vim.opt.wrap = true
    vim.opt.scrolloff = 3
    vim.opt.textwidth = 0
    vim.opt.wrapmargin = 0
    vim.opt.listchars = { space = "·", eol = "⮠" }
    vim.opt.fillchars = { vert = "│" }
    vim.opt.cmdheight = 1
    vim.opt.background = "dark"

    -- Indentation
    vim.opt.autoindent = true
    vim.opt.smartindent = true
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 4

    -- Search
    vim.opt.incsearch = true
    vim.opt.inccommand = "nosplit"
    vim.opt.ignorecase = false
    vim.opt.hlsearch = true
    vim.opt.showmatch = true
    vim.opt.gdefault = true

    -- Completion
    vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
    vim.opt.shortmess:append("c")

    -- Splits
    vim.opt.splitright = true
    vim.opt.splitbelow = true

    -- Undo
    vim.opt.undolevels = 1000
    vim.opt.undodir = util.join_paths(vim.fn.stdpath("data"), "undo")
    vim.opt.undofile = true
    vim.opt.swapfile = false

    -- Spell checking
    vim.opt.spelllang = { "en", "de", "es", "nl" }

    -- Miscellaneous
    vim.opt.updatetime = 300
    vim.opt.mouse = "a"
    vim.opt.hidden = true
end

return M
