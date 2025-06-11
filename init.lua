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

Plug 'nvim-tree/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'romgrk/barbar.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

-- TEST

-- END TEST


vim.call('plug#end')

---------------------------------------- Отступы в коде
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { indent = { highlight = highlight } }


----------------------------------------- git status в файле буфера
require('gitsigns').setup()
----------------------------------------- buffers
-- require("bufferline").setup{
--     options = {
--         separator_style = "slope" ,--| "slope" | "thick" | "thin" | { 'any', 'any' },
--     }
-- }

---------------------------------------------------------------------- ЛСП И ПОДСВЕТКА СИНТЕКССА

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local luasnip = require 'luasnip'

local servers = {
    "lua_ls",
    "tsserver",
    "somesass_ls",
    "ast_grep",
    "lua_ls",
    "ts_ls",

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

local logo_array = {

    {
    "█     █░▓█████  ██▓     ▄████▄   ▒█████   ███▄ ▄███▓▓█████",
    "█░ █ ░█░▓█   ▀ ▓██▒    ▒██▀ ▀█  ▒██▒  ██▒▓██▒▀█▀ ██▒▓█   ▀",
    "█░ █ ░█ ▒███   ▒██░    ▒▓█    ▄ ▒██░  ██▒▓██    ▓██░▒███",
    "█░ █ ░█ ▒▓█  ▄ ▒██░    ▒▓▓▄ ▄██▒▒██   ██░▒██    ▒██ ▒▓█  ▄",
    "░██▒██▓ ░▒████▒░██████▒▒ ▓███▀ ░░ ████▓▒░▒██▒   ░██▒░▒████▒",
    "▓░▒ ▒  ░░ ▒░ ░░ ▒░▓  ░░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ░  ░░░ ▒░ ░",
    "▒ ░ ░   ░ ░  ░░ ░ ▒  ░  ░  ▒     ░ ▒ ▒░ ░  ░      ░ ░ ░  ░",
    "░   ░     ░     ░ ░   ░        ░ ░ ░ ▒  ░      ░      ░",
      "░       ░  ░    ░  ░░ ░          ░ ░         ░      ░  ░",
                          "░",
                 "▄▄▄█████▓ ▒█████",
                 "▓  ██▒ ▓▒▒██▒  ██▒",
                 "▒ ▓██░ ▒░▒██░  ██▒",
                 "░ ▓██▓ ░ ▒██   ██░",
                   "▒██▒ ░ ░ ████▓▒░",
                   "▒ ░░   ░ ▒░▒░▒░",
                     "░      ░ ▒ ▒░",
                   "░      ░ ░ ░ ▒",
                              "░ ░",
               "██░ ██ ▓█████  ██▓     ██▓",
              "▓██░ ██▒▓█   ▀ ▓██▒    ▓██▒",
              "▒██▀▀██░▒███   ▒██░    ▒██░",
              "░▓█ ░██ ▒▓█  ▄ ▒██░    ▒██░",
              "░▓█▒░██▓░▒████▒░██████▒░██████▒",
               "▒ ░░▒░▒░░ ▒░ ░░ ▒░▓  ░░ ▒░▓  ░",
               "▒ ░▒░ ░ ░ ░  ░░ ░ ▒  ░░ ░ ▒  ░",
               "░  ░░ ░   ░     ░ ░     ░ ░",
               "░  ░  ░   ░  ░    ░  ░    ░  ░",

    },
    {
    "██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗   ",
    "██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝   ",
    "██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗     ",
    "██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝     ",
    "╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗   ",
    " ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝   ",
    "                                                                 ",
    "                    ████████╗ ██████╗                            ",
    "                    ╚══██╔══╝██╔═══██╗                           ",
    "                       ██║   ██║   ██║                           ",
    "                       ██║   ██║   ██║                           ",
    "                       ██║   ╚██████╔╝                           ",
    "                       ╚═╝    ╚═════╝                            ",
    "                                                                 ",
    "                ██╗  ██╗███████╗██╗     ██╗                      ",
    "                ██║  ██║██╔════╝██║     ██║                      ",
    "                ███████║█████╗  ██║     ██║                      ",
    "                ██╔══██║██╔══╝  ██║     ██║                      ",
    "                ██║  ██║███████╗███████╗███████╗                 ",
    "                ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝                 ",
    "                                                                 ",
    },
    {
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
    },
}


-- Set header
dashboard.section.header.val = {
    {
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
    },
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
        lualine_c = { "filename" , path = 0, shorting_target = 40,   },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename"  },
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
        disable = function (_,buf)
            local max_filesize = 100 * 1024
            local ok, stats = pcall(vim.loop.fs_stat , vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end
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

-- Для работы дерева
require('neo-tree').setup({

    filesystem = {
        filtered_items = {
            hide_gitignored = false,
        }
    }
})


-- Масон для ЛСП
-- require('mason').setup()
-- require('mason-lspconfig').setup {
--
--
--
--     ensure_installed = {
--         "ast_grep",
--         "lua-language-server",
--         "html",
--         "ast_grep",
--         "lua_ls",
--         "somesass_ls",
--         "ts_ls",
--     },
--     automatic_installation = true,
-- }


vim.cmd [[
autocmd FileType javascript lua require('lspconfig').tsserver.setup{}

]]

local lspconf_to_install = require('lspconfig')
lspconf_to_install.ast_grep.setup{}
lspconf_to_install.lua_ls.setup{}
lspconf_to_install.html.setup{
    filetypes = {"php" , "html"},
}
lspconf_to_install.somesass_ls.setup{}

lspconf_to_install.gopls.setup({})

lspconf_to_install.intelephense.setup({
  init_options = {
    storagePath = "/tmp/intelephense", -- кеш в /tmp
  },
  settings = {
    intelephense = {
      -- Отключаем анализ всего проекта
      files = {
        maxSize = 1000000, -- 1MB (не анализировать большие файлы)
        exclude = {
          "**/vendor/**",
          "**/bitrix/**", -- исключаем ядро Битрикс
          "**/upload/**",
          "**/node_modules/**",
          "**/.git/**"
        }
      },
      -- Только базовая диагностика
      diagnostics = {
        enable = true,
        run = "onType", -- проверка только при наборе
        undefinedTypes = false,
        undefinedFunctions = false,
        undefinedConstants = false,
        undefinedMethods = false,
        undefinedProperties = false,
      },
      -- Минимальные настройки для Битрикс
      environment = {
        includePaths = {
          "C:\\OpenServer\\domains\\dvblocal\\bitrix\\modules", -- ваши модули
        }
      },
      -- Отключаем ненужные фичи
      completion = {
        insertUseDeclaration = false,
      },
      format = {
        enable = false -- отключаем автоформатирование
      }
    }
  },
  on_attach = function(client, bufnr)
    -- Только базовые возможности LSP
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buwnr })

    -- Отключаем все лишние обработчики
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
  end,
  flags = {
    debounce_text_changes = 500, -- задержка проверки (мс)
  },
  root_dir = function() return vim.loop.cwd() end, -- не искать корень проекта
})

lspconf_to_install.emmet_ls.setup{
    filetypes = {"html" , "css" , "php" , "javascript"},
}



lspconf_to_install.ts_ls.setup({
  on_attach = function(client, bufnr)
    -- Ключевые mappingи
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr }) -- Перейти к определению
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr }) -- Ссылки
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr }) -- Документация
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr }) -- Переименовать
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr }) -- Code actions
  end,
  settings = {
    completions = {
      completeFunctionCalls = true -- Автодополнение вызовов функций
    },
    javascript = {
      preferences = {
        importModuleSpecifier = "shortest" -- Автоимпорты с короткими путями
      }
    }
  }
})



