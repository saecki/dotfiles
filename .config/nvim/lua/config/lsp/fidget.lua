-- Stolen from https://github.com/j-hui/fidget.nvim

local M = {}

local options = {
    text = {
        spinner = {
            "⠋",
            "⠙",
            "⠹",
            "⠸",
            "⠼",
            "⠴",
            "⠦",
            "⠧",
            "⠇",
            "⠏",
        },
        done = "",
        commenced = "",
        completed = "",
    },
    window = {
        blend = 100,
    },
    timer = {
        throttle_rate = 50,
        spinner_rate = 50,
        fidget_decay = 1500,
        task_decay = 800,
    },
    fmt = {
        max_messages = 8,
        max_width = 50,
    },
}

local function fmt_fidget(fidget_name, spinner)
    return string.format("%s %s", spinner, fidget_name)
end

local function fmt_task(task_name, message, percentage)
    message = message or ""
    if percentage then
        message = string.format("(%.0f%%) %s", percentage, message)
    end
    if task_name then
        message = string.format("%s [%s]", message, task_name)
    end
    return message
end

---@type table<integer,Fidget>
local fidgets = {}

local function render_fidgets()
    local offset = 0
    for client_id, fidget in pairs(fidgets) do
        if vim.lsp.buf_is_attached(0, client_id) then
            offset = offset + fidget:show(offset)
        else
            fidget:close()
        end
    end
end

---@class Task
---@field title string?
---@field message string?
---@field percentage integer?

---@class Fidget
---@field key string
---@field name string
---@field bufid integer?
---@field winid integer?
---@field tasks Task[]
---@field lines string[]
---@field spinner_idx integer
---@field max_line_len integer
---@field closed boolean
local Fidget = {}

local last_call = 0;
local timer = nil
function Fidget:throttled_draw()
    -- Make sure to stop any scheduled timers
    if timer then
        return
    end

    local rem = options.timer.throttle_rate - (vim.loop.now() - last_call)
    -- Schedule a tail call
    if rem > 0 then
        -- Reuse timer
        if timer == nil then
            timer = vim.loop.new_timer()
        end

        timer:start(rem, 0, vim.schedule_wrap(function()
            timer:stop()
            timer:close()
            timer = nil

            last_call = vim.loop.now()
            vim.schedule(function()
                self:draw()
            end)
        end))
    else
        last_call = vim.loop.now()
        vim.schedule(function()
            self:draw()
        end)
    end
end

function Fidget:draw()
    -- Substitute tabs into spaces, to make strlen easier to count.
    local function subtab(s)
        return s and s:gsub("\t", "  ") or nil
    end
    local strlen = vim.fn.strdisplaywidth

    local spinner = self.spinner_idx == -1 and options.text.done
        or options.text.spinner[self.spinner_idx + 1]
    local line = fmt_fidget(self.name, spinner)
    self.lines = { line }
    self.max_line_len = strlen(line)
    for _, task in pairs(self.tasks) do
        line = fmt_task(subtab(task.title), subtab(task.message), task.percentage)
        if line and #self.lines < options.fmt.max_messages then
            table.insert(self.lines, 1, line)
            self.max_line_len = math.max(self.max_line_len, strlen(line))
        end
    end

    -- Never try to output any text wider than what we are aligning to.
    self.max_line_len = math.min(self.max_line_len, vim.opt.columns:get())

    if options.fmt.max_width > 0 then
        self.max_line_len = math.min(self.max_line_len, options.fmt.max_width)
    end

    for i, s in ipairs(self.lines) do
        if strlen(s) > self.max_line_len then
            -- truncate
            self.lines[i] = vim.fn.strcharpart(s, 0, self.max_line_len - 1) .. "…"
        else
            -- pad
            self.lines[i] = string.rep(" ", self.max_line_len - strlen(s)) .. s
        end
    end

    render_fidgets()
end

local function splits_on_newlines(lines)
    local result = {}
    for _, line in ipairs(lines) do
        if line:match("\n") then
            for _, subline in ipairs(vim.split(line, "\n")) do
                table.insert(result, subline)
            end
        else
            table.insert(result, line)
        end
    end
    return result
end

function Fidget:show(offset)
    local height = #self.lines
    local width = self.max_line_len

    if height == 0 or width == 0 then
        -- Nothing to show
        self:close()
        return offset
    end

    local statusline_height = 1
    local row = vim.opt.lines:get() - (statusline_height + vim.opt.cmdheight:get() + offset)
    local col = vim.opt.columns:get()

    if self.bufid == nil or not vim.api.nvim_buf_is_valid(self.bufid) then
        self.bufid = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_option_value("filetype", "fidget", { buf = self.bufid })
    end
    if self.winid == nil or not vim.api.nvim_win_is_valid(self.winid) then
        self.winid = vim.api.nvim_open_win(self.bufid, false, {
            relative = "editor",
            anchor = "SE",
            row = row,
            col = col,
            width = width,
            height = height,
            focusable = false,
            style = "minimal",
            noautocmd = true,
            border = "none",
        })
        vim.api.nvim_set_option_value("winblend", options.window.blend, { win = self.winid })
        vim.api.nvim_set_option_value("winhighlight", "Normal:FidgetTask", { win = self.winid })
    else
        vim.api.nvim_win_set_config(self.winid, {
            relative = "editor",
            anchor = "SE",
            row = row,
            col = col,
            width = width,
            height = height,
        })
    end

    self.lines = splits_on_newlines(self.lines) -- handle lines that might contain a "\n" character
    pcall(vim.api.nvim_buf_set_lines, self.bufid, 0, height, false, self.lines)
    vim.api.nvim_buf_add_highlight(self.bufid, -1, "FidgetTitle", height - 1, 0, -1)

    local next_offset = #self.lines + offset
    return next_offset
