local M = {}

local lualine = require("lualine")
local lsp_status = require("lsp-status")

-- stylua: ignore start
local modemap = {
    ["n"]    = "N ",
    ["no"]   = "O ",
    ["nov"]  = "O ",
    ["noV"]  = "O ",
    ["no"] = "O ",
    ["niI"]  = "N ",
    ["niR"]  = "N ",
    ["niV"]  = "N ",
    ["v"]    = "V ",
    ["V"]    = "VL",
    [""]   = "VB",
    ["s"]    = "S ",
    ["S"]    = "SL",
    [""]   = "SB",
    ["i"]    = "I ",
    ["ic"]   = "I ",
    ["ix"]   = "I ",
    ["R"]    = "R ",
    ["Rc"]   = "R ",
    ["Rv"]   = "VR",
    ["Rx"]   = "R ",
    ["c"]    = "C ",
    ["cv"]   = "EX",
    ["ce"]   = "EX",
    ["r"]    = "R ",
    ["rm"]   = "MORE",
    ["r?"]   = "CONFIRM",
    ["!"]    = "SHELL",
    ["t"]    = "TERMINAL",
}
-- stylua: ignore end
local function mode()
    local mode_code = vim.api.nvim_get_mode().mode
    if modemap[mode_code] == nil then
        return mode_code
    end
    return modemap[mode_code]
end

local function fileformat()
    return vim.bo.fileformat
end

local function position()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local linecount = vim.api.nvim_buf_line_count(0)
    local linedigits = math.floor(math.log10(linecount)) + 1

    local template = "%" .. linedigits .. "d:%-2d"
    return string.format(template, cursor[1], cursor[2])
end

local function lsp_status_text()
    return vim.trim(lsp_status.status())
end

function M.setup()
    local colors = require("colors.mineauto")
    local theme = colors.lualine

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = theme,
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = {
                { mode, separator = { left = " " } },
            },
            lualine_b = { lsp_status_text },
            lualine_c = {
                {
                    "filename",
                    path = 1,
                    symbols = { modified = " ", readonly = " ", unnamed = "|unnamed|" },
                },
            },
            lualine_x = { fileformat, "encoding", { "filetype" } },
            lualine_y = {
                { "branch" },
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    sections = { "error", "warn", "info", "hint" },
                    symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    diagnostics_color = {
                        error = "DiagnosticSignError",
                        warn = "DiagnosticSignWarn",
                        info = "DiagnosticSignInfo",
                        hint = "DiagnosticSignHint",
                    },
                },
            },
            lualine_z = {
                { position, separator = { right = " " } },
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {
                {
                    "filename",
                    path = 1,
                    symbols = { modified = " ", readonly = " ", unnamed = "|unnamed|" },
                    separator = { left = " " },
                },
            },
            lualine_x = {
                { "location", separator = { right = " " } },
            },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {},
    })
end

return M
