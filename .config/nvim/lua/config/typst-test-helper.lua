local typst_test_helper = require("typst-test-helper")

local M = {}

function M.setup()
    typst_test_helper.setup({
        maps = {
            { "<leader>iot", typst_test_helper.open_identity, desc = "Open typst test" },
        }
    })
end

return M
