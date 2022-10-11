# Vim Switching Colors

## Setting colors

To use all installed color schemes ($VIMRUNTIME/colors/*.vim).

```vim
:SetColors all
```

To use the schemes specified (scheme names, separated with a space, for example, blue slate ron).

```vim
:SetColors blue slate ron

or

let g:themes = 'breeze earth less aqua gothic'
```

To display the current list of scheme names.

```vim
:SetColors
```

## Switching colors

- Press F8 to use the next color scheme.
- Press Shift-F8 to use the previous color scheme.
- Press Alt-F8 to use a random color scheme.

```vim
nnoremap <F8> :call NextColor(1)<CR>
nnoremap <S-F8> :call NextColor(-1)<CR>
nnoremap <A-F8> :call NextColor(0)<CR>
```

