---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val =
        -- {
        --   "██╗░░██╗███████╗██╗░░░░░██╗░░░░░░█████╗░  ░██╗░░░░░░░██╗░█████╗░██████╗░██╗░░░░░██████╗░",
        --   "██║░░██║██╔════╝██║░░░░░██║░░░░░██╔══██╗  ░██║░░██╗░░██║██╔══██╗██╔══██╗██║░░░░░██╔══██╗",
        --   "███████║█████╗░░██║░░░░░██║░░░░░██║░░██║  ░╚██╗████╗██╔╝██║░░██║██████╔╝██║░░░░░██║░░██║",
        --   "██╔══██║██╔══╝░░██║░░░░░██║░░░░░██║░░██║  ░░████╔═████║░██║░░██║██╔══██╗██║░░░░░██║░░██║",
        --   "██╔══██║██╔══╝░░██║░░░░░██║░░░░░██║░░██║  ░░████╔═████║░██║░░██║██╔══██╗██║░░░░░██║░░██║",
        --   "██║░░██║███████╗███████╗███████╗╚█████╔╝  ░░╚██╔╝░╚██╔╝░╚█████╔╝██║░░██║███████╗██████╔╝",
        --   "╚═╝░░╚═╝╚══════╝╚══════╝╚══════╝░╚════╝░  ░░░╚═╝░░░╚═╝░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═════╝░",
        -- }
        {
          "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░",
          "░      ░░░░░   ░░░░░░░░░   ░     ░░░░░░░░░░░  ░░░░░░░░    ░░░░░   ░   ░░░   ░░",
          "▒   ▒▒▒   ▒▒▒   ▒▒▒▒▒▒▒   ▒▒  ▒▒   ▒▒▒▒▒▒▒▒  ▒  ▒▒▒▒▒▒  ▒   ▒▒▒   ▒   ▒▒   ▒▒▒",
          "▒   ▒▒▒▒   ▒▒▒   ▒▒▒▒▒   ▒▒▒  ▒▒▒   ▒▒▒▒▒▒  ▒▒   ▒▒▒▒▒   ▒   ▒▒   ▒   ▒   ▒▒▒▒",
          "▓   ▓▓▓▓   ▓▓▓▓   ▓▓▓   ▓▓▓▓      ▓▓▓▓▓▓▓   ▓▓▓   ▓▓▓▓   ▓▓   ▓   ▓  ▓  ▓▓▓▓▓▓",
          "▓   ▓▓▓▓   ▓▓▓▓▓   ▓   ▓▓▓▓▓  ▓▓▓▓   ▓▓▓       ▓   ▓▓▓   ▓▓▓  ▓   ▓   ▓▓   ▓▓▓",
          "▓   ▓▓▓   ▓▓▓▓▓▓▓     ▓▓▓▓▓▓  ▓▓▓▓▓  ▓▓   ▓▓▓▓▓▓▓   ▓▓   ▓▓▓▓  ▓  ▓   ▓▓▓   ▓▓",
          "█      ███████████   ███████    █   ██   █████████   █   ██████   █   █████   ",
          "██████████████████████████████████████████████████████████████████████████████",
        }
      return opts
    end,
  },
  {
    "mfussenegger/nvim-lint",
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- You can disable default plugins as follows:
  --
  -- {
  --   "Pocco81/auto-save.nvim",
  --   config = function()
  --     require("auto-save").setup {
  --       enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
  --       execution_message = {
  --         message = function() -- message to print on save
  --           return ("Автосохранение: сохранение в  " .. vim.fn.strftime "%H:%M:%S" .. "")
  --         end,
  --         dim = 0.48, -- dim the color of `message`
  --         cleaning_interval = 500, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
  --       },
  --       trigger_events = { "TextChanged" }, -- vim events that trigger auto-save. See :h events
  --       -- trigger_events = { "InsertLeave", "TextChanged" }, -- vim events that trigger auto-save. See :h events
  --       condition = function(buf)
  --         local fn = vim.fn
  --         local utils = require "auto-save.utils.data"
  --
  --         if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
  --           return true -- met condition(s), can save
  --         end
  --         return false -- can't save
  --       end,
  --       write_all_buffers = false, -- write all buffers when the current one meets `condition`
  --       debounce_delay = 5000, -- saves the file at most every `debounce_delay` milliseconds
  --       callbacks = { -- functions to be executed at different intervals
  --         enabling = nil, -- ran when enabling auto-save
  --         disabling = nil, -- ran when disabling auto-save
  --         before_asserting_save = nil, -- ran before checking `condition`
  --         before_saving = nil, -- ran before doing the actual save
  --         after_saving = nil, -- ran after doing the actual save
  --       },
  --     }
  --   end,
  -- },
  { "max397574/better-escape.nvim", enabled = true },
  { "nvimtools/none-ls.nvim", enabled = true },
  { "nvim-lua/plenary.nvim", enabled = true },
  { "junegunn/fzf", enabled = true },
  { "max397574/better-escape.nvim", enabled = true },
  { "windwp/nvim-autopairs", enabled = true, event = "InsertEnter", config = true },
  { "windwp/nvim-ts-autotag", enabled = true },
  {
    "kr40/nvim-macros",
    cmd = { "MacroSave", "MacroYank", "MacroSelect", "MacroDelete" },
    opts = {
      json_file_path = vim.fs.normalize(vim.fn.stdpath "config" .. "/macros.json"),
      default_macro_register = "Q",
      json_formatter = "none",
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "chrisgrieser/nvim-recorder",
    dependencies = "rcarriga/nvim-notify", -- optional
    opts = {
      slots = { "a", "b" },
      mapping = {
        startStopRecording = "q",
        playMacro = "Q",
        switchSlot = "<C-q>",
        editMacro = "cq",
        deleteAllMacros = "dq",
        yankMacro = "yq",
        addBreakPoint = "##",
      },
      clear = false,
      logLevel = vim.log.levels.INFO, -- :help vim.log.levels
      lessNotifications = false,

      useNerdfontIcons = true,
      performanceOpts = {
        countThreshold = 100,
        lazyredraw = true,
        noSystemClipboard = true,
        autocmdEventsIgnore = {
          "TextChangedI",
          "TextChanged",
          "InsertLeave",
          "InsertEnter",
          "InsertCharPre",
        },
      },

      dapSharedKeymaps = false,
    },
  },
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
