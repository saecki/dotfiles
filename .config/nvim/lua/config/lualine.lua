local lualine = require("lualine")

local M = {}

---@format disable-next
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
    local linecount = math.max(2, vim.api.nvim_buf_line_count(0))
    local linedigits = math.floor(math.log10(linecount)) + 1

    local template = " %" .. linedigits .. "d:%-3d"
    return string.format(template, cursor[1], cursor[2])
end

function M.setup()
    local filename_symbols = {
        modified = " ",
        readonly = " ",
        unnamed = "unnamed",
    }

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = {
                normal = {
                    a = "LualineNormalA",
                    b = "LualineB",
                    c = "LualineC",
                },
                insert = {
                    a = "LualineInsertA",
                    b = "LualineB",
                    c = "LualineC",
                },
                visual = {
                    a = "LualineVisualA",
                    b = "LualineB",
                    c = "LualineC",
                },
                replace = {
                    a = "LualineReplaceA",
                    b = "LualineB",
                    c = "LualineC",
                },
                command = {
                    a = "LualineCommandA",
                    b = "LualineB",
                    c = "LualineC",
                },
                inactive = {
                    a = "LualineInactiveA",
                    b = "LualineB",
                    c = "LualineC",
                },
            },
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
            globalstatus = true,
        },
        sections = {
            lualine_a = {
                { mode, separator = { left = " ", right = "" } },
            },
            lualine_b = {},
            lualine_c = {
                {
                    "filename",
                    path = 1,
                    symbols = filename_symbols,
                },
            },
            lualine_x = { fileformat, "encoding", "filetype" },
            lualine_y = {
                "branch",
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    sections = { "error", "warn", "info", "hint" },
                    symbols = { error = " ", warn = " ", info = " ", hint = " " },
                    diagnostics_color = {
                        error = "LualineDiagnosticSignError",
                        warn = "LualineDiagnosticSignWarn",
                        info = "LualineDiagnosticSignInfo",
                        hint = "LualineDiagnosticSignHint",
                    },
                },
            },
            lualine_z = {
                { position, separator = { left = "", right = " " }, padding = 0 },
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {
                {
                    "filename",
                    path = 1,
                    symbols = filename_symbols,
                    separator = { left = " " },
                },
            },
            lualine_x = {
                { "location", separator = { right = " " } },
            },
            lualine_y = {},
            lualine_z = {},
        },
        extensions = {},
    })
end

return M
