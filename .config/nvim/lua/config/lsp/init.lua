local lspconfig = require("lspconfig")
local blink = require("blink.cmp")
local trouble = require("trouble")
local mason = require("mason")
local mason_ui = require("mason.ui")
local wk = require("which-key.config")
local shared = require("shared")
local fidget = require("config.lsp.fidget")
local live_rename = require("live-rename")
-- servers
local arduino_language_server = require("config.lsp.server.arduino_language_server")
local dartls = require("config.lsp.server.dartls")
local lua_ls = require("config.lsp.server.lua_ls")
local rust_analyzer = require("config.lsp.server.rust_analyzer")
local texlab = require("config.lsp.server.texlab")

local M = {}

local float_preview_opts = {
    offset_x = -1,
    border = shared.window.border,
    anchor_bias = "above",
}

local group

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

function M.get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local blink_capabilities = blink.get_lsp_capabilities()
    local fidget_capabilities = { capabilities = { window = { workDoneProgress = true } } }
    capabilities = vim.tbl_deep_extend("force", capabilities, blink_capabilities, fidget_capabilities)
    capabilities.general = {
        positionEncodings = { "utf-8", "utf-32", "utf-16" },
    }
    return capabilities
end

function M.on_attach(client, buf)
    -- Occurences
    if client.server_capabilities.documentHighlightProvider then
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

    -- Inlay hints
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(shared.lsp.enable_inlay_hints, {})
    end

    wk.add({
        buffer = buf,

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
    })
end

function M.setup()
    group = vim.api.nvim_create_augroup("user.config.lsp", {})

    -- Client capabilities
    vim.lsp.config("*", {
        capabilities = M.get_capabilities(),
    })

    -- Setup servers
    lspconfig.util.default_config.autostart = false

    lspconfig["clangd"].setup({})
    lspconfig["zls"].setup({})
    lspconfig["gopls"].setup({})
    lspconfig["wgsl_analyzer"].setup({})
    lspconfig["pyright"].setup({})
    lspconfig["vhdl_ls"].setup({})
    lspconfig["tinymist"].setup({})

    arduino_language_server.setup(lspconfig["arduino_language_server"])
    dartls.setup(lspconfig["dartls"])
    lua_ls.setup(lspconfig["lua_ls"])
    rust_analyzer.setup(lspconfig["rust_analyzer"])
    texlab.setup(lspconfig["texlab"])

    do
        local configs = require("lspconfig.configs")
        configs["vvm-ls"] = {
            default_config = {
                cmd = { "vvm-ls" },
                filetypes = { "vvm" },
                root_dir = function(fname)
                    return vim.fs.root(fname, ".git") or vim.uv.cwd()
                end,
                settings = {},
            },
        }
        lspconfig["vvm-ls"].setup({})
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buf = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            M.on_attach(client, buf)
        end,
    })

    -- Setup mason
    mason.setup({
        ui = {
            border = shared.window.border,
        },
    })

    -- Progress handler
    fidget.setup()

    -- Highlight occurences
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
        { "<leader>is", "<cmd>LspStart<cr>",   desc = "Start" },
        { "<leader>ir", "<cmd>LspRestart<cr>", desc = "Restart" },
        { "<leader>it", "<cmd>LspStop<cr>",    desc = "Stop (terminate)" },
        { "<leader>ii", "<cmd>LspInfo<cr>",    desc = "Info" },
        { "<leader>il", "<cmd>LspLog<cr>",     desc = "Log" },
        { "<leader>iI", mason_ui.open,         desc = "Install Info" },
        { "<leader>iL", "<cmd>MasonLog<cr>",   desc = "Install Log" },
    })
end

return M
