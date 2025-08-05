return {
    name = "crates-ls",
    cmd = { "crates-ls" },
    filetypes = { "toml" },
    root_dir = function(fname, on_dir)
        local dir = vim.fs.root(fname, ".git") or vim.uv.cwd()
        on_dir(dir)
    end,
    settings = {},
}
