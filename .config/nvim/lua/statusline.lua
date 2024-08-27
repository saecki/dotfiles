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

local devicons = package.loaded["nvim-web-devicons"]
local statusline_c_hl_group = vim.api.nvim_get_hl(0, { name = "StatusLineC" })
local function filetype()
    local ft = vim.bo.filetype
    if ft and devicons then
        local icon, icon_hl = devicons.get_icon(vim.fn.expand('%:t'))
        if icon == nil then
            icon, icon_hl = devicons.get_icon_by_filetype(ft)
        end

        if not icon then
            return ft
        end

        -- create highlight group with statusline background
        local sl_icon_hl = "StatusLine" .. icon_hl
        if vim.fn.hlexists(sl_icon_hl) ~= 1 then
            local icon_hl_group = vim.api.nvim_get_hl(0, { name = icon_hl })
            vim.api.nvim_set_hl(0, sl_icon_hl, {
                fg = icon_hl_group.fg,
                bg = statusline_c_hl_group.bg,
            })
        end
        return string.format("%%#%s#%s %%#StatusLineC#%s", sl_icon_hl, icon, ft)
    end
    return ft
end
function M.load_devicons()
    devicons = require("nvim-web-devicons")
end

local function position()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local linecount = math.max(2, vim.api.nvim_buf_line_count(0))
    local linedigits = math.floor(math.log10(linecount)) + 1

    local template = " %" .. linedigits .. "d:%-3d"
    return string.format(template, cursor[1], cursor[2])
end

---@class GitRootCache
---@field path string?

---@type table<integer,GitRootCache>
local git_root_cache = {}

---@class GitHeadCache
---@field stat_time integer
---@field mtime integer
---@field rev string?

---@type table<string,GitHeadCache>
local git_head_cache = {}
local function git_rev()
    local buf = vim.api.nvim_get_current_buf()

    local root_cache = git_root_cache[buf]
    local git_root = nil
    if root_cache then
        git_root = root_cache.path
    else
        git_root = vim.fs.root(buf, ".git")
        git_root_cache[buf] = { path = git_root }
    end
    if not git_root then
        return nil
    end

    local one_second = 1000000000
    local now = vim.uv.hrtime()
    local cache = git_head_cache[git_root]
    if cache and now < cache.stat_time + one_second then
        return cache.rev
    end

    local head_path = vim.fs.joinpath(git_root, ".git/HEAD")
    local head_stat = vim.uv.fs_stat(head_path)
    if cache and cache.mtime == head_stat.mtime.sec then
        cache.stat_time = now
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

    git_head_cache[git_root] = {
        stat_time = now,
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

function STATUSLINE()
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
            pad(filetype()),
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
    vim.opt.statusline = "%!v:lua.STATUSLINE()"

    local group = vim.api.nvim_create_augroup("user.statusline", {})
    vim.api.nvim_create_autocmd({ "ModeChanged", "DiagnosticChanged" }, {
        group = group,
        callback = function()
            vim.cmd.redrawstatus()
        end,
    })

    -- invalidate git buffer cache when file name changes
    vim.api.nvim_create_autocmd("BufFilePost", {
        group = group,
        callback = function(ev)
            git_root_cache[ev.buf] = nil
        end,
    })
end

return M
