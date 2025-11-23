local ferris = require("ferris")
local wk = require("which-key.config")

local M = {}

local use_clippy = false
---@type integer?
local split_win = nil


---@param method vim.lsp.protocol.Method|string
---@param params any
---@param handler lsp.Handler
local function rust_analyzer_request(method, params, handler)
    local client = vim.lsp.get_clients({ name = "rust_analyzer" })[1]
    if not client then
        vim.notify("rust_analyzer is not attached")
        return
    end

    if params == nil then
        params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    end

    client:request(method, params, handler)
end

---@class SplitWinOpts
---@field below boolean?
---@field nowrap boolean?
---@field filetype string?

---@param lines string[]
---@param opts SplitWinOpts
local function open_split_win(lines, opts)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].filetype = opts.filetype or "rust"

    local split_dir = opts.below and "below" or "right"

    ---@param split_win integer?
    local function compute_height(split_win)
        local available = vim.api.nvim_win_get_height(0)
        if split_win then
            local cfg = vim.api.nvim_win_get_config(split_win)
            if cfg.split == "below" then
                available = available + cfg.height
            end
        end
        local max_height = math.floor(0.6 * available)
        return math.min(#lines, max_height)
    end

    if split_win and vim.api.nvim_win_is_valid(split_win) then

        vim.api.nvim_win_set_buf(split_win, buf)
        vim.api.nvim_win_set_config(split_win, {
            split = split_dir,
            height = opts.below and compute_height(split_win) or nil,
        })
    else
        split_win = vim.api.nvim_open_win(buf, false, {
            win = 0,
            split = split_dir,
            height = opts.below and compute_height() or nil,
        })
    end

    vim.wo[split_win].wrap = not opts.nowrap
end

local function expand_macro()
    rust_analyzer_request("rust-analyzer/expandMacro", nil, function(_, result)
        if result == nil then
            vim.notify("No expansion")
            return
        end

        local lines = vim.split(result.expansion, "\n")
        table.insert(lines, 1, string.format("// expansion of `%s`", result.name))

        open_split_win(lines, {})
    end)
end

local function view_memory_layout()
    ---@class RaNode
    ---@field itemName string
    ---@field typename string
    ---@field size integer
    ---@field offset integer
    ---@field alignment integer
    ---@field childrenStart integer
    ---@field childrenLen integer
    ---@field parentIdx integer

    ---@class Node
    ---@field name string
    ---@field type string
    ---@field size integer
    ---@field offset integer
    ---@field align integer
    ---@field children Node[]?
    ---@field measured Measured?

    ---@class Measured
    ---@field height integer
    ---@field name string
    ---@field layout string

    ---@class Column
    ---@field width integer
    ---@field last_y integer

    ---@param list RaNode[]
    ---@param ra_node RaNode
    ---@return Node
    local function build_tree(list, ra_node)
        ---@type Node
        local node = {
            name = ra_node.itemName,
            type = ra_node.typename,
            size = ra_node.size,
            offset = ra_node.offset,
            align = ra_node.alignment,
        }
        if ra_node.childrenStart == -1 then
            return node
        end

        local children = {}
        local start = ra_node.childrenStart + 1
        for ra_child in vim.iter(list):slice(start, start + ra_node.childrenLen - 1) do
            if ra_child.size > 0 then
                local child = build_tree(list, ra_child)
                table.insert(children, child)
            end
        end
        table.sort(children, function(a, b)
            return a.offset < b.offset
        end)
        node.children = children

        return node
    end

    ---@type integer[]
    local col_widths = {}
    ---@type integer[]
    local scalar_offsets = {}
    ---@type Node[][]
    local grid = {}

    ---@param x integer
    ---@param y integer
    ---@param node Node
    local function set_grid(x, y, node)
        local row = grid[x] or {}
        grid[x] = row
        row[y] = node
    end

    ---@param x integer
    ---@param y integer
    ---@return Node?
    local function get_grid(x, y)
        local row = grid[x] or {}
        return row[y]
    end

    ---@param x integer
    ---@param y integer
    ---@param parent_offset integer
    ---@param node Node
    ---@return Measured
    local function measure_tree(x, y, parent_offset, node)
        set_grid(x, y, node)

        local name = node.name .. ": " .. node.type
        local layout = string.format("size: %s, align: %s", node.size, node.align)

        local offset = parent_offset + node.offset
        local width = col_widths[x + 1] or 0
        col_widths[x + 1] = math.max(width, name:len(), layout:len())

        if not node.children then
            table.insert(scalar_offsets, offset)
            node.measured = {
                height = 1,
                name = name,
                layout = layout,
            }
            return node.measured
        end

        local height = 0
        local y_offset = 0
        for _, child in ipairs(node.children) do
            local child_y = y + y_offset
            local mes = measure_tree(x + 1, child_y, offset, child)
            height = height + mes.height
            y_offset = y_offset + mes.height
        end
        node.measured = {
            height = height,
            name = name,
            layout = layout,
        }
        return node.measured
    end

    local line_builder = {}
    local closing_lines = {}
    ---@param idx integer
    ---@param str string
    local function push_line(idx, str)
        local builder = line_builder[idx] or {}
        table.insert(builder, str)
        line_builder[idx] = builder
    end
    local function close_line(idx, str)
        local builder = closing_lines[idx] or {}
        table.insert(builder, str)
        closing_lines[idx] = builder
    end

    local cross = "┼"
    local vert = "│"
    local hor = "─"

    ---@param x integer 0-based
    ---@param y integer 0-based
    ---@param node Node
    local function render_tree(x, y, node)
        local width = col_widths[x + 1]
        local mes = assert(node.measured)

        -- close the bottom of the cell
        local close_bottom = get_grid(x, y + mes.height) == nil
        if close_bottom then
            local line_idx = 3 * (y + mes.height) + 1
            close_line(line_idx, string.rep(hor, width))
            close_line(line_idx, cross)
        end

        do
            -- draw cell
            local line_idx = 3 * y + 1
            push_line(line_idx, cross)
            push_line(line_idx, string.rep(hor, width))

            push_line(line_idx + 1, vert)
            push_line(line_idx + 1, mes.name)
            push_line(line_idx + 1, string.rep(" ", width - mes.name:len()))

            push_line(line_idx + 2, vert)
            push_line(line_idx + 2, mes.layout)
            push_line(line_idx + 2, string.rep(" ", width - mes.layout:len()))

            -- draw end line
            if not node.children then
                push_line(line_idx, cross)
                push_line(line_idx + 1, vert)
                push_line(line_idx + 2, vert)
                return
            end
        end

        -- add padding for other rows
        for i = 1, mes.height - 1 do
            local line_idx = 3 * (y + i) + 1
            push_line(line_idx, cross)
            push_line(line_idx, string.rep(" ", width))

            push_line(line_idx + 1, vert)
            push_line(line_idx + 1, string.rep(" ", width))

            push_line(line_idx + 2, vert)
            push_line(line_idx + 2, string.rep(" ", width))
        end

        local y_offset = 0
        for _, child in ipairs(node.children) do
            local child_y = y + y_offset
            local child_x = x + 1
            render_tree(child_x, child_y, child)
            local child_mes = assert(child.measured)
            y_offset = y_offset + child_mes.height
        end
    end

    rust_analyzer_request("rust-analyzer/viewRecursiveMemoryLayout", nil, function(_, result)
        if result == nil then
            vim.notify("No memory layout")
            return
        end

        local tree = build_tree(result.nodes, result.nodes[1])

        -- measure
        measure_tree(0, 0, 0, tree)

        -- render
        for i, offset in ipairs(scalar_offsets) do
            local idx = 3 * (i - 1) + 1
            push_line(idx, string.format("%4d ", offset))
            push_line(idx + 1, "     ")
            push_line(idx + 2, "     ")
        end
        push_line(#line_builder + 1, string.format("%4d %s", tree.size, cross))
        render_tree(0, 0, tree)

        -- display
        local lines = vim.iter(line_builder):enumerate()
            :map(function(i, l)
                local close = closing_lines[i]
                local close_str = close and table.concat(close) or ""
                return table.concat(l) .. close_str
            end)
            :totable()
        table.insert(lines, 1, "")
        table.insert(lines, "")
        open_split_win(lines, {
            below = true,
            nowrap = true,
        })
    end)
end

local function setup_server(opts)
    opts = opts or {}
    local check_command = opts.check_command or nil -- defaults to cargo check
    vim.lsp.config("rust_analyzer", {
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = check_command,
                },
                assist = {
                    importEnforceGranularity = true,
                    importGranularity = "module",
                    importPrefix = "crate",
                },
                inlayHints = {
                    maxLength = 40,
                },
            },
        },
    })

    for _, client in ipairs(vim.lsp.get_clients({ name = "rust_analyzer" })) do
        -- Update the settings on the active client.
        client.settings = vim.lsp.config.rust_analyzer.settings
        -- Send a notification with empty settings, rust_analyzer pulls the
        -- configuration using a `workspace/configuration` request.
        client:notify("workspace/didChangeConfiguration", { settings = {} })
    end
