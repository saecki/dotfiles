local tth = require("typst-test-helper")
local wk = require("which-key.config")

local M = {}

local function on_attach(buf)
    wk.add({
        buffer = buf,
        { "<leader>it",  group = "Typst test" },
        { "<leader>itt", tth.run_test,                    desc = "Run test" },
        { "<leader>itu", tth.update_ref,                  desc = "Update ref" },
        { "<leader>itr", tth.map_open_render("identity"), desc = "Open render" },
        { "<leader>ith", tth.open_html,                   desc = "Open html" },
        { "<leader>itp", tth.open_pdftags,                desc = "Open pdftags" },
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
