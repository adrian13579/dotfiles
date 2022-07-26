let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin()

Plug 'nvim-lua/plenary.nvim'

" Tools
Plug 'moll/vim-bbye'
Plug 'ggandor/lightspeed.nvim'
Plug 'aserowy/tmux.nvim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'b3nj5m1n/kommentary'
Plug 'mhartington/formatter.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'fannheyward/telescope-coc.nvim'
Plug 'karoliskoncevicius/vim-sendtowindow'
Plug 'goerz/jupytext.vim' 

" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

" Appearance
Plug 'nvim-telescope/telescope.nvim'
Plug 'chentoast/marks.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'lukas-reineke/indent-blankline.nvim'
" Themes
Plug 'ful1e5/onedark.nvim'

"Syntax and LSP
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'adimit/prolog.vim'
Plug 'iden3/vim-circom-syntax'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Basic settings
syntax enable
set number
augroup nonumberterminal
  autocmd!
  autocmd TermOpen * setlocal nonu
augroup END
set pumheight=10
set cmdheight=2
set shiftwidth=0
set tabstop=4
set smarttab
set showtabline=2
set clipboard=unnamedplus
set updatetime=300
set shortmess+=c
set timeoutlen=500
set nobackup
set nowritebackup
set noshowmode
set termguicolors 
" set mouse=a
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

" next item in quickfix
nnoremap <Leader>n :cn <CR>
" previous item in quickfix
nnoremap <Leader>p :cp <CR>

""use C+hjkl to move between split/vsplit panels
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
		
"use alt+hjkl to resize window
nnoremap <M-j> :resize +2<CR>
nnoremap <M-k> :resize -2<CR>
nnoremap <M-h> :vertical resize +2<CR>
nnoremap <M-l> :vertical resize -2<CR>

"go to normal mode in terminal
tnoremap jk <C-\><C-n>  
tnoremap <Esc> <C-\><C-n>

"go to normal mode from insert
inoremap jk <ESC>

" Have j and k navigate visual lines rather than logical ones
nnoremap j gj
nnoremap k gk

"buffer switching
nnoremap <TAB> :bn<CR>
nnoremap <S-TAB> :bp<CR>

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


" theme
lua <<EOF
require('onedark').setup{
	lualine_bold = true,
}
EOF

hi Search guibg=peru guibg=LightBlue
hi IncSearch guibg=peru guibg=LightBlue

lua << EOF
require("tmux").setup(
{
    copy_sync = {
        -- enables copy sync and overwrites all register actions to
        -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
        enable = false,

        -- ignore specific tmux buffers e.g. buffer0 = true to ignore the
        -- first buffer or named_buffer_name = true to ignore a named tmux
        -- buffer with name named_buffer_name :)
        ignore_buffers = { empty = false },

        -- TMUX >= 3.2: yanks (and deletes) will get redirected to system
        -- clipboard by tmux
        redirect_to_clipboard = false,

        -- offset controls where register sync starts
        -- e.g. offset 2 lets registers 0 and 1 untouched
        register_offset = 0,

        -- sync clipboard overwrites vim.g.clipboard to handle * and +
        -- registers. If you sync your system clipboard without tmux, disable
        -- this option!
        sync_clipboard = true,

        -- syncs deletes with tmux clipboard as well, it is adviced to
        -- do so. Nvim does not allow syncing registers 0 and 1 without
        -- overwriting the unnamed register. Thus, ddp would not be possible.
        sync_deletes = true,

        -- syncs the unnamed register with the first buffer entry from tmux.
        sync_unnamed = true,
    },
    navigation = {
        -- cycles to opposite pane while navigating into the border
        cycle_navigation = true,

        -- enables default keybindings (C-hjkl) for normal mode
        enable_default_keybindings = true,

        -- prevents unzoom tmux when navigating beyond vim border
        persist_zoom = false,
    },
    resize = {
        -- enables default keybindings (A-hjkl) for normal mode
        enable_default_keybindings = true,

        -- sets resize steps for x axis
        resize_step_x = 1,

        -- sets resize steps for y axis
        resize_step_y = 1,
    }
}
)
EOF


" Telescope settings
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files theme=ivy<cr>
nnoremap <leader>fg <cmd>Telescope live_grep theme=ivy<cr>
nnoremap <leader>fb <cmd>Telescope buffers theme=ivy<cr>
nnoremap <leader>fh <cmd>Telescope help_tags theme=ivy<cr>
nnoremap <leader>fw <cmd>Telescope grep_string theme=ivy<cr>

