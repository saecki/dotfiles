local M = {}

M.actions = {}

function M.setup()
    M.actions = {}
end

local function validate(mode, lhs, rhs, opts)
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
        error("Tried to map '" .. lhs .. "' to nil", 2)
    end

    local rhs_str = rhs
    if type(rhs) == "function" then
        table.insert(M.actions, rhs)
        local luaexpr = "lua require('util.maps').actions[" .. #M.actions .. "]()"
        if opts.expr then
            rhs_str = "luaeval('" .. luaexpr .. "')"
        else
            rhs_str = "<cmd>" .. luaexpr .. "<cr>"
        end
    end

    return mode, lhs, rhs_str, opts
end

function M.register(mode, lhs, rhs, opts)
    local m, l, r, o = validate(mode, lhs, rhs, opts)
    vim.api.nvim_set_keymap(m, l, r, o)
end

function M.nore_register(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    M.register(mode, lhs, rhs, opts)
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

function M.buf_register(buf, mode, lhs, rhs, opts)
    local m, l, r, o = validate(mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(buf, m, l, r, o)
end

function M.buf_nore_register(buf, mode, lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = true
    M.buf_register(buf, mode, lhs, rhs, opts)
end

function M.buf_map(buf, lhs, rhs, opts)
    M.buf_register(buf, "", lhs, rhs, opts)
end
function M.buf_noremap(buf, lhs, rhs, opts)
    M.buf_nore_register(buf, "", lhs, rhs, opts)
end

function M.buf_imap(buf, lhs, rhs, opts)
    M.buf_register(buf, "i", lhs, rhs, opts)
end
function M.buf_inoremap(buf, lhs, rhs, opts)
    M.buf_nore_register(buf, "i", lhs, rhs, opts)
end

function M.buf_nmap(buf, lhs, rhs, opts)
    M.buf_register(buf, "n", lhs, rhs, opts)
end
function M.buf_nnoremap(buf, lhs, rhs, opts)
    M.buf_nore_register(buf, "n", lhs, rhs, opts)
end

function M.buf_vmap(buf, lhs, rhs, opts)
    M.buf_register(buf, "v", lhs, rhs, opts)
end
function M.buf_vnoremap(buf, lhs, rhs, opts)
    M.buf_nore_register(buf, "v", lhs, rhs, opts)
end

function M.buf_smap(buf, lhs, rhs, opts)
    M.buf_register(buf, "s", lhs, rhs, opts)
end
function M.buf_snoremap(buf, lhs, rhs, opts)
    M.buf_nore_register(buf, "s", lhs, rhs, opts)
end

return M
