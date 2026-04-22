" This is some random change
" Some new change too
"
" Some more

cmap <C-V> <C-R>+
cmap <C-Y> <C-R>+
set backspace=indent,eol,start
set showmatch

let g:user_font_face='Consolas'
let g:user_font_size=11
let g:user_notes_dir='F:/misc/hby/notes'
let g:user_debug_enabled=v:false

let s:init_vim_path  = expand('<sfile>')
let s:init_vim_dir   = expand('<sfile>:p:h')
let s:user_init_path = s:init_vim_dir . "/user.vim"

set fileformats=unix,dos

if g:user_debug_enabled
  echom s:init_vim_path
  echom s:init_vim_dir
  echom s:user_init_path
endif

if filereadable(s:user_init_path)
  if g:user_debug_enabled
    echom "Loading " . s:user_init_path
  endif
  execute "source " . s:user_init_path
else
  if g:user_debug_enabled
    echom "No user.vim"
  endif
endif

function! ApplyUserFontProc()
  let font_string = g:user_font_face . ':h' . g:user_font_size
  if g:user_debug_enabled
    echom "User font: " . font_string
  endif
  execute "set guifont=" . font_string
endfunction

function! SetFontSizeProc(size)
  let g:user_font_size = a:size
  call ApplyUserFontProc()
endfunction

function! IncrementFontSize()
  let g:user_font_size = g:user_font_size + 1
  call ApplyUserFontProc()
endfunction

function! DecrementFontSize()
  if g:user_font_size > 5
    let g:user_font_size = g:user_font_size - 1
    call ApplyUserFontProc()
  endif
endfunction

call ApplyUserFontProc()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use this to search all lines
" :vimgrep pattern %
"
" Then use this to open buffer with all matches:
" :copen
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:cpp_class_scope_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1

set autoread
set noerrorbells
set novisualbell
set vb t_vb=
set hlsearch

