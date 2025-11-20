local hipatterns = require("mini.hipatterns")
local wk = require("which-key.config")
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

local function ft_pattern(ft, pattern)
    return function(buf)
        if vim.bo[buf].filetype ~= ft then
            return nil
        end
        return pattern
    end
end

local function extmark_opts(a, match, data)
    return {
        virt_text = { { match, data.hl_group } },
        virt_text_pos = "overlay",
        priority = 150,
    }
end

function M.setup()
    local config = {
        highlighters = {
            hex_color = {
                pattern = "#%x%x%x%x%x%x%f[%X]",
                group = function(_, match)
                    return hipatterns.compute_hex_color_group(match, style())
                end,
                extmark_opts = extmark_opts,
            },
            hex_color_with_alpha = {
                pattern = "#%x%x%x%x%x%x%x%x%f[%X]",
                group = function(_, match)
                    return hipatterns.compute_hex_color_group(match:sub(1, -3), style())
                end,
                extmark_opts = extmark_opts,
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
                extmark_opts = extmark_opts,
            },
            rgb_color = {
                pattern = "rgb%(%s*%d+%s*,?%s*%d+%s*,?%s*%d+%s*%)",
                group = function(_, match)
                    local nr, ng, nb = match:match("rgb%(%s*(%d+)%s*,?%s*(%d+)%s*,?%s*(%d+)%s*%)")
                    local r = util.clamp(tonumber(nr), 0, 255)
                    local g = util.clamp(tonumber(ng), 0, 255)
                    local b = util.clamp(tonumber(nb), 0, 255)
                    local hex_color = util.rgb_to_hex_string(r, g, b)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
                extmark_opts = extmark_opts,
            },
            rgba_color = {
                pattern = "rgba%(%s*%d+%s*,?%s*%d+%s*,?%s*%d+%s*%,?%s*%d+%.?%d*%s*%)",
                group = function(_, match)
                    local nr, ng, nb = match:match("rgba%(%s*(%d+)%s*,?%s*(%d+)%s*,?%s*(%d+)%s*%,.*%)")
                    local r = util.clamp(tonumber(nr), 0, 255)
                    local g = util.clamp(tonumber(ng), 0, 255)
                    local b = util.clamp(tonumber(nb), 0, 255)
                    local hex_color = util.rgb_to_hex_string(r, g, b)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
                extmark_opts = extmark_opts,
            },
            egui_color32_from_gray = {
                pattern = ft_pattern("rust", "Color32::from_gray%(%s*%d+%s*%)"),
                group = function(_, match)
                    local ng = match:match("Color32::from_gray%(%s*(%d+)%s*%)")
                    local g = util.clamp(tonumber(ng), 0, 255)
                    local hex_color = util.rgb_to_hex_string(g, g, g)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
                extmark_opts = extmark_opts,
            },
            egui_color32_from_rgb = {
                pattern = ft_pattern("rust", "Color32::from_rgb%(%s*%d+%s*,?%s*%d+%s*,?%s*%d+%s*%)"),
                group = function(_, match)
                    local nr, ng, nb = match:match("Color32::from_rgb%(%s*(%d+)%s*,?%s*(%d+)%s*,?%s*(%d+)%s*%)")
                    local r = util.clamp(tonumber(nr), 0, 255)
                    local g = util.clamp(tonumber(ng), 0, 255)
                    local b = util.clamp(tonumber(nb), 0, 255)
                    local hex_color = util.rgb_to_hex_string(r, g, b)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
                extmark_opts = extmark_opts,
            },
            egui_color32_from_rgb_hex = {
                pattern = ft_pattern("rust", "Color32::from_rgb%(%s*0x%x+%s*,?%s*0x%x+%s*,?%s*0x%x+%s*%)"),
                group = function(_, match)
                    local nr, ng, nb = match:match("Color32::from_rgb%(%s*0x(%x+)%s*,?%s*0x(%x+)%s*,?%s*0x(%x+)%s*%)")
                    local r = util.clamp(tonumber(nr, 16), 0, 255)
                    local g = util.clamp(tonumber(ng, 16), 0, 255)
                    local b = util.clamp(tonumber(nb, 16), 0, 255)
                    local hex_color = util.rgb_to_hex_string(r, g, b)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
                extmark_opts = extmark_opts,
            },
            glm_vec3_color = {
                pattern = ft_pattern("cpp", "glm::vec3%(%s*%d+%.%d+f%s*,%s*%d+%.%d+f%s*,%s*%d+%.%d+f%s*%)"),
                group = function(_, match)
                    local nr, ng, nb = match:match("glm::vec3%(%s*(%d+%.%d+)f%s*,%s*(%d+%.%d+)f%s*,%s*(%d+%.%d+)f%s*%)")
                    local r = util.clamp(255 * tonumber(nr), 0, 255)
                    local g = util.clamp(255 * tonumber(ng), 0, 255)
                    local b = util.clamp(255 * tonumber(nb), 0, 255)
                    local hex_color = util.rgb_to_hex_string(r, g, b)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
            },
            glm_vec4_color = {
                pattern = ft_pattern("cpp", "glm::vec4%(%s*%d+%.%d+f%s*,%s*%d+%.%d+f%s*,%s*%d+%.%d+f%s*,%s*.+%s*%)"),
                group = function(_, match)
                    local nr, ng, nb = match:match(
                        "glm::vec4%(%s*(%d+%.%d+)f%s*,%s*(%d+%.%d+)f%s*,%s*(%d+%.%d+)f%s*,%s*(.+)%s*%)")
                    local r = util.clamp(255 * tonumber(nr), 0, 255)
                    local g = util.clamp(255 * tonumber(ng), 0, 255)
                    local b = util.clamp(255 * tonumber(nb), 0, 255)
                    local hex_color = util.rgb_to_hex_string(r, g, b)
                    return hipatterns.compute_hex_color_group(hex_color, style())
                end,
                extmark_opts = extmark_opts,
            },
            typst_rgb_string = {
                pattern = ft_pattern("typst", "rgb%(%s*\"%x%x%x%x%x%x\"%s*%)"),
                group = function(_, match)
                    local hex_str = match:match("rgb%(%s*\"(%x%x%x%x%x%x)\"%s*%)")
                    return hipatterns.compute_hex_color_group("#" .. hex_str, style())
                end,
                extmark_opts = extmark_opts,
            },
        },
        delay = {
            text_change = 10,
            scroll = 10,
        },
    }

    wk.add({
        { "<leader>e",  group = "Toggle (enable)" },
        { "<leader>ec", function() hipatterns.toggle(nil, config) end, desc = "Colorizer" },
        { "<leader>eC", toggle_style,                                  desc = "Colorizer style" },
    })
end

return M
