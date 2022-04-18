local M = {
    namespace = vim.api.nvim_create_namespace("util.input"),
}

function M.input(text, insert, callback)
    local cword = vim.fn.expand("<cword>")
    text = text or cword or ""
    local text_width = vim.fn.strdisplaywidth(text)

    M.callback = callback
    M.mode = vim.fn.mode()
    M.min_width = 1
    if cword then
        M.min_width = vim.fn.strdisplaywidth(cword)
    end

    -- create buf
    M.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(M.buf, 0, 1, false, { text })

    -- get word start
    local old_pos = vim.api.nvim_win_get_cursor(0)
    vim.fn.search(vim.fn.expand("<cword>"), "bc")
    local new_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { old_pos[1], old_pos[2] })
    local col = new_pos[2] - old_pos[2]

    -- create win
    local opts = {
        relative = "cursor",
        col = col,
        row = 0,
        width = math.max(text_width + 1, M.min_width),
        height = 1,
        style = "minimal",
        border = "none",
    }
    M.win = vim.api.nvim_open_win(M.buf, false, opts)

    -- key mappings
    vim.api.nvim_buf_set_keymap(M.buf, "n", "<cr>", "", { callback = M.submit, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(M.buf, "v", "<cr>", "", { callback = M.submit, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(M.buf, "i", "<cr>", "", { callback = M.submit, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(M.buf, "n", "<esc>", "", { callback = M.hide, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(M.buf, "n", "q", "", { callback = M.hide, noremap = true, silent = true })

    -- automatically resize
    local group = vim.api.nvim_create_augroup("UtilInputWindow", {})
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP" }, {
        group = group,
        buffer = M.buf,
        callback = M.resize,
    })

    -- focus and enter insert mode
    vim.api.nvim_set_current_win(M.win)
    if insert then
        vim.cmd("startinsert")
    end
    vim.api.nvim_win_set_cursor(M.win, { 1, text_width })
end

function M.resize()
    local new_text = vim.api.nvim_buf_get_lines(M.buf, 0, 1, false)[1]
    local new_text_width = vim.fn.strdisplaywidth(new_text)
    local width = math.max(new_text_width + 1, M.min_width)

    vim.api.nvim_win_set_width(M.win, width)
    vim.api.nvim_buf_clear_namespace(M.buf, M.namespace, 0, -1)
    vim.api.nvim_buf_add_highlight(M.buf, M.namespace, "Underlined", 0, 0, -1)
end

function M.submit()
    local new_text = vim.api.nvim_buf_get_lines(M.buf, 0, 1, false)[1]
    M.hide()

    if M.callback then
        M.callback(new_text)
        M.callback = nil
    end
end

function M.hide()
    if M.win and vim.api.nvim_win_is_valid(M.win) then
        vim.api.nvim_win_close(M.win, false)
    end
    M.win = nil

    if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
        vim.api.nvim_buf_delete(M.buf, {})
    end
    M.buf = nil

    if M.mode == "i" and vim.fn.mode() ~= "i" then
        vim.cmd("startinsert")
    elseif M.mode ~= "i" and vim.fn.mode() == "i" then
        local pos = vim.api.nvim_win_get_cursor(0)
        pos[2] = pos[2] + 1
        vim.api.nvim_win_set_cursor(0, pos)
        vim.cmd("stopinsert")
    end
end

return M
