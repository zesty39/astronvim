-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  {
    "stevearc/aerial.nvim",
    opts = function(_, opts) opts.layout.default_direction = "right" end,
  },
  { "max397574/better-escape.nvim", enabled = false },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts) opts.indent.tab_char = "»" end,
  },
  {
    "onsails/lspkind.nvim",
    opts = function(_, opts) opts.mode = "symbol_text" end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts) opts.ui.border = "rounded" end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window.position = "float"
      opts.window.mappings["<Esc>"] = {
        function(state)
          local Preview = require "neo-tree.sources.common.preview"
          local renderer = require "neo-tree.ui.renderer"
          if Preview.is_active() then
            Preview.hide()
          else
            if state.current_position == "float" then renderer.close(state) end
          end
        end,
        desc = "cancel",
      }
      opts.window.mappings["/"] = "noop"
      opts.popup_border_style = "rounded"
      opts.sources = { "filesystem" }
      opts.source_selector.winbar = false
    end,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          if opts.mappings.n["<Leader>o"] then opts.mappings.n["<Leader>o"] = false end

          opts.mappings.n["<Leader>e"] = { "<Cmd>Neotree toggle reveal<CR>", desc = "Toggle Explorer" }
        end,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts) opts.formatting.fields = { "abbr", "kind" } end,
  },
  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.stages = "static"
      opts.fps = 5
      opts.timeout = 3000
    end,
  },
  {
    "folke/todo-comments.nvim",
    opts = function(_, opts) opts.signs = false end,
  },

  -- Community plugins
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_executor = {
        name = "toggleterm",
      },
      cmake_runner = {
        name = "toggleterm",
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      local utils = require "astrocore"
      return utils.extend_tbl(opts, {
        messages = {
          view_search = false,
        },
        views = {
          cmdline_popup  = {
            position = {
              row = 12,
              col = "50%",
            },
            size = {
              width = 60,
              height = "auto",
            },
          },
          cmdline_popupmenu = {
            position = {
              row = 15,
              col = "50%",
            },
            size = {
              width = 60,
              height = 10,
            },
          },
        },
      })
    end,
  },
}