-- Настройка pyright
lspconf_to_install.pyright.setup({
  on_attach = function(client, bufnr)
    -- Маппинги LSP-функций (по желанию)
    local buf_map = function(lhs, rhs)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, { noremap = true, silent = true })
    end

    buf_map('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')         -- Перейти к определению
    buf_map('K', '<cmd>lua vim.lsp.buf.hover()<CR>')               -- Тип под курсором
    buf_map('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')     -- Перейти к реализации
    buf_map('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')  -- Сигнатура функции
  end,
})



-- --
local null_ls = require('null-ls')
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.diagnostics.flake8,
    },
})




vim.g.ale_enabled = 1
vim.g.ale_fix_on_save = 1 -- Автофикс при сохранении
vim.g.ale_lint_on_text_changed = 'normal' -- Проверка при изменении (но не в insert-режиме)
vim.g.ale_lint_on_insert_leave = 1 -- Проверка при выходе из insert-режима
vim.g.ale_lint_on_enter = 1 -- Проверка при открытии файла
vim.g.ale_echo_cursor = 0 -- Сообщение при пересечении ошибки курсором

vim.g.ale_linter_aliases = {
    php = {'php' , 'html'}
}
-- Линтеры для языков
vim.g.ale_linters = {
  javascript = {'eslint'},
  javascriptreact = {'eslint'},
  html = {'htmlhint'},
  css = {'stylelint'},
  scss = {'stylelint'},
  go = {'golangci-lint'},
  php = {'phpcs', 'phpstan',"htmlhint"},
  python = { 'pyright', 'flake8', 'mypy', 'pylint' },
}

