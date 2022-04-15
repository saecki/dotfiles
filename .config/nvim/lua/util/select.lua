local M = {
    namespace = vim.api.nvim_create_namespace("util.select"),
}

local shared = require("shared")

local calculate_popup_width = function(entries)
    local result = 0

    for _, entry in ipairs(entries) do
        local width = vim.fn.strdisplaywidth(entry)
        if width > result then
            result = #entry
        end
    end

    if #entries < 10 then
        return result + 2
    else
        return result + 3
    end
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

function M.highlight()
    local row = vim.api.nvim_win_get_cursor(M.win)[1] - 1
    vim.api.nvim_buf_clear_namespace(M.buf, M.namespace, 0, -1)
    vim.api.nvim_buf_add_highlight(M.buf, M.namespace, "Underlined", row, 0, -1)
end

-- 1 based index
function M.confirm(index)
    if index == nil then
        index = vim.api.nvim_win_get_cursor(M.win)[1]
    end
    if M.on_choice and M.items and M.items[index] then
        M.on_choice(M.items[index], index)
    end
    hide()
end

function M.cancel()
    if M.on_choice then
        M.on_choice()
    end
    hide()
end

function M.select(items, opts, on_choice)
    assert(items ~= nil and not vim.tbl_isempty(items), "No entries available.")

    M.items = items
    M.on_choice = on_choice

    local formatted_items = format_entries(items, opts.format_item)
    local width = calculate_popup_width(formatted_items)

    -- create buf
    M.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(M.buf, 0, 1, false, formatted_items)
    vim.api.nvim_buf_set_option(M.buf, "modifiable", false)

    -- get word start
    local old_pos = vim.api.nvim_win_get_cursor(0)
    vim.fn.search(vim.fn.expand("<cword>"), "bc")
    local new_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { old_pos[1], old_pos[2] })
    local col = new_pos[2] - old_pos[2]

    -- create win
    local win_opts = {
        relative = "cursor",
        col = col,
        row = 0,
        width = width,
        height = #items,
        style = "minimal",
        border = shared.window.border,
    }
    M.win = vim.api.nvim_open_win(M.buf, false, win_opts)

    -- key mappings
    local confirm_cmd = "<cmd>lua require('util.select').confirm()<cr>"
    vim.api.nvim_buf_set_keymap(M.buf, "n", "<cr>", confirm_cmd, { noremap = true, silent = true })
    for i = 1, math.min(#formatted_items, 9) do
        local confirm_index_cmd = string.format("<cmd>lua require('util.select').confirm(%s)<cr>", i)
        vim.api.nvim_buf_set_keymap(M.buf, "n", tostring(i), confirm_index_cmd, { noremap = true, silent = true })
    end
    local cancel_cmd = "<cmd>lua require('util.select').cancel()<cr>"
    vim.api.nvim_buf_set_keymap(M.buf, "n", "<esc>", cancel_cmd, { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(M.buf, "n", "q", cancel_cmd, { noremap = true, silent = true })

    -- automatically resize
    vim.cmd("augroup UtilSelectWindow")
    vim.cmd("autocmd CursorMoved,CursorMovedI <buffer=" .. M.buf .. "> lua require('util.select').highlight()")
    vim.cmd("augroup END")

    -- focus window
    vim.api.nvim_set_current_win(M.win)
    M.highlight()

    vim.opt_local.number = true
    if #formatted_items < 10 then
        vim.opt_local.numberwidth = 2
    else
        vim.opt_local.numberwidth = 3
    end
end

function M.setup()
    vim.ui.select = M.select
end

return M
