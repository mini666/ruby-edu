unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
" -------------------------------------
call plug#begin('~/.vim/plugged')

" Basic
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'vim-scripts/ReplaceWithRegister'

" Colors
Plug 'junegunn/seoul256.vim'

" Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-bundler'
Plug 'w0rp/ale'

call plug#end()
" -------------------------------------

set hidden
set autoindent smartindent
set laststatus=2
set tabstop=2
set shiftwidth=2
set expandtab smarttab
set clipboard=unnamed
set number
set diffopt=filler,vertical

let g:seoul256_background = 235
silent! colo seoul256

inoremap jk <Esc>
xnoremap jk <Esc>
cnoremap jk <C-c>

let mapleader = ' '

function! s:tmux_send(content, dest) range
  let dest = empty(a:dest) ? input('To which pane? ') : a:dest
  let tempfile = tempname()
  call writefile(split(a:content, "\n", 1), tempfile, 'b')
  call system(printf('tmux load-buffer -b vim-tmux %s \; paste-buffer -d -b vim-tmux -t %s',
        \ shellescape(tempfile), shellescape(dest)))
  call delete(tempfile)
endfunction

function! s:tmux_map(key, dest)
  execute printf('nnoremap <silent> %s "tyy:call <SID>tmux_send(@t, "%s")<cr>', a:key, a:dest)
  execute printf('xnoremap <silent> %s "ty:call <SID>tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
endfunction

call s:tmux_map('<leader>tt', '')
call s:tmux_map('<leader>th', '.left')
call s:tmux_map('<leader>tj', '.bottom')
call s:tmux_map('<leader>tk', '.top')
call s:tmux_map('<leader>tl', '.right')
call s:tmux_map('<leader>ty', '.top-left')
call s:tmux_map('<leader>to', '.top-right')
call s:tmux_map('<leader>tn', '.bottom-left')
call s:tmux_map('<leader>t.', '.bottom-right')

autocmd vimrc FileType ruby command! Rubocop :call system('rubocop -a '.expand('%')) | e
