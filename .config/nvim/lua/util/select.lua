local shared = require("shared")

local M = {}

local hl_ns = vim.api.nvim_create_namespace("user.util.select.hl")

local calculate_popup_width = function(entries)
    local result = 0

    for _, entry in ipairs(entries) do
        local width = vim.fn.strdisplaywidth(entry)
        result = math.max(result, width)
    end

    result = result + 2

    local num_entries = #entries
    local num_width = 2
    while num_entries >= 10 do
        num_entries = num_entries / 10
        num_width = num_width + 1
    end

    local win_width = result + num_width
    return win_width, num_width
end

local format_entries = function(entries, formatter)
    local format_item = formatter or tostring

    local results = {}

    for _, entry in pairs(entries) do
        table.insert(results, string.format("%s", format_item(entry)))
    end

    return results
end

local function hide()
    if M.win and vim.api.nvim_win_is_valid(M.win) then
        vim.api.nvim_win_close(M.win, false)
    end
    M.win = nil

    if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
        vim.api.nvim_buf_delete(M.buf, {})
    end
    M.buf = nil
end

local function highlight()
    local row = vim.api.nvim_win_get_cursor(M.win)[1] - 1
    vim.api.nvim_buf_clear_namespace(M.buf, hl_ns, 0, -1)
    vim.api.nvim_buf_set_extmark(M.buf, hl_ns, row, 0, {
        end_row = row + 1,
        hl_group = "Selection",
    })
end

-- 1 based index
function M.confirm(index)
    if index == nil then
        index = vim.api.nvim_win_get_cursor(M.win)[1]
    end
    hide()
    if M.on_choice and M.items and M.items[index] then
        M.on_choice(M.items[index], index)
    end
end

function M.cancel()
    hide()
    if M.on_choice then
        M.on_choice()
    end
end

function M.select(items, opts, on_choice)
    assert(items ~= nil and not vim.tbl_isempty(items), "No entries available.")

    -- close still open window
    hide()

    M.items = items
    M.on_choice = on_choice

    local formatted_items = format_entries(items, opts.format_item)
    local width, num_width = calculate_popup_width(formatted_items)

    -- create buf
    M.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(M.buf, 0, 1, false, formatted_items)
    vim.api.nvim_set_option_value("filetype", "markdown", { buf = M.buf })
    vim.api.nvim_set_option_value("modifiable", false, { buf = M.buf })

    -- get word start
    local old_pos = vim.api.nvim_win_get_cursor(0)
    vim.fn.search(vim.fn.expand("<cword>"), "bc")
    local new_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { old_pos[1], old_pos[2] })
    local col = 0
    if new_pos[1] == old_pos[1] then
        col = new_pos[2] - old_pos[2]
    end

    -- create win
    local win_opts = {
        relative = "cursor",
        col = col - (num_width + 1),
        row = 1,
        width = width,
        height = #items,
        style = "minimal",
        border = shared.window.border,
    }
    M.win = vim.api.nvim_open_win(M.buf, false, win_opts)

    -- key mappings
    local keymap_opts = { buffer = M.buf, silent = true }
    vim.keymap.set("n", "<cr>", function() M.confirm() end, keymap_opts)
    for i = 1, math.min(#formatted_items, 9) do
        vim.keymap.set("n", tostring(i), function() M.confirm(i) end, keymap_opts)
    end
    vim.keymap.set("n", "<esc>", M.cancel, keymap_opts)
    vim.keymap.set("n", "q", M.cancel, keymap_opts)

    -- highlight current line
    local group = vim.api.nvim_create_augroup("user.util.select", {})
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = group,
        buffer = M.buf,
        callback = highlight,
    })

    -- focus window
    vim.api.nvim_set_current_win(M.win)
    highlight()

    vim.wo[M.win].number = true
    vim.wo[M.win].numberwidth = num_width
end

function M.setup()
    vim.ui.select = M.select
end

return M
