local shared = require("shared")

local M = {}

local lock_file_path = vim.fn.stdpath("config") .. "/plugs.lock"
local plugs_path = vim.fn.stdpath("data") .. "/site/pack/plugs/opt/"
local projects_path = vim.fn.expand("~/Projects/")

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
---@field lock boolean
---@field log string[]

local in_progress = 0
---@type {[1]: string, [2]: string}[]
local global_log = {}
---@type Plugin[]
local plugins = {}
---@type string[]
local setup_queue = {}

---@class PopupCtx
---@field win integer
---@field buf integer

---@type PopupCtx?
local popup_ctx = nil
local popup_ns = vim.api.nvim_create_namespace("user.plugman.win")

---@return PopupCtx
local function init_popup()
    -- create buf
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, 1, true, { "PLUGMAN" })
    vim.api.nvim_buf_add_highlight(buf, popup_ns, "Statement", 0, 0, -1)
    vim.bo[buf].filetype = "markdown"
    -- vim.bo[buf].modifiable = false

    -- create win
    local margin_x = 8
    local margin_y = 4
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
    vim.api.nvim_set_current_win(win)

    return {
        win = win,
        buf = buf,
    }
end

local function render_win()
    ---@type string[]
    local lines = {}
    ---@type {hl: string, start_col: integer, end_col: integer}[][]
    local hls = {}

    for _, msg in ipairs(global_log) do
        table.insert(lines, msg[1])
        table.insert(hls, { { hl = msg[2], start_col = 0, end_col = -1 } })
    end

    table.insert(lines, "------------------------------")
    table.insert(hls, { { hl = "PreProc", start_col = 0, end_col = -1 } })

    for _, p in ipairs(plugins) do
        local last_msg = p.log[#p.log]
        local dir_name = vim.fs.basename(p.spec.source)
        if last_msg then
            table.insert(lines, string.format("%-30s %s", dir_name, last_msg[1]))
            table.insert(hls, {
                { hl = "Function",  start_col = 0,  end_col = 30 },
                { hl = last_msg[2], start_col = 31, end_col = -1 },
            })
        else
            table.insert(lines, string.format("%-30s %s", dir_name, "ok"))
            table.insert(hls, {
                { hl = "Function", start_col = 0,  end_col = 30 },
                { hl = "Comment",  start_col = 31, end_col = -1 },
            })
        end
    end

    local ctx = popup_ctx or init_popup()
    popup_ctx = ctx

    vim.bo[ctx.buf].modifiable = true
    vim.api.nvim_buf_set_lines(ctx.buf, 1, -1, true, lines)
    for i, line_hls in ipairs(hls) do
        for _, line_hl in ipairs(line_hls) do
            vim.api.nvim_buf_add_highlight(ctx.buf, popup_ns, line_hl.hl, i, line_hl.start_col, line_hl.end_col)
        end
    end
    vim.bo[ctx.buf].modifiable = false
end


local function append_to_win(reg_idx, line, hl)
    if reg_idx == -1 then
        table.insert(global_log, { line, hl })
    else
        table.insert(plugins[reg_idx].log, { line, hl })
    end

    vim.schedule(render_win)
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
        print_error(reg_idx, "error unlinking `%s` -> `%s`: %s", path, prev_link, err)
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
        print_info(reg_idx, "error creating dir (%o) `%s`: `%s`", mode, path, err)
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
        print_error(reg_idx, "error creating symlink from `%s` -> `%s`: %s", link, link_target, err)
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
        local mode = 7 * 8 * 8 + 5 * 8 + 5 -- 755
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
        print_error(reg_idx, "error removing `%s`: %s", path, res.stderr)
        error()
    end
end

---@class CommandOpts
---@field cwd string?

---@param reg_idx integer
---@param command string[]
---@param opts CommandOpts?
---@param on_exit fun(boolean)
local function run_command(reg_idx, command, opts, on_exit)
    opts = opts or {}

    local command_str = table.concat(command, " ")
    print_info(reg_idx, "running `%s`", command_str)

    local timeout = 30000
    local command_opts = {
        timeout = timeout,
        cwd = opts.cwd,
    }
    vim.system(command, command_opts, function(res)
        local success = res and res.code == 0
        if success then
            print_info(reg_idx, "success `%s`", command_str)
        else
            print_error(reg_idx, "error running `%s`: `%s`", command_str, res.stderr)
        end

        on_exit(success)
    end)
end

---@param reg_idx integer
---@param commands {args: string[], opts: CommandOpts?}[]|{on_exit: fun(success: boolean)}
local function chain_commands(reg_idx, commands)
    local callback = commands.on_exit
    for i = #commands, 2, -1 do
        local command = commands[i]
        local next_callback = callback
        callback = function(success)
            if success then
                -- continue on success
                run_command(reg_idx, command.args, command.opts, next_callback)
            else
                -- short circuit on error
                commands.on_exit(success)
            end
        end
    end

    local command = commands[1]
    run_command(reg_idx, command.args, command.opts, callback)
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

---@param spec PlugSpec|DepSpec
local function ensure_installed_git_repo(spec)
    local already_registerd, reg_idx = register_plug({
        spec = spec,
        run_post_checkout = false,
        lock = true,
        log = {},
    })

    if already_registerd then
        return
    end

    local dir_name = vim.fs.basename(spec.source)
    local package_path = plugs_path .. dir_name
    local repo_url = spec.source
    if string.match(repo_url, "^[^/]+/[^/]+$") then
        repo_url = "https://github.com/" .. spec.source
    end

    if not vim.uv.fs_stat(package_path) then
        plugins[reg_idx].run_post_checkout = true
        in_progress = in_progress + 1

        chain_commands(reg_idx, {
            -- clone
            {
                args = {
                    "git", "clone", "--quiet", "--filter=blob:none",
                    "--recurse-submodules", "--also-filter-submodules",
                    "--origin", "origin",
                    repo_url, package_path,
                },
            },
            -- checkout
            spec.checkout and {
                args = { "git", "checkout", "--quiet", spec.checkout },
                opts = { cwd = package_path },
            },
            on_exit = function(success)
                if success then
                    print_info(reg_idx, "installed")
                end

                in_progress = in_progress - 1
            end,
        })
    end
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

    vim.cmd.redraw()
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
        lock = false,
        log = {},
    })

    if cfg_file then
        table.insert(setup_queue, "config." .. cfg_file)
    end

    local repo_url = "git@github.com:" .. spec.source
    local dir_name = vim.fs.basename(spec.source)
    local project_path = projects_path .. dir_name
    local package_path = plugs_path .. dir_name

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
    if not vim.uv.fs_stat(project_path) then
        plugins[reg_idx].run_post_checkout = true
        in_progress = in_progress + 1

        chain_commands(reg_idx, {
            -- clone
            {
                args = { "git", "clone", "--quiet", repo_url, project_path },
            },
            -- checkout
            spec.checkout and {
                args = { "git", "checkout", "--quiet", spec.checkout },
                opts = { cwd = project_path },
            },
            on_exit = function(success)
                if success and pcall(symlink_into_package_dir) then
                    print_info(reg_idx, "installed and linked")
                end

                in_progress = in_progress - 1
            end,
        })
    else
        local ok, res = pcall(symlink_into_package_dir)
        if ok and res then
            print_info(reg_idx, "linked")
        end
    end

    vim.cmd.redraw()
