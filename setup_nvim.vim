
let s:content = [
      \'set runtimepath^=~/vimfiles runtimepath+=~/vimfiles/after',
      \'let &packpath = &runtimepath',
      \'source ~/.vimrc'
      \]

let s:nvim_conf_dir  = $HOME . '/AppData/Local/nvim'
let s:nvim_conf_path = s:nvim_conf_dir . "/init.vim"

if !isdirectory(s:nvim_conf_dir)
  call mkdir(s:nvim_conf_dir, "p")
endif

call writefile(s:content, s:nvim_conf_path)

