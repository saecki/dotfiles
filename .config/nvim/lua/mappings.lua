local M = {}

local maps = require("util.maps")

function M.setup()
    -- Text navigation
    maps.nnoremap("j", "gj")
    maps.nnoremap("k", "gk")

    -- Copy to the end of the line
    maps.nnoremap("Y", "y$")

    -- Resize
    maps.nnoremap("<c-left>", ":vertical resize -5<cr>")
    maps.nnoremap("<c-down>", ":resize +5<cr>")
    maps.nnoremap("<c-up>", ":resize -5<cr>")
    maps.nnoremap("<c-right>", ":vertical resize +5<cr>")

    -- Quick save
    maps.nnoremap("<leader>w", ":w<cr>")

    -- Stop searching
    maps.vnoremap("S", ":nohlsearch<cr>")
    maps.nnoremap("S", ":nohlsearch<cr>")

    -- Copy paste
    maps.vnoremap("<c-c>", '"+y')
    maps.inoremap("<c-v>", "<c-r>+")

    -- Toggle between buffers
    maps.nnoremap("<leader><leader>", "<c-^>")

    -- I don't need your help
    maps.noremap("<F1>", "<esc>")
    maps.inoremap("<F1>", "<esc>")

    -- Toggle listchars
    maps.nnoremap("<leader>hl", function()
        vim.opt.list = not vim.o.list
    end)
end

return M
