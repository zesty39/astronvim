-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    ---@type CatppuccinOptions
    ---@diagnostic disable: missing-fields
    opts = {
      transparent_background = true,
      auto_integrations = true,
      integrations = {
        colorful_winsep = { color = "lavender" },
        snacks = {
          indent_scope_color = "lavender",
        },
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          return require("astrocore").extend_tbl(opts, {
            highlights = require("catppuccin.special.bufferline").get_theme(),
          })
        end,
      },
    },
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
      picker = {
        focus = "list",
        win = {
          input = {
            ["|"] = { "edit_vsplit", mode = { "i", "n" } },
            ["\\"] = { "edit_split", mode = { "i", "n" } },
          },
          list = {
            keys = {
              ["|"] = "edit_vsplit",
              ["\\"] = "edit_split",
            },
          },
        },
      },
    },
    specs = {
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          if opts.mappings.n.gra then opts.mappings.n.gra = false end
          if opts.mappings.x.gra then opts.mappings.x.gra = false end
          if opts.mappings.n.grn then opts.mappings.n.grn = false end
          if opts.mappings.n.grr then opts.mappings.n.grr = false end

          opts.mappings.n["<Leader>fj"] = {
            function() require("snacks").picker.jumps() {} end,
            desc = "Jumplists",
          }

          if opts.mappings.n["<Leader>fw"] then
            opts.mappings.n["<Leader>fw"][1] = function()
              require("snacks").picker.grep {
                focus = "input",
              }
            end
          end
        end,
      },
      {
        "AstroNvim/astrolsp",
        opts = function(_, opts)
          if opts.mappings.n.gd then
            opts.mappings.n.gd[1] = function() require("snacks").picker.lsp_definitions() { reuse_win = true } end
          end
          if opts.mappings.n.gI then
            opts.mappings.n.gI[1] = function() require("snacks").picker.lsp_implementations() { reuse_win = true } end
          end
          if opts.mappings.n.gy then
            opts.mappings.n.gy[1] = function() require("snacks").picker.lsp_type_definitions() { reuse_win = true } end
          end
          if opts.mappings.n["<Leader>lG"] then
            opts.mappings.n["<Leader>lG"][1] = function()
              require("snacks").picker.lsp_workspace_symbols {
                tree = false,
                focus = "input",
              }
            end
          end

          if opts.mappings.n["<Leader>lR"] then
            opts.mappings.n["<Leader>lR"][1] = function() require("snacks").picker.lsp_references() end
          end

          opts.mappings.n["<Leader>ls"] = {
            function()
              require("snacks").picker.lsp_symbols {
                tree = false,
              }
            end,
            desc = "Search symbols",
          }
          opts.mappings.n["gr"] = {
            function() require("snacks").picker.lsp_references() end,
            desc = "Search references",
            cond = "textDocument/references",
          }
          opts.mappings.n["gD"] = {
            function() require("snacks").picker.lsp_declarations() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          }
        end,
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
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

  -- user configuration
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
      max_lines = 2,
    },
  },
  {
    "kawre/neotab.nvim",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    specs = {
      {
        "Saghen/blink.cmp",
        optional = true,
        opts = {
          keymap = {
            ["<Tab>"] = {
              "select_next",
              "snippet_forward",
              "fallback",
            },
            ["<S-Tab>"] = {
              "select_prev",
              "snippet_backward",
              "fallback",
            },
          },
        },
      },
    },
    opts = {
      act_as_tab = true,
      behavior = "closing",
    },
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
    "folke/todo-comments.nvim",
    opts = function(_, opts) opts.signs = false end,
  },
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_regenerate_on_save = false,
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
          cmdline_popup = {
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
