local common = require("colors.common")

local M = {}

M.palette = {
    bg         = "#ffffff",
    fg         = "#313131",

    dred       = "#9d0006",
    dgreen     = "#79740e",
    dyellow    = "#b57614",
    dblue      = "#076678",
    dpurple    = "#8f3f71",
    dcyan      = "#427b58",

    lred       = "#ec5444",
    lgreen     = "#a8c72a",
    lyellow    = "#f2ad38",
    lblue      = "#78ced8",
    lpurple    = "#d868a0",
    lcyan      = "#56d44a",

    lred_bg    = "#ffefeb",
    lyellow_bg = "#fdf8eb",
    lblue_bg   = "#f2faf7",

    texthl1    = "#d4d4d4",
    texthl2    = "#ff8565",
    ref_text   = "#f2eaff",
    ref_write  = "#e2fff0",
    ref_read   = "#ffeae4",

    invtext    = "#dedede",
    text2      = "#585858",
    text3      = "#808080",

    surface1   = "#e0e0e0",
    surface2   = "#efefef",
    surface3   = "#f6f6f6",

    scrollbg   = "#dadada",
    scrollfg   = "#a8a8a8",

    title      = "#b059b0",
    preproc    = "#0087ff",
    ident      = "#359598",
    type       = "#00cea0",
    special    = "#875fd7",
    todo       = "#00d700",
    nontext    = "#c0c6d8",
    whitespace = "#d0d4dd",
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

M.highlights = common.highlights(M.palette)

function M.setup()
    vim.g.colors_name = "minelight"

    common.apply_term_colors(M.palette)
    common.apply_highlights(M.highlights)
end

return M
