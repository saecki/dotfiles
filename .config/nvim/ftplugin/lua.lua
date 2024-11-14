vim.api.nvim_buf_create_user_command(
    0,
    "TealRecordToEmmyluaAnnotation",
    [['<,'>s/\s*record \(.*\)/---@class \1/r]]
        .. [[ | '<,'>s/\s*\(.*\): \(.*\)/---@field \1 \2/r]]
        .. [[ | '<,'>s/\s*end\n//r]],
    {
        range = true,
    }
)
vim.api.nvim_buf_create_user_command(
    0,
    "TealEnumToEmmyluaAnnotation",
    [['<,'>s/\s*enum \(.*\)/---@enum \1\rM.\1 = {/r]]
        .. [[ | '<,'>s/\s*"\(.*\)"/    \1 = "\1",/r ]]
        .. [[ |  '<,'>s/\s*end$/}/r]],
    {
        range = true,
    }
)
