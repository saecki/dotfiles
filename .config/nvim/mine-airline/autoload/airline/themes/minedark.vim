let g:airline#themes#minedark#palette = {}

" Normal mode
let s:N1 = [ '#000000', '#000000', 11 , 239 ]
let s:N2 = [ '#000000', '#000000', 15 , 237 ]
let s:N3 = [ '#000000', '#000000', 7  , 0   ]
let g:airline#themes#minedark#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#minedark#palette.normal_modified = { 'airline_c': [ '#000000', '#000000', 3  , 0 ] }

" Insert mode
let s:I1 = [ '#000000', '#000000', 10 , 239 ]
let s:I2 = s:N2
let s:I3 = s:N3
let g:airline#themes#minedark#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#minedark#palette.insert_modified = { 'airline_c': [ '#000000', '#000000', 2  , 0 ] }

" Replace mode
let g:airline#themes#minedark#palette.replace = copy(g:airline#themes#minedark#palette.insert)
let g:airline#themes#minedark#palette.replace.airline_a = [ '#000000', '#000000', 10, 1, '' ]
let g:airline#themes#minedark#palette.replace_modified = g:airline#themes#minedark#palette.insert_modified

" Visual mode
let s:V1 = [ '#000000', '#000000', 13 , 239 ]
let s:V2 = s:N2
let s:V3 = s:N3
let g:airline#themes#minedark#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#minedark#palette.visual_modified = { 'airline_c': [ '#000000', '#000000', 5  , 0 ] }

" Command mode
let s:C1 = [ '#000000', '#000000', 12 , 239 ]
let s:C2 = s:N2
let s:C3 = s:N3
let g:airline#themes#minedark#palette.commandline = airline#themes#generate_color_map(s:C1, s:C2, s:C3)
let g:airline#themes#minedark#palette.commandline_modified = { 'airline_c': [ '#000000', '#000000', 4  , 0 ] }

" Inactive mode
let s:IA1 = s:N3
let s:IA2 = s:N3
let s:IA3 = s:N3
let g:airline#themes#minedark#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#minedark#palette.inactive_modified = { 'airline_c': [ '#000000', '#000000', 15 , 0 ] }
