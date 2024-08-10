local M = {}

local win_hl_ns = vim.api.nvim_create_namespace("user.util.input.win_hl")
local buf_hl_ns = vim.api.nvim_create_namespace("user.util.input.buf_hl")

function M.input(opts, on_confirm)
    local cword = vim.fn.expand("<cword>")
    local text = opts.text or cword or ""
    local text_width = vim.fn.strdisplaywidth(text)

    M.confirm_opts = {}
    M.on_confirm = on_confirm
    M.min_width = 1
    if cword then
        M.min_width = vim.fn.strdisplaywidth(cword)
    end

    -- create buf
    M.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(M.buf, 0, 1, false, { text })

    -- get word start
    local old_pos = vim.api.nvim_win_get_cursor(0)
    vim.fn.search(cword, "bc")
    local new_pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, { old_pos[1], old_pos[2] })
    local col = 0
    if new_pos[1] == old_pos[1] then
        col = new_pos[2] - old_pos[2]
    end

    -- create win
    local win_opts = {
        relative = "cursor",
        col = col,
        row = 0,
        width = math.max(text_width + 1, M.min_width),
        height = 1,
        style = "minimal",
        border = "none",
    }
    M.win = vim.api.nvim_open_win(M.buf, false, win_opts)

    -- highlights and transparency
    -- vim.api.nvim_set_option_value("winblend", 100, {
    --     scope = "local",
    --     win = M.win,
    -- })
    vim.api.nvim_set_hl(win_hl_ns, "Normal", { fg = nil, bg = nil })
    vim.api.nvim_win_set_hl_ns(M.win, win_hl_ns)

    -- key mappings
    vim.api.nvim_buf_set_keymap(M.buf, "n", "<cr>", "", { callback = M.submit, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(M.buf, "v", "<cr>", "", { callback = M.submit, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(M.buf, "i", "<cr>", "", { callback = M.submit, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(M.buf, "n", "<esc>", "", { callback = M.hide, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(M.buf, "n", "q", "", { callback = M.hide, noremap = true, silent = true })

    -- automatically resize
    local group = vim.api.nvim_create_augroup("user.util.input", {})
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP" }, {
        group = group,
        buffer = M.buf,
        callback = M.resize,
    })

    -- focus and enter insert mode
    vim.api.nvim_set_current_win(M.win)
    if opts.insert then
        vim.cmd.startinsert()
    end
    vim.api.nvim_win_set_cursor(M.win, { 1, text_width })
end

function M.resize()
    local new_text = vim.api.nvim_buf_get_lines(M.buf, 0, 1, false)[1]
    local new_text_width = vim.fn.strdisplaywidth(new_text)
    local width = math.max(new_text_width + 1, M.min_width)

    vim.api.nvim_buf_clear_namespace(M.buf, buf_hl_ns, 0, -1)
    vim.api.nvim_buf_add_highlight(M.buf, buf_hl_ns, "Selection", 0, 0, -1)

    vim.api.nvim_win_set_width(M.win, width)
end

function M.submit()
    local new_text = vim.api.nvim_buf_get_lines(M.buf, 0, 1, false)[1]
    M.hide()

    if M.on_confirm then
        M.on_confirm(new_text)
        M.on_confirm = nil
    end
end

function M.hide()
    local mode = vim.api.nvim_get_mode().mode;
    if mode == "i" then
        vim.cmd.stopinsert()
    end

    if M.win and vim.api.nvim_win_is_valid(M.win) then
        vim.api.nvim_win_close(M.win, false)
    end
    M.win = nil

    if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
        vim.api.nvim_buf_delete(M.buf, {})
    end
    M.buf = nil
end

return M
