if has('win32') || has('win64')
  let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --exclude .git'
  " Speeds up :History and general searches
  let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
endif

set autochdir

" ============================================================================
" PLUGINS (Vim-Plug handles nocompatible automatically)
" ============================================================================
call plug#begin('~/vimfiles/bundle')
Plug 'antiagainst/vim-tablegen'
Plug 'lambdalisue/fern.vim', { 'branch': 'main' }
Plug 'preservim/nerdcommenter'
Plug 'tpope/tpope-vim-abolish'
Plug 'beyondmarc/hlsl.vim'
Plug 'tpope/vim-speeddating'
Plug 'PProvost/vim-ps1'
Plug 'flazz/vim-colorschemes'
Plug 'skywind3000/asyncrun.vim'
Plug 'vim-airline/vim-airline'
Plug 'justinmk/vim-syntax-extra'
Plug 'Tetralux/odin.vim'
Plug 'tbastos/vim-lua'
Plug 'jdonaldson/vaxe'
Plug 'ziglang/zig.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'chriskempson/base16-vim'
Plug 'tikhomirov/vim-glsl'
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

" ============================================================================
" CORE SETTINGS & PERFORMANCE TWEAKS
" ============================================================================
set backspace=indent,eol,start
set showmatch
set fileformats=unix,dos
set autoread
set noerrorbells
set novisualbell
set vb t_vb=
set hlsearch
set encoding=utf-8   
syntax on
set number
set background=dark
set cursorline
set clipboard^=unnamed

" Performance rendering flags for standard GVim/Vim
if !has('nvim')
  set ttyfast ttymouse=xterm2 lazyredraw ttyscroll=3 
endif

" CRITICAL PERFORMANCE FIX: Avoid using 'set autochdir' as it destroys performance.
" Use manual cd if needed: command! CdCurrent cd %:p:h

" ============================================================================
" GUI OPTIONS (Disable laggy toolbars/scrollbars)
" ============================================================================
set guioptions-=L
set guioptions-=r
set guioptions-=T
set guioptions-=m
set guioptions-=e

" ============================================================================
" BACKUP / SWAP DIRECTORIES
" ============================================================================
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

" ============================================================================
" VARIABLES & INITIALIZATION
" ============================================================================
let g:user_font_face='Consolas'
let g:user_font_size=11
let g:user_notes_dir='F:/misc/hby/notes'
let g:user_debug_enabled=v:false
let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-p']
let g:cpp_class_scope_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1
let g:zig_fmt_autosave = 0

let s:init_vim_path  = expand('<sfile>')
let s:init_vim_dir   = expand('<sfile>:p:h')
let s:user_init_path = s:init_vim_dir . "/user.vim"

if filereadable(s:user_init_path)
  execute "source " . s:user_init_path
endif

" ============================================================================
" MAPPINGS (Cleaned up recursive loops)
" ============================================================================
let mapleader="\<Space>"
let maplocalleader="\<Space>"
map \ <leader>

" Command-line mode mappings
cmap <C-V> <C-R>+
cmap <C-Y> <C-R>+

" Window navigation (Enforced non-recursive)
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>l <c-w>l
nnoremap <leader>h <c-w>h
nnoremap <leader>k <c-w>k
nnoremap <leader>j <c-w>j
nnoremap <leader>n <c-w>n
nnoremap <leader>v <c-w>v

" Window Resizing
nnoremap <A-=> <c-w>+
nnoremap <A--> <c-w>-
nnoremap = <c-w>>
nnoremap - <c-w><

" Buffer Navigation
nnoremap <C-S-Tab> :bprevious<CR>
nnoremap <C-Tab> :bnext<CR>
nnoremap <leader>q :bp <BAR> :bd #<CR>

" Tags / Files
nnoremap <F12> <C-]>
nnoremap <C-BS> <C-T>
nnoremap <C-t> :Files<CR>
nnoremap <C-p> :GFiles<CR>

" Font / Path Mappings
nnoremap <C-=> :call IncrementFontSize()<CR>
nnoremap <C--> :call DecrementFontSize()<CR>
nnoremap cp :let @* = expand("%:p")<CR>
nnoremap fp :let @* = expand("%:p")<CR>
nnoremap <c-b> :call Run()<CR>

