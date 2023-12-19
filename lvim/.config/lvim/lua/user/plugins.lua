local M = {}

M.config = function()
  lvim.plugins = {
    { "catppuccin/nvim", name = "catppuccin" },
    {
      "axelvc/template-string.nvim",
      config = function()
        require("template-string").setup {
          filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue", "svelte" },
          remove_template_string = true,
          restore_quotes = {
            normal = [[']],
            jsx = [["]],
          },
        }
      end,
      event = "InsertEnter",
      ft = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue", "svelte" },
    },
    {
      "nvChad/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup {
          filetypes = { "*", "!packer" },
          user_default_options = {
            tailwind = "lsp",
            names = false,
            sass = { enable = true, parsers = { css = true } },
          },
        }
      end,
    },
    {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup()
      end,
    },
    {
      "HiPhish/rainbow-delimiters.nvim",
      config = function()
        local rd = require("rainbow-delimiters")
        vim.g.rainbow_delimiters = {
          strategy = {
            [''] = rd.strategy['global'],
            vim = rd.strategy['local'],
          },
          query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
          },
          highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
          },
        }
      end,
    },
    {
      "tpope/vim-surround",
      init = function()
        vim.o.timeoutlen = 500
      end,
    }
  }
end

return M
