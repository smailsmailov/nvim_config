



return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "xml",
      "go",
      "python",
      "php",
      "javascript",
      "html",
      "scss",
      "css",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