lua require('telescope').load_extension('coc')

"CoC settings
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
			\'coc-vimtex',
			\'coc-spell-checker',
			\ 'coc-cspell-dicts']

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
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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


lua << EOF
-- following options are the default
require'nvim-tree'.setup {

  -- disables netrw completely
  disable_netrw       = true,
  -- hijack netrw window on startup
  hijack_netrw        = true,
  -- open the tree when running this setup function
  open_on_setup       = false,
  -- will not open on setup if the filetype is in this list
  ignore_ft_on_setup  = {},
  -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
  open_on_tab         = false,
  -- hijack the cursor in the tree to put it at the start of the filename
  hijack_cursor       = true,
  -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually) 
  update_cwd          = false,
  -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
  update_focused_file = {
    -- enables the feature
    enable      = false,
    -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
    -- only relevant when `update_focused_file.enable` is true
    update_cwd  = false,
    -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
    -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
    ignore_list = {'.git/**'}
  },
  -- configuration options for the system open command (`s` in the tree by default)
  system_open = {
    -- the command to run this, leaving nil should work in most cases
    cmd  = nil,
    -- the command arguments as a list
    args = {}
  },

  view = {
    -- width of the window, can be either a number (columns) or a string in `%`
    width = 30,
	height= 30,
    -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
    side = 'left',
	hide_root_folder = true,
    -- if true the tree will resize itself after opening a file
    mappings = {
      -- custom only false will merge the list with the default mappings
      -- if true, it will only use your list to set the mappings
      custom_only = false,
      -- list of mappings to set on the tree manually
      list = {}
    },
 },
 filters = {
	dotfiles = false,
	custom = { '.git/*','node_modules/*', '.cache/*' }
  },
 trash = {
    cmd = "trash",
    require_confirm = true
  }
}
EOF
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 0 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':e'
let g:nvim_tree_add_trailing = 0 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 0 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
" Dictionary of buffer option names mapped to a list of option values that
" indicates to the window picker that the buffer's window should not be
" selectable.
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 1,
    \ }
"If 0, do not show the icons for one of 'git' 'folder' and 'files'
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath.
"if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
"but this will not work when you set indent_markers (because of UI conflict)

" default will show icon by default if no icon is provided
" default shows no icon by default 
let g:nvim_tree_icons = {
	\ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

nnoremap <C-n> :NvimTreeToggle<CR>


lua << EOF
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'onedark-nvim',
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename','filesize'},
    lualine_x = {'encoding', 'filetype','fileformat' },
    lualine_y = {'diagnostics','diff'},
	lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
EOF




lua << EOF
require('bufferline').setup {
  options = {
    numbers = "buffer_id",-- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
    close_command = "Bdelete! %d",       -- can be a string | function, see "Mouse actions"
    right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
    indicator_icon = '▎',
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = 'ᐊ',
    right_trunc_marker = 'ᐅ',
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 18,
    diagnostics = "coc",-- | "nvim_lsp" | "coc",
    diagnostics_update_in_insert = true,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      return "("..count..")"
    end,
    offsets = {{filetype = "NvimTree", text = "" , text_align =  "center" }},
    show_buffer_icons = true,-- | false, -- disable filetype icons for buffers
    show_buffer_close_icons = true,-- | false,
    show_close_icon = true,-- | false,
    show_tab_indicators = true,-- | false,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    separator_style = "thin",-- | "thick" | "thin" | { 'any', 'any' },
    enforce_regular_tabs = false,-- | true,
    always_show_bufferline = true ,--| false,
    sort_by = 'id'
  }
}
EOF


augroup nonumberterminal
  autocmd!
  autocmd BufNewFile,BufRead *.sol			setf solidity
augroup END
set foldlevel=20
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
lua <<EOF
require'nvim-treesitter.configs'.setup {
  --ensure_installed = "all", 
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
		  args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote'},
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
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = { '<C-d>', '<C-u>',
                '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = false, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil,        -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,              -- Function to run after the scrolling animation ends
})
EOF

lua<<EOF
require'marks'.setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions. 
  -- higher values will have better performance but may cause visual lag, 
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 250,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world"
  },
  mappings = {}
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

let g:jupytext_fmt = 'py'
let g:jupytext_to_ipynb_opts = '--to=ipynb --update'
