local tth = require("typst-test-helper")
local wk = require("which-key.config")

local M = {}

local function on_attach(buf)
    wk.add({
        buffer = buf,
        { "<leader>it",  group = "Typst" },
        { "<leader>itt", tth.map_run_this(),                   desc = "Run test" },
        { "<leader>its", tth.map_run_this({ "--scale=4" }),    desc = "Run test scale=4" },
        { "<leader>itu", tth.map_run_this({ "--update" }),     desc = "Update ref" },
        { "<leader>itr", tth.map_open_render("identity"), desc = "Open render" },
        { "<leader>ith", tth.read_html,                   desc = "Read html" },
        { "<leader>itp", tth.read_pdftags,                desc = "Read pdftags" },
        { "<leader>itv", tth.read_svg,                    desc = "Read svg" },
    })
end

function M.setup()
    tth.setup({
        on_attach = on_attach,
        programs = {
            identity = { "identity" },
        },
    })
end

return M