end

local function toggle_check_command()
    use_clippy = not use_clippy
    local cmd = use_clippy and "clippy" or "check"
    setup_server({ check_command = cmd })
    vim.notify("cargo " .. cmd, vim.log.levels.INFO)
end

function M.setup()
    setup_server()

    ferris.setup({
        create_commands = true,
        url_handler = vim.ui.open,
    })

    local group = vim.api.nvim_create_augroup("user.config.lsp.server.rust-analyzer", {})
    vim.api.nvim_create_autocmd("BufRead", {
        group = group,
        pattern = "*.rs",
        callback = function(ev)
            wk.add({
                buffer = ev.buf,
                { "<leader>ic",  toggle_check_command,               desc = "Rust check command" },
                { "<leader>ie",  expand_macro,                       desc = "Rust expand" },

                { "<leader>ivh", "<cmd>FerrisViewHIR<cr>",           desc = "Rust view HIR" },
                { "<leader>ivm", "<cmd>FerrisViewMIR<cr>",           desc = "Rust view MIR" },
                { "<leader>ivl", view_memory_layout,                 desc = "Rust view memory layout" },
                -- TODO: support new viewSyntaxTree extension method
                -- { "<leader>ivs", "<cmd>FerrisViewSyntaxTree<cr>",    desc = "Rust view syntax tree",  mode = { "n", "v" } },
                { "<leader>ivi", "<cmd>FerrisViewItemTree<cr>",      desc = "Rust view item tree" },

                { "<leader>iom", "<cmd>FerrisOpenCargoToml<cr>",     desc = "Rust open manifest" },
                { "<leader>iop", "<cmd>FerrisOpenParentModule<cr>",  desc = "Rust open parent module" },
                { "<leader>iod", "<cmd>FerrisOpenDocumentation<cr>", desc = "Rust open docs" },

                { "<leader>ir",  "<cmd>FerrisReloadWorkspace<cr>",   desc = "Rust reload workspace" },
                { "<leader>im",  "<cmd>FerrisRebuildMacros<cr>",     desc = "Rust rebuild macros" },
            })
        end
    })
end

return M
