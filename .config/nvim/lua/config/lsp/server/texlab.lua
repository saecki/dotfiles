local wk = require("which-key.config")

local M = {}

function M.setup(server, on_attach, capabilities)
    local function m_on_attach(client, buf)
        on_attach(client, buf)

        wk.add({
            { "<leader>if", "<cmd>TexlabForward<cr>", desc = "Forward search", buffer = buf },
        })
    end

    server.setup({
        on_attach = m_on_attach,
        capabilities = capabilities,
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
