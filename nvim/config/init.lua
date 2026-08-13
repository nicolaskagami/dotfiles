-- ~/.config/nvim/init.lua
-- Neovim 0.11+ config for illumos.
-- Design rules: pure-Lua plugins only, no mason.nvim, no prebuilt-binary
-- downloads. External tools you install yourself (pkgsrc / rustup / cargo):
--   rust-analyzer   -> rustup component add rust-analyzer
--   ripgrep (rg)    -> pkgin in ripgrep   (or: cargo install ripgrep)
--   fd (optional)   -> pkgin in fd-find   (or: cargo install fd-find)
--   gcc + gmake     -> for treesitter parsers and telescope-fzf-native

-------------------------------------------------------------------------
-- Options
-------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


local o = vim.opt
o.number = true
o.relativenumber = true
o.signcolumn = 'yes'          -- keep gutter stable for gitsigns/diagnostics
o.cursorline = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.splitright = true
o.splitbelow = true
-- o.undofile = true             -- persistent undo
o.updatetime = 250            -- faster CursorHold (gitsigns blame, etc.)
o.timeoutlen = 1000           -- give multi-key maps (grr, <leader>h…) time
o.completeopt = { 'menu', 'menuone', 'noselect' }
o.termguicolors = true
o.scrolloff = 4
o.clipboard = 'unnamedplus'   -- needs a clipboard provider; harmless if absent
o.exrc = true                 -- per-project .nvim.lua (trust-prompted on first load)

