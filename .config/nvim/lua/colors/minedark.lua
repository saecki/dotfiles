local colors = {}

local palette = {
  yellow       = '#fabd2f',
  green        = '#98971a',
  red          = '#fb3b24',
  purple       = '#d3869b',
  blue         = '#72a1a5',
  
  text2        = '#ebdbb2',
  text3        = '#a89d8e',

  gray1        = '#4e4e4e',
  gray2        = '#3a3a3a',
  gray3        = '#282828',
}
colors.palette = palette

colors.lualine = {
  normal = {
    a = { bg = palette.gray1, fg = palette.yellow, gui = 'bold' },
    b = { bg = palette.gray2, fg = palette.text2                },
    c = { bg = palette.gray3, fg = palette.text3                },
  },
  insert = {
    a = { bg = palette.gray1, fg = palette.green,  gui = 'bold' },
    b = { bg = palette.gray2, fg = palette.text2                },
    c = { bg = palette.gray3, fg = palette.text3                },
  },
  visual = {
    a = { bg = palette.gray1, fg = palette.purple, gui = 'bold' },
    b = { bg = palette.gray2, fg = palette.text2                },
    c = { bg = palette.gray3, fg = palette.text3                },
  },
  replace = {
    a = { bg = palette.gray1, fg = palette.red,    gui = 'bold' },
    b = { bg = palette.gray2, fg = palette.text2                },
    c = { bg = palette.gray3, fg = palette.text3                },
  },
  command = {
    a = { bg = palette.gray1, fg = palette.blue,   gui = 'bold' },
    b = { bg = palette.gray2, fg = palette.text2                },
    c = { bg = palette.gray3, fg = palette.text3                },
  },
  inactive = {
    a = { bg = palette.gray3, fg = palette.text3                },
    b = { bg = palette.gray3, fg = palette.text3                },
    c = { bg = palette.gray3, fg = palette.text3                },
  }
}

return colors
