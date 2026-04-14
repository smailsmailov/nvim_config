--[[
  Neovim 0.11+ config — lazy.nvim, native LSP, treesitter
  Поставить: см. инструкцию в конце файла
]]

--------------------------------------------------------------------------------
-- Leader
--------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Отключаем netrw (будем использовать neo-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--------------------------------------------------------------------------------
-- Базовые опции
--------------------------------------------------------------------------------
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 20
vim.opt.wrap = false
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.selection = "exclusive"
-- gdefault убран: ломает substitute (используй /g явно)
vim.opt.virtualedit = "block"
vim.opt.clipboard = "unnamedplus"
vim.opt.spell = true
vim.opt.spelllang = { "en", "ru" }
-- Если русский словарь не найден — nvim предложит скачать его автоматически.
-- Либо вручную в nvim:  :set spelllang=ru  (и согласиться на загрузку)
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300

--------------------------------------------------------------------------------
-- Bootstrap lazy.nvim
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Плагины
--------------------------------------------------------------------------------
require("lazy").setup({

  -- ═══════════════════════  Тема  ═══════════════════════
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  -- ═══════════════════════  Иконки  ═══════════════════════
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ═══════════════════════  Treesitter  ═══════════════════════
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "query",
          "markdown", "markdown_inline",
          "python", "php", "html", "css", "scss",
          "javascript", "typescript", "tsx",
          "go", "gomod", "gosum",
          "json", "yaml", "toml", "bash",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- ═══════════════════════  LSP: Mason + lspconfig  ═══════════════════════
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "html",
        "emmet_ls",
        "cssls",
        "somesass_ls",
        "pyright",
        "gopls",
        "intelephense",
      },
      -- mason-lspconfig v2 автоматически вызывает vim.lsp.enable()
      -- для всех установленных серверов
    },
  },

  { "neovim/nvim-lspconfig", lazy = false },

  -- ═══════════════════════  Автодополнение  ═══════════════════════
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      local kind_icons = {
        Text = "󱂛", Method = "", Function = "", Constructor = "",
        Field = "", Variable = "var", Class = "class", Interface = "",
        Module = "", Property = "", Unit = "", Value = "󰮐",
        Enum = "", Keyword = "", Snippet = "", Color = "",
        File = "", Reference = "", Folder = "", EnumMember = "",
        Constant = "__", Struct = "", Event = "", Operator = "opr",
        TypeParameter = "T",
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind] or vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip  = "[Snip]",
              buffer   = "[Buf]",
              path     = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-d>"]     = cmp.mapping.scroll_docs(4),
          ["<C-j>"]     = cmp.mapping.select_next_item(),
          ["<C-k>"]     = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        window = {
          documentation = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } },
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  },

  -- ═══════════════════════  Форматирование (conform)  ═══════════════════════
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua        = { "stylua" },
        python     = { "black" },
        go         = { "gofmt", "goimports" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        html       = { "prettier" },
        css        = { "prettier" },
        scss       = { "prettier" },
        json       = { "prettier" },
        php        = { "php_cs_fixer" },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
    },
  },

  -- ═══════════════════════  Telescope  ═══════════════════════
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- ═══════════════════════  Файловое дерево  ═══════════════════════
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    opts = {
      filesystem = {
        filtered_items = { hide_gitignored = false },
      },
    },
  },

  -- ═══════════════════════  Git  ═══════════════════════
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- ═══════════════════════  Статусбар  ═══════════════════════
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ═══════════════════════  Табы (barbar)  ═══════════════════════
  {
    "romgrk/barbar.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
    opts = {},
  },

  -- Noice убран: ломал cmdline/substitute. Если захочешь вернуть —
  -- раскомментируй и поставь lazy = false
  -- {
  --   "folke/noice.nvim",
  --   lazy = false,
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --   opts = { cmdline = { enabled = true, view = "cmdline_popup" } },
  -- },

  -- ═══════════════════════  Стартовый экран  ═══════════════════════
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[=================     ===============     ===============   ========  ========]],
        [[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
        [[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
        [[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
        [[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
        [[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
        [[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
        [[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
        [[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
        [[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
        [[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
        [[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
        [[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
        [[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
        [[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
        [[||.=='    _-'                                                     `' |  /==.||]],
        [[=='    _-'                        N E O V I M                         \/   `==]],
        [[\   _-'                                                                `-_   /]],
        [[ `''                                                                      ``' ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("e", "  > New file",    ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "  > Find file",   ":Telescope find_files<CR>"),
        dashboard.button("r", "  > Recent",      ":Telescope oldfiles<CR>"),
        dashboard.button("g", "  > Live grep",   ":Telescope live_grep<CR>"),
        dashboard.button("s", "  > Settings",    ":e $MYVIMRC<CR>"),
        dashboard.button("q", "  > Quit",        ":qa<CR>"),
      }

      alpha.setup(dashboard.opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        callback = function() vim.opt_local.foldenable = false end,
      })
    end,
  },

  -- ═══════════════════════  Комментарии  ═══════════════════════
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- ═══════════════════════  Отступы (indent-blankline)  ═══════════════════════
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local highlight = {
        "RainbowRed", "RainbowYellow", "RainbowBlue",
        "RainbowOrange", "RainbowGreen", "RainbowViolet", "RainbowCyan",
      }
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#56B6C2" })
      end)
      require("ibl").setup({ indent = { highlight = highlight } })
    end,
  },

  -- ═══════════════════════  Spider (CamelCase движение)  ═══════════════════════
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
    },
  },

  -- ═══════════════════════  Плавный скролл  ═══════════════════════
  { "psliwka/vim-smoothie", event = "VeryLazy" },

}, {
  -- lazy.nvim options
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = false },
})

--------------------------------------------------------------------------------
-- Тема
--------------------------------------------------------------------------------
vim.cmd.colorscheme("tokyonight")

--------------------------------------------------------------------------------
-- LSP: настройки конкретных серверов через vim.lsp.config (Neovim 0.11+)
--------------------------------------------------------------------------------

-- Глобальная конфигурация для всех LSP
vim.lsp.config("*", {
  capabilities = (function()
    local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
      return cmp_lsp.default_capabilities()
    end
    return vim.lsp.protocol.make_client_capabilities()
  end)(),
})

-- lua_ls: распознавание глобальной vim
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- pyright: видит локальные пакеты через venv
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
})

-- gopls
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

-- ts_ls (TypeScript/JavaScript)
vim.lsp.config("ts_ls", {
  settings = {
    completions = { completeFunctionCalls = true },
    javascript = {
      preferences = { importModuleSpecifier = "shortest" },
    },
  },
})

-- html (+ php)
vim.lsp.config("html", {
  filetypes = { "html", "php" },
})

-- emmet_ls
vim.lsp.config("emmet_ls", {
  filetypes = { "html", "css", "php", "javascript" },
})

-- intelephense (PHP)
vim.lsp.config("intelephense", {
  settings = {
    intelephense = {
      files = {
        maxSize = 1000000,
        exclude = {
          "**/vendor/**",
          "**/node_modules/**",
          "**/.git/**",
        },
      },
      diagnostics = { enable = true },
      format = { enable = false },
    },
  },
})

-- Включаем все серверы
vim.lsp.enable({
  "lua_ls", "ts_ls", "html", "emmet_ls", "cssls",
  "somesass_ls", "pyright", "gopls", "intelephense",
})

--------------------------------------------------------------------------------
-- LSP keymaps через LspAttach
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>ge", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  end,
})

--------------------------------------------------------------------------------
-- Диагностика
--------------------------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = { current_line = true },
  signs = true,
  underline = true,
  update_in_insert = false,
  float = { border = "rounded", source = true },
})

--------------------------------------------------------------------------------
-- Цвета и курсор
--------------------------------------------------------------------------------
vim.cmd([[ highlight Visual guibg=#f200ff guifg=#ffffff ]])
vim.cmd([[ highlight YankHighLight guibg=#40ff00 guifg=#ffffff ]])
vim.cmd("set guicursor=n-v-c:block,i:ver25")

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ higroup = "YankHighLight", timeout = 400 })
  end,
})

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>rg", ":Telescope live_grep<CR>", opts)
map("n", "<leader>tl", ":Telescope live_grep<CR>", opts)

-- Neo-tree
map("n", "<leader>e", ":Neotree toggle<CR>", opts)

-- Буферы (barbar)
map("n", "]b", ":BufferNext<CR>", opts)
map("n", "[b", ":BufferPrevious<CR>", opts)
map("n", "<leader>c", ":BufferClose<CR>", opts)

-- Окна
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-j>", "<C-w>j", opts)

-- Сплит
map("n", "|", ":vsplit<CR>", opts)
map("n", "\\", ":split<CR>", opts)

-- Сохранение/выход
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>Q", ":qa<CR>", opts)

-- Visual Block
map("n", "<leader>VD", "<C-V>", opts)

-- Копирование полного пути файла
map("n", "<leader>cp", ':let @+=expand("%:p")<CR>', opts)

-- Терминал
map("n", "<leader>th", ":belowright split | resize 10 | terminal<CR>", opts)
map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Макросы (q записывает в @q, Q воспроизводит)
map("n", "q", "qq", opts)
map("n", "Q", "@q", opts)

-- Git
map("n", "<leader>gl", ":Gitsigns blame_line<CR>", opts)
map("n", "<leader>lg", ":LazyGit<CR>", opts)

--------------------------------------------------------------------------------
-- Neovide (если используется)
--------------------------------------------------------------------------------
if vim.g.neovide then
  vim.g.neovide_opacity = 0.8
  vim.g.transparency = 0.8
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_confirm_quit = false
  vim.g.neovide_refresh_rate = 120
end

--[[
╔══════════════════════════════════════════════════════════════════════════════╗
║                        ИНСТРУКЦИЯ ПО УСТАНОВКЕ                             ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  1. Установить Neovim 0.11+                                                ║
║     Ubuntu/Debian:                                                         ║
║       sudo snap install nvim --classic                                     ║
║     Arch:                                                                  ║
║       sudo pacman -S neovim                                                ║
║     macOS:                                                                 ║
║       brew install neovim                                                  ║
║                                                                            ║
║  2. Системные зависимости (для treesitter, mason, telescope):              ║
║     Ubuntu/Debian:                                                         ║
║       sudo apt install git curl gcc make unzip ripgrep fd-find             ║
║     Arch:                                                                  ║
║       sudo pacman -S git curl gcc make unzip ripgrep fd                    ║
║     macOS:                                                                 ║
║       brew install git curl gcc make unzip ripgrep fd                      ║
║                                                                            ║
║  3. Для конкретных LSP серверов нужны рантаймы:                            ║
║     - Node.js 18+   (для ts_ls, html, cssls, emmet_ls, prettier)          ║
║       https://nodejs.org или nvm                                           ║
║     - Python 3.10+  (для pyright, black)                                   ║
║     - Go 1.21+      (для gopls, goimports)                                 ║
║     - PHP 8+        (для intelephense)                                     ║
║     - Lua 5.1+      (для lua_ls — устанавливается Mason'ом)               ║
║                                                                            ║
║  4. Nerd Font (для иконок):                                               ║
║     Скачать любой Nerd Font: https://www.nerdfonts.com/font-downloads      ║
║     Рекомендую: JetBrainsMono Nerd Font                                    ║
║     Установить и выбрать в терминале.                                      ║
║                                                                            ║
║  5. Положить этот файл:                                                    ║
║     Linux/macOS: ~/.config/nvim/init.lua                                   ║
║     Windows:     ~/AppData/Local/nvim/init.lua                             ║
║                                                                            ║
║  6. Первый запуск:                                                         ║
║     nvim                                                                   ║
║     → lazy.nvim скачает все плагины автоматически                          ║
║     → treesitter скачает парсеры                                           ║
║     → Mason скачает LSP серверы                                            ║
║     → Перезапустить nvim после первой установки                            ║
║                                                                            ║
║  7. Проверка здоровья:                                                     ║
║     :checkhealth                                                           ║
║     :checkhealth vim.lsp                                                   ║
║     :checkhealth nvim-treesitter                                           ║
║                                                                            ║
║  8. Если нужен tree-sitter CLI (для сборки парсеров из исходников):        ║
║     npm install -g tree-sitter-cli                                         ║
║     или: cargo install --locked tree-sitter-cli                            ║
║                                                                            ║
╚══════════════════════════════════════════════════════════════════════════════╝
]]