-------------------------------------------------------------------------
-- Bootstrap lazy.nvim (pure Lua, installs via git clone)
-------------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------
require('lazy').setup({

  -- Colorscheme (pure Lua)
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('kanagawa')
    end,
  },

  -- Treesitter: parsers are compiled locally with gcc
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',   -- pin: the new 'main' branch removed the old API
    build = ':TSUpdate',
    config = function()
      -- illumos: make sure we use gcc, not Sun cc, for parser builds
      require('nvim-treesitter.install').compilers = { 'gcc', 'cc' }
      -- illumos: Sun tar chokes on GitHub tarballs (pax headers); clone
      -- parser repos with git instead of curl+tar
      require('nvim-treesitter.install').prefer_git = true
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'rust', 'toml', 'lua', 'vim', 'vimdoc', 'markdown', 'c' },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Fuzzy finding: telescope + ripgrep, with the native C sorter
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- plain `make` on illumos is Sun make; use gmake
        build = 'gmake',
      },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          layout_strategy = 'flex',
          sorting_strategy = 'ascending',
          layout_config = { prompt_position = 'top' },
          preview = {
            -- illumos: Sun file(1) has no --mime-type; skip the binary probe
            check_mime_type = false,
            filesize_limit = 5, -- MB; don't try to preview huge files instead
          },
        },
        pickers = {
          -- results list shows just file:line, the code lives in the preview
          lsp_references       = { show_line = false },
          lsp_implementations  = { show_line = false },
          lsp_type_definitions = { show_line = false },
          lsp_definitions      = { show_line = false },
        },
        extensions = {
          -- code actions (gra) and every other vim.ui.select prompt
          -- become a compact fuzzy dropdown instead of a numbered list
          ['ui-select'] = {
            require('telescope.themes').get_dropdown({}),
          },
        },
      })
      -- Don't die if the C extension didn't build; telescope still works
      pcall(telescope.load_extension, 'fzf')
      telescope.load_extension('ui-select')

      local b = require('telescope.builtin')
      local map = vim.keymap.set
      map('n', '<leader>ff', b.find_files,  { desc = 'Find files' })
      map('n', '<leader>fg', b.live_grep,   { desc = 'Live grep (rg)' })
      map('n', '<leader>fw', b.grep_string, { desc = 'Grep word under cursor' })
      map('n', '<leader>fb', b.buffers,     { desc = 'Buffers' })
      map('n', '<leader>fh', b.help_tags,   { desc = 'Help' })
      map('n', '<leader>fr', b.oldfiles,    { desc = 'Recent files' })
      map('n', '<leader>fd', b.diagnostics, { desc = 'Diagnostics' })
      map('n', '<leader>fs', b.lsp_document_symbols,          { desc = 'Document symbols' })
      map('n', '<leader>fS', b.lsp_dynamic_workspace_symbols, { desc = 'Workspace symbols' })
      map('n', '<leader>gs', b.git_status,  { desc = 'Git status (picker)' })
      map('n', '<leader>gc', b.git_commits, { desc = 'Git commits' })
    end,
  },

  -- Git: hunks, staged-vs-unstaged signs, blame
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '┃' }, change = { text = '┃' },
          delete = { text = '▁' }, topdelete = { text = '▔' },
          changedelete = { text = '~' },
        },
        -- staged hunks get their own (dimmer) signs so you can see
        -- at a glance what's staged vs not
        signs_staged_enable = true,
        -- Zed-style inline blame: faded text after the cursor line
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text_pos = 'eol_right_align',
          delay = 5,                -- only appears when you linger
          ignore_whitespace = true,
        },
        current_line_blame_formatter = '<author>, <author_time:%R> • <summary>',
        on_attach = function(bufnr)
          local gs = require('gitsigns')
          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then vim.cmd.normal({ ']c', bang = true })
            else gs.nav_hunk('next') end
          end, 'Next hunk')
          map('n', '[c', function()
            if vim.wo.diff then vim.cmd.normal({ '[c', bang = true })
            else gs.nav_hunk('prev') end
          end, 'Prev hunk')

          -- Hunk actions
          map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk (again = unstage)')
          map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
          map('v', '<leader>hs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, 'Stage selected lines')
          map('v', '<leader>hr', function()
            gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, 'Reset selected lines')
          map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
          map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
          map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
          map('n', '<leader>hi', gs.preview_hunk_inline, 'Preview hunk inline')
          map('n', '<leader>hd', gs.diffthis, 'Diff against index')
          map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff against HEAD~')
          map('n', '<leader>hb', gs.toggle_current_line_blame, 'Toggle line blame')
          map('n', '<leader>hq', gs.setqflist, 'Hunks -> quickfix')

          -- Hunk as a text object: e.g. `vih` selects it, `dih` deletes it
          map({ 'o', 'x' }, 'ih', gs.select_hunk, 'Select hunk')
        end,
      })
    end,
  },

  -- Fugitive: :Git status buffer (stage/unstage with `-`, diff with `=`),
  -- :Git blame, :Gdiffsplit for resolving against the index
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gg', '<cmd>Git<cr>', { desc = 'Git status (fugitive)' })
      vim.keymap.set('n', '<leader>gd', '<cmd>Gdiffsplit<cr>', { desc = 'Diff split vs index' })
      vim.keymap.set('n', '<leader>gb', '<cmd>Git blame<cr>', { desc = 'Git blame' })
    end,
  },

  -- Review whole changesets / file history
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gv', '<cmd>DiffviewOpen<cr>', desc = 'Diffview' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history' },
    },
  },

  -- Completion: nvim-cmp (pure Lua) + LuaSnip
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',            -- skip jsregexp build; not needed
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },

  -- LSP progress in the corner: shows rust-analyzer's indexing status
  -- ("cargo metadata", "indexing 231/540", ...) so silence is explainable
  {
    'j-hui/fidget.nvim',
    opts = {},
  },

  -- Statusline (pure Lua)
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      -- show the host OS's logo for unix fileformat, not always illumos
      local os_glyph = ({
        SunOS   = '\u{f326}', -- illumos (nf-linux-illumos)
        Linux   = '\u{f31a}', -- Tux
        Darwin  = '\u{f179}', -- Apple
        FreeBSD = '\u{f30c}',
      })[(vim.uv or vim.loop).os_uname().sysname] or '\u{f31a}'
      require('lualine').setup({
        options = { section_separators = '', component_separators = '|' },
        sections = {
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = {
            'encoding',
            { 'fileformat', symbols = { unix = os_glyph, dos = '\u{f17a}', mac = '\u{f179}' } },
            'filetype',
          },
        },
      })
    end,
  },
})

