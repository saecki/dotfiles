local dap = require("dap")
local Job = require("plenary.job")
local telescope_pickers = require("telescope.pickers")
local telescope_finders = require("telescope.finders")
local telescope_sorters = require("telescope.sorters")
local telescope_actions = require("telescope.actions")
local telescope_action_state = require("telescope.actions.state")

local M = {}

local history = {}

local function push_history_entry(entry)
    for i, e in ipairs(history) do
        local exists = (e.workspace_root == entry.workspace_root)
            and (e.cargo_args == entry.cargo_args)
            and (e.cmd_args == entry.cmd_args)

        if exists then
            table.remove(history, i)
            break
        end
    end

    table.insert(history, entry)
end

local function input_cmd_args(suggestion)
    local cmd_args_str = vim.fn.input("Args: ", suggestion)
    return vim.split(cmd_args_str, " ", { plain = true, trimempty = true })
end

local function init_commands()
    local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

    local script_path = vim.fs.joinpath(rustc_sysroot, "/lib/rustlib/etc/lldb_lookup.py")
    local script_import = string.format('command script import "%s"', script_path)
    local commands_file = vim.fs.joinpath(rustc_sysroot, "/lib/rustlib/etc/lldb_commands")

    local commands = {}
    local file = io.open(commands_file, "r")
    if file then
        for line in file:lines() do
            table.insert(commands, line)
        end
        file:close()
    end
    table.insert(commands, 1, script_import)

    return commands
end

M.configurations = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            local suggestion = M.last_program or (vim.fn.getcwd() .. "/target/debug/")
            M.last_program = vim.fn.input("Path to executable: ", suggestion, "file")
            return M.last_program
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
            return input_cmd_args("")
        end,
        runInTerminal = false,
        initCommands = init_commands,
    },
}

-- filter and modify list of targets for debugging
local function sanitize_results_for_debugging(results)
    return vim.tbl_filter(function(r)
        if r.args.cargoArgs[1] == "check" then
            return false
        elseif r.args.cargoArgs[1] == "run" then
            r.args.cargoArgs[1] = "build"
        elseif r.args.cargoArgs[1] == "test" then
            table.insert(r.args.cargoArgs, 2, "--no-run")
        end

        return true
    end, results)
end

local function get_choice_strs(runnable_entries)
    local option_strings = {}

    for _, runnable_entry in ipairs(runnable_entries) do
        local label = ""
        for _, a in ipairs(runnable_entry.cargo_args) do
            label = label .. a .. " "
        end

        if not vim.tbl_isempty(runnable_entry.cmd_args) then
            label = label .. "-- "
            for _, value in ipairs(runnable_entry.cmd_args) do
                label = label .. value .. " "
            end
        end

        table.insert(option_strings, label)
    end

    return option_strings
end

local function show_debuggable_menu(entries)
    local choices = get_choice_strs(entries)
    local function attach_mappings(bufnr, map)
        local function on_select()
            local choice = telescope_action_state.get_selected_entry().index

            telescope_actions.close(bufnr)

            M.debug(entries[choice])
        end

        map("n", "<cr>", on_select)
        map("i", "<cr>", on_select)

        -- Additional mappings don't push the item to the tagstack.
        return true
    end

    telescope_pickers
        .new({}, {
            prompt_title = "Debuggables",
            finder = telescope_finders.new_table({ results = choices }),
            sorter = telescope_sorters.get_generic_fuzzy_sorter(),
            previewer = nil,
            attach_mappings = attach_mappings,
        })
        :find()
end

function M.debuggables_history(opts)
    local _, first_entry = next(history)
    if not first_entry then
        vim.notify("History is empty")
        return
    end

    if opts.run_first then
        M.debug(first_entry)
    else
        show_debuggable_menu(history)
    end
end

function M.debuggables(opts)
    local client = vim.lsp.get_clients({ name = "rust_analyzer" })[1]
    if not client then
        vim.notify("rust_analyzer is not attached")
        return
    end

    local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local debuggables_handler = function(_, results)
        if results == nil then
            vim.notify("No debuggables found")
            return
        end

        results = sanitize_results_for_debugging(results)
        if not next(results) then
            vim.notify("No debuggables found")
            return
        end

        if opts.current_pos then
            results = vim.tbl_filter(function(r)
                if not r.location then
                    return true
                end

                local range = r.location.targetRange
                return (current_line >= range.start.line) and (current_line < range["end"].line)
            end, results)

            if not next(results) then
                vim.notify("No debuggables found for current position")
                return
            end
        end

        local entries = vim.tbl_map(function(r)
            local runnable_args = r.args
            local entry = {
                workspace_root = runnable_args.workspaceRoot,
                cargo_args = runnable_args.cargoArgs,
                cmd_args = runnable_args.executableArgs,
            }
            table.insert(entry.cargo_args, "--message-format=json")
            return entry
        end, results)

        show_debuggable_menu(entries)
    end

    local params = {
        textDocument = vim.lsp.util.make_text_document_params(),
        position = nil,
    }
    client.request("experimental/runnables", params, debuggables_handler)
end

function M.debug(runnable_entry)
    vim.notify("Compiling - This might take some time...")

    local cmd_args_str = table.concat(runnable_entry.cmd_args, " ")
    runnable_entry.cmd_args = input_cmd_args(cmd_args_str)

    local on_exit = function(j, code)
        if code and code > 0 then
            vim.schedule(function()
                vim.notify("An error occured while compiling:\n" .. vim.inspect(j), vim.log.levels.ERROR)
            end)
        end

        vim.schedule(function()
            for _, value in pairs(j:result()) do
                local json = vim.fn.json_decode(value)
                if type(json) == "table" and json.executable ~= vim.NIL and json.executable ~= nil then
                    push_history_entry(runnable_entry)

                    local config = {
                        name = "Launch",
                        type = "lldb",
                        request = "launch",
                        program = json.executable,
                        args = runnable_entry.cmd_args,
                        cwd = runnable_entry.workspace_root,
                        stopOnEntry = false,
                        runInTerminal = false,
                        initCommands = init_commands,
                    }
                    dap.run(config)
                    break
                end
            end
        end)
    end

    Job:new({
        command = "cargo",
        args = runnable_entry.cargo_args,
        cwd = runnable_entry.workspaceRoot,
        on_exit = on_exit,
    }):start()
end

return M
