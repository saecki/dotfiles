local M = {}

local hipatterns = require("mini.hipatterns")
local wk = require("which-key")
local util = require("util")

function M.setup()
    hipatterns.setup({
        highlighters = {
            hex_color = hipatterns.gen_highlighter.hex_color(),
            hsl_color = {
                pattern = "hsl%(%s*%d+%s*,?%s*%d+%s*,?%s*%d+%s*%)",
                group = function(_, match)
                    local nh, ns, nl = match:match("hsl%(%s*(%d+)%s*,?%s*(%d+)%s*,?%s*(%d+)%s*%)")
                    local h = util.clamp(tonumber(nh), 0, 360) / 360
                    local s = util.clamp(tonumber(ns), 0, 100) / 100
                    local l = util.clamp(tonumber(nl), 0, 100) / 100
                    local r, g, b = util.hsl_to_rgb(h, s, l)
                    local hex_color = util.rgb_to_hex_string(r, g, b)
                    return hipatterns.compute_hex_color_group(hex_color, "bg")
                end,
            },
        },
        delay = {
            text_change = 10,
            scroll = 10,
        },
    })

    wk.register({
        ["<leader>e"] = {
            name = "Toggle (enable)",
            ["c"] = { ":ColorizerToggle<cr>", "Colorizer" },
        },
    })
end

return M
