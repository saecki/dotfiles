local M = {}

M.actions = {}

function M.setup()
    M.actions = {}
end

function M.register(mode, lhs, rhs, opts)
    if mode == nil then
        error("Missing mode on mapping", 2)
    end
    if lhs == nil then
        error("Missing lhs on mapping", 2)
    end
    if rhs == nil then
        error("Tried to map '"..lhs.."' to nil", 2)
    end

    local rhs_str = rhs
    if type(rhs) == "function" then
        table.insert(M.actions, rhs)
        rhs_str = ":lua require('mappings').actions["..#M.actions.."]()<cr>"
    end

    opts = opts or {}
    if opts.silent == nil then
        opts.silent = true
    end

    vim.api.nvim_set_keymap(mode, lhs, rhs_str, opts)
end

function M.nore_register(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    M.register(mode, lhs, rhs, opts)
end


function M.imap(lhs, rhs, opts)
    M.register("i", lhs, rhs, opts)
end

function M.inoremap(lhs, rhs, opts)
    M.nore_register("i", lhs, rhs, opts)
end


function M.nmap(lhs, rhs, opts)
    M.register("n", lhs, rhs, opts)
end

function M.nnoremap(lhs, rhs, opts)
    M.nore_register("n", lhs, rhs, opts)
end


function M.vmap(lhs, rhs, opts)
    M.register("v", lhs, rhs, opts)
end

function M.vnoremap(lhs, rhs, opts)
    M.nore_register("v", lhs, rhs, opts)
end

return M
