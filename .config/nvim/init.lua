-- ============================================================================
-- Plugins
-- ============================================================================

vim.pack.add {
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/rebelot/kanagawa.nvim',
    'https://github.com/vyfor/cord.nvim',
}

-- Built-in / native plugins
vim.cmd.packadd('cfilter')
vim.cmd.packadd('nvim.undotree')
vim.cmd.packadd('nvim.difftool')

require('tagx')


-- ============================================================================
-- Leader
-- ============================================================================

vim.g.mapleader = ','
vim.g.maplocalleader = ','


-- ============================================================================
-- UI
-- ============================================================================

require('vim._core.ui2').enable {
    msg = {
        target = 'cmd',
        cmd = { height = 1 },
    },
}

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes:1'

vim.opt.cursorline = true
vim.opt.scrolloff = 1
vim.opt.sidescrolloff = 8

vim.opt.colorcolumn = '100'
vim.opt.textwidth = 80

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.smoothscroll = true

vim.opt.showmode = false
vim.opt.ruler = false

vim.opt.statusline =
    '[%n] %<%f %h%w%m%r%=%-14.(%l,%c%V%) %P'

vim.cmd.colorscheme('kanagawa-dragon')


-- ============================================================================
-- Editing
-- ============================================================================

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.completeopt = {
    'menu',
    'menuone',
    'fuzzy',
    'noinsert',
}

vim.opt.nrformats:append {
    'blank',
    'alpha',
}

vim.opt.path:append {
    '**',
}


-- ============================================================================
-- Files / Persistence
-- ============================================================================

vim.opt.swapfile = false
vim.opt.confirm = true
vim.opt.undofile = true

vim.opt.exrc = true

-- Don't create these files in the current directory.
vim.opt.backup = false
vim.opt.writebackup = false


-- ============================================================================
-- Clipboard
-- ============================================================================

vim.opt.clipboard = 'unnamedplus'


-- ============================================================================
-- Searching
-- ============================================================================

vim.opt.grepprg = 'rg --vimgrep --no-messages --smart-case'

vim.opt.incsearch = true
vim.opt.hlsearch = true


-- ============================================================================
-- Folding
-- ============================================================================

vim.opt.foldlevel = 999
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'


-- ============================================================================
-- Command-line completion
-- ============================================================================

vim.opt.wildoptions:append {
    'fuzzy',
}


-- ============================================================================
-- Mouse
-- ============================================================================

vim.opt.mouse = 'a'

-- Disable the mouse popup menu while keeping mouse support.
vim.cmd [[
    aunmenu PopUp
    autocmd! nvim.popupmenu
]]


-- ============================================================================
-- Treesitter
-- ============================================================================

vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})


-- ============================================================================
-- Oil
-- ============================================================================

require('oil').setup {
    keymaps = {
        ['<C-h>'] = false,
    },

    columns = {
        'size',
        'mtime',
    },
    view_options = {
        show_hidden = true,
    },


    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
}

vim.keymap.set('n', '<leader><leader>', '<cmd>Oil<CR>', {
    silent = true,
    desc = 'Open Oil',
})


-- ============================================================================
-- Arguments
-- ============================================================================

vim.keymap.set('n', '<leader>a', function()
    vim.cmd('$argadd %')
    vim.cmd('argdedup')
end, {
    desc = 'Add current file to arguments',
})

vim.keymap.set('n', '<C-h>', function()
    vim.cmd('silent! 1argument')
end, {
    desc = 'Argument 1',
})

vim.keymap.set('n', '<C-j>', function()
    vim.cmd('silent! 2argument')
end, {
    desc = 'Argument 2',
})

vim.keymap.set('n', '<C-l>', function()
    vim.cmd('silent! 3argument')
end, {
    desc = 'Argument 3',
})

vim.keymap.set('n', '<C-n>', function()
    vim.cmd('silent! 4argument')
end, {
    desc = 'Argument 4',
})

vim.keymap.set('n', '<C-m>', function()
    vim.cmd('silent! 5argument')
end, {
    desc = 'Argument 5',
})

-- ============================================================================
-- LSP
-- ============================================================================

vim.diagnostic.config {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,

    severity_sort = true,

    float = {
        border = 'rounded',
        source = true,
    },
}


-- LSP servers
vim.lsp.config('clangd', {
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--completion-style=detailed',
        '--header-insertion=iwyu',
        '--fallback-style=llvm',
    },

    filetypes = {
        'c',
        'cpp',
        'objc',
        'objcpp',
        'cuda',
    },

    root_markers = {
        'compile_commands.json',
        'compile_flags.txt',
        '.clangd',
        '.git',
    },
})

vim.lsp.config('pyright', {
    cmd = {
        'pyright-langserver',
        '--stdio',
    },

    filetypes = {
        'python',
    },

    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
    },
})

vim.lsp.enable {
    'clangd',
    'pyright',
}


-- LSP attach
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
            return
        end

        vim.bo[bufnr].signcolumn = 'yes:1'

        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
                buffer = bufnr,
                silent = true,
                desc = desc,
            })
        end

        -- Navigation
        map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
        map('n', 'gr', vim.lsp.buf.references, 'Find references')
        map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
        map('n', 'gy', vim.lsp.buf.type_definition, 'Go to type definition')

        -- Information
        map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
        map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature help')

        -- Actions
        map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')

        -- Diagnostics
        map('n', '[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
        map('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')
        map('n', '<leader>e', vim.diagnostic.open_float, 'Show diagnostic')
        map('n', '<leader>q', vim.diagnostic.setloclist, 'Diagnostics list')

        -- Formatting
        if client:supports_method('textDocument/formatting') then
            map('n', '<leader>f', function()
                vim.lsp.buf.format {
                    async = true,
                }
            end, 'Format buffer')
        end

        -- Completion
        if client:supports_method('textDocument/completion') then
            vim.opt.completeopt = {
                'menu',
                'menuone',
                'popup',
                'noinsert',
            }

            vim.opt.complete = {
                'o',
                '.',
                'w',
                'b',
                'u',
            }

            vim.lsp.completion.enable(
                true,
                client.id,
                bufnr
            )
        end
    end,
})

-- ============================================================================
-- Yank highlighting
-- ============================================================================

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank {
            timeout = 150,
        }
    end,
})


-- ============================================================================
-- Miscellaneous
-- ============================================================================

-- Keep the cursor centered while jumping around.
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Clear search highlighting.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', {
    silent = true,
    desc = 'Clear search highlight',
})

