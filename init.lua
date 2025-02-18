-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
vim.opt.termguicolors = true
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)
vim.api.nvim_command ":set spell spelllang=en_us,ru_ru"
--Команда на старт терминала( при включении перестает работать стартовое окно)

local opts = { noremap = true, silent = true }

local function quickfix()
  vim.lsp.buf.code_action {
    filter = function(a) return a.isPreferred end,
    apply = true,
  }
end

local function searchFiles() vim.cmd "Rg" end

vim.keymap.set("n", "<leader>fq", quickfix, opts)
vim.keymap.set("n", "<leader>ff", searchFiles)

vim.api.nvim_create_user_command("Whereami", function()
  path = vim.api.nvim_buf_get_name(0)
  vim.api.nvim_echo({ { ("%s\n"):format(path), "InfoMsg" } }, true, {})
  vim.fn.setreg('"+', path)
end, {})

local function customMotion(motion)
  local save_pos = vim.fn.getpos "."
  vim.cmd("normal! " .. motion)
  if vim.fn.line "." ~= save_pos[2] then vim.fn.setpos(".", save_pos) end
end

local function customMotion_w()
  local save_pos = vim.fn.getpos "."
  vim.cmd "normal! w"
  if vim.fn.line "." ~= save_pos[2] then
    vim.fn.setpos(".", save_pos)
  else
    vim.cmd "normal! aw"
  end
end

vim.keymap.set("v", "w", function() customMotion "w" end , { noremap = true, silent = true })
vim.keymap.set("v", "b", function() customMotion "b" end, { noremap = true, silent = true })

vim.opt.scrolloff = 10
vim.opt.wrap = false
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
--vim.opt.theme = "delek"

--vim.api.nvim_command(':terminal')
-- validate that lazy is available
--
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end
require "lazy_setup"
require "polish"
require("neo-tree").setup {
  filesystem = {
    filtered_items = {
      visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
      hide_dotfiles = false,
      hide_gitignored = true,
    },
    follow_current_file = {
      enabled = false, -- This will find and focus the file in the active buffer every time
      --               -- the current file is changed while the tree is open.
      leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    },
  },
  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
        ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
      },
    },
  },
}

local servers = {
  "golangci_lint_ls",
  "intelephense",
  "pyright",
  "gopls",
  "cssls",
  "html",
  "bashls",
  "eslint",
  "jsonls",
  "tailwindcss",
}

for _, lsp in pairs(servers) do
  require("lspconfig")[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 300,
    },
    capabilities = capabilities,
  }
end

require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "onelight",
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
require("notify").setup {
  background_colour = "#000000",
  timeout = 1000,
  fps = 60,
  max_width = 50,
  max_height = 5,
}
