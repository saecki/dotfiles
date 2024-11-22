local util = require("util")

local M = {}

function M.setup()
    vim.g.mapleader = " "
    vim.g.maplocalleader = ","
    vim.opt.shell = "/bin/bash"

    -- Visuals
    vim.opt.signcolumn = "yes:2"
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.linebreak = true
    vim.opt.showbreak = "⮡   "
    vim.opt.wrap = true
    vim.opt.scrolloff = 3
    vim.opt.textwidth = 0
    vim.opt.wrapmargin = 0
    vim.opt.listchars = { space = "·", eol = "⮠" }
    vim.opt.fillchars:append({ horiz = "─", vert = "│", eob = " ", fold = " ", diff = "╱" })
    vim.opt.cmdheight = 1
    vim.opt.background = "dark"
    vim.opt.showmode = false
    vim.opt.cursorline = true -- just for the line number highlight

    -- Indentation
    vim.opt.autoindent = true
    vim.opt.smartindent = true
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 4
    vim.opt.fixendofline = false

    -- Folds
    vim.opt.foldlevelstart = 99
    vim.opt.foldnestmax = 30
    vim.opt.foldminlines = 1
    vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ]]
        .. [[... '.trim(getline(v:foldend)).'  ('.(v:foldend - v:foldstart + 1).' lines)']]

    -- Search
    vim.opt.incsearch = true
    vim.opt.inccommand = "nosplit"
    vim.opt.ignorecase = true
    vim.opt.hlsearch = true
    vim.opt.gdefault = true

    -- Completion
    vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
    vim.opt.shortmess:append("c")

    -- Splits
    vim.opt.laststatus = 3
    vim.opt.splitright = true
    vim.opt.splitbelow = true

    -- Undo
    vim.opt.undolevels = 1000
    vim.opt.undodir = vim.fs.joinpath(vim.fn.stdpath("data"), "undo")
    vim.opt.undofile = true
    vim.opt.swapfile = false

    -- Spell checking
    vim.opt.spell = true
    vim.opt.spelllang = { "en", "de", "es", "nl" }

    -- Miscellaneous
    vim.opt.updatetime = 300
    vim.opt.showmatch = false
    vim.opt.mouse = "a"
    vim.opt.hidden = true

    local group = vim.api.nvim_create_augroup("user.options", {})

    -- Highlight yanked text
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = group,
        callback = function()
            vim.highlight.on_yank({ on_visual = false, timeout = 150 })
        end,
    })

    -- Split help window to the right
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "help",
        callback = function()
            vim.opt_local.bufhidden = "unload"
            vim.cmd.wincmd("L")
            vim.api.nvim_win_set_width(0, 90)
        end,
    })

    -- Git commit spell checking
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "gitcommit",
        group = group,
        callback = function()
            vim.opt_local.spell = true
        end,
    })
end

return M
