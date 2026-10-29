local M = {}

---@class QFList
---@field id integer
---@field title string?
---@field vsplit boolean

local hl_ns = vim.api.nvim_create_namespace("user.config.lsp.server.dartls.hl")

---@type { symbol: string, hl: string }[]
local type_signs = {}

---Get the window id of the currently open quickfix window.
---@return integer?
local function get_quickfix_window()
    for _, wininfo in ipairs(vim.fn.getwininfo()) do
        if wininfo.quickfix == 1 then
            return wininfo.winid
        end
    end
end

---Get the the last quickfix list and context assoctiated with it.
---@return QFList?
local function get_last_quickfix_list()
    local last_list = vim.fn.getqflist({ nr = "$", id = 0, title = 0, context = 0 })
    if not last_list then
        return nil
    end

    -- Store the preferred position of the quickfix window in the list context.
    local vsplit = type(last_list.context) == "table"
        and last_list.context.vsplit

    return {
        id = last_list.id,
        title = last_list.title,
        vsplit = vsplit,
    }
end

-- Update the quickfix window position.
---@param vsplit boolean
local function update_quickfix_position(winid, vsplit)
    if vsplit then
        vim.api.nvim_set_current_win(winid)
        vim.cmd.wincmd("L")
        vim.api.nvim_win_set_width(0, 90)
    else
        vim.api.nvim_set_current_win(winid)
        vim.cmd.wincmd("J")
        vim.api.nvim_win_set_height(0, 10)
    end
end

function M.toggle_position()
    local last_list = get_last_quickfix_list()
    if not last_list then return end

    local vsplit = not last_list.vsplit

    -- Update the context of the quickfix list.
    vim.fn.setqflist({}, "a", {
        id = last_list.id,
        context = { vsplit = vsplit },
        items = {}
    })

    local winid = get_quickfix_window()
    if not winid then
        vim.cmd.copen()
        winid = vim.api.nvim_get_current_win()
    end

    update_quickfix_position(winid, vsplit)
end

function M.show(title, vsplit, items)
    local last_list = get_last_quickfix_list()
    if last_list and last_list.title ~= title then
        last_list = nil
    end

    -- Update existing diagnostic quickfix list if it's the last one.
    local quickfix_id = last_list and last_list.id or nil

    local context = {}

    -- Reuse existing vsplit configuration, otherwise use preferred one.
    context.vsplit = last_list and last_list.vsplit
    if context.vsplit == nil then
        context.vsplit = vsplit
    end

    vim.fn.setqflist({}, quickfix_id and 'u' or ' ', {
        id = quickfix_id,
        title = title,
        context = context,
        items = items,
    })

    M.open()
end

function M.open()
    vim.cmd.copen()

    local last_list = get_last_quickfix_list()
    update_quickfix_position(0, last_list and last_list.vsplit or false)
end

function M.toggle()
    if get_quickfix_window() then
        vim.cmd.cclose()
    else
        M.open()
    end
end

-- Inspiration taken from `pqf.nvim`.
local function apply_highlights(buf, highlights)
    assert(buf ~= nil)
    for _, hl in ipairs(highlights) do
        vim.api.nvim_buf_set_extmark(buf, hl_ns, hl.line, hl.start_col, {
            end_col = hl.end_col,
            hl_group = hl.group,
        })
    end
end

-- `syntax/qf.vim` clears the default highlighting
function QUICKFIXTEXTFUNC(info)
    local list = vim.fn.getqflist({ id = info.id, qfbufnr = 0, items = 0 })

    local has_signs = false
    for _, item in ipairs(list.items) do
        has_signs = item.type ~= ""
    end

    local lines = {}
    local highlights = {}

    for idx = info.start_idx, info.end_idx do
        local line = ""
        local function push(text, group)
            local start_col = line:len()
            line = line .. text

            if group then
                local end_col = line:len()
                table.insert(highlights, {
                    line = idx - 1,
                    start_col = start_col,
                    end_col = end_col,
                    group = group,
                })
            end
        end

        local item = list.items[idx]
        if has_signs then
            local symbol = item.type
            local hl = "Special"

            local sign = type_signs[item.type]
            if sign then
                symbol = sign.symbol
                hl = sign.hl
            end
            push(symbol .. " ", hl)
        end

        local path = vim.fn.fnamemodify(vim.fn.bufname(item.bufnr), ":p:.")
        local text = vim.split(item.text, "\n")[1]

        push(path, "qfFileName")
        push(":", "qfSeparator")
        push(item.lnum, "qfLineNr")
        push(" ")
        push(text, "qfText")

        table.insert(lines, line)
    end

    vim.schedule(function()
        apply_highlights(list.qfbufnr, highlights)
    end)

    return lines
end

---@param signs table<string, { symbol: string, hl: string }>
function M.add_type_signs(signs)
    for type, sign in pairs(signs) do
        type_signs[type] = sign
    end
end

function M.setup()
    vim.opt.quickfixtextfunc = "v:lua.QUICKFIXTEXTFUNC"

    vim.keymap.set("n", "<leader>q", M.toggle, { desc = "Toggle quickfix list" })
    vim.keymap.set("n", "<leader>Q", M.toggle_position, { desc = "Toggle quickfix list position" })
end

return M
