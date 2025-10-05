let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()

Plug 'nvim-lua/plenary.nvim'

" Tools
if has('nvim')
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction

  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
  Plug 'gelguy/wilder.nvim'

  " To use Python remote plugin features in Vim, can be skipped
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

" UI
Plug 'hoob3rt/lualine.nvim'
Plug 'navarasu/onedark.nvim'

"Syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

" Basic settings
syntax enable
set number
set nowrap
set pumheight=10
set cmdheight=2
set shiftwidth=0
set tabstop=4
set smarttab
set showtabline=2
set clipboard=unnamedplus
set updatetime=100
set shortmess+=c
set timeoutlen=500
set nobackup
set nowritebackup
set noshowmode
set termguicolors 
let g:mapleader = "\<Space>"

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup END

" open init.vim
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

" useful abreviations
iabbrev @@ adrianportales135@gmail.com

" open current buffer in new tab
nnoremap <Leader>z :tabnew %<CR>

"next item in quickfix
nnoremap <Leader>n :cn <CR>
" previous item in quickfix
nnoremap <Leader>p :cp <CR>

" use C+hjkl to move between split/vsplit panels
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
		
" use alt+hjkl to resize window
nnoremap <M-j> :resize +2<CR>
nnoremap <M-k> :resize -2<CR>
nnoremap <M-h> :vertical resize +2<CR>
nnoremap <M-l> :vertical resize -2<CR>

" go to normal mode in terminal
tnoremap jk <C-\><C-n>  
tnoremap <Esc> <C-\><C-n>

" go to normal mode from insert
inoremap jk <ESC>

" Have j and k navigate visual lines rather than logical ones
nnoremap j gj
nnoremap k gk

" buffer switching
nnoremap <TAB> :bn<CR>
nnoremap <S-TAB> :bp<CR>
" close current buffer
nnoremap <leader>q :bd<CR>

" reload init.vim
nnoremap <leader>sv :source $MYVIMRC<CR>

" theme
let g:onedark_config = {
	\'style': 'darker',
    \'transparent': v:true,
\}
colorscheme onedark


" wilder
lua << EOF
local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})
-- Disable Python remote plugin
wilder.set_option('use_python_remote_plugin', 0)

wilder.set_option('pipeline', {
  wilder.branch(
	wilder.cmdline_pipeline({
	  fuzzy = 1,
	}),
	wilder.vim_search_pipeline()
  )
})

wilder.set_option('renderer', wilder.renderer_mux({
  [':'] = wilder.popupmenu_renderer({
	highlighter = wilder.basic_highlighter(),
	left = {
	  ' ',
	  wilder.popupmenu_devicons()
	},
	right = {
	  ' ',
	  wilder.popupmenu_scrollbar()
	},
  }),
  ['/'] = wilder.wildmenu_renderer({
	highlighter = wilder.basic_highlighter(),
  }),
}))
EOF


lua << EOF
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'onedark',
    disabled_filetypes = {},
	globalstatus= true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'diff','filesize'},
    lualine_x = {'encoding', 'filetype','fileformat' },
    lualine_y = {'diagnostics'},
	lualine_z = {'location'}
  },
}
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,       
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false
  }
}
EOF

" gitsigns
lua require('gitsigns').setup{ current_line_blame=true }
