local M = {}

local common = require("colors.common")

-- stylua: ignore start
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
    lblue      = "#83a598",
    lpurple    = "#d3869b",
    lcyan      = "#8ec07c",

    lred_bg    = "#1f0906",
    lyellow_bg = "#2a2008",
    lblue_bg   = "#222a27",

    texthl1    = "#585858",
    texthl2    = "#343052",

    invtext    = "#000000",
    text2      = "#ebdbb2",
    text3      = "#a89d8e",

    surface1   = "#4e4e4e",
    surface2   = "#3a3a3a",
    surface3   = "#282828",
    surface4   = "#202020",

    scrollbg   = "#444444",
    scrollfg   = "#a8a8a8",

    title      = "#ffd7ff",
    preproc    = "#00afff",
    type       = "#5fd7af",
    special    = "#afafff",
    todo       = "#afff00",
    nontext    = "#5b676a",
    whitespace = "#24292a",
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
-- stylua: ignore end

M.highlights = common.highlights(M.palette)
M.lualine = common.lualine(M.palette)

function M.setup()
    vim.g.colors_name = "minedark"

    common.apply_term_colors(M.palette)
    common.apply_highlights(M.highlights)
end

return M