-- Фиксеры (форматеры)
vim.g.ale_fixers = {
  ['*'] = {'remove_trailing_lines', 'trim_whitespace'}, -- Для всех файлов
  javascript = {'prettier', 'eslint'},
  javascriptreact = {'prettier', 'eslint'},
  typescript = {'prettier', 'eslint'},
  html = {'prettier'},
  css = {'prettier'},
  scss = {'prettier'},
  go = {'gofmt', 'goimports'},
  php = {'prettier', 'php_cs_fixer'},
  python =  { 'black', 'isort', 'autopep8' },
}

-- Доп. настройки ESLint (если нужен глобальный ESLint)
vim.g.ale_javascript_eslint_use_global = 1

-- Настройки для Go (golangci-lint)
vim.g.ale_go_golangci_lint_options = '--fast'

-- Дополнительные настройки ALE
vim.g.ale_sign_error = '✘'          -- Значок ошибки
vim.g.ale_sign_warning = '⚠'       -- Значок предупреждения


vim.g.ale_python_auto_pipenv = true

vim.g.ale_virtualenv_dir_names = {'venv', '.venv'}
-- Настройка путей, чтобы ALE использовал venv-интерпретатор и пакеты
vim.g.ale_python_black_executable = 'black'
vim.g.ale_python_isort_executable = 'isort'
vim.g.ale_python_flake8_executable = 'flake8'
vim.g.ale_python_mypy_executable = 'mypy'


-- Настройка для глобал

-- vim.g.ale_eslint_use_global = 1
-- vim.g.ale_eslint_options = '--no-eslintrc'
--
-- vim.g.ale_htmlhint_use_global = 1
-- vim.g.ale_htmlhint_options = "-c $HOME/.htmlhintrc"
--
-- vim.g.ale_stylelint_use_global = 1
-- vim.g.ale_stylelint_options = '--config $HOME/.stylelintrc.json --no-config-overrides'
--
-- vim.g.ale_php_phpcs_use_global = 1
-- vim.g.ale_php_phpcs_standard = '$HOME/.phpcs.xml'
--
-- vim.g.ale_php_phpstan_use_global = 1
-- vim.g.ale_php_phpstan_configuration = '$HOME/.phpstan.neon'
--
-- vim.g.ale_php_php_cs_fixer_options = '--config=$HOME/.php-cs-fixer.php'
--
--
-- vim.g.ale_go_golangci_lint_use_global = 1
-- vim.g.ale_go_golangci_lint_options = '--config $HOME/.golangci.yml'
--
-- vim.g.ale_html_htmlhint_options = "--rules tag-pair,id-class-value=underline"
-- vim.g.ale_html_htmlhint_use_global = 1
--
-- vim.g.ale_javascript_prettier_use_global = 1
-- vim.g.ale_javascript_prettier_executable = 'prettier'
-- vim.g.ale_javascript_prettier_options = '--write --config $HOME/.prettierrc --parser html'


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

