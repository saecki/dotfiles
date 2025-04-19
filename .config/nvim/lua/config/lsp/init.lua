local blink = require("blink.cmp")
local trouble = require("trouble")
local mason = require("mason")
local mason_ui = require("mason.ui")
local wk = require("which-key.config")
local shared = require("shared")
local fidget = require("config.lsp.fidget")
local live_rename = require("live-rename")
-- servers
local dartls = require("config.lsp.server.dartls")
local lua_ls = require("config.lsp.server.lua_ls")
local rust_analyzer = require("config.lsp.server.rust_analyzer")
local texlab = require("config.lsp.server.texlab")

local M = {}

local server_names = {}

local float_preview_opts = {
    offset_x = -1,
    border = shared.window.border,
    anchor_bias = "above",
}

local function open_lsp_log()
    vim.cmd("edit " .. vim.lsp.log.get_filename())
end

local function toggle_document_highlight()
    shared.lsp.enable_document_highlight = not shared.lsp.enable_document_highlight
    if not shared.lsp.enable_document_highlight then
        vim.lsp.buf.clear_references()
    else
        vim.lsp.buf.document_highlight()
    end
end

local function toggle_inlay_hints()
    shared.lsp.enable_inlay_hints = not shared.lsp.enable_inlay_hints
    vim.lsp.inlay_hint.enable(shared.lsp.enable_inlay_hints, {})
end

local function range_code_action()
    vim.lsp.buf.code_action()
    vim.api.nvim_input("<ESC>")
end

local function get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local blink_capabilities = blink.get_lsp_capabilities()
    local fidget_capabilities = { capabilities = { window = { workDoneProgress = true } } }
    capabilities = vim.tbl_deep_extend("force", capabilities, blink_capabilities, fidget_capabilities)
    return capabilities
end

local lsp_mappings = {
    { "<c-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<cr>",                                   desc = "LSP definition" },
    { "<A-LeftMouse>", "<LeftMouse>:Trouble lsp_type_definitions<cr>",                                       desc = "LSP type definition" },

    { "<c-a-l>",       vim.lsp.buf.format,                                                                   desc = "LSP format" },
    { "K",             function() vim.lsp.buf.hover(float_preview_opts) end,                                 desc = "Show documentation" },
    { "<a-k>",         function() vim.lsp.buf.signature_help(float_preview_opts) end,                        desc = "Signature help",        mode = { "n", "i" } },

    { "g",             group = "Go" },
    { "gD",            vim.lsp.buf.declaration,                                                              desc = "LSP declaration" },
    { "gd",            vim.lsp.buf.definition,                                                               desc = "LSP definition" },
    { "gy",            vim.lsp.buf.type_definition,                                                          desc = "LSP type definitions" },
    { "gi",            function() trouble.open({ mode = "lsp_implementations", auto_jump = false }) end,     desc = "LSP implementations" },
    { "gr",            function() trouble.open({ mode = "lsp_references", auto_jump = false }) end,          desc = "LSP references" },

    { "]r",            function() trouble.next({ mode = "lsp_references", focus = false, jump = true }) end, desc = "Next LSP reference" },
    { "[r",            function() trouble.prev({ mode = "lsp_references", focus = false, jump = true }) end, desc = "Previous LSP reference" },

    { "<leader>a",     vim.lsp.buf.code_action,                                                              desc = "Code action" },
    { "<leader>a",     range_code_action,                                                                    desc = "Range code action",     mode = "v" },
    { "<leader>eh",    toggle_document_highlight,                                                            desc = "Document highlight" },
    { "<leader>ei",    toggle_inlay_hints,                                                                   desc = "Inlay hints" },
    { "<leader>r",     live_rename.rename,                                                                   desc = "Refactor keep name" },
    { "<leader>R",     live_rename.map({ text = "", insert = true }),                                        desc = "Refactor clear name" },
}

---@param client vim.lsp.Client
---@param buf integer
local function on_attach(client, buf)
    -- Highlight occurrences
    if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        -- make sure only one autocmd per buffer exists
        local group = vim.api.nvim_create_augroup("user.config.lsp.occurrences", { clear = false })
        vim.api.nvim_clear_autocmds({
            group = group,
            buffer = buf,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "ModeChanged" }, {
            group = group,
            buffer = buf,
            callback = function()
                if shared.lsp.enable_document_highlight then
                    if vim.fn.mode() == "n" then
                        vim.lsp.buf.document_highlight()
                    else
                        vim.lsp.buf.clear_references()
                    end
                end
            end,
        })
    end

    -- add lsp buffer mappings
    wk.add({
        buffer = buf,
        unpack(vim.deepcopy(lsp_mappings))
    })
end

