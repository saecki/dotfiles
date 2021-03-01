let g:airline#themes#minelight#palette = {}

" Normal mode
let s:N1 = [ '#000000', '#000000', 3  , 252 ]
let s:N2 = [ '#000000', '#000000', 240, 253 ]
let s:N3 = [ '#000000', '#000000', 244, 255 ]
let g:airline#themes#minelight#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#minelight#palette.normal_modified = { 'airline_c': [ '#000000', '#000000', 3  , 234 ] }

" Insert mode
let s:I1 = [ '#000000', '#000000', 2  , 251 ]
let s:I2 = s:N2
let s:I3 = s:N3
let g:airline#themes#minelight#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#minelight#palette.insert_modified = { 'airline_c': [ '#000000', '#000000', 2  , 234 ] }

" Replace mode
let g:airline#themes#minelight#palette.replace = copy(g:airline#themes#minelight#palette.insert)
let g:airline#themes#minelight#palette.replace.airline_a = [ '#000000', '#000000', 10, 1, '' ]
let g:airline#themes#minelight#palette.replace_modified = g:airline#themes#minelight#palette.insert_modified

" Visual mode
let s:V1 = [ '#000000', '#000000', 5  , 251 ]
let s:V2 = s:N2
let s:V3 = s:N3
let g:airline#themes#minelight#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#minelight#palette.visual_modified = { 'airline_c': [ '#000000', '#000000', 5  , 234 ] }

" Command mode
let s:C1 = [ '#000000', '#000000', 4  , 251 ]
let s:C2 = s:N2
let s:C3 = s:N3
let g:airline#themes#minelight#palette.commandline = airline#themes#generate_color_map(s:C1, s:C2, s:C3)
let g:airline#themes#minelight#palette.commandline_modified = { 'airline_c': [ '#000000', '#000000', 4  , 234 ] }

" Inactive mode
let s:IA1 = s:N3
let s:IA2 = s:N3
let s:IA3 = s:N3
let g:airline#themes#minelight#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#minelight#palette.inactive_modified = { 'airline_c': [ '#000000', '#000000', 15 , 234 ] }
