local M = {}

local common = require("colors.common")

-- stylua: ignore start
M.palette = {
    bg         = "#ffffff",
    fg         = "#313131",

    dred       = "#cc241d",
    dgreen     = "#98971a",
    dyellow    = "#d79921",
    dblue      = "#458588",
    dpurple    = "#b16286",
    dcyan      = "#689d6a",

    lred       = "#9d0006",
    lgreen     = "#79740e",
    lyellow    = "#b57614",
    lblue      = "#076678",
    lpurple    = "#8f3f71",
    lcyan      = "#427b58",

    lred_bg    = "#ffefeb",
    lyellow_bg = "#fdf8eb",
    lblue_bg   = "#f2faf7",

    texthl1    = "#d4d4d4",
    ref_text   = "#f2eaff",
    ref_write  = "#e2fff0",
    ref_read   = "#ffeae4",

    invtext    = "#dedede",
    text2      = "#585858",
    text3      = "#808080",

    surface1   = "#d8d8d8",
    surface2   = "#e4e4e4",
    surface3   = "#f2f2f2",
    surface4   = "#f6f6f6",

    scrollbg   = "#dadada",
    scrollfg   = "#a8a8a8",

    title      = "#b059b0",
    preproc    = "#0087ff",
    type       = "#00b997",
    special    = "#875fd7",
    todo       = "#00d700",
    nontext    = "#b1c9c8",
    whitespace = "#c8d4dd",
    folded     = "#3e3e6c",
    folded_bg  = "#eaeaff",

    diff_a_bg  = "#ccfbba",
    diff_c_bg  = "#c7dcff",
    diff_d_bg  = "#ffbdbd",
    diff_cd_bg = "#d0b6ff",

    diff_a_fg  = "#7ee07d",
    diff_c_fg  = "#77acff",
    diff_d_fg  = "#ff8080",
    diff_cd_fg = "#c982ff",
}
-- stylua: ignore end

M.highlights = common.highlights(M.palette)
M.lualine = common.lualine(M.palette)

function M.setup()
    vim.g.colors_name = "minelight"

    common.apply_term_colors(M.palette)
    common.apply_highlights(M.highlights)
end

return M
