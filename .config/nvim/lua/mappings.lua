local M = {}

local maps = require('util.maps')

function M.setup()
    -- Text navigation
    maps.nnoremap("j", "gj")
    maps.nnoremap("k", "gk")

    -- Copy to the end of the line
    maps.nnoremap("Y", "y$")

    -- Resize
    maps.nmap("<c-left>",  ":vertical resize -5<cr>")
    maps.nmap("<c-down>",  ":resize +5<cr>")
    maps.nmap("<c-up>",    ":resize -5<cr>")
    maps.nmap("<c-right>", ":vertical resize +5<cr>")

    -- Quick save
    maps.nmap("<leader>w", ":w<cr>")

    -- stop searching
    maps.vnoremap("<s-h>", ":nohlsearch<cr>")
    maps.nnoremap("<s-h>", ":nohlsearch<cr>")

    -- Copy paste
    maps.vnoremap("<c-c>", '"+y')
    maps.inoremap("<c-v>", "<c-r>+")

    -- Toggle between buffers
    maps.nnoremap("<leader><leader>", "<c-^>")

    -- I don't need your help
    maps.map("<F1>", "<esc>")
    maps.imap("<F1>", "<esc>")
end

return M
