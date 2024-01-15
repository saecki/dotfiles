local M = {}

function M.setup()
    vim.api.nvim_create_user_command(
        "TealRecordToEmmyluaAnnotation",
        [['<,'>s/\s*record \(.*\)/---@class \1/r]]
            .. [[ | '<,'>s/\s*\(.*\): \(.*\)/---@field \1 \2/r]]
            .. [[ | '<,'>s/\s*end\n//r]],
        {
            range = true,
        }
    )
    vim.api.nvim_create_user_command(
        "TealEnumToEmmyluaAnnotation",
        [['<,'>s/\s*enum \(.*\)/---@enum\rlocal \1 = {/r]]
            .. [[ | '<,'>s/\s*"\(.*\)"/    \1 = "\1",/r ]]
            .. [[ |  '<,'>s/\s*end/}/r]],
        {
            range = true,
        }
    )
end

return M
