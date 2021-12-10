local M = {}

M.actions = {}

function M.setup()
    M.actions = {}
end

function M.register(mode, lhs, rhs, opts)
    opts = opts or {}
    if opts.silent == nil then
        opts.silent = true
    end

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
        local luaexpr = "lua require('util.maps').actions["..#M.actions.."]()"
        if opts.expr then
            rhs_str = "luaeval('" .. luaexpr .. "')"
        else
            rhs_str = "<cmd>" .. luaexpr .. "<cr>"
        end
    end

    if opts.buf then
        local buf = opts.buf
        opts.buf = nil
        vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs_str, opts)
    else
        vim.api.nvim_set_keymap(mode, lhs, rhs_str, opts)
    end
end

function M.nore_register(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    M.register(mode, lhs, rhs, opts)
end

function M.buf_register(mode, lhs, rhs, opts)
    opts = opts or {}
    if opts.buf == nil then
        opts.buf = 0
    end
    M.register(mode, lhs, rhs, opts)
end

function M.buf_nore_register(mode, lhs, rhs, opts)
    opts = opts or {}
    if opts.buf == nil then
        opts.buf = 0
    end
    M.nore_register(mode, lhs, rhs, opts)
end


function M.map(lhs, rhs, opts)
    M.register("", lhs, rhs, opts)
end

function M.noremap(lhs, rhs, opts)
    M.nore_register("", lhs, rhs, opts)
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


function M.smap(lhs, rhs, opts)
    M.register("s", lhs, rhs, opts)
end

function M.snoremap(lhs, rhs, opts)
    M.nore_register("s", lhs, rhs, opts)
end

-- buffer local

function M.buf_map(lhs, rhs, opts)
    M.buf_register("", lhs, rhs, opts)
end

function M.buf_noremap(lhs, rhs, opts)
    M.buf_nore_register("", lhs, rhs, opts)
end


function M.buf_imap(lhs, rhs, opts)
    M.buf_register("i", lhs, rhs, opts)
end

function M.buf_inoremap(lhs, rhs, opts)
    M.buf_nore_register("i", lhs, rhs, opts)
end


function M.buf_nmap(lhs, rhs, opts)
    M.buf_register("n", lhs, rhs, opts)
end

function M.buf_nnoremap(lhs, rhs, opts)
    M.buf_nore_register("n", lhs, rhs, opts)
end


function M.buf_vmap(lhs, rhs, opts)
    M.buf_register("v", lhs, rhs, opts)
end

function M.buf_vnoremap(lhs, rhs, opts)
    M.buf_nore_register("v", lhs, rhs, opts)
end


function M.buf_smap(lhs, rhs, opts)
    M.buf_register("s", lhs, rhs, opts)
end

function M.buf_snoremap(lhs, rhs, opts)
    M.buf_nore_register("s", lhs, rhs, opts)
end

return M
