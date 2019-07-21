if exists('g:loaded_locstack')
  finish
endif
let g:loaded_locstack = 1

command! SaveLocation call locstack#save()
command! NextLocation call locstack#next()
command! PrevLocation call locstack#prev()
command! ListLocations call locstack#list()
command! ClearLocations call locstack#clear()

nnoremap <Plug>(locstack-save) :call locstack#save()<CR>
nnoremap <Plug>(locstack-next) :call locstack#next()<CR>
nnoremap <Plug>(locstack-prev) :call locstack#prev()<CR>
nnoremap <Plug>(locstack-show) :call locstack#list()<CR>
nnoremap <Plug>(locstack-clear) :call locstack#clear()<CR>