end

function Fidget:kill_task(task)
    self.tasks[task] = nil
    self:draw()
end

function Fidget:has_tasks()
    return next(self.tasks)
end

function Fidget:close()
    -- NOTE: this function is not reentrant, and may be the source of silly races.
    -- Time will tell.

    if self.winid ~= nil and vim.api.nvim_win_is_valid(self.winid) then
        vim.api.nvim_win_hide(self.winid)
        self.winid = nil
    end
    if self.bufid ~= nil and vim.api.nvim_buf_is_valid(self.bufid) then
        -- If the fidget buffer becomes the current one after closing the fidget
        -- window, this most likely means that vim is exiting, although VimLeavePre
        -- autocmd was not executed yet.
        -- Deleting the buffer at this point causes a Neovim crash.
        -- We let the buffer be - it will be deleted automatically on vim exit.
        if self.bufid ~= vim.api.nvim_get_current_buf() then
            -- wrap nvim_buf_delete to ignore E11 (#136)
            pcall(vim.api.nvim_buf_delete, self.bufid, { force = true })
        end
        self.bufid = nil
    end

    -- Remove a fidget after window/buffer deletion is successful (see #68)
    fidgets[self.key] = nil
    self.closed = true
end

function Fidget:spin()
    local function do_spin(idx, continuation, delay)
        self.spinner_idx = idx
        self:draw()
        vim.defer_fn(continuation, delay)
    end

    local function do_kill()
        self:close()
        render_fidgets()
    end

    local function spin_again()
        self:spin()
    end

    if self.closed then
        return
    end

    if self:has_tasks() then
        local next_idx = (self.spinner_idx + 1) % #options.text.spinner
        do_spin(next_idx, spin_again, options.timer.spinner_rate)
    else
        if options.timer.fidget_decay > 0 then
            -- kill later; indicate done for now
            do_spin(-1, function()
                if self:has_tasks() then
                    do_spin(0, spin_again, options.timer.spinner_rate)
                else
                    do_kill()
                end
            end, options.timer.fidget_decay)
        else
            -- kill now
            do_kill()
        end
    end
end

function Fidget.new(key, name)
    local fidget = {
        key = key,
        name = name,
        tasks = {},
        lines = {},
        spinner_idx = 0,
        max_line_len = 0,
        closed = false,
    }
    setmetatable(fidget, { __index = Fidget })
    if options.timer.spinner_rate > 0 then
        vim.defer_fn(function()
            fidget:spin()
        end, options.timer.spinner_rate)
    end
    return fidget
end

local vim_closing = false

local function handle_progress(_, msg, info)
    -- See: https://microsoft.github.io/language-server-protocol/specifications/specification-current/#progress
    if vim_closing then
        return
    end

    local token = msg.token
    local val = msg.value

    if not token then
        -- Notification missing required token??
        return
    end

    local client_id = info.client_id
    local client = vim.lsp.get_client_by_id(info.client_id)
    if not client then
        return
    end
    local client_name = client.name

    -- Create entry if missing
    if fidgets[client_id] == nil then
        fidgets[client_id] = Fidget.new(client_id, client_name)
    end
    local fidget = fidgets[client_id]
    if fidget.tasks[token] == nil then
        fidget.tasks[token] = {}
    end
    local task = fidget.tasks[token]

    -- Update progress state
    if val.kind == "begin" then
        task.title = val.title
        task.message = options.text.commenced
    elseif val.kind == "report" then
        if val.percentage then
            task.percentage = val.percentage
        end
        if val.message then
            task.message = val.message
        end
    elseif val.kind == "end" then
        if task.percentage then
            task.percentage = 100
        end
        task.message = options.text.completed
        if options.timer.task_decay > 0 then
            vim.defer_fn(function()
                fidget:kill_task(token)
            end, options.timer.task_decay)
        elseif options.timer.task_decay == 0 then
            fidget:kill_task(token)
        end
    else
        -- Invalid progress notification from, unrecognized kind
        fidget:kill_task(token)
    end

    fidget:throttled_draw()
end

function M.close(...)
    local args = { n = select("#", ...), ... }
    local function do_close(client_id)
        if fidgets[client_id] ~= nil then
            fidgets[client_id]:close()
        end
    end

    if args.n == 0 then
        for client_id, _ in pairs(fidgets) do
            do_close(client_id)
        end
    else
        for i = 1, args.n do
            do_close(args[i])
        end
    end

    render_fidgets()
end

function M.setup()
    if vim.lsp.handlers["$/progress"] then
        local old_handler = vim.lsp.handlers["$/progress"]
        vim.lsp.handlers["$/progress"] = function(...)
            old_handler(...)
            handle_progress(...)
        end
    else
        vim.lsp.handlers["$/progress"] = handle_progress
    end

    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            vim_closing = true
            M.close()
        end
    })

    vim.api.nvim_set_hl(0, "FidgetTitle", { default = true, link = "Statement" })
    vim.api.nvim_set_hl(0, "FidgetTask", { default = true, link = "NonText" })
end

return M