end

---@param name string?
---@param keys string[]
function M.setup_on_keys(name, keys)
    local loaded = false
    local function load_and_feedkeys(key)
        return function()
            if loaded then
                return
            end
            loaded = true

            -- delete lazy loading keymaps
            for _, lhs in ipairs(keys) do
                vim.keymap.del("n", lhs)
            end

            require("config." .. name).setup()

            local feed = vim.api.nvim_replace_termcodes("<ignore>" .. key, true, true, true)
            vim.api.nvim_feedkeys(feed, "i", false)
        end
    end

    for _, lhs in ipairs(keys) do
        vim.keymap.set("n", lhs, load_and_feedkeys(lhs), {})
    end
end

function M.start_setup()
    create_all_dirs(-1, plugs_path)
    create_all_dirs(-1, projects_path)
end

---@param post_setup fun()?
local function finish_setup(post_setup)
    for _, plug in ipairs(plugins) do
        local dir_name = vim.fs.basename(plug.spec.source)
        vim.cmd.packadd(dir_name)

        if plug.run_post_checkout and plug.spec.post_checkout then
            plug.spec.post_checkout()
        end
    end

    for _, name in ipairs(setup_queue) do
        local ok, config = pcall(require, name)
        if not ok then
            vim.notify(string.format("failed to load `%s`:\n%s", name, config))
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
    timer:start(100, 100, function()
        if in_progress == 0 then
            vim.schedule(function()
                finish_setup(post_setup)
            end)
            timer:close()
        end
    end)
end

return M
