let g:is_rails = 0

if exists("*RailsDetect")
  let g:is_rails = RailsDetect()
end

fun! s:load_rails_projections()
  if g:is_rails && !exists('g:rails_projections')
    echo 'detect'
    let g:rails_projections = projections#load_projections('rails')
    autocmd User ProjectionistActivate :call projections#set_projections('rails')
  endif
endfun

autocmd User ProjectionistDetect :call s:load_rails_projections()
