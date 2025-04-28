local shared = require("shared")

local M = {}

local lock_file_path = vim.fs.joinpath(vim.fn.stdpath("config"), "/plugs.lock")
local plugs_path = vim.fs.joinpath(vim.fn.stdpath("data"), "/site/pack/plugs/opt/")
local projects_path = vim.fn.expand("~/Projects/")

local async = {}

---@param f function
---@param ... any
function async.launch(f, ...)
    local t = coroutine.create(f)
    local function exec(...)
        local ok, data = coroutine.resume(t, ...)
        if not ok then
            error(debug.traceback(t, data))
        end
        if coroutine.status(t) ~= "dead" then
            data(exec)
        end
    end
    exec(...)
end

---@class PlugSpec
---@field source string
---@field checkout string?
---@field deps (DepSpec|string)[]?
---@field post_checkout fun()?

---@class DepSpec
---@field source string
---@field checkout string?

---@class Plugin
---@field spec PlugSpec|DepSpec
---@field run_post_checkout boolean
---@field managed boolean
---@field log string[]

-- whether to update the lock-file
local in_progress = 0
local global_log = {
    ---@type {[1]: string, [2]: string}[]
    pre = {},
    ---@type {[1]: string, [2]: string}[]
    post = {},

    PRE = -1,
    POST = -2,
}
---@type Plugin[]
local plugins = {}
---@type string[]
local setup_queue = {}

---@class PopupCtx
---@field win integer
---@field buf integer

---@class PlugsUiState
---@field plugs PlugUiState[]
---@field last_line integer

---@class PlugUiState
---@field line integer
---@field expanded boolean

---@type PopupCtx?
local popup_ctx = nil
local popup_ns = vim.api.nvim_create_namespace("user.plugman.win")
---@type PlugsUiState
local ui_state = {
    plugs = {},
    last_line = 0,
}
local render_scheduled = false

---@return PopupCtx
local function init_popup()
    -- create buf
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].modifiable = false

    -- create win
    local margin_x = 8
    local margin_y = 3
    local border = 2
    local width = vim.opt.columns:get() - 2 * margin_x - border
    local height = vim.opt.lines:get() - 2 * margin_y - border
    local win_opts = {
        relative = "editor",
        col = margin_x,
        row = margin_y,
        width = width,
        height = height,
        style = "minimal",
        border = shared.window.border,
    }
    local win = vim.api.nvim_open_win(buf, false, win_opts)
    vim.wo[win].wrap = false
    vim.schedule(function()
        vim.api.nvim_set_current_win(win)
    end)

    -- key mappings
    vim.keymap.set("n", "zo", M.log_fold_open, { buffer = buf })
    vim.keymap.set("n", "zc", M.log_fold_close, { buffer = buf })
    vim.keymap.set("n", "za", M.log_fold_toggle, { buffer = buf })

    vim.keymap.set("n", "zR", M.log_folds_open_all, { buffer = buf })
    vim.keymap.set("n", "zM", M.log_folds_close_all, { buffer = buf })
    vim.keymap.set("n", "zX", M.log_folds_toggle_all, { buffer = buf })

    vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf })
    vim.keymap.set("n", "<esc>", "<cmd>q<cr>", { buffer = buf })

    -- clean up when window is closed
    local group = vim.api.nvim_create_augroup("user.plugman.popup", {})
    vim.api.nvim_create_autocmd("WinClosed", {
        group = group,
        buffer = buf,
        callback = function()
            if vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_buf_delete(buf, {})
            end
            popup_ctx = nil
        end,
        once = true,
    })

    return {
        win = win,
        buf = buf,
    }
end

