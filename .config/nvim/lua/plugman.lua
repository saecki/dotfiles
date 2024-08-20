local shared = require("shared")

local M = {}

local lock_file_path = vim.fn.stdpath("config") .. "/plugs.lock"
local plugs_path = vim.fn.stdpath("data") .. "/site/pack/plugs/opt/"
local projects_path = vim.fn.expand("~/Projects/")

local popup_ns = vim.api.nvim_create_namespace("user.plugman.win")
local popup_ctx = nil
local function init_win()
    -- create buf
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, 0, true, { "   PLUGMAN LOGS   " })
    vim.api.nvim_buf_add_highlight(buf, popup_ns, "Statement", 0, 0, -1)
    vim.bo[buf].filetype = "markdown"
    vim.bo[buf].modifiable = false

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
    vim.api.nvim_set_current_win(win)

    vim.wo[win].wrap = false

    return {
        win = win,
        buf = buf,
    }
end

local function append_to_win(line, hl)
    popup_ctx = popup_ctx or init_win()
    local ctx = popup_ctx

    vim.bo[ctx.buf].modifiable = true
    local n = vim.api.nvim_buf_line_count(ctx.buf)
    vim.api.nvim_buf_set_lines(ctx.buf, n, n, true, { line })
    vim.api.nvim_buf_add_highlight(ctx.buf, popup_ns, hl, n, 0, -1)
    vim.bo[ctx.buf].modifiable = false

    vim.cmd.redraw()
end

local function print_info(pattern, ...)
    append_to_win(string.format(pattern, ...), "NormalFloat")
end

local function print_error(pattern, ...)
    append_to_win(string.format(pattern, ...), "ErrorMsg")
end

local function rm_rf(path)
    local res = nil
    vim.system({ "rm", "-rf", path }, {}, function(r)
        res = r
    end)
    vim.wait(100, function()
        return res ~= nil
    end, 1)
    if res and res.code == 0 then
        print_info("removed `%s`", path)
    else
        print_error("error removing `%s`: %s", path, res.stderr)
        error()
    end
end

local function unlink(path, prev_link)
    local ok, err = vim.uv.fs_unlink(path)
    if ok then
        print_info("unlinked `%s` -> `%s`", path, prev_link)
    else
        print_error("error unlinking `%s` -> `%s`: %s", path, prev_link, err)
        error()
    end
end

local function mkdir(path, mode)
    local ok, err = vim.uv.fs_mkdir(path, mode)
    if ok then
        print_info("created dir (%o) `%s`", mode, path)
    else
        print_info("error creating dir (%o) `%s`: `%s`", mode, path, err)
        error()
    end
end

local function symlink(link, link_target)
    local ok, err = vim.uv.fs_symlink(link_target, link, { dir = true })
    if ok then
        print_info("created symlink `%s` -> `%s`", link, link_target)
    else
        print_error("error creating symlink from `%s` -> `%s`: %s", link, link_target, err)
        error()
    end
end

---@param command string[]
---@param opts {cwd: string?}?
local function run_command(command, opts)
    opts = opts or {}

    local command_str = table.concat(command, " ")
    print_info("running `%s`", command_str)
    vim.cmd.redraw()

    local res = nil
    local timeout = 30000
    local command_opts = {
        timeout = timeout,
        cwd = opts.cwd,
    }
    vim.system(command, command_opts, function(r)
        res = r
    end)
    vim.wait(timeout, function()
        return res ~= nil
    end, 100)

    if res and res.code == 0 then
        print_info("success `%s`", command_str)
    else
        print_error("error running `%s`: `%s`", command_str, res.stderr)
        error()
    end
end

local function create_all_dirs(path)
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
        mkdir(sub_path, mode)
    end
end

---@param path string
---@return string
local function plugin_dir_name(path)
    return string.match(path, "/?([^/]+)$")
end

---@class PlugSpec
---@field source string
---@field checkout string?
---@field deps (DepSpec|string)[]?
---@field post_checkout fun()?

---@class DepSpec
---@field source string
---@field checkout string?

---@type table<string,DepSpec>
local plugins = {}

---@param spec PlugSpec|DepSpec
local function ensure_installed_git_repo(spec)
    local dir_name = plugin_dir_name(spec.source)
    local package_path = plugs_path .. dir_name
    local repo_url = spec.source
    if string.match(repo_url, "^[^/]+/[^/]+$") then
        repo_url = "https://github.com/" .. spec.source
    end

    local cloned = false
    if not vim.uv.fs_stat(package_path) then
        run_command({
            "git", "clone", "--quiet", "--filter=blob:none",
            "--recurse-submodules", "--also-filter-submodules",
            "--origin", "origin",
            repo_url, package_path,
        })
        if spec.checkout then
            run_command({ "git", "checkout", "--quiet", spec.checkout }, { cwd = package_path })
        end
        cloned = true
    end

    plugins[spec.source] = {
        source = spec.source,
        checkout = spec.checkout,
    }

    return cloned
end

---@type string[]
local setup_queue = {}

---@param cfg_file string?
---@param spec PlugSpec
---@param checkout boolean
local function add_plugin(cfg_file, spec, checkout)
    -- dependencies
    if spec.deps then
        for _, d in ipairs(spec.deps) do
            if type(d) == "string" then
                d = { source = d }
            end
            ensure_installed_git_repo(d)

            local dir_name = plugin_dir_name(d.source)
            vim.cmd.packadd(dir_name)
        end
    end

    local dir_name = plugin_dir_name(spec.source)
    vim.cmd.packadd(dir_name)

    if checkout and spec.post_checkout then
        spec.post_checkout()
    end

    if cfg_file then
        table.insert(setup_queue, "config." .. cfg_file)
    end
end

---@param cfg_file string?
---@param spec PlugSpec|string
function M.add(cfg_file, spec)
    if type(spec) == "string" then
        spec = { source = spec }
    end

    local cloned = ensure_installed_git_repo(spec)

    add_plugin(cfg_file, spec, cloned)
end

---@param cfg_file string?
---@param spec PlugSpec|string
function M.dev_repo(cfg_file, spec)
    if type(spec) == "string" then
        spec = { source = spec }
    end
    assert(string.match(spec.source, "^[^/]+/[^/]+$"))
    local repo_url = "git@github.com:" .. spec.source

    local dir_name = plugin_dir_name(spec.source)
    local project_path = projects_path .. dir_name
    local package_path = plugs_path .. dir_name

    -- clone repository into `~/Projects` dir
    local cloned = false
    if not vim.uv.fs_stat(project_path) then
        run_command({ "git", "clone", "--quiet", repo_url, project_path })
        if spec.checkout then
            run_command({ "git", "checkout", "--quiet", spec.checkout }, { cwd = project_path })
        end
        cloned = true
    end

    -- symlink it into the plugins dir
    if vim.uv.fs_stat(package_path) then
        local link_path = vim.uv.fs_readlink(package_path)
        if link_path == project_path then
            -- correct symlink already exists
        elseif link_path then
            -- incorrect symlink
            unlink(package_path, project_path)
            symlink(package_path, project_path)
        else
            -- not a symlink
            rm_rf(package_path)
            symlink(package_path, project_path)
        end
    else
        symlink(package_path, project_path)
    end

    add_plugin(cfg_file, spec, cloned)
end

function M.create_dirs()
    create_all_dirs(plugs_path)
    create_all_dirs(projects_path)
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

function M.finish_setup()
    for _, name in ipairs(setup_queue) do
        local ok, config, err = pcall(require, name)
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
end

return M
