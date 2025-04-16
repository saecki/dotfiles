local wk = require("which-key.config")

local M = {}

local function on_attach(client, buf)
    wk.add({
        { "<leader>if", "<cmd>TexlabForward<cr>", desc = "Forward search", buffer = buf },
    })
end

function M.setup()
    vim.lsp.config("texlab", {
        on_attach = on_attach,
        settings = {
            texlab = {
                build = {
                    executable = "latexmk",
                    args = {
                        "-xelatex",
                        "-verbose",
                        "-file-line-error",
                        "-interaction=nonstopmode",
                        "-synctex=1",
                        "%f",
                    },
                    forwardSearchAfter = true,
                    onSave = true,
                },
                chktex = {
                    onOpenAndSave = true,
                    onEdit = true,
                },
                forwardSearch = {
                    executable = "zathura",
                    args = { "--synctex-forward", "%l:1:%f", "%p" },
                },
            },
        },
    })
end

return M
