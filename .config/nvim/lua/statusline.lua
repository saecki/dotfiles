local M = {}

---@format disable-next
local modemap = {
    ["n"]     = "N ",
    ["no"]    = "O ",
    ["nov"]   = "O ",
    ["noV"]   = "O ",
    ["no\22"] = "O ",
    ["niI"]   = "N ",
    ["niR"]   = "N ",
    ["niV"]   = "N ",
    ["nt"]    = "N ",
    ["ntT"]   = "N ",
    ["v"]     = "V ",
    ["vs"]    = "V ",
    ["V"]     = "VL",
    ["Vs"]    = "VL",
    ["\22"]   = "VB",
    ["\22s"]  = "VB",
    ["s"]     = "S ",
    ["S"]     = "SL",
    ["\19"]   = "SB",
    ["i"]     = "I ",
    ["ic"]    = "I ",
    ["ix"]    = "I ",
    ["R"]     = "R ",
    ["Rc"]    = "R ",
    ["Rx"]    = "R ",
    ["Rv"]    = "VR",
    ["Rvc"]   = "VR",
    ["Rvx"]   = "VR",
    ["c"]     = "C ",
    ["cv"]    = "EX",
    ["ce"]    = "EX",
    ["r"]     = "R ",
    ["rm"]    = "MORE",
    ["r?"]    = "CONFIRM",
    ["!"]     = "SHELL",
    ["t"]     = "TERMINAL",
}

local filename_symbols = {
    modified = " ",
    readonly = " ",
    unnamed = "unnamed",
}

local git_symbols = {
    branch = " ",
}

local diagnostic_symbols = { " ", " ", " ", " " }

local function mode()
    local mode_code = vim.api.nvim_get_mode().mode
    local mode_str = modemap[mode_code]
    assert(mode_str ~= nil)
    return mode_str
end

local function filename()
    local path = vim.fn.expand("%:~:.")
    if path == "" then
        return filename_symbols.unnamed
    end

    if vim.bo.modified then
        path = path .. filename_symbols.modified
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
        path = path .. filename_symbols.readonly
    end
    return path
end

local function position()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local linecount = math.max(2, vim.api.nvim_buf_line_count(0))
    local linedigits = math.floor(math.log10(linecount)) + 1

    local template = " %" .. linedigits .. "d:%-3d"
    return string.format(template, cursor[1], cursor[2])
end

local head_cache = {}
local function git_rev()
    local git_root = vim.fs.root(0, ".git")
    if not git_root then
        return nil
    end

    local head_path = vim.fs.joinpath(git_root, ".git/HEAD")
    local head_stat = vim.uv.fs_stat(head_path)
    local cache = head_cache[git_root]
    if cache and cache.mtime == head_stat.mtime.sec then
        return cache.rev
    end

    local rev = nil
    local fd = vim.uv.fs_open(head_path, "r", 0)
    if fd then
        local head = vim.uv.fs_read(fd, head_stat.size)
        head = vim.trim(head)
        vim.uv.fs_close(fd)

        if head then
            local branch = head:match("ref: refs/heads/(.+)$")
            if branch then
                rev = git_symbols.branch .. branch
            else
                rev = head:sub(1, 7)
            end
        end
    end

    head_cache[git_root] = {
        mtime = head_stat.mtime.sec,
        rev = rev,
    }

    return rev
end

local function diagnostics()
    local count = vim.diagnostic.count(0)
    local hls = {
        "StatusLineDiagnosticSignError",
        "StatusLineDiagnosticSignWarn",
        "StatusLineDiagnosticSignInfo",
        "StatusLineDiagnosticSignHint",
    }
    local builder = {}
    for i = 1, 4 do
        if count[i] then
            local str = string.format("%%#%s#%s %s", hls[i], count[i], diagnostic_symbols[i])
            if #builder ~= 0 then
                str = " " .. str
            end
            table.insert(builder, str)
        end
    end
    return table.concat(builder)
end

---@param str string?
---@return string
local function pad(str)
    if not str or str == "" then
        return ""
    end
    return " " .. str .. " "
end

function __statusline()
    local mode = mode()
    local mode_hl_map = {
        ["N "]       = "Normal",
        ["O "]       = "Operator",
        ["V "]       = "Visual",
        ["VL"]       = "Visual",
        ["VB"]       = "Visual",
        ["S "]       = "Visual",
        ["SL"]       = "Visual",
        ["SB"]       = "Visual",
        ["I "]       = "Insert",
        ["R "]       = "Replace",
        ["VR"]       = "Replace",
        ["C "]       = "Command",
        ["EX"]       = "Command",
        ["MORE"]     = "Command",
        ["CONFIRM"]  = "Command",
        ["SHELL"]    = "Command",
        ["TERMINAL"] = "Comman",
    }
    local suffix = mode_hl_map[mode]
    assert(suffix ~= nil, vim.inspect(mode))
    local mode_hl = "StatusLine" .. suffix .. "A"

    local sections = {
        a = table.concat({
            "%#", mode_hl, "#", pad(mode),
        }),
        b = "",
        c = pad(filename()),

        x = table.concat({
            pad(vim.bo.fileformat),
            pad(vim.bo.fileencoding),
            pad(vim.bo.filetype),
        }),
        y = table.concat({
            pad(git_rev()),
            pad(diagnostics()),
        }),
        z = table.concat({
            "%#", mode_hl, "#", position(),
        }),
    }

    return table.concat({
        " %#StatusLineBorderA#",
        sections.a,
        (#sections.b ~= 0) and "%#StatusLineBorderAB#" or "%#StatusLineBorderAC#",

        "%#StatusLineB#",
        sections.b,
        (#sections.b ~= 0) and "%#StatusLineBorderBC#" or "",

        "%#StatusLineC#",
        sections.c,

        -- right align
        "%=",
        sections.x,

        (#sections.y ~= 0) and "%#StatusLineBorderBC#" or "",
        "%#StatusLineB#",
        sections.y,

        (#sections.y == 0) and "%#StatusLineBorderAC#" or "%#StatusLineBorderAB#",
        sections.z,
        "%#StatusLineBorderA# ",
    })
end

function M.setup()
    vim.opt.statusline = "%!v:lua.__statusline()"

    local group = vim.api.nvim_create_augroup("user.statusline", {})
    vim.api.nvim_create_autocmd({ "ModeChanged", "DiagnosticChanged" }, {
        group = group,
        callback = function()
            vim.cmd.redrawstatus()
        end,
    })
end

return M