local function render_win()
    local ctx = popup_ctx
    render_scheduled = false
    if not ctx then
        return
    end

    ---@type string[]
    local lines = {}
    ---@type {hl: string, start_col: integer, end_col: integer}[][]
    local hls = {}

    -- title
    table.insert(lines, "PLUGMAN")
    table.insert(hls, { { hl = "Statement", start_col = 0, end_col = -1 } })

    -- pre log
    for _, msg in ipairs(global_log.pre) do
        table.insert(lines, msg[1])
        table.insert(hls, { { hl = msg[2], start_col = 0, end_col = -1 } })
    end
    table.insert(lines, "--------------------------------------------------")
    table.insert(hls, { { hl = "PreProc", start_col = 0, end_col = -1 } })

    -- plugin logs
    for reg_idx, p in ipairs(plugins) do
        ui_state.plugs[reg_idx] = ui_state.plugs[reg_idx] or { line = #lines, expanded = false }
        local state = ui_state.plugs[reg_idx]
        state.line = #lines

        local dir_name = vim.fs.basename(p.spec.source)
        if #p.log == 0 then
            table.insert(lines, string.format("%-30s %s", dir_name, "ok"))
            table.insert(hls, {
                { hl = "Function", start_col = 0,  end_col = 30 },
                { hl = "Comment",  start_col = 31, end_col = -1 },
            })
        elseif state.expanded then
            local msg = p.log[1]
            table.insert(lines, string.format("%-30s %s", dir_name, msg[1]))
            table.insert(hls, {
                { hl = "Function", start_col = 0,  end_col = 30 },
                { hl = msg[2],     start_col = 31, end_col = -1 },
            })

            for i = 2, #p.log do
                local msg = p.log[i]
                table.insert(lines, string.format("%30s %s", "", msg[1]))
                table.insert(hls, { { hl = msg[2], start_col = 31, end_col = -1 } })
            end
            table.insert(lines, "")
            table.insert(hls, {})
        else
            local msg = p.log[#p.log]
            table.insert(lines, string.format("%-30s %s", dir_name, msg[1]))
            table.insert(hls, {
                { hl = "Function", start_col = 0,  end_col = 30 },
                { hl = msg[2],     start_col = 31, end_col = -1 },
            })
        end
    end
    ui_state.last_line = #lines

    -- post log
    table.insert(lines, "--------------------------------------------------")
    table.insert(hls, { { hl = "PreProc", start_col = 0, end_col = -1 } })
    for _, msg in ipairs(global_log.post) do
        table.insert(lines, msg[1])
        table.insert(hls, { { hl = msg[2], start_col = 0, end_col = -1 } })
    end

    -- update popup
    vim.bo[ctx.buf].modifiable = true
    vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, true, lines)
    for i, line_hls in ipairs(hls) do
        local line_idx = i - 1
        for _, line_hl in ipairs(line_hls) do
            vim.api.nvim_buf_add_highlight(ctx.buf, popup_ns, line_hl.hl, line_idx, line_hl.start_col, line_hl.end_col)
        end
    end
    vim.bo[ctx.buf].modifiable = false
end

---@return integer?
local function log_fold_idx()
    local cursor_line = vim.api.nvim_win_get_cursor(popup_ctx.win)[1] - 1
    for reg_idx, state in ipairs(ui_state.plugs) do
        if state.line <= cursor_line then
            local next = ui_state.plugs[reg_idx + 1]
            local next_line = next and next.line or ui_state.last_line
            if cursor_line < next_line then
                return reg_idx
            end
        end
    end
end

function M.log_fold_open()
    if not popup_ctx then return end
    local idx = log_fold_idx()
    if idx then
        ui_state.plugs[idx].expanded = true
    end
    render_win()
end

function M.log_fold_close()
    if not popup_ctx then return end
    local idx = log_fold_idx()
    if idx then
        ui_state.plugs[idx].expanded = false
    end
    render_win()
end

function M.log_fold_toggle()
    if not popup_ctx then return end
    local idx = log_fold_idx()
    if idx then
        ui_state.plugs[idx].expanded = not ui_state.plugs[idx].expanded
    end
    render_win()
end

function M.log_folds_open_all()
    if not popup_ctx then return end
    for _, state in ipairs(ui_state.plugs) do
        state.expanded = true
    end
    render_win()
end

function M.log_folds_close_all()
    if not popup_ctx then return end
    for _, state in ipairs(ui_state.plugs) do
        state.expanded = false
    end
    render_win()
end

function M.log_folds_toggle_all()
    if not popup_ctx then
        return
    end

    local all_expanded = true
    for _, state in ipairs(ui_state.plugs) do
        all_expanded = all_expanded and state.expanded
    end
    for _, state in ipairs(ui_state.plugs) do
        state.expanded = not all_expanded
    end
    render_win()
end

local function append_to_win(reg_idx, text, hl, opts)
    opts = opts or {}
    if not opts.no_time then
        text = os.date("[%H:%M:%S] ") .. text
    else
        text = "           " .. text
    end

    local array
    if reg_idx == global_log.PRE then
        array = global_log.pre
    elseif reg_idx == global_log.POST then
        array = global_log.post
    else
        array = plugins[reg_idx].log
    end

    local lines = vim.gsplit(text, "\n", { trimempty = true })
    table.insert(array, { lines(), hl })
    for line in lines do
        table.insert(array, { "           " .. line, hl })
    end

    if not render_scheduled then
        vim.schedule(render_win)
        render_scheduled = true
    end
end

---@param reg_idx integer
---@param pattern string
---@param ... any
local function print_plain_dimmed(reg_idx, pattern, ...)
    append_to_win(reg_idx, string.format(pattern, ...), "Comment", { no_time = true })
end

---@param reg_idx integer
---@param pattern string
---@param ... any
local function print_info(reg_idx, pattern, ...)
    append_to_win(reg_idx, string.format(pattern, ...), "NormalFloat")
end

---@param reg_idx integer
---@param pattern string
---@param ... any
local function print_important(reg_idx, pattern, ...)
    append_to_win(reg_idx, string.format(pattern, ...), "MoreMsg")
end

---@param reg_idx integer
---@param pattern string
---@param ... any
local function print_error(reg_idx, pattern, ...)
    append_to_win(reg_idx, string.format(pattern, ...), "ErrorMsg")
end

---@param reg_idx integer
---@param path string
---@param prev_link string
local function unlink(reg_idx, path, prev_link)
    local ok, err = vim.uv.fs_unlink(path)
    if ok then
        print_info(reg_idx, "unlinked `%s` -> `%s`", path, prev_link)
    else
        print_error(reg_idx, "error unlinking `%s` -> `%s`:\n`%s`", path, prev_link, err)
        error()
    end
end

---@param reg_idx integer
---@param path string
---@param mode integer
local function mkdir(reg_idx, path, mode)
    local ok, err = vim.uv.fs_mkdir(path, mode)
    if ok then
        print_info(reg_idx, "created dir (%o) `%s`", mode, path)
    else
        print_error(reg_idx, "error creating dir (%o) `%s`:\n`%s`", mode, path, err)
        error()
    end
end

---@param reg_idx integer
---@param link string
---@param link_target string
local function symlink(reg_idx, link, link_target)
    local ok, err = vim.uv.fs_symlink(link_target, link, { dir = true })
    if ok then
        print_info(reg_idx, "created symlink `%s` -> `%s`", link, link_target)
    else
        print_error(reg_idx, "error creating symlink from `%s` -> `%s`:\n`%s`", link, link_target, err)
        error()
    end
end

---@param reg_idx integer
---@param path string
---@param text string
local function write_file(reg_idx, path, text)
    local mode = (6 * 8 * 8) + (4 * 8) + 4 -- 644
    local fd, err = vim.uv.fs_open(path, "w", mode)
    if err then
        print_error(reg_idx, "error opening file`%s`:\n`%s`", path, fd)
        error()
    end

    local len, err = vim.uv.fs_write(fd, { text })

    vim.uv.fs_close(fd)

    if len then
        print_info(reg_idx, "wrote file `%s`", path)
    else
        print_error(reg_idx, "error writing file `%s`:\n`%s`", path, err)
        error()
    end
end

---@param reg_idx integer
---@param path string
---@return string
local function read_file(reg_idx, path)
    local mode = (6 * 8 * 8) + (4 * 8) + 4 -- 644
    local fd, err = vim.uv.fs_open(path, "r", mode)
    if err then
        print_error(reg_idx, "error opening file `%s`:\n`%s`", path, fd)
        error()
    end

    local stat, err = vim.uv.fs_fstat(fd)
    if err then
        print_error(reg_idx, "error stat'ing file `%s`:\n`%s`", path, fd)
        error()
    end

    local text, err = vim.uv.fs_read(fd, stat.size)

    vim.uv.fs_close(fd)

    if text then
        print_info(reg_idx, "read file `%s`", path)
        return text
    else
        print_error(reg_idx, "error writing file `%s`:\n`%s`", path, err)
        error()
    end
end

---@param reg_idx integer
---@param path string
local function create_all_dirs(reg_idx, path)
    if vim.uv.fs_stat(path) then
        return
    end

    local components = {}
    for pos in path:gmatch("/?[^/]+()/?") do
        table.insert(components, pos)
    end

    local from = 0
    for i = #components - 1, 1, -1 do
        local pos = components[i]
        local sub_path = string.sub(path, 0, pos)

        if vim.uv.fs_stat(sub_path) then
            from = i + 1
            break
        end
    end

    for i = from, #components do
        local pos = components[i]
        local sub_path = string.sub(path, 0, pos)
        local mode = (7 * 8 * 8) + (5 * 8) + 5 -- 755
        mkdir(reg_idx, sub_path, mode)
    end
end

---@param reg_idx integer
---@param path string
local function rm_rf(reg_idx, path)
    local res = nil
    vim.system({ "rm", "-rf", path }, {}, function(r)
        res = r
    end)
    vim.wait(100, function()
        return res ~= nil
    end, 1)
    assert(res)

    if res.code == 0 then
        print_info(reg_idx, "removed `%s`", path)
    else
        local error = res.code == 124 and "timeout" or vim.trim(res.stderr)
        print_error(reg_idx, "error removing `%s`:\n`%s`", path, error)
        error()
    end
end

---@class CommandOpts
---@field cwd string?
---@field verbosity integer?

--- when on_exit is ommited, the command is run synchronously
---@param reg_idx integer
---@param command string[]
---@param opts CommandOpts?
---@param on_exit fun(success: boolean, stdout: string)?
---@return boolean, string
local function run_command(reg_idx, command, opts, on_exit)
    opts = opts or {}
    local verbosity = opts.verbosity or (not on_exit and 1) or 2

    local command_str = table.concat(command, " ")
    if opts.cwd then
        command_str = string.format("`%s` in `%s`", command_str, opts.cwd)
    end

    if verbosity >= 1 then
        local verb = (verbosity >= 2) and "running" or "run"
        print_info(reg_idx, "%s %s", verb, command_str)
    end

    local timeout = 30000
    local command_opts = {
        timeout = timeout,
        cwd = opts.cwd,
    }

    ---@type boolean?, string
    local success, stdout = nil, nil
    local ok, res = pcall(vim.system, command, command_opts, function(res)
        success = res.code == 0
        stdout = res.stdout
        if success then
            -- only log success for execution with callback
            if verbosity >= 2 then
                print_info(reg_idx, "success %s", command_str)
            end
        else
            local error = res.code == 124 and "timeout" or vim.trim(res.stderr)
            print_error(reg_idx, "error running %s:\n`%s`", command_str, error)
        end

        if on_exit then
            on_exit(success, stdout)
        end
    end)
    if not ok then
        success = false
        print_error(reg_idx, "error running %s:\n`%s`", command_str, res)

        if on_exit then
            on_exit(success, stdout)
        end
    end

    if not on_exit then
        vim.wait(timeout, function()
            return success ~= nil
        end, 1)
        assert(success ~= nil)
        vim.cmd.redraw()
        return success, stdout
    end
end

---@param reg_idx integer
---@param command string[]
---@param opts CommandOpts|{noschedule: boolean}?
---@return boolean, string
local function async_command(reg_idx, command, opts)
    opts = opts or {}

    ---@param resolve fun(crate: ApiCrateSummary[]?, cancelled: boolean)
    return coroutine.yield(function(resolve)
        if not opts.noschedule then
            resolve = vim.schedule_wrap(resolve)
        end
        run_command(reg_idx, command, opts, resolve)
    end)
end

---@param plug Plugin
---@return boolean, integer
local function register_plug(plug)
    for i, p in ipairs(plugins) do
        if p.spec.source == plug.spec.source then
            plugins[i] = vim.tbl_extend("keep", p, plug)
            return true, i
        end
    end

    table.insert(plugins, plug)
    return false, #plugins
end

---@param source string
---@return integer?, Plugin?
local function registered_plugin(source)
    for i, p in ipairs(plugins) do
        if p.spec.source == source then
            return i, p
        end
    end
end

---@param spec PlugSpec|DepSpec
local function ensure_installed_git_repo(spec)
    local already_registerd, reg_idx = register_plug({
        spec = spec,
        run_post_checkout = false,
        managed = true,
        log = {},
    })

    if already_registerd then
        return
    end

    local dir_name = vim.fs.basename(spec.source)
    local package_path = vim.fs.joinpath(plugs_path, dir_name)
    local repo_url = spec.source
    if string.match(repo_url, "^[^/]+/[^/]+$") then
        repo_url = "https://github.com/" .. spec.source
    end

    if vim.uv.fs_stat(package_path) then
        return
    end

    popup_ctx = popup_ctx or init_popup()
    in_progress = in_progress + 1
    plugins[reg_idx].run_post_checkout = true

    async.launch(function()
        local success = async_command(reg_idx, {
            "git", "clone", "--quiet", "--filter=blob:none",
            "--recurse-submodules", "--also-filter-submodules",
            "--origin", "origin",
            repo_url, package_path,
        })
        if success and spec.checkout then
            success = async_command(
                reg_idx,
                { "git", "checkout", "--quiet", spec.checkout },
                { cwd = package_path, verbosity = 1 }
            )
        end

        if success then
            print_info(reg_idx, "installed")
        end

        in_progress = in_progress - 1
    end)
end

---@param spec PlugSpec
local function ensure_installed_deps(spec)
    if spec.deps then
        for _, d in ipairs(spec.deps) do
            if type(d) == "string" then
                d = { source = d }
            end
            ensure_installed_git_repo(d)
        end
    end
end

---@param cfg_file string?
---@param spec PlugSpec|string
function M.add(cfg_file, spec)
    if type(spec) == "string" then
        spec = { source = spec }
    end

    ensure_installed_deps(spec)

    ensure_installed_git_repo(spec)

    if cfg_file then
        table.insert(setup_queue, "config." .. cfg_file)
    end
end

---@param cfg_file string?
---@param spec PlugSpec|string
function M.dev_repo(cfg_file, spec)
    if type(spec) == "string" then
        spec = { source = spec }
    end
    assert(string.match(spec.source, "^[^/]+/[^/]+$"))

    ensure_installed_deps(spec)

    local _, reg_idx = register_plug({
        spec = spec,
        run_post_checkout = false,
        managed = false,
        log = {},
    })

    if cfg_file then
        table.insert(setup_queue, "config." .. cfg_file)
    end

    local repo_url = "git@github.com:" .. spec.source
    local dir_name = vim.fs.basename(spec.source)
    local project_path = vim.fs.joinpath(projects_path, dir_name)
    local package_path = vim.fs.joinpath(plugs_path, dir_name)

    local function symlink_into_package_dir()
        if vim.uv.fs_stat(package_path) then
            local link_path = vim.uv.fs_readlink(package_path)
            if link_path == project_path then
                return false
            elseif link_path then
                -- incorrect symlink
                unlink(reg_idx, package_path, project_path)
                symlink(reg_idx, package_path, project_path)
            else
                -- not a symlink
                rm_rf(reg_idx, package_path)
                symlink(reg_idx, package_path, project_path)
            end
        else
            symlink(reg_idx, package_path, project_path)
        end
        return true
    end

    -- clone repository into `~/Projects` dir
    if vim.uv.fs_stat(project_path) then
        local ok, linked = pcall(symlink_into_package_dir)
        if ok and linked then
            print_info(reg_idx, "already linked")
        end
        return
    end

    popup_ctx = popup_ctx or init_popup()
    plugins[reg_idx].run_post_checkout = true
    in_progress = in_progress + 1

    async.launch(function()
        local success = async_command(
            reg_idx,
            { "git", "clone", "--quiet", repo_url, project_path }
        )

        if success and spec.checkout then
            success = async_command(
                reg_idx,
                { "git", "checkout", "--quiet", spec.checkout },
                { cwd = project_path, verbosity = 1 }
            )
        end

        if success and pcall(symlink_into_package_dir) then
            print_info(reg_idx, "installed and linked")
        end
        in_progress = in_progress - 1
    end)
end

local function update_lock_file()
    print_important(global_log.POST, "generating lock-file")
    local lines = {}

    local in_progress = #plugins
    local any_failed = false

    for reg_idx, plug in ipairs(plugins) do
        if plug.managed then
            async.launch(function()
                local dir_name = vim.fs.basename(plug.spec.source)
                local package_path = vim.fs.joinpath(plugs_path, dir_name)
                local success, refname = run_command(
                    reg_idx,
                    { "git", "rev-list", "-1", "HEAD" },
                    { cwd = package_path, verbosity = 0 }
                )
                if success then
                    local commit = vim.trim(refname)
                    table.insert(lines, vim.json.encode({ plug.spec.source, commit }) .. "\n")
                else
                    any_failed = true
                end
                in_progress = in_progress - 1

                if in_progress == 0 then
                    if any_failed then
                        print_error(global_log.POST, "failed to get some refs")
                    else
                        local text = table.concat(lines)
                        write_file(global_log.POST, lock_file_path, text)
                        print_important(global_log.POST, "generated lock-file")
                    end
                end
            end)
        else
            in_progress = in_progress - 1
        end
    end
end

---@param name string
---@param locked_commit string
local function restore_plugin(name, locked_commit)
    local reg_idx, plug = registered_plugin(name)
    if not reg_idx or not plug or not plug.managed then
        return
    end

    local dir_name = vim.fs.basename(plug.spec.source)
    local package_path = vim.fs.joinpath(plugs_path, dir_name)

    -- check current commit
    local success, refname = async_command(
        reg_idx,
        { "git", "rev-list", "-1", "HEAD" },
        { cwd = package_path }
    )
    if not success then
        return
    end
    local current_commit = vim.trim(refname)

    -- only run checkout if needed
    if current_commit == locked_commit then
        print_info(reg_idx, "unchanged")
        return
    end

    -- FIXME: if the locked commit is newer, the log is empty
    -- print log
    local success, git_log = async_command(
        reg_idx,
        { "git", "log", "--oneline", string.format("%s..%s", locked_commit, "HEAD") },
        { cwd = package_path }
    )
    if success then
        for commit in vim.gsplit(git_log, "\n", { trimempty = true }) do
            print_plain_dimmed(reg_idx, "%s", commit)
        end
    end


    local success = async_command(
        reg_idx,
        { "git", "checkout", "--quiet", locked_commit },
        { cwd = package_path }
    )
    if success then
        print_important(reg_idx, "restored")
    end
end

local function restore_lock_file()
    print_important(global_log.POST, "restoring lock-file")
    local text = read_file(global_log.POST, lock_file_path)
    local lock = {}
    for line in vim.gsplit(text, "\n", { trimempty = true }) do
        local ok, entry = pcall(vim.json.decode, line)
        if not ok then
            print_error(global_log.POST, "invalid lockfile `%s`", lock_file_path)
            return
        end
        table.insert(lock, entry)
    end

    local in_progress = #lock

    for _, l in ipairs(lock) do
        async.launch(function()
            restore_plugin(l[1], l[2])
            in_progress = in_progress - 1

            if in_progress == 0 then
                print_important(global_log.POST, "restored lock-file")
            end
        end)
    end
end

local function fetch_updates()
    for reg_idx, plug in ipairs(plugins) do
        if not plug.managed then
            goto continue
        end

        local dir_name = vim.fs.basename(plug.spec.source)
        local package_path = vim.fs.joinpath(plugs_path, dir_name)

        async.launch(function()
            local success = async_command(
                reg_idx,
                { "git", "fetch", "--quiet", "--tags", "--force", "--recurse-submodules=yes", "origin" },
                { cwd = package_path }
            )

            if success then
                print_info(reg_idx, "fetched updates")
            end
        end)


        ::continue::
    end
end

---@param reg_idx integer
---@param plug Plugin
---@return boolean
local function update_plugin(reg_idx, plug)
    if not plug.managed then
        return false
    end

    local dir_name = vim.fs.basename(plug.spec.source)
    local package_path = vim.fs.joinpath(plugs_path, dir_name)

    local success, current_commit = async_command(
        reg_idx,
        { "git", "rev-list", "-1", "HEAD" },
        { cwd = package_path }
    )
    if not success then
        return false
    end
    current_commit = vim.trim(current_commit)

    local checkout
    if plug.spec.checkout then
        local origin_branch = "origin/" .. plug.spec.checkout
        local success, refname = async_command(
            reg_idx,
            { "git", "branch", "--list", "--all", "--format=%(refname:short)", origin_branch },
            { cwd = package_path }
        )
        if not success then
            return false
        end
        if vim.trim(refname) == origin_branch then
            checkout = origin_branch
        else
            checkout = plug.spec.checkout
        end
    else
        -- infer default branch
        local success, refname = async_command(
            reg_idx,
            { "git", "rev-parse", "--abbrev-ref", "origin/HEAD" },
            { cwd = package_path }
        )
        if not success then
            return false
        end
        checkout = vim.trim(refname)
    end

    local success = async_command(
        reg_idx,
        { "git", "fetch", "--quiet", "--tags", "--force", "--recurse-submodules=yes", "origin" },
        { cwd = package_path }
    )
    if not success then
        return false
    end

    -- check for updates
    local success, refname = async_command(
        reg_idx,
        { "git", "rev-list", "-1", checkout },
        { cwd = package_path }
    )
    if not success then
        return false
    end
    local newest_commit = vim.trim(refname)

    if newest_commit == current_commit then
        print_info(reg_idx, "up to date")
        return false
    end

    -- print log
    local success, git_log = async_command(
        reg_idx,
        { "git", "log", "--oneline", "HEAD.." .. checkout },
        { cwd = package_path }
    )
    if not success then
        return false
    end
    for commit in vim.gsplit(git_log, "\n", { trimempty = true }) do
        print_plain_dimmed(reg_idx, "%s", commit)
    end

    -- checkout newest commit
    local success = async_command(
        reg_idx,
        { "git", "checkout", "--quiet", newest_commit },
        { cwd = package_path }
    )
    if not success then
        return false
    end
    print_important(reg_idx, "updated")

    return true
end

---@param opts { write_lock: boolean }
local function update_plugins(opts)
    local updating = #plugins
    local any_updated = false

    for reg_idx, plug in ipairs(plugins) do
        async.launch(function()
            local updated = update_plugin(reg_idx, plug)
            updating = updating - 1
            any_updated = any_updated or updated

            if updating == 0 then
                if any_updated then
                    if opts.write_lock then
                        vim.schedule(update_lock_file)
                    else
                        print_info(global_log.POST, "all updated")
                    end
                else
                    print_info(global_log.POST, "all up to date")
                end
            end
        end)
    end
end

---@param name string?
---@param keys {[1]: string, desc: string}[]
function M.setup_on_keys(name, keys)
    local loaded = false
    ---@param pressed string
    local function load_and_feedkeys(pressed)
        return function()
            if loaded then
                return
            end
            loaded = true

            -- delete lazy loading keymaps
            for _, key in ipairs(keys) do
                vim.keymap.del("n", key[1])
            end

            require("config." .. name).setup()

            local feed = vim.api.nvim_replace_termcodes("<ignore>" .. pressed, true, true, true)
            vim.api.nvim_feedkeys(feed, "i", false)
        end
    end

    for _, key in ipairs(keys) do
        vim.keymap.set("n", key[1], load_and_feedkeys(key[1]), { desc = key.desc })
    end
end

function M.start_setup()
    create_all_dirs(global_log.PRE, plugs_path)
    create_all_dirs(global_log.PRE, projects_path)
end

---@param post_setup fun()?
local function finish_setup(post_setup)
    for _, plug in ipairs(plugins) do
        local dir_name = vim.fs.basename(plug.spec.source)
        local ok, err = pcall(vim.cmd.packadd, dir_name)
        if not ok then
            vim.notify(string.format("error running packadd `%s`:\n`%s`", dir_name, err))
        else
            if plug.run_post_checkout and plug.spec.post_checkout then
                plug.spec.post_checkout()
            end
        end
    end

    for _, name in ipairs(setup_queue) do
        local ok, config = pcall(require, name)
        if not ok then
            vim.notify(string.format("failed to load `%s`:\n`%s`", name, config))
            goto continue
        end

        local ok, res = pcall(config.setup)
        if not ok then
            vim.notify(string.format("failed to run setup for `%s`:\n%s", name, res))
        end

        ::continue::
    end

    vim.cmd.helptags("ALL")

    if post_setup then
        post_setup()
    end
end

---@param post_setup fun()?
function M.finish_setup(post_setup)
    if in_progress == 0 then
        finish_setup(post_setup)
        return
    end

    local timer = vim.uv.new_timer()
    timer:start(10, 10, function()
        if in_progress == 0 then
            vim.schedule(function()
                finish_setup(post_setup)
            end)
            timer:close()
        end
    end)
end

function M.fetch()
    popup_ctx = popup_ctx or init_popup()
    fetch_updates()
end

function M.update()
    popup_ctx = popup_ctx or init_popup()
    update_plugins({ write_lock = true })
end

function M.update_no_lock()
    popup_ctx = popup_ctx or init_popup()
    update_plugins({ write_lock = false })
end

function M.save_lock_file()
    popup_ctx = popup_ctx or init_popup()
    update_lock_file()
end

function M.restore_lock_file()
    popup_ctx = popup_ctx or init_popup()
    restore_lock_file()
end

function M.log()
    popup_ctx = popup_ctx or init_popup()
    render_win()
end

return M
