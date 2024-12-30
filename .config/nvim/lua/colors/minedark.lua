local common = require("colors.common")

local M = {}

M.palette = {
    bg         = "#181818",
    fg         = "#ffedcd",

    dred       = "#cc241d",
    dgreen     = "#98971a",
    dyellow    = "#d79921",
    dblue      = "#458588",
    dpurple    = "#b16286",
    dcyan      = "#689d6a",

    lred       = "#fb4934",
    lgreen     = "#b8bb26",
    lyellow    = "#fabd2f",
    lblue      = "#88beda",
    lpurple    = "#d3869b",
    lcyan      = "#8ec07c",

    lred_bg    = "#1f0906",
    lyellow_bg = "#2a2008",
    lblue_bg   = "#222a27",

    texthl1    = "#585858",
    texthl2    = "#ff7555",
    ref_text   = "#343052",
    ref_write  = "#284034",
    ref_read   = "#42321a",

    invtext    = "#000000",
    text2      = "#ebdbb2",
    text3      = "#a89d8e",

    surface1   = "#4e4e4e",
    surface2   = "#3a3a3a",
    surface3   = "#282828",

    scrollbg   = "#444444",
    scrollfg   = "#a8a8a8",

    title      = "#ffd7ff",
    preproc    = "#589ff0",
    ident      = "#83a598",
    type       = "#5fccaf",
    special    = "#afafff",
    todo       = "#afff00",
    nontext    = "#5d6268",
    whitespace = "#343638",
    indent     = "#242628",
    folded     = "#c0c0d0",
    folded_bg  = "#282832",

    diff_a_bg  = "#395039",
    diff_c_bg  = "#33415b",
    diff_d_bg  = "#7a4242",
    diff_cd_bg = "#553b6c",

    diff_a_fg  = "#5fa55e",
    diff_c_fg  = "#5a8abf",
    diff_d_fg  = "#b45050",
    diff_cd_fg = "#a573c2",
}

M.highlights = common.highlights(M.palette)

function M.setup()
    vim.g.colors_name = "minedark"

    common.apply_term_colors(M.palette)
    common.apply_highlights(M.highlights)
end

return M
