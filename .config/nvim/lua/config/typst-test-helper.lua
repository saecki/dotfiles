local tth = require("typst-test-helper")

local M = {}

local function on_attach(buf)
    local function opts(desc)
        return { buffer = buf, desc = desc }
    end
    vim.keymap.set("n", "<leader>iot", tth.map_open("identity"), opts("Open typst test"))
    vim.keymap.set("n", "<leader>iog", tth.map_open("geeqie"), opts("Open typst test"))
end

function M.setup()
    tth.setup({
        on_attach = on_attach,
        programs = {
            geeqie = { "geeqie" },
        },
    })
end

return M
