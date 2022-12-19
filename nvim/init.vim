let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()

Plug 'nvim-lua/plenary.nvim'

" Tools
"
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

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'moll/vim-bbye'
Plug 'ggandor/leap.nvim'
Plug 'aserowy/tmux.nvim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'b3nj5m1n/kommentary'
Plug 'mhartington/formatter.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'karoliskoncevicius/vim-sendtowindow'

" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

Plug 'nvim-telescope/telescope.nvim'
Plug 'smartpde/telescope-recent-files'
Plug 'chentoast/marks.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'lukas-reineke/indent-blankline.nvim'

" Themes
Plug 'navarasu/onedark.nvim'

"Syntax and LSP
Plug 'lervag/vimtex'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'adimit/prolog.vim'
Plug 'iden3/vim-circom-syntax'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()


" Basic settings
syntax enable
set number
set nowrap
set pumheight=10
set cmdheight=0
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

augroup no_number_terminal
  autocmd!
  autocmd TermOpen * setlocal nonumber
augroup END

" open init.vim
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

" useful abreviations
iabbrev @@ adrianportales135@gmail.com

" open current buffer in new tab
nnoremap <Leader>z :tabnew %<CR>

" next item in quickfix
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

" reload init.vim
nnoremap <leader>sv :source $MYVIMRC<CR>

"delete buffers
nnoremap <Leader>d :call DeleteBuffer() <CR>
function! DeleteBuffer()  
	let g:bufname = bufname("%")
	if &buftype ==# 'terminal'
		execute	':Bdelete!' g:bufname 
	else
		execute	':Bdelete' g:bufname 
	endif
endfunction

" vimtex
let g:tex_flavor = 'latex'
" let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_compiler_method = 'latexmk'

" markdown preview
let g:mkdp_auto_start = 0

" theme
let g:onedark_config = {
    \ 'style': 'warmer',
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

" tmux
lua << EOF
require("tmux").setup(
{
    copy_sync = {
        enable = false,
        ignore_buffers = { empty = false },
        redirect_to_clipboard = false,
        register_offset = 0,
        sync_clipboard = true,
        sync_deletes = true,
        sync_unnamed = true,
    },
    navigation = {
        cycle_navigation = true,
        enable_default_keybindings = true,
        persist_zoom = true,
    },
    resize = {
        enable_default_keybindings = true,
        resize_step_x = 1,
        resize_step_y = 1,
    }
}
)
EOF

" Telescope settings
" loading extensions
lua require("telescope").load_extension("recent_files")

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files <cr>
nnoremap <leader>fg <cmd>Telescope live_grep <cr>
nnoremap <leader>fb <cmd>Telescope buffers <cr>
nnoremap <leader>fh <cmd>Telescope help_tags <cr>
nnoremap <leader>fw <cmd>Telescope grep_string <cr>
nnoremap <leader>fr <cmd>lua require('telescope').extensions.recent_files.pick()<CR>


"CoC settings
nnoremap <leader>c <cmd>CocStart<cr>
let g:coc_start_at_startup = v:false
let g:coc_global_extensions = [
			\'coc-css', 
			\'coc-html', 
			\'coc-json', 
			\'coc-xml',
			\'coc-yaml',
			\'coc-sh',
			\'coc-lua',
			\'coc-vimlsp',
			\'coc-tsserver',
			\'coc-pyright',
			\'coc-docker',
			\'coc-vimtex']

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
:augroup cursorholdcoc
:  autocmd!
:  autocmd CursorHold * silent call CocActionAsync('highlight')
:augroup END

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
   \ coc#pum#visible() ? coc#_select_confirm() :
   \ coc#expandableOrJumpable() ?
   \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
   \ <SID>check_back_space() ? "\<TAB>" :
   \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" let g:coc_snippet_next = '<tab>'

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif


" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)


nnoremap <C-n> :NvimTreeToggle<CR>
lua << EOF
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  open_on_tab         = false,
  hijack_cursor       = true,
  update_cwd          = true,
  update_focused_file = {
    enable      = true,
    update_cwd  = false,
    ignore_list = {'.git/**'}
  },
  view = {
    width = 30,
	preserve_window_proportions = false,
    side = 'right',
	hide_root_folder = true,
    mappings = {
      custom_only = false,
      list = {}
    },
	float = {
	  enable = true,
	  open_win_config = {
		relative = "editor",
		border = "rounded",
		width = 200,
		height = 25,
		row = 1,
		col = 1,
	  },
	},
 },
  renderer = {
	root_folder_modifier = ":e",
 },
  filters = {
	dotfiles = false,
	custom = { '.git/*','node_modules/*', '.cache/*' }
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  },
}
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


lua << EOF
require('bufferline').setup {
  options = {
    numbers = "buffer_id",
    modified_icon = '●',
    max_name_length = 18,
    max_prefix_length = 15, 
    tab_size = 18,
    diagnostics = "coc",
    diagnostics_update_in_insert = true,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      return "("..count..")"
    end,
    offsets = {{filetype = "NvimTree", text = "" , text_align =  "center" }},
    show_buffer_icons = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true, 
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = true ,
    sort_by = 'id'
  }
}
EOF

set foldlevel=20
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
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

" Provided by setup function
nnoremap <silent> <leader>f :Format<CR>
lua <<EOF
prettier_config = {
      function()
        return {
          exe = "npx prettier",
		  args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--end-of-line","lf"},
          stdin = true
        }
      end
    }

require'formatter'.setup({
  filetype = {
	solidity = {
		function()
			return {
			 exe = "npx prettier",
			 args = {"--write",vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
			 stdin = false
			}
		  end
		  },
    javascript =  prettier_config,
    javascriptreact = prettier_config,
    typescriptreact = prettier_config,
    typescript = prettier_config,
	json = prettier_config,
	css = prettier_config,
	python = {
      function()
        return {
          exe = "black",
		  args = {vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
		  stdin = false
        }
      end
    },
	haskell = {
		function()
			return {
				exe = "ormolu",
				args = {"--mode","inplace",vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
				stdin= false
			}
		end
	},
	go = {
		function()
			return {
				exe = "gofmt",
				args = {"-w","-s",vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
				stdin= false
			}
		end
	}
  }
})
EOF


lua <<EOF
require('neoscroll').setup({
    mappings = { '<C-d>', '<C-u>',
                '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    cursor_scrolls_alone = false,
})
EOF

lua<<EOF
require'marks'.setup {
  default_mappings = true,
  builtin_marks = { },
  cyclic = true,
  force_write_shada = false,
  refresh_interval = 250,
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  excluded_filetypes = {},
}
EOF

" gitsigns
lua require('gitsigns').setup{ current_line_blame=true }

" indent_blankline
lua << EOF
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = false,
    filetype_exclude = {'dashboard','help'}
}
EOF

" Leap
lua require('leap').add_default_mappings()