vim.opt.tabstop=2 -- отступ при табе
vim.opt.shiftwidth=2 -- отступ при >>
vim.opt.expandtab=true -- отступы это пробелы

vim.opt.selection = 'exclusive' -- для нормального переноса shift v

vim.opt.gdefault = true -- замена в файле глобальная
vim.opt.lazyredraw = true -- не перерисовывать экран при макросах
vim.opt.ttyfast = true -- для новых терминалов
vim.opt.virtualedit = 'block'

--Тема
vim.cmd('silent! colorscheme seoul256')
vim.cmd('colorscheme tokyonight')


--colors
vim.cmd [[ highlight Visual guibg=#f200ff guifg=#ffffff]]

vim.cmd [[ highlight LineNr guibg=#1102ea guifg=#ffffff]]
vim.cmd [[ highlight LineNrAbove guibg=#fc3fd3 guifg=#ffffff]]
vim.cmd [[ highlight LineNrBelow guibg=#fc3fd3 guifg=#ffffff]]

vim.cmd [[ highlight CusrorNormal guibg=#ff0000 guifg=#ffffff]]
vim.cmd [[ highlight CursorInsert guibg=#00ff00 guifg=#000000]]

vim.cmd("set guicursor=n-v-c:block-CursorNormal,i:ver25-CursorInsert")

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

--Telescope
vim.api.nvim_set_keymap('n','<leader>ff',":Telescope find_files<CR>", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','<leader>rg',":Telescope live_grep<CR>", {noremap=true, silent = true})

-- Neotree
vim.api.nvim_set_keymap('n','<leader>e',":Neotree toggle <CR>", {noremap=true, silent = true})
-- vim.api.nvim_set_keymap('n','<leader>e',":Neotree toggle", {noremap=true, silent = true})

-- комменты
vim.api.nvim_set_keymap('n','<leader>/', "gcc", {noremap=true , silent = true})
vim.api.nvim_set_keymap('v','<leader>/',"gc", {noremap=true, silent = true})

--для буфера
vim.api.nvim_set_keymap('n',']b',":BufferNext<CR>", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','[b',":BufferPrevious<CR>", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','<leader>c',"<C-w>c", {noremap=true, silent = true})
--Буфер обмена
vim.opt.clipboard = "unnamedplus"

--Для окон
vim.api.nvim_set_keymap('n','<C-l>',"<C-w>l", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','<C-h>',"<C-w>h", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','<C-k>',"<C-w>k", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','<c-j>',"<c-w>j", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','<leader>cp',':let @+=expand("%:p")<CR>', {noremap=true, silent = true})


--Terminal

vim.api.nvim_set_keymap('n','<leader>th',":belowright split | resize 10 | terminal <CR>", {noremap=true, silent = true})
vim.api.nvim_set_keymap('t','<Esc>',"<C-\\><C-n>", {noremap=true, silent = true})

-- Сплит
vim.api.nvim_set_keymap('n','|',":vsplit<CR>", {noremap=true, silent = true})
vim.api.nvim_set_keymap('n','\\',":split<CR>", {noremap=true, silent = true})

-- Стандартные
vim.api.nvim_set_keymap('n',"<leader>w",":w<CR>",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n',"<leader>q",":q<CR>",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n',"<leader>Q",":qa<CR>",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n',"<leader>VD","<C-V>",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n' ,"<leader>/","gcc",{noremap=true, silent = true})

--PROXY
vim.env.HTTP_PROXY = "http://proxy-1.feb.ru:3128"
vim.env.HTTPS_PROXY = "http://proxy-1.feb.ru:3128"

--макросы

vim.api.nvim_set_keymap('n' ,"q","qq",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n' ,"Q","@q",{noremap=true, silent = true})


--GIT

vim.api.nvim_set_keymap('n' ,"<leader>gl",":Gitsigns blame_line<CR>",{noremap=true, silent = true})
vim.api.nvim_set_keymap('n' ,"<leader>gs",":Neotree filesystem show --no-hide-gitignored<CR>",{noremap=true, silent = true})

-- Диагностика файлов
-- vim.api.nvim_set_keymap('n' ,"<leader>ge",":lua vim.diagnostics.open_float()<CR>" ,{noremap=true, silent = true})
vim.api.nvim_set_keymap('n' ,"<leader>ge",":lua vim.diagnostic.open_float()<CR>" ,{noremap=true, silent = true})

require('neo-tree.command').execute({
    toggle = true,
    source = "filesystem",
    position = "left",
    filters = {
        hide_gitignored = false,
    }

})

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


function EnableLspServer(lsp_name)
    local nvim_lsp = require('lspconfig')

    local on_attach = function (client , bufnr)
        print("LSP запущен" .. lsp_name .. "BUF:" .. bufnr)
    end

    if nvim_lsp[lsp_name] then
        nvim_lsp[lsp_name].setup({
            on_attach = on_attach
        })
    else
        print("LSP НЕ запущен. Name:" .. lsp_name)
    end
end

-- Привязка функции к команде в Neovim
vim.api.nvim_create_user_command(
"AlignColumnsSelection",
function(opts) align_columns_selection(opts.args) end,
{ range = true, nargs = 1 }
)

vim.api.nvim_create_user_command(
    "EnableLsp",
    function (args)
        EnableLspServer(args.args)
    end,
    {nargs = 1}
)


-- Форматирование кода в зависимости от выбранного линтера языка
vim.api.nvim_create_user_command('FormatSelection', function(opts)
  local filetype = opts.args -- Получаем тип файла (html, css, js и т. д.)
  local start_line = vim.fn.line("'<") -- Начало выделения
  local end_line = vim.fn.line("'>") -- Конец выделения

  -- Выбираем форматтер в зависимости от filetype
  local formatter = {
    html = { cmd = "prettier", args = { "--parser", "html" } },
    css = { cmd = "prettier", args = { "--parser", "css" } },
    scss = { cmd = "prettier", args = { "--parser", "scss" } },
    js = { cmd = "prettier", args = { "--parser", "babel" } },
    javascript = { cmd = "prettier", args = { "--parser", "babel" } },
    json = { cmd = "prettier", args = { "--parser", "json" } },
    php = { cmd = "php-cs-fixer", args = { "fix" } },
    go = { cmd = "gofmt", args = {} },
  }

  if not formatter then
    vim.notify("Форматтер для '" .. filetype .. "' не найден!", vim.log.levels.ERROR)
    return
  end

  -- Форматируем выделенные строки
  vim.cmd(string.format(
    "%d,%d!%s %s",
    start_line,
    end_line,
    formatter.cmd,
    table.concat(formatter.args, " ")
  ))
end, { nargs = 1, range = true })

-- Неовим ( настройки должны быть
if vim.g.neovide then
local alpha = function()
  return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
end
vim.g.neovide_opacity = 0.8
vim.g.transparency = 0.8
vim.g.neovide_background_color = "#0f1117" .. alpha()
vim.g.neovide_cursor_vfx_mode = "pixiedust"

vim.g.neovide_refresh_rate = 120

vim.o.guifont = "UbuntuSansMono Nerd Font:h14" -- text below applies for VimScript

end
