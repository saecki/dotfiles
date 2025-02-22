local markview = require("markview")
local wk = require("which-key.config")

local M = {}

function M.setup()
    markview.setup({
        preview = {
            enable = false,
        },
        markdown = {
            list_items = {
                shift_width = 4,
                indent_size = 4,
            },
            tables = {
                enable = true,
                text = {
                    "╭", "─", "╮", "┬",
                    "├", "│", "┤", "┼",
                    "╰", "─", "╯", "┴",

                    "╼", "╾", "╴", "╶"
                },
                hl = {
                    "red_fg", "red_fg", "red_fg", "red_fg",
                    "red_fg", "red_fg", "red_fg", "red_fg",
                    "red_fg", "red_fg", "red_fg", "red_fg",

                    "red_fg", "red_fg", "red_fg", "red_fg"
                },
                use_virt_lines = true,
            },
        },
        code_blocks = {
            enable = true,
            style = "language",
            border_hl = "code_block",
            pad_char = " ",
            pad_amount = 4,
            sign = true,
        },
        inline_codes = {
            enable = true,
            hl = "inline_code",
            corner_left = "",
            corner_left_hl = "inline_code_corner",
            corner_right = "",
            corner_right_hl = "inline_code_corner",
            padding_left = "",
            padding_right = "",
        },
        hyperlinks = {
            enable = true,
            hl = "link",
            icon = "󰌷 ",
            icon_hl = "link",
        },
    })

    wk.add({
        { "<leader>em", markview.commands.Toggle, desc = "Markview" },
    })
end

return M
