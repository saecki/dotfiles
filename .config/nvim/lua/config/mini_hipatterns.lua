local hipatterns = require("mini.hipatterns")
local wk = require("which-key")
local util = require("util")
local colors = require("colors")

local M = {}

local highlight_foreground = false

local function toggle_style()
    highlight_foreground = not highlight_foreground
    colors.update_colorscheme()
end

local function style()
    return highlight_foreground and "fg" or "bg"
end

function M.setup()
    hipatterns.setup({
        highlighters = {
            hex_color = {
                pattern = "#%x%x%x%x%x%x%f[%X]",
                group = function(_, match)
                    return hipatterns.compute_hex_color_group(match, style())
                end,
            },
            hsl_color = {
                pattern = "hsl%(%s*%d+%s*,?%s*%d+%s*,?%s*%d+%s*%)",
                group = function(_, match)
                    local nh, ns, nl = match:match("hsl%(%s*(%d+)%s*,?%s*(%d+)%s*,?%s*(%d+)%s*%)")
                    local h = util.clamp(tonumber(nh), 0, 360) / 360
                    local s = util.clamp(tonumber(ns), 0, 100) / 100
                    local l = util.clamp(tonumber(nl), 0, 100) / 100
                    local r, g, b = util.hsl_to_rgb(h, s, l)
                    local hex_color = util.rgb_to_hex_string(r, g, b)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
            },
            egui_color32_from_gray = {
                pattern = "Color32::from_gray%(%s*%d+%s*%)",
                group = function(_, match)
                    local ng = match:match("Color32::from_gray%(%s*(%d+)%s*%)")
                    local g = util.clamp(tonumber(ng), 0, 255)
                    local hex_color = util.rgb_to_hex_string(g, g, g)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
            },
            egui_color32_from_rgb = {
                pattern = "Color32::from_rgb%(%s*%d+%s*,?%s*%d+%s*,?%s*%d+%s*%)",
                group = function(_, match)
                    local nr, ng, nb = match:match("Color32::from_rgb%(%s*(%d+)%s*,?%s*(%d+)%s*,?%s*(%d+)%s*%)")
                    local r = util.clamp(tonumber(nr), 0, 255)
                    local g = util.clamp(tonumber(ng), 0, 255)
                    local b = util.clamp(tonumber(nb), 0, 255)
                    local hex_color = util.rgb_to_hex_string(r, g, b)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
            },
            egui_color32_from_rgb_hex = {
                pattern = "Color32::from_rgb%(%s*0x%x+%s*,?%s*0x%x+%s*,?%s*0x%x+%s*%)",
                group = function(_, match)
                    local nr, ng, nb = match:match("Color32::from_rgb%(%s*0x(%x+)%s*,?%s*0x(%x+)%s*,?%s*0x(%x+)%s*%)")
                    local r = util.clamp(tonumber(nr, 16), 0, 255)
                    local g = util.clamp(tonumber(ng, 16), 0, 255)
                    local b = util.clamp(tonumber(nb, 16), 0, 255)
                    local hex_color = util.rgb_to_hex_string(r, g, b)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
            },
        },
        delay = {
            text_change = 10,
            scroll = 10,
        },
    })

    wk.add({
        { "<leader>e",  group = "Toggle (enable)" },
        { "<leader>ec", hipatterns.toggle,        desc = "Colorizer" },
        { "<leader>eC", toggle_style,             desc = "Colorizer style" },
    })
end

return M
