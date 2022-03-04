local util = require("util")

return {
    packer = {
        compile_path = util.join_paths(vim.fn.stdpath("config"), "lua", "packer_compiled.lua"),
        snapshot_path = util.join_paths(vim.fn.stdpath("config"), "snapshots"),
        snapshot_version = "v0.1.2",
    },
}
