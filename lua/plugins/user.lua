return {
  {
    "kawre/neotab.nvim",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    specs = {
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        opts = function(_, opts)
          local cmp = require "cmp"
          local neotab = require "neotab"
          local snippet_jumpable = function(dir) return vim.snippet and vim.snippet.active { direction = dir } end
          local snippet_jump = vim.schedule_wrap(function() vim.snippet.jump(1) end)
          local luasnip_avail, luasnip = pcall(require, "luasnip")
          if luasnip_avail then
            snippet_jumpable = luasnip.jumpable
            snippet_jump = luasnip.jump
          end
          opts.mapping["<C-E>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" })
          opts.mapping["<C-F>"] = cmp.mapping(cmp.mapping.scroll_docs(6), { "i", "c" })
          opts.mapping["<C-B>"] = cmp.mapping(cmp.mapping.scroll_docs(-6), { "i", "c" })
          opts.mapping["<C-D>"] = cmp.mapping(function()
            if snippet_jumpable(1) then snippet_jump(1) end
          end, { "i", "s" })
          opts.mapping["<C-U>"] = cmp.mapping(function()
            if snippet_jumpable(-1) then snippet_jump(-1) end
          end, { "i", "s" })
          opts.mapping["<Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              neotab.tabout()
            end
          end, { "i", "s" })
          opts.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible(cmp) then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" })
        end,
      },
    },
    opts = {
      tabkey = "",
      act_as_tab = true,
      behavior = "closing",
    },
  },

  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {
      extra_groups = {
        "Normal",
        "NormalNC",
        "NormalFloat",
        "FloatBorder",
        "CursorLineNr",
        "LineNr",
        "SignColumn",
        "TabLine",
        "TabLineFill",
        "VertSplit",
        "WinSeparator",
        "WinBarNC",
      },
    },
    config = function(_, opts)
      local transparent = require "transparent"
      transparent.setup(opts)
      transparent.clear_prefix "BufferLine"
      transparent.clear_prefix "NeoTreeNormal"
      transparent.clear_prefix "NeoTreeTab"
      transparent.clear_prefix "NeoTreeFloat"
      transparent.clear_prefix "NeoTreeTitleBar"
      transparent.clear_prefix "lualine"
      transparent.clear_prefix "TelescopePreviewNormal"
      transparent.clear_prefix "TelescopePreviewBorder"
      transparent.clear_prefix "TelescopePrompt"
      transparent.clear_prefix "TelescopeResults"
      transparent.clear_prefix "Notify"
      transparent.clear_prefix "Overseer"

      if vim.g.neovide then
        vim.g.transparent_enabled = false
      else
        vim.g.transparent_enabled = true
      end
    end,
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<Leader>uT"] = { "<Cmd>TransparentToggle<CR>", desc = "Toggle transparency" }
          if vim.tbl_get(opts, "autocmds", "heirline_colors") then
            table.insert(opts.autocmds.heirline_colors, {
              event = "User",
              pattern = "TransparentClear",
              desc = "Refresh heirline colors",
              callback = function()
                if package.loaded["heirline"] then require("astroui.status.heirline").refresh_colors() end
              end,
            })
          end
        end,
      },
    },
  },

  {
    "smoka7/hop.nvim",
    opts = {},
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["s"] = { function() require("hop").hint_char1() end, desc = "Hop hint char1" },
            ["<S-s>"] = { function() require("hop").hint_words() end, desc = "Hop hint words" },
            ["<S-L>"] = { function() require("hop").hint_lines() end, desc = "Hop hint lines" },
          },
        },
      },
    },
    specs = {
      {
        "catppuccin",
        optional = true,
        ---@type CatppuccinOptions
        opts = { integrations = { hop = true } },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "User AstroFile",
    cmd = { "TSContextToggle" },
    opts = {
      separator = "═",
    },
  },
}
