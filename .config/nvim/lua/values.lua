local util = require("util")

return {
    packer = {
        snapshot_version = "v0.1.3",
        snapshot_path = util.join_paths(vim.fn.stdpath("config"), "snapshots"),
        compile_path = util.join_paths(vim.fn.stdpath("config"), "lua", "packer_compiled.lua"),
    },
}
