local colors = {}

local palette = {
  yellow       = '#f09300',
  green        = '#98ae0f',
  red          = '#dd241d',
  purple       = '#c15296',
  blue         = '#46a5a9',
  
  text2        = '#585858',
  text3        = '#808080',

  gray1        = '#d0d0d0',
  gray2        = '#dadada',
  gray3        = '#eeeeee',
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
