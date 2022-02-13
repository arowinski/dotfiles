" TODO: convert to lua 
let s:base_dir = matchstr(resolve(expand("<sfile>:p:h:h")), '\(.*\)/')
let s:projections_dir = s:base_dir . 'projections/'

fun! projections#exists(name)
  return filereadable(s:projections_dir . a:name . '.json')
endfun

fun! projections#load_projections(name)
  let l:json = readfile(s:projections_dir . a:name . '.json')

  return projectionist#json_parse(l:json)
endfunction

function! projections#set_projections(name)
  let types = split(a:name, '\.')

  for type in types
    if(projections#exists(type))
      call projectionist#append(getcwd(), projections#load_projections(type))
    endif
  endfor
endfunction