---@param client vim.lsp.Client
---@param buf integer
local function on_detach(client, buf)
    local attached_clients = vim.lsp.get_clients({ bufnr = buf })

    -- check if any other client is still attached
    for _, c in ipairs(attached_clients) do
        if c.id ~= client.id then
            return
        end
    end

    -- remove document highlight autocmd
    local group = vim.api.nvim_create_augroup("user.config.lsp.occurrences", { clear = false })
    vim.api.nvim_clear_autocmds({
        group = group,
        buffer = buf,
    })

    -- remove all lsp buffer mappings
    for _, mapping in ipairs(lsp_mappings) do
        local modes = mapping.mode or "n"
        vim.keymap.del(modes, mapping[1], { buffer = buf })
    end
end

local function setup_server(name, setup_fn)
    table.insert(server_names, name)
    if setup_fn then
        setup_fn()
    end
end

---@param config vim.lsp.Config
local function start_server(config)
    -- Deepcopy config so changes done in the client
    -- do not propagate back to the enabled configs.
    config = vim.deepcopy(config)

    if type(config.root_dir) == 'function' then
        local bufnr = vim.api.nvim_get_current_buf()
        ---@param root_dir string
        config.root_dir(bufnr, function(root_dir)
            config.root_dir = root_dir
            vim.schedule(function()
                local client_id = vim.lsp.start(config)
                fidget.show_starting(client_id, config.name)
            end)
        end)
    else
        local client_id = vim.lsp.start(config)
        fidget.show_starting(client_id, config.name)
    end
end

local function start_servers()
    local started = false
    local ft = vim.bo.filetype
    for _, name in ipairs(server_names) do
        local config = vim.lsp.config[name]
        if config.filetypes and vim.tbl_contains(config.filetypes, ft) then
            vim.lsp.enable(name, true)
            start_server(config)
            started = true
        end
    end

    if not started then
        vim.notify(string.format("No server found for filetype `%s`", ft))
    end
end

local function stop_servers()
    for _, name in ipairs(server_names) do
        vim.lsp.enable(name, false)
    end
    vim.lsp.stop_client(vim.lsp.get_clients())
end

function M.setup()
    local group = vim.api.nvim_create_augroup("user.config.lsp", {})
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
            local buf = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buf)
        end,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
        group = group,
        callback = function(args)
            local buf = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_detach(client, buf)
        end,
    })

    -- Client capabilities
    vim.lsp.config("*", {
        capabilities = get_capabilities(),
    })

    -- default servers
    setup_server("clangd")
    setup_server("zls")
    setup_server("gopls")
    setup_server("wgsl_analyzer")
    setup_server("pyright")
    setup_server("vhdl_ls")
    setup_server("tinymist")

    -- customized servers
    setup_server("dartls", dartls.setup)
    setup_server("lua_ls", lua_ls.setup)
    setup_server("rust_analyzer", rust_analyzer.setup)
    setup_server("texlab", texlab.setup)

    -- custom servers
    setup_server("vvm-ls")

    -- Setup mason
    mason.setup({
        ui = {
            border = shared.window.border,
        },
    })

    -- Progress handler
    fidget.setup()

    -- Inlay hints
    vim.lsp.inlay_hint.enable(shared.lsp.enable_inlay_hints, {})

    -- Highlight occurrences
    vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
        -- only clear highlights when the new locations are known to avoid jitter
        vim.lsp.util.buf_clear_references(ctx.bufnr)
        if not result then
            return
        end
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then
            return
        end
        vim.lsp.util.buf_highlight_references(ctx.bufnr, result, client.offset_encoding)
    end

    -- Write buffers that were edited in a rename
    local rename_handler = vim.lsp.handlers["textDocument/rename"]
    ---@param result lsp.WorkspaceEdit?
    vim.lsp.handlers["textDocument/rename"] = function(err, result, ctx, config)
        rename_handler(err, result, ctx, config)

        if err or not result then
            return
        end

        ---@param buf integer?
        local function write_buf(buf)
            if buf and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
                vim.api.nvim_buf_call(buf, function()
                    vim.cmd("w")
                end)
            end
        end
        if result.changes then
            for uri, edits in pairs(result.changes) do
                local buf = vim.uri_to_bufnr(uri)
                write_buf(buf)
            end
        elseif result.documentChanges then
            for _, change in ipairs(result.documentChanges) do
                if change.textDocument then
                    local buf = vim.uri_to_bufnr(change.textDocument.uri)
                    write_buf(buf)
                end
            end
        end
    end

    -- Keymappings
    wk.add({
        { "<leader>i",  group = "Lsp" },
        { "<leader>is", start_servers,                  desc = "Start" },
        { "<leader>it", stop_servers,                   desc = "Stop (terminate)" },
        { "<leader>ii", "<cmd>checkhealth vim.lsp<cr>", desc = "Info" },
        { "<leader>il", open_lsp_log,                   desc = "Log" },
        { "<leader>iI", mason_ui.open,                  desc = "Install Info" },
        { "<leader>iL", "<cmd>MasonLog<cr>",            desc = "Install Log" },
    })
end

return M
