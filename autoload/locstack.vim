let s:save_cpo = &cpoptions
set cpoptions&vim

function! locstack#save() abort
  call s:lazyInit()

  let l:new_elem = {
        \  'line': line("."),
        \  'col': col('.'),
        \  'file': expand('%:p')
        \}

  if len(w:locstack) > w:locstack_level
    call remove(w:locstack, w:locstack_level, len(w:locstack) - 1)
  endif

  if len(w:locstack) > 0 && w:locstack[w:locstack_level - 1] == l:new_elem
    return
  endif

  call add(w:locstack, l:new_elem)
  let w:locstack_level += 1
endfunction

function! locstack#next() abort
  call s:lazyInit()
  if len(w:locstack) <= w:locstack_level
    echohl WarningMsg | echo "top of stack" | echohl None
    return
  endif
  call s:jumpToLocationAt(w:locstack_level + 1)
endfunction

function! locstack#prev() abort
  call s:lazyInit()
  if w:locstack_level == 0
    echohl WarningMsg | echo "bottom of stack" | echohl None
    return
  endif

  call s:jumpToLocationAt(w:locstack_level - 1)
endfunction

function! locstack#clear() abort
  call remove(w:locstack, 0, len(w:locstack) - 1)
  let w:locstack_level = 0
endfunction

function! locstack#list() abort
  call s:lazyInit()

  let l:lines = []
  let l:n = 0
  for l:elem in w:locstack
    let l:prefix = "  "
    if l:n == w:locstack_level
      let l:prefix = "> "
    endif
    call add(l:lines,
          \   printf("%s%d: %s:%d:%d",
          \   l:prefix,
          \   l:n + 1,
          \   l:elem['file'],
          \   l:elem['line'],
          \   l:elem['col'])
          \)
    let l:n += 1
  endfor

  if len(w:locstack) == w:locstack_level
    call add(l:lines, ">")
  endif

  echohl Title | echo "  #  LOCATION" | echohl None
  echo join(l:lines, "\n")
  echohl Question
  let l:choise = input("jump? ")
  echohl None
  if len(l:choise) > 0
    call s:jumpToLocationAt(l:choise - 1)
  endif
endfunction

function! locstack#save_then(cmd) abort
  call locstack#save()

  let l:t = type(a:cmd)
  if l:t == v:t_string
    execute a:cmd
  elseif l:t == v:t_func
    call a:cmd()
  else
    echoerr "Invalid argument type[" . l:t "]"
  endif
endfunction

" private

function! s:lazyInit() abort
  if !exists('w:locstack')
    let w:locstack = []
  endif
  if !exists('w:locstack_level')
    let w:locstack_level = 0
  endif
endfunction

function! s:saveLocation()
  if exists('w:locstack')
    let s:stack = w:locstack
  endif
  if exists('w:locstack_level')
    let s:level = w:locstack_level
  endif
endfunction

function! s:restoreLocation()
  if !exists('w:locstack') && exists('s:stack')
    let w:locstack = copy(s:stack)
  endif
  if !exists('w:locstack_level') && exists('s:level')
    let w:locstack_level = s:level
  endif
endfunction

function! s:jumpToLocationAt(pos) abort
  if a:pos < 0 || len(w:locstack) <= a:pos
    echoerr "range error"
  endif

  let l:target = w:locstack[a:pos]
  if l:target['file'] != expand('%:p')
    exec 'edit' target['file']
  endif
  call cursor(l:target['line'], l:target['col'])
  let w:locstack_level = a:pos
endfunction

au WinLeave * call s:saveLocation()
au WinEnter * call s:restoreLocation()

let &cpoptions = s:save_cpo
unlet s:save_cpo