function! PatchSDProc()
  :%s/@llvm\.xbox\.load\.scratch\.desc(i64 %\d\+/@llvm\.xbox\.load\.scratch\.desc(i32 %shmem_ptr, i32 %shmem_ptr/g
  :%s/declare <4 x i32> @llvm.xbox\.load\.scratch\.desc(i64,/declare <4 x i32> @llvm.xbox.load.scratch.desc(i32, i32,/g
  :%s/ = XBOX_LOAD_SCRATCH_DESC %\d\+, \(\d\+\), 0, %\d\+/ = XBOX_LOAD_SCRATCH_DESC $sgpr0, $sgpr1, \1, 0, $sgpr0, $sgpr1/g
endfunction

function! MkdirIfNotExist(path)
	if !isdirectory(a:path)
		call mkdir(a:path, "p")
	endif
endfunction
call MkdirIfNotExist($HOME."/.vim/backup/")
call MkdirIfNotExist($HOME."/.vim/swap/")
call MkdirIfNotExist($HOME."/.vim/undo/")

set noswapfile
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

set encoding=utf-8   

map <C-j> <C-w>j
nmap <C-j> <C-w>j
nnoremap <C-j> <C-w>j
map <c-h> <C-w>h
nmap <c-h> <C-w>h
nnoremap <C-h> <c-w>h
map <c-k> <C-w>k
nmap <c-k> <C-w>k
nnoremap <C-k> <C-w>k
map <C-l> <C-w>l
nmap <C-l> <C-w>l
nnoremap <C-l> <C-w>l

nnoremap <F12> <C-]>
nnoremap <C-BS> <C-T>

function! RunBat(name)
	let OriginalDirectory = getcwd()
	for i in [ 1, 2, 3, 4, 5, 6 ]
		if filereadable(a:name)
			echo 'Found '.a:name
			let output = system(a:name)
			echo output
			break
		endif
		exec 'cd ..'
		echo 'Searching deeper '.getcwd()
	endfor
	exec 'cd '.OriginalDirectory
endfunction

function! SetupScript()
	call RunBat('setup.bat')
endfunction

function! Build()
	call RunBat('build.bat')
endfunction

function! DoPruneDbg()
  :%s/, debug-location !\d\+;.\+\n/\r/g
  :%s/\ \+DBG_VALUE.\+\n//g
  :%s/; .\+:\d\+\d\+\n/\r/g
  :%s/,\ debug-location !\d\+//g
  :%s/\ debug-location\ !\d\+;.\+:\d\+:\d\+\n/\r/g
endfunction

function! Refactor()
  let l:list = [
        \["app_win32_window", "app_win32_.window"],
        \["app_win32_dc", "app_win32_.dc"],
        \["app_win32_frequency", "app_win32_.frequency"],
        \["app_win32_use_system_dpi", "app_win32_.use_system_dpi"],
        \]
  for kw in l:list
    let l:replace_string = "%s/\\<" . kw[0] . "\\>/" . kw[1] . "/g"
    :execute l:replace_string
  endfor
endfunction


function! DoPruneDbgMore()
  call DoPruneDbg()
  :%s/!\d\+ = !.\+\n//g
  :%s/!\d\+ = .\+\n//g
  :%s/!dx.\+\n//g
  :%s/\s\+call void @llvm\.dbg.\+\n//g
  :%s/, !dbg !\d\+//g
  :%s/%.\+ = type.\+\n//g
  :%s/.\+ = external.\+\n//g
  :%s/; Function Attrs.\+\n//g
  :%s/declare .\+\n//g
  :%s/attributes .\+ = .\+\n//g
  :%s/!.\+ = !{.\+\n/\r/g
  :%s/\n\+\*\*\*/\r***/g
  :%s/\n\+define/\rdefine/g
  :%s/) \#\d\+.\+{/) {/g
  :%s/!\d\+/!00/g
  :%s/; xb.uniform//g
  :%s/%descriptor_load\d\+/%descriptor_load/g
  :%s/\#\d\+/\#00/g
  :%s/; F:\\.\+//g
  :%s/, debug-location.\+//g
  :%s/\n\s\+\(\d\+B\)/\r\1/g
  :%s/\n\t\+\n/\r\r/g
  :%s/; xb.safe-to-remove xb.uniform//g
  :%s/ debug-location !00//g
  :%s/,\s\+!dbgv_id//g
  :%s/\s\+!dbgv_id//g
  :%s/; xb\.wqm.*//g
  :%s/ xb\.wqm.*//g
endfunction

function! SaveAsUTF8Function()
  :w ++enc=utf8 %
endfunction

function! DoPruneEnum()
	:'<,'>s/\s\+=\s\+\d\+,/:/g
endfunction

function! DoPruneShaderAsm()
	:%s/ \+\/\/.*\n/\r/g
endfunction

function! SetIndentNormal()
	set tabstop=4
	set shiftwidth=4
	set noexpandtab
endfunction

function! SetIndentRazzle()
	set tabstop=4
	set shiftwidth=4
	set expandtab
endfunction

function! SetIndentLLVM()
	set tabstop=2
	set shiftwidth=2
	set expandtab
endfunction

function! Run()
	call RunBat('r.bat')
endfunction
map<c-b> :call Run()<CR>

set guioptions-=L
set guioptions-=r
set guioptions-=T
set guioptions-=m
set guioptions-=e

let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-p']

set noswapfile

set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/vimfiles/bundle')
Plug 'antiagainst/vim-tablegen'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/tpope-vim-abolish'
Plug 'beyondmarc/hlsl.vim'
Plug 'tpope/vim-speeddating'
Plug 'PProvost/vim-ps1'
Plug 'flazz/vim-colorschemes'
Plug 'skywind3000/asyncrun.vim'
Plug 'vim-airline/vim-airline'
Plug 'leafgarland/typescript-vim'
Plug 'justinmk/vim-syntax-extra'
Plug 'Tetralux/odin.vim'
Plug 'tbastos/vim-lua'
Plug 'jdonaldson/vaxe'
Plug 'ziglang/zig.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'jdonaldson/vaxe'
Plug 'mg979/vim-studio-dark'
Plug 'chriskempson/base16-vim'
Plug 'tikhomirov/vim-glsl'
Plug 'vimwiki/vimwiki'
Plug 'stephpy/vim-yaml'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/vim-markdown'

if has('nvim')
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'nvim-orgmode/orgmode'
  Plug 'alec-gibson/nvim-tetris'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
endif
call plug#end()

if !has('nvim')
  :set ttyfast ttymouse=xterm2 lazyredraw ttyscroll=3 
endif

if has('nvim')
  :autocmd FocusGained * checktime
  :au FocusGained * :checktime
  autocmd FocusGained * silent! checktime
endif

set tabstop=4
set shiftwidth=4
syntax on
set number

set background=dark
"colorscheme base16-default-dark
"colorscheme base16-black-metal
"colorscheme base16-ia-dark
colorscheme codedark

:command! NT :NERDTreeToggle
:command! NTT :NERDTree
:command! Setup :call SetupScript()
:command! PruneDbg :call DoPruneDbg()
:command! PruneDbgMore :call DoPruneDbgMore()
:command! IndentNormal :call SetIndentNormal()
:command! IndentLLVM :call SetIndentLLVM()
:command! PruneShaderAsm :call DoPruneShaderAsm()
:command! PruneEnum :call DoPruneEnum()
:command! LLVMIndent :call SetIndentLLVM()
:command! IndentRazzle :call SetIndentRazzle()
:command! RazzleIndent :call SetIndentRazzle()
:command! Notes :execute 'e ' . g:user_notes_dir . '/notes.txt'
:command! Work :execute 'e ' .  g:user_notes_dir . '/work_notes.txt'

function! ToggleSensitivityFunc()
  :set ic!
endfunction


:set cursorline
let mapleader="\<Space>"
let maplocalleader="\<Space>"
map \ <leader>

map <leader>l <c-w>l
map <leader>h <c-w>h
map <leader>k <c-w>k
map <leader>j <c-w>j
map <leader>n <c-w>n
map <leader>v <c-w>v

nmap <C-=> :call IncrementFontSize()<CR>
nmap <C--> :call DecrementFontSize()<CR>

nmap cp :let @* = expand("%:p")<CR>
nmap fp :let @* = expand("%:p")<CR>

if has('nvim')
  set listchars=tab:¦\ ,trail:·

  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>

  " Using Lua functions
  nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
endif


command! Con :execute "e " . s:init_vim_path
command! Conf :Con
command! Eval :so%
command! Wiki :e ~/Dropbox/wiki
command! LoadConf :so ~/.vimrc
command! Spell :spell spelllang=en_us
command! PatchSD :call PatchSDProc()
command! ReloadConf :so ~/.vimrc
command! SaveAsUTF8 :call SaveAsUTF8Function()
command! -nargs=1 SetFontSize call SetFontSizeProc(<f-args>)

set autochdir

nnoremap <C-S-Tab> :bprevious<CR>
nnoremap <C-Tab> :bnext<CR>
nnoremap <leader>q :bp <BAR> :bd #<CR>

nnoremap <C-t> :Files<CR>
nnoremap <C-p> :GFiles<CR>

function! FnSetLLVMKeyword()
  :setlocal iskeyword+=.
  :setlocal iskeyword+=%
  :setlocal iskeyword+=@
endfunction

command! SetLLVMKeyword :call FnSetLLVMKeyword()
command! ToggleCaseSensitivity :call ToggleSensitivityFunc()

au BufNewFile,BufRead *.td setlocal ft=tablegen
au BufRead,BufNewFile *.hlsl.* setfiletype hlsl
au BufRead,BufNewFile *.glsli* setfiletype glsl
au BufRead,BufNewFile *.natvis setfiletype xml
au BufRead,BufNewFile *.bf setfiletype beef
au BufRead,BufNewFile *.bf set tabstop=2
au BufRead,BufNewFile *.bf set noexpandtab
au BufRead,BufNewFile *.ll :call FnSetLLVMKeyword()

set clipboard^=unnamed
"match Ignore /\r$/
"
let g:zig_fmt_autosave = 0
:LLVMIndent


map <A-=> <c-w>+
map <A--> <c-w>-
map = <c-w>>
map - <c-w><


