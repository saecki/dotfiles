local quickfix = require("quickfix")

local M = {}

local hls = {
    error = { "DiagnosticError" },
    warn = { "DiagnosticWarn" },
    todo = { "Todo" },
    info = { "DiagnosticInfo" },
}

local keywords = {
    F = { symbol = " FIXME", hl = hls.error, kws = { "FIXME", "FIX" } },
    S = { symbol = " STOPSHIP", hl = hls.error, kws = { "STOPSHIP" } },
    A = { symbol = " HACK", hl = hls.warn, kws = { "HACK" } },
    T = { symbol = " TODO", hl = hls.todo, kws = { "TODO", "todo!" } },
    P = { symbol = "󰅒 PERF", hl = hls.todo, kws = { "PERF" } },
    O = { symbol = " IMPORTANT", hl = hls.todo, kws = { "IMPORTANT" } },
    V = { symbol = " VOLATILE", hl = hls.info, kws = { "VOLATILE" } },
    N = { symbol = "󰎚 NOTE", hl = hls.info, kws = { "NOTE", "INFO" } },
}

local keywords_pattern
do
    local kws = {}
    for _, keyword in pairs(keywords) do
        vim.list_extend(kws, keyword.kws)
    end
    table.sort(kws, function(a, b)
        return #b < #a
    end)
    keywords_pattern = [[\b(]] .. table.concat(kws, "|") .. [[)]]
end

local type_lut = {}
for type, keyword in pairs(keywords) do
    for _, kw in ipairs(keyword.kws) do
        type_lut[kw] = type
    end
end

---@param stdout string
local function parse(stdout)
    local matches = {}
    local lines = vim.split(stdout, "\n", { trimempty = true })
    for _, line in ipairs(lines) do
        local message = vim.json.decode(line)
        if message.type == "match" then
            local match = message.data

            for _, submatch in ipairs(match.submatches) do
                local type = type_lut[submatch.match.text]
                local col = tonumber(submatch.start)
                local text = match.lines.text:sub(col)

                table.insert(matches, {
                    filename = match.path.text,
                    lnum = tonumber(match.line_number),
                    col = col,
                    text = text,
                    type = type,
                })
            end
        end
    end
    return matches
end

local function search_todos()
    local cwd = vim.fn.fnamemodify(".", ":p")
    local command = { "rg", "--json", keywords_pattern }

    local command_opts = {
        timeout = 3000,
        cwd = cwd,
    }
    vim.system(command, command_opts, vim.schedule_wrap(function(res)
        if res.code == 0 then
            local matches = parse(res.stdout)
            quickfix.show("TODOs", true, matches)
        else
            vim.print("error searching todos:", res)
        end
    end))
end

function M.setup()
    quickfix.add_type_signs(keywords)

    vim.keymap.set("n", "<leader>lt", search_todos, { desc = "TODO comments" })
end

return M
