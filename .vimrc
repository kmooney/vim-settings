syntax on
set number
set softtabstop=4
set shiftwidth=4
set expandtab

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

function! s:TodoList ()
    cclose
    let task_list = []
    for row in split(system('ack --column "(TODO|CHANGED|FIXME|CONSIDER)"'), '\n')
        let t = split(row, ':')
        let task_dict = {'filename': t[0], 'lnum': t[1], 'col': t[2]}
        let task_dict.text = substitute(join(t[3:-1]), '\s\+', ' ', '')
        let task_list += [task_dict]
    endfor
    call setqflist(task_list, 'r')
    copen
endfunction
command! TodoList call <SID>TodoList()
map <silent> <Leader>td :TodoList<CR>


set background=dark
colorscheme solarized
set guioptions-=T

let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

