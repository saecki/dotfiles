local telescope = require("telescope")
local telescope_builtin = require("telescope.builtin")
local wk = require("which-key.config")

local M = {}

local symbol_highlights = {
    ["File"]          = "TelescopeLspSymbolKindFile",
    ["Module"]        = "TelescopeLspSymbolKindModule",
    ["Namespace"]     = "TelescopeLspSymbolKindNamespace",
    ["Package"]       = "TelescopeLspSymbolKindPackage",
    ["Class"]         = "TelescopeLspSymbolKindClass",
    ["Method"]        = "TelescopeLspSymbolKindMethod",
    ["Property"]      = "TelescopeLspSymbolKindProperty",
    ["Field"]         = "TelescopeLspSymbolKindField",
    ["Constructor"]   = "TelescopeLspSymbolKindConstructor",
    ["Enum"]          = "TelescopeLspSymbolKindEnum",
    ["Interface"]     = "TelescopeLspSymbolKindInterface",
    ["Function"]      = "TelescopeLspSymbolKindFunction",
    ["Variable"]      = "TelescopeLspSymbolKindVariable",
    ["Constant"]      = "TelescopeLspSymbolKindConstant",
    ["String"]        = "TelescopeLspSymbolKindString",
    ["Number"]        = "TelescopeLspSymbolKindNumber",
    ["Boolean"]       = "TelescopeLspSymbolKindBoolean",
    ["Array"]         = "TelescopeLspSymbolKindArray",
    ["Object"]        = "TelescopeLspSymbolKindObject",
    ["Key"]           = "TelescopeLspSymbolKindKey",
    ["Null"]          = "TelescopeLspSymbolKindNull",
    ["EnumMember"]    = "TelescopeLspSymbolKindEnumMember",
    ["Struct"]        = "TelescopeLspSymbolKindStruct",
    ["Event"]         = "TelescopeLspSymbolKindEvent",
    ["Operator"]      = "TelescopeLspSymbolKindOperator",
    ["TypeParameter"] = "TelescopeLspSymbolKindTypeParameter",
}

local function find_files(opts)
    return function()
        local fd_cmd = { "fd", "--type", "f", "--exclude", ".git", "--hidden" }
        telescope_builtin.find_files({
            find_command = fd_cmd,
            no_ignore = opts.no_ignore,
        })
    end
end

local function buf_diagnostics()
    telescope_builtin.diagnostics({ bufnr = 0 })
end

local function trailing_whitespace()
    telescope_builtin.grep_string({ search = "\\s+$", use_regex = true })
end

function M.setup()
    telescope.setup({
        defaults = {
            layout_config = {
                horizontal = {
                    width = {
                        padding = 8,
                    },
                    height = {
                        padding = 3,
                    },
                    preview_cutoff = 120,
                },
            },
            borderchars = {
                prompt = {
                    "█",
                    "█",
                    "█",
                    "█",
                    "█",
                    "█",
                    "",
                    "",
                },
                results = {
                    "█",
                    "█",
                    "█",
                    "█",
                    "",
                    "",
                    "█",
                    "█",
                },
                preview = {
                    "█",
                    "█",
                    "█",
                    "▐",
                    "▐",
                    "",
                    "",
                    "▐",
                },
            },
            prompt_prefix = " ",
            selection_caret = " ",
        },
    })

    local symbol_opts = {
        symbol_highlights = symbol_highlights,
    }
    wk.add({
        { "<leader>f",  group = "Find" },
        { "<leader>fp", find_files({ no_ignore = false }),                                   desc = "Files" },
        { "<leader>fP", find_files({ no_ignore = true }),                                    desc = "Ignored Files" },
        { "<leader>ff", telescope_builtin.live_grep,                                         desc = "Live grep" },
        { "<leader>fb", telescope_builtin.buffers,                                           desc = "Buffers" },
        { "<leader>fh", telescope_builtin.help_tags,                                         desc = "Help" },
        { "<leader>fc", telescope_builtin.commands,                                          desc = "Commands" },
        { "<leader>fm", telescope_builtin.keymaps,                                           desc = "Key mappings" },
        { "<leader>fi", telescope_builtin.highlights,                                        desc = "Highlight groups" },
        { "<leader>fg", telescope_builtin.git_status,                                        desc = "Git status" },
        { "<leader>fd", buf_diagnostics,                                                     desc = "Document diagnostics" },
        { "<leader>fD", telescope_builtin.diagnostics,                                       desc = "Workspace diagnostics" },
        { "<leader>fs", function() telescope_builtin.lsp_document_symbols(symbol_opts) end,  desc = "LSP document symbols" },
        { "<leader>fS", function() telescope_builtin.lsp_workspace_symbols(symbol_opts) end, desc = "LSP workspace symbols" },
        { "<leader>fw", trailing_whitespace,                                                 desc = "Whitespace", },
        { "<leader>fr", telescope_builtin.resume,                                            desc = "Resume" },
    })
end

return M
