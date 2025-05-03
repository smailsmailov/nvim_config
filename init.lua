vim.g.mapleader = ' '
-- Окно  работа
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local kind_icons = {
    Text = "󱂛",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "var",
    Class = "class",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "󰮐",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "__",
    Struct = "",
    Event = "",
    Operator = "opr",
    TypeParameter = "TypeParameter",
}

local vim = vim
local Plug = vim.fn['plug#']
---------------------------------------------------------------------- PLUGINS
vim.call('plug#begin')

-- Plug 'nvim-tree/nvim-tree.lua'
Plug "lewis6991/gitsigns.nvim"

Plug "nvim-neo-tree/neo-tree.nvim"

Plug "folke/noice.nvim"

Plug "folke/tokyonight.nvim"

Plug 'numToStr/Comment.nvim'

Plug 'neovim/nvim-lspconfig'

Plug 'jose-elias-alvarez/null-ls.nvim'

Plug 'goolord/alpha-nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'akinsho/bufferline.nvim'

Plug 'kdheepak/lazygit.nvim'

Plug 'MunifTanjim/nui.nvim'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'dense-analysis/ale'

Plug 'nvim-treesitter/nvim-treesitter'

vim.call('plug#end')

----------------------------------------- git status в файле буфера
require('gitsigns').setup()
----------------------------------------- buffers
require("bufferline").setup{}

---------------------------------------------------------------------- ЛСП И ПОДСВЕТКА СИНТЕКССА

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local luasnip = require 'luasnip'

local servers = {
    "lua_ls",
    "tsserver",
    "somesass_ls",
    "ast_grep",
    "intelephense",
    "lua_ls",
    -- "ts_ls",

}
for _, lsp in ipairs(servers) do
    require'lspconfig'[lsp].setup{
        capabilities = capabilities
    }
end


local cmp = require 'cmp'


local cmp = require 'cmp'
cmp.setup {
    formatting = {

        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),

    window = {
        documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
    },
    experimental = {
        ghost_text = false,
        native_menu = false,
    },
    sources = {
        { name = 'nvim_lsp' },

        { name = "luasnip" },
        {name = "buffer"},
        { name = "path" },
    },

    ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end, { 'i', 's' }),
}

