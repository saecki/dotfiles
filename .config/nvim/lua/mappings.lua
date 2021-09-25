local M = {}

M.actions = {}

function M.register(mode, lhs, rhs, opts)
    local rhs_str = rhs
    if type(rhs) == "function" then
        table.insert(M.actions, rhs)
        rhs_str = ":lua require('mappings').actions["..#M.actions.."]()<cr>"
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


function M.setup()
    M.actions = {}
end

return M
