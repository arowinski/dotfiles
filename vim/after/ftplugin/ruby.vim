" Ruby related configs

" Binding pry
nnoremap <buffer> <Leader>bp orequire "pry"; binding.pry<Esc>
nnoremap <buffer> <Leader>bP Orequire "pry"; binding.pry<Esc>
nnoremap <buffer> <silent> <Leader>br :g/binding.pry/d<CR>

nnoremap <Leader>bb orequire "byebug"; byebug<Esc>

let g:is_rails = 0

fun! s:project_root()
  if exists('b:rails_root')
    return b:rails_root
  else
    let git_dir = finddir('.git/..', expand('%:p:h').';')

    if (git_dir)
      return git_dir
    else
      return getcwd()
    endif
  endif
endfun

fun! s:file_path()
  let match = matchlist(expand('%:p:r'), s:project_root() . '/\(.*\)')

  if len(match) > 0
    return match[1]
  else
    return expand("%:p:r")
  end
endfun

fun! s:extract(path)
  let parts = split(a:path, '/')
  let root = parts[0]

  if root == 'app'
    return parts[2: -1]
  elseif root == 'spec'
    let parts[-1] = substitute(parts[-1], '_spec', '', '')

    return g:is_rails ? parts[2: -1] : parts[1: -1]
  elseif root == 'lib'
    return parts[1: -1]
  else
    return parts
  endif
endfun

fun! ruby#class_name(...)
  let path = s:file_path()
  let parts = s:extract(path)

  call map(parts, {idx, val -> substitute(val, '\(_\|^\)\(.\)', '\u\2', 'g') })

  if a:0 > 0
    return parts
  else
    return join(parts, '::')
  endif
endfun

nnoremap <Leader>fl :Files lib/<CR>
nnoremap <Leader>fs :Files spec/<CR>

" vim:ft=vim
