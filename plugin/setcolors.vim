" Change the color scheme from a list of color scheme names.
" Modify from http://vim.wikia.com/wiki/VimTip341
" Set the list of color schemes used by the above (default is 'all'):
"   :SetColors all              (all $VIMRUNTIME/colors/*.vim)
"   :SetColors blue slate ron   (these schemes)
"   :SetColors                  (display current scheme names)
if v:version < 700 || exists('loaded_setcolors') || &cp
  finish
endif

let loaded_setcolors = 1
let g:themes = get(g:, 'themes', '')  " colorscheme names that we use to set color

" Set list of color scheme names that we will use
function! s:SetColors(args)
  if type(g:themes) != v:t_list
      let g:themes = split(g:themes)
  endif
  if len(a:args) == 0
    echo 'Current color scheme names:'
    let i = 0
    while i < len(g:themes)
      echo '  '.join(map(g:themes[i : i+4], 'printf("%-14s", v:val)'))
      let i += 5
    endwhile
  elseif a:args == 'all'
    let paths = split(globpath(&runtimepath, 'colors/*.vim'), "\n")
    let g:themes = uniq(sort(map(paths, 'fnamemodify(v:val, ":t:r")')))
    echo 'List of colors set from all installed color schemes'
  else
    let g:themes = split(a:args)
    echo 'List of colors set from argument (space-separated names)'
  endif
endfunction

command! -nargs=* SetColors call s:SetColors('<args>')

" Set next/previous/random (how = 1/-1/0) color from our list of colors.
" The 'random' index is actually set from the current time in seconds.
" Global (no 's:') so can easily call from command line.
function! NextColor(how)
  call s:NextColor(a:how, 1)
endfunction

" Helper function for NextColor(), allows echoing of the color name to be
" disabled.
function! s:NextColor(how, echo_color)
  if type(g:themes) != v:t_list
      let g:themes = split(g:themes)
  endif
  if len(g:themes) == 0
    call s:SetColors('all')
  endif
  if exists('g:colors_name')
    let current = index(g:themes, g:colors_name)
  else
    let current = 0
  endif
  let missing = []
  let how = a:how
  for i in range(len(g:themes))
    if how == 0
      let current = localtime() % len(g:themes)
      let how = 1  " in case random color does not exist
    else
      let current += how
      if !(0 <= current && current < len(g:themes))
        let current = (how>0 ? 0 : len(g:themes)-1)
      endif
    endif
    try
      execute 'colorscheme '.g:themes[current]
      break
    catch /E185:/
      call add(missing, g:themes[current])
    endtry
  endfor
  redraw
  if len(missing) > 0
    echo 'Error: colorscheme not found:' join(missing)
  endif
  if (a:echo_color)
    echo g:colors_name
  endif
endfunction