-------------------------------------------------------------------------
-- LSP: rust-analyzer via Neovim 0.11 native config (no lspconfig, no mason)
-------------------------------------------------------------------------
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },      -- must be on $PATH (rustup component)
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', '.git' },
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      check = { command = 'clippy' },   -- clippy on save instead of check
      inlayHints = {
        bindingModeHints = { enable = true },
        closureReturnTypeHints = { enable = 'with_block' },
        lifetimeElisionHints = { enable = 'skip_trivial' },
      },
    },
  },
})
vim.lsp.enable('rust_analyzer')

-- Track whether any LSP work (rust-analyzer indexing, cargo check, ...) is
-- in flight, so navigation can wait instead of returning empty results.
local lsp_inflight = {}
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local key = ev.data.client_id .. ':' .. tostring(ev.data.params.token)
    if ev.data.params.value.kind == 'end' then
      lsp_inflight[key] = nil
    else
      lsp_inflight[key] = true
    end
  end,
})

-- Wrap an LSP action: if the server is busy, wait for it (up to 60s) and
-- run the action once indexing settles, instead of querying too early.
local function when_ready(fn)
  return function()
    if next(lsp_inflight) == nil then return fn() end
    vim.notify('rust-analyzer is indexing — will search when it settles…',
      vim.log.levels.INFO)
    local timer = assert((vim.uv or vim.loop).new_timer())
    local waited = 0
    timer:start(250, 250, vim.schedule_wrap(function()
      waited = waited + 250
      if next(lsp_inflight) == nil or waited >= 60000 then
        timer:stop()
        timer:close()
        fn()
      end
    end))
  end
end

-- Buffer-local LSP keymaps (0.11 already gives you: grn rename, gra code
-- action, grr references, gri implementation, gO document symbols, K hover)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map('gD', vim.lsp.buf.declaration, 'Go to declaration')

    -- Telescope-backed LSP navigation: fuzzy picker + preview instead of
    -- the raw quickfix list. Shadows the 0.11 builtin gr* defaults.
    local tb = require('telescope.builtin')
    map('grr', when_ready(tb.lsp_references),       'References / usages (telescope)')
    map('gri', when_ready(tb.lsp_implementations),  'Implementations (telescope)')
    map('grt', when_ready(tb.lsp_type_definitions), 'Type definitions (telescope)')
    map('gd',  when_ready(vim.lsp.buf.definition),  'Go to definition')
    map('grn', vim.lsp.buf.rename,      'Rename symbol')
    map('gra', vim.lsp.buf.code_action, 'Code action')
    map('<leader>lf', function() vim.lsp.buf.format({ async = true }) end, 'Format (rustfmt)')
    map('<leader>lh', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }),
        { bufnr = ev.buf })
    end, 'Toggle inlay hints')

    -- Format Rust buffers on save
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == 'rust_analyzer' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = ev.buf,
        callback = function() vim.lsp.buf.format({ bufnr = ev.buf }) end,
      })
    end
  end,
})

-------------------------------------------------------------------------
-- Diagnostics
-------------------------------------------------------------------------
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { current_line = false },
  float = { border = 'rounded', source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN]  = '▲',
      [vim.diagnostic.severity.HINT]  = '⚑',
      [vim.diagnostic.severity.INFO]  = '»',
    },
  },
})
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics -> loclist' })

-------------------------------------------------------------------------
-- Quality of life
-------------------------------------------------------------------------
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.hl.on_yank() end,
})
