vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2

-- Automatically use typst-dev when inside the typst/repro directory
local use_typst_dev = vim.api.nvim_buf_get_name(0):match("/typst/repro/") ~= nil
local recompile_typst_dev = true

local function update_cmd()
    vim.g.typst_cmd = (not use_typst_dev) and "typst"
        or (recompile_typst_dev and "typst-dev-recompile" or "typst-dev")
    vim.cmd.compiler("typst")
    vim.notify(vim.g.typst_cmd)
end

local function toggle_typst_dev()
    use_typst_dev = not use_typst_dev
    update_cmd()
end

local function toggle_typst_recompile()
    recompile_typst_dev = not recompile_typst_dev
    update_cmd()
end

vim.api.nvim_buf_create_user_command(0, "ToggleTypstDev", toggle_typst_dev, {})
vim.api.nvim_buf_create_user_command(0, "ToggleTypstRecompile", toggle_typst_recompile, {})