" ============================================================================
" FUNCTIONS & UTILITIES
" ============================================================================
function! ApplyUserFontProc()
  let font_string = g:user_font_face . ':h' . g:user_font_size
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

function! Run()
  call RunBat('r.bat')
endfunction

function! SaveAsUTF8Function()
  :w ++enc=utf8 %
endfunction

function! ToggleSensitivityFunc()
  set ic!
endfunction

" Indentation Profiles
function! SetIndentNormal()
  set tabstop=4 shiftwidth=4 noexpandtab
endfunction

function! SetIndentRazzle()
  set tabstop=4 shiftwidth=4 expandtab
endfunction

function! SetIndentLLVM()
  set tabstop=2 shiftwidth=2 expandtab
endfunction

function! FnSetLLVMKeyword()
  setlocal iskeyword+=.,%,@
endfunction

" Regex Processing Functions
function! PatchSDProc()
  :%s/@llvm\.xbox\.load\.scratch\.desc(i64 %\d\+/@llvm\.xbox\.load\.scratch\.desc(i32 %shmem_ptr, i32 %shmem_ptr/g
  :%s/declare <4 x i32> @llvm.xbox\.load\.scratch\.desc(i64,/declare <4 x i32> @llvm.xbox.load.scratch.desc(i32, i32,/g
  :%s/ = XBOX_LOAD_SCRATCH_DESC %\d\+, \(\d\+\), 0, %\d\+/ = XBOX_LOAD_SCRATCH_DESC $sgpr0, $sgpr1, \1, 0, $sgpr0, $sgpr1/g
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
    execute l:replace_string
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

function! DoPruneEnum()
  :'<,'>s/\s\+=\s\+\d\+,/:/g
endfunction
function! DoPruneShaderAsm()
  :%s/ \+\/\/.*\n/\r/g
endfunction

" ============================================================================
" AUTOCMDS
" ============================================================================
autocmd FileType markdown setlocal formatoptions-=r formatoptions-=o

augroup PROJECT_FILETYPES
  autocmd!
  au BufNewFile,BufRead *.td setlocal ft=tablegen
  au BufRead,BufNewFile *.hlsl.* setfiletype hlsl
  au BufRead,BufNewFile *.glsli* setfiletype glsl
  au BufRead,BufNewFile *.natvis setfiletype xml
  au BufRead,BufNewFile *.bf setfiletype beef | setlocal tabstop=2 noexpandtab
  au BufRead,BufNewFile *.ll :call FnSetLLVMKeyword()
augroup END

" ============================================================================
" COMMAND EXECS
" ============================================================================
"command! NT :NERDTreeToggle
"command! NTT :NERDTree
command! NT :Fern . -drawer -toggle
command! NTT :Fern . -drawer
command! Setup :call SetupScript()
command! PruneDbg :call DoPruneDbg()
command! PruneDbgMore :call DoPruneDbgMore()
command! IndentNormal :call SetIndentNormal()
command! IndentLLVM :call SetIndentLLVM()
command! PruneShaderAsm :call DoPruneShaderAsm()
command! PruneEnum :call DoPruneEnum()
command! LLVMIndent :call SetIndentLLVM()
command! IndentRazzle :call SetIndentRazzle()
command! RazzleIndent :call SetIndentRazzle()
command! Notes :execute 'e ' . g:user_notes_dir . '/notes.txt'
command! Work :execute 'e ' .  g:user_notes_dir . '/work_notes.txt'
command! ToggleCaseSensitivity :call ToggleSensitivityFunc()
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

function! s:init_fern() abort
  nmap <buffer> o <Plug>(fern-action-open-or-expand)
  nmap <buffer> u <Plug>(fern-action-leave)
  nmap <buffer> C <Plug>(fern-action-enter)
  nmap <buffer> R <Plug>(fern-action-reload)
endfunction

augroup FernNerdTreeHabits
  autocmd!
  autocmd FileType fern call s:init_fern()
augroup END

" ============================================================================
" NEOVIM ONLY CONFIGS
" ============================================================================
if has('nvim')
  autocmd FocusGained * silent! checktime
  set listchars=tab:¦\ ,trail:·

  nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
endif

" ============================================================================
" INITIALIZATION RUNS
" ============================================================================
colorscheme codedark
call ApplyUserFontProc()
call SetIndentLLVM()