---------------------------------------comment
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {



    --█     █░▓█████  ██▓     ▄████▄   ▒█████   ███▄ ▄███▓▓█████
    --█░ █ ░█░▓█   ▀ ▓██▒    ▒██▀ ▀█  ▒██▒  ██▒▓██▒▀█▀ ██▒▓█   ▀
    --█░ █ ░█ ▒███   ▒██░    ▒▓█    ▄ ▒██░  ██▒▓██    ▓██░▒███
    --█░ █ ░█ ▒▓█  ▄ ▒██░    ▒▓▓▄ ▄██▒▒██   ██░▒██    ▒██ ▒▓█  ▄
    --░██▒██▓ ░▒████▒░██████▒▒ ▓███▀ ░░ ████▓▒░▒██▒   ░██▒░▒████▒
    -- ▓░▒ ▒  ░░ ▒░ ░░ ▒░▓  ░░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ░  ░░░ ▒░ ░
    -- ▒ ░ ░   ░ ░  ░░ ░ ▒  ░  ░  ▒     ░ ▒ ▒░ ░  ░      ░ ░ ░  ░
    -- ░   ░     ░     ░ ░   ░        ░ ░ ░ ▒  ░      ░      ░
    --   ░       ░  ░    ░  ░░ ░          ░ ░         ░      ░  ░
    --                       ░
    --              ▄▄▄█████▓ ▒█████
    --              ▓  ██▒ ▓▒▒██▒  ██▒
    --              ▒ ▓██░ ▒░▒██░  ██▒
    --              ░ ▓██▓ ░ ▒██   ██░
    --                ▒██▒ ░ ░ ████▓▒░
    --                ▒ ░░   ░ ▒░▒░▒░
    --                  ░      ░ ▒ ▒░
    --                ░      ░ ░ ░ ▒
    --                           ░ ░
    --
    --            ██░ ██ ▓█████  ██▓     ██▓
    --           ▓██░ ██▒▓█   ▀ ▓██▒    ▓██▒
    --           ▒██▀▀██░▒███   ▒██░    ▒██░
    --           ░▓█ ░██ ▒▓█  ▄ ▒██░    ▒██░
    --           ░▓█▒░██▓░▒████▒░██████▒░██████▒
    --            ▒ ░░▒░▒░░ ▒░ ░░ ▒░▓  ░░ ▒░▓  ░
    --            ▒ ░▒░ ░ ░ ░  ░░ ░ ▒  ░░ ░ ▒  ░
    --            ░  ░░ ░   ░     ░ ░     ░ ░
    --            ░  ░  ░   ░  ░    ░  ░    ░  ░
    --


    -- "██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗   ",
    -- "██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝   ",
    -- "██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗     ",
    -- "██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝     ",
    -- "╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗   ",
    -- " ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝   ",
    -- "                                                                 ",
    -- "                    ████████╗ ██████╗                            ",
    -- "                    ╚══██╔══╝██╔═══██╗                           ",
    -- "                       ██║   ██║   ██║                           ",
    -- "                       ██║   ██║   ██║                           ",
    -- "                       ██║   ╚██████╔╝                           ",
    -- "                       ╚═╝    ╚═════╝                            ",
    -- "                                                                 ",
    -- "                ██╗  ██╗███████╗██╗     ██╗                      ",
    -- "                ██║  ██║██╔════╝██║     ██║                      ",
    -- "                ███████║█████╗  ██║     ██║                      ",
    -- "                ██╔══██║██╔══╝  ██║     ██║                      ",
    -- "                ██║  ██║███████╗███████╗███████╗                 ",
    -- "                ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝                 ",
    -- "                                                                 ",
    -- 	}
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
    [[\   _-'                           ROMANOVSKII                          `-_   /]],
    [[ `''                                 DANIL                                ``' ]],
}



dashboard.section.buttons.val = {
    dashboard.button( "e", "  > New file" , ":ene <BAR> startinsert <CR>"),
    dashboard.button( "f", "  > Find file", ":cd $HOME/Workspace | Telescope find_files<CR>"),
    dashboard.button( "r", "  > Recent"   , ":Telescope oldfiles<CR>"),
    dashboard.button( "s", "  > Settings" , ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    dashboard.button( "q", "  > Quit NVIM", ":qa<CR>"),
}

alpha.setup(dashboard.opts)

vim.cmd([[
autocmd FileType alpha setlocal nofoldenable
]])


---------------------------------------comment
require('Comment').setup({
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
    },
    ---Function to call before (un)comment
    pre_hook = nil,
    ---Function to call after (un)comment
    post_hook = nil,
})

--------------------------------------------------- lualine то что внизу бара
require("lualine").setup {
    options = {
        icons_enabled = true,
        theme = "dracula",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
}

---------------------------------------------- Просмотр и поддержка файлов в буфере
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" ,"php" , "html" , "css" , "javascript" , "go"},

    sync_install = false,

    auto_install = true,

    highlight = {
        enable = true,
    },
}

-- Нойс для красивой консоли и ошибок
require("noice").setup(

{
    cmdline = {
        enabled = true, -- enables the Noice cmdline UI
        view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        opts = {}, -- global options for the cmdline. See section on views
        ---@type table<string, CmdlineFormat>
        format = {
            -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
            -- view: (default is cmdline view)
            -- opts: any options passed to the view
            -- icon_hl_group: optional hl_group for the icon
            -- title: set to anything or empty string to hide
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
            input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
            -- lua = false, -- to disable a format, set to `false`
        },
    },
    messages = {
        enabled = true, -- enables the Noice messages UI
        view = "notify", -- default view for messages
        view_error = "notify", -- view for errors
        view_warn = "notify", -- view for warnings
        view_history = "messages", -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
    },
    popupmenu = {
        enabled = true, -- enables the Noice popupmenu UI
        ---@type 'nui'|'cmp'
        backend = "nui", -- backend to use to show regular cmdline completions
        ---@type NoicePopupmenuItemKind|false
        -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
        kind_icons = {}, -- set to `false` to disable icons
    },
    -- default options for require('noice').redirect
    -- see the section on Command Redirection
    ---@type NoiceRouteConfig
    redirect = {
        view = "popup",
        filter = { event = "msg_show" },
    },
    -- You can add any custom commands below that will be available with `:Noice command`
    ---@type table<string, NoiceCommand>
    commands = {
        history = {
            -- options for the message history that you get with `:Noice`
            view = "split",
            opts = { enter = true, format = "details" },
            filter = {
                any = {
                    { event = "notify" },
                    { error = true },
                    { warning = true },
                    { event = "msg_show", kind = { "" } },
                    { event = "lsp", kind = "message" },
                },
            },
        },
        -- :Noice last
        last = {
            view = "popup",
            opts = { enter = true, format = "details" },
            filter = {
                any = {
                    { event = "notify" },
                    { error = true },
                    { warning = true },
                    { event = "msg_show", kind = { "" } },
                    { event = "lsp", kind = "message" },
                },
            },
            filter_opts = { count = 1 },
        },
        -- :Noice errors
        errors = {
            -- options for the message history that you get with `:Noice`
            view = "popup",
            opts = { enter = true, format = "details" },
            filter = { error = true },
            filter_opts = { reverse = true },
        },
        all = {
            -- options for the message history that you get with `:Noice`
            view = "split",
            opts = { enter = true, format = "details" },
            filter = {},
        },
    },
    notify = {
        enabled = true,
        view = "notify",
    },
    lsp = {
        progress = {
            enabled = true,
            -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
            -- See the section on formatting for more details on how to customize.
            --- @type NoiceFormat|string
            format = "lsp_progress",
            --- @type NoiceFormat|string
            format_done = "lsp_progress_done",
            throttle = 1000 / 30, -- frequency to update lsp progress message
            view = "mini",
        },
        override = {
            -- override the default lsp markdown formatter with Noice
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            -- override the lsp markdown formatter with Noice
            ["vim.lsp.util.stylize_markdown"] = false,
            -- override cmp documentation with Noice (needs the other options to work)
            ["cmp.entry.get_documentation"] = false,
        },
        hover = {
            enabled = true,
            silent = false, -- set to true to not show a message if hover is not available
            view = nil, -- when nil, use defaults from documentation
            ---@type NoiceViewOptions
            opts = {}, -- merged with defaults from documentation
        },
        signature = {
            enabled = true,
            auto_open = {
                enabled = true,
                trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
                luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
                throttle = 50, -- Debounce lsp signature help request by 50ms
            },
            view = nil, -- when nil, use defaults from documentation
            ---@type NoiceViewOptions
            opts = {}, -- merged with defaults from documentation
        },
        message = {
            -- Messages shown by lsp servers
            enabled = true,
            view = "notify",
            opts = {},
        },
        -- defaults for hover and signature help
        documentation = {
            view = "hover",
            ---@type NoiceViewOptions
            opts = {
                lang = "markdown",
                replace = true,
                render = "plain",
                format = { "{message}" },
                win_options = { concealcursor = "n", conceallevel = 3 },
            },
        },
    },
    markdown = {
        hover = {
            ["|(%S-)|"] = vim.cmd.help, -- vim help links
            ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
        },
        highlights = {
            ["|%S-|"] = "@text.reference",
            ["@%S+"] = "@parameter",
            ["^%s*(Parameters:)"] = "@text.title",
            ["^%s*(Return:)"] = "@text.title",
            ["^%s*(See also:)"] = "@text.title",
            ["{%S-}"] = "@parameter",
        },
    },
    health = {
        checker = true, -- Disable if you don't want health checks to run
    },
    ---@type NoicePresets
    presets = {
        -- you can enable a preset by setting it to true, or a table that will override the preset config
        -- you can also add custom presets that you can enable/disable with enabled=true
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = false, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    throttle = 1000 / 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
    ---@type NoiceConfigViews
    views = {}, ---@see section on views
    ---@type NoiceRouteConfig[]
    routes = {}, --- @see section on routes
    ---@type table<string, NoiceFilter>
    status = {}, --- @see section on statusline components
    ---@type NoiceFormatOptions
    format = {}, --- @see section on formatting
}
)

-- Масон для ЛСП
require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = {"ast-grep ast_grep", "lua-language-server", "intelephense"},
    automatic_installation = true,

}




-- ~/.config/nvim/init.lua или ~/.config/nvim/lua/config/ale.lua

-- Настройки ALE
-- ALE Configuration
vim.g.ale_enabled = 1
vim.g.ale_lint_on_enter = 1
vim.g.ale_lint_on_save = 1
vim.g.ale_lint_on_text_changed = 'normal'
vim.g.ale_lint_on_insert_leave = 1

-- Фиксаторы (форматтеры)
vim.g.ale_fix_on_save = 1
vim.g.ale_fixers = {
  ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
  javascript = {'prettier', 'eslint'},
  typescript = {'prettier', 'eslint'},
  python = {'black', 'isort'},
  php = {'php_cs_fixer'},
  go = {'gofmt', 'goimports'},
  html = {'prettier'},
  css = {'prettier'},
  scss = {'prettier'},
  markdown = {'prettier'},
  json = {'prettier', 'jq'},
  dockerfile = {'hadolint'},
  make = {},
}

-- Линтеры
vim.g.ale_linters = {
  javascript = {'eslint'},
  typescript = {'eslint', 'tsserver'},
  python = {'flake8', 'pylint'},
  php = {'php', 'phpstan', 'psalm'},
  go = {'golangci-lint', 'govet'},
  html = {'tidy'},
  css = {'stylelint'},
  scss = {'stylelint'},
  markdown = {'markdownlint'},
  json = {'jsonlint'},
  dockerfile = {'hadolint'},
  make = {'checkmake'},
}

-- Использовать глобальные бинарники (не из node_modules)
vim.g.ale_use_global_executables = 1

-- Настройки линтеров
vim.g.ale_python_flake8_options = '--max-line-length=120'
vim.g.ale_python_black_options = '--line-length 120'
vim.g.ale_javascript_prettier_options = '--single-quote --trailing-comma all'
vim.g.ale_php_phpstan_level = 8

-- Интерфейс
vim.g.ale_sign_error = '✘'
vim.g.ale_sign_warning = '⚠'
vim.g.ale_virtualtext_cursor = 1
vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'

-- Цвета
vim.cmd([[
  highlight ALEErrorSign ctermfg=red guifg=#ff0000
  highlight ALEWarningSign ctermfg=yellow guifg=#ffff00
]])

-- Клавиши
vim.keymap.set('n', '<leader>d', '<Plug>(ale_go_to_definition)')
vim.keymap.set('n', '<leader>f', '<Plug>(ale_fix)')
vim.keymap.set('n', '[d', '<Plug>(ale_previous_wrap)')
vim.keymap.set('n', ']d', '<Plug>(ale_next_wrap)')




-- require'lspconfig'.ts_ls.setup{}

--
-- local null_ls = require('null-ls')
-- null_ls.setup({
--     sources = {
--         null_ls.builtins.formatting.black,
--         null_ls.builtins.diagnostics.flake8,
--     },
-- })


--ДАЛЬШЕ ТОЛЬКО ХУЖЕ!
--Команды автостарта
vim.opt.smarttab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 20
vim.opt.wrap = false
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true


--Тема
vim.cmd('silent! colorscheme seoul256')
vim.cmd('colorscheme tokyonight')
--colors
vim.cmd [[ highlight Visual guibg=#f200ff guifg=#ffffff]]

vim.cmd [[ highlight LineNr guibg=#f200ff guifg=#ffffff]]
vim.cmd [[ highlight LineNrAbove guibg=#fc02a0 guifg=#ffffff]]
vim.cmd [[ highlight LineNrBelow guibg=#fc02a0 guifg=#ffffff]]

vim.cmd("highlight YankHighLight guibg=#40ff00 guifg=#ffffff")

vim.api.nvim_create_autocmd("TextYankPost",{
    callback = function ()
        vim.highlight.on_yank({
            higroup = "YankHighLight",
            timeout = 400
        })
    end


})

--Распознавание текста
vim.opt.spell = true
vim.opt.spelllang = {"ru" , "en"}
vim.cmd("set spell")
vim.cmd("set spelllang=ru,en")
-- Neotree
vim.api.nvim_set_keymap('n','<leader>e',":Neotree toggle <CR>", {noremap=true, silent = true})
-- vim.api.nvim_set_keymap('n','<leader>e',":Neotree toggle", {noremap=true, silent = true})

-- комменты
vim.api.nvim_set_keymap('n','<leader>/', "gcc", {noremap=true , silent = true})
vim.api.nvim_set_keymap('v','<leader>/',"gc", {noremap=true, silent = true})

--для буфера
vim.api.nvim_set_keymap('n',']b',":BufferLineCycleNext<CR>", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','[b',":BufferLineCyclePrev<CR>", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','<leader>c',"<C-w>c", {noremap=true, silent = true})

--Для окон
vim.api.nvim_set_keymap('n','<C-l>',"<C-w>l", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','<C-h>',"<C-w>h", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','<C-k>',"<C-w>k", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','<C-j>',"<C-w>j", {noremap=true, silent = true})

--Terminal

vim.api.nvim_set_keymap('n','<leader>th',":belowright split | resize 10 | terminal <CR>", {noremap=true, silent = true})
vim.api.nvim_set_keymap('t','<Esc>',"<C-\\><C-n>", {noremap=true, silent = true})

-- Сплит
vim.api.nvim_set_keymap('n','|',":vsplit<CR>", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','\\',":split<CR>", {noremap=true, silent = true})

-- Стандартные
vim.api.nvim_set_keymap('n',"<leader>w",":w<CR>",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n',"<leader>q",":q<CR>",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n',"<leader>Q",":q!<CR>",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n',"<leader>VD","<C-V>",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n' ,"<leader>/","gcc",{noremap=true, silent = true})

--макросы

vim.api.nvim_set_keymap('n' ,"q","qq",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n' ,"Q","@q",{noremap=true, silent = true})
--Буфер обмена
vim.opt.clipboard = "unnamedplus"

--GIT

vim.api.nvim_set_keymap('n' ,"<leader>gl",":Gitsigns blame_line<CR>",{noremap=true, silent = true})

------------------------------------------------------------------------- Кастомные функции для работы

local function align_columns_selection(delimiter)
    -- Получение выделенных строк в текущем буфере
    local start_pos = vim.fn.line "'<"
    local end_pos = vim.fn.line "'>"
    local lines = vim.api.nvim_buf_get_lines(0, start_pos - 1, end_pos, false)

    -- Разделение строк по заданному разделителю и выравнивание колонок
    local columns = {}
    for _, line in ipairs(lines) do
        local parts = vim.split(line, delimiter)
        for i, part in ipairs(parts) do
            columns[i] = columns[i] or {}
            table.insert(columns[i], part)
        end
    end

    -- Найти максимальную длину каждой колонки
    local max_lengths = {}
    for i, column in ipairs(columns) do
        local max_length = 0
        for _, part in ipairs(column) do
            max_length = math.max(max_length, #part)
        end
        max_lengths[i] = max_length
    end

    -- Формирование выровненных строк
    local new_lines = {}
    for i = 1, #lines do
        local parts = {}
        for j, column in ipairs(columns) do
            table.insert(parts, string.format("%-" .. max_lengths[j] .. "s", column[i]))
        end
        table.insert(new_lines, table.concat(parts, delimiter))
    end

    -- Замена выделенных строк в буфере на выровненные
    vim.api.nvim_buf_set_lines(0, start_pos - 1, end_pos, false, new_lines)
end


-- Привязка функции к команде в Neovim
vim.api.nvim_create_user_command(
"AlignColumnsSelection",
function(opts) align_columns_selection(opts.args) end,
{ range = true, nargs = 1 }
)
