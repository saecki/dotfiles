local chars = {
    border_n = "▄",
    border_e = "█",
    border_s = "▀",
    border_w = "█",

    corner_nw = "",
    corner_ne = "",
    corner_se = "",
    corner_sw = "",
}

return {
    lsp = {
        enable_inlay_hints = false,
        enable_document_highlight = true,
    },
    window = {
        border = {
            chars.corner_nw,
            chars.border_n,
            chars.corner_ne,
            chars.border_e,
            chars.corner_se,
            chars.border_s,
            chars.corner_sw,
            chars.border_w,
        },
        plenary_border = {
            chars.border_n,
            chars.border_e,
            chars.border_s,
            chars.border_w,
            chars.corner_nw,
            chars.corner_ne,
            chars.corner_se,
            chars.corner_sw,
        },
    },
}
