-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  { "max397574/better-escape.nvim", enabled = false },

  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts.defaults.initial_mode = "insert"
      opts.pickers = {
        find_files = {
          initial_mode = "normal",
        },
        lsp_references = {
          initial_mode = "normal",
        },
        lsp_definitions = {
          initial_mode = "normal",
        },
        lsp_implementations = {
          initial_mode = "normal",
        },
        lsp_incoming_calls = {
          initial_mode = "normal",
        },
        lsp_outcoming_calls = {
          initial_mode = "normal",
        },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      signs = false,
    },
  },

  {
    "onsails/lspkind.nvim",
    opts = function(_, opts)
      opts.mode = "symbol_text"
      opts.symbol_map = {
        Namespace = "󰌗",
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰆧",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈚",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰊄",
        Table = "",
        Object = "󰅩",
        Tag = "",
        Array = "[]",
        Boolean = "",
        Number = "",
        Null = "󰟢",
        Supermaven = "",
        String = "󰉿",
        Calendar = "",
        Watch = "󰥔",
        Package = "",
        Copilot = "",
        Codeium = "",
        TabNine = "",
      }
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.window.position = "float"
      opts.popup_border_style = "rounded"
      opts.sources = { "filesystem" }
      opts.source_selector.winbar = false
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts) opts.formatting.fields = { "abbr", "kind" } end,
  },

  {
    "stevearc/aerial.nvim",
    opts = function(_, opts) opts.layout.default_direction = "right" end,
  },

  {
    "rcarriga/nvim-notify",
    opts = function(_, opts)
      opts.stages = "static"
      opts.fps = 5
      opts.timeout = 1000
    end,
  },

  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_executor = {
        name = "overseer",
      },
      cmake_runner = {
        name = "overseer",
        default_opts = {
          overseer = {
            new_task_opts = {
              strategy = {
                "toggleterm",
                direction = "horizontal",
                autos_croll = true,
                open_on_start = true,
              },
            }, -- options to pass into the `overseer.new_task` command
          },
        },
      },
      cmake_notifications = {
        runner = { enabled = false },
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts) opts.indent.tab_char = "»" end,
  },

  -- new plugin
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
      transparent.clear_prefix "NeoTree"
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
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction ",
      "OverseerClearCache",
    },
    ---@param opts overseer.Config
    opts = function(_, opts)
      local astrocore = require "astrocore"
      local templates = require "overseer.template.builtin"
      if astrocore.is_available "toggleterm.nvim" then opts.strategy = "toggleterm" end

      for i = #templates, 1, -1 do
        if templates[i] == "shell" then table.remove(templates, i) end
      end

      opts.templates = templates
      opts.task_list = {
        bindings = {
          ["<C-l>"] = false,
          ["<C-h>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          q = "<Cmd>close<CR>",
          K = "IncreaseDetail",
          J = "DecreaseDetail",
          ["<C-p>"] = "ScrollOutputUp",
          ["<C-n>"] = "ScrollOutputDown",
        },
      }
    end,
    dependencies = {
      { "AstroNvim/astroui", opts = { icons = { Overseer = "" } } },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local commands = opts.commands
          local maps = opts.mappings
          local prefix = "<leader>o"
          maps.n[prefix] = { desc = require("astroui").get_icon("Overseer", 1, true) .. "Overseer" }

          maps.n[prefix .. "t"] = { "<Cmd>OverseerToggle<CR>", desc = "Toggle Overseer" }
          maps.n[prefix .. "c"] = { "<Cmd>OverseerRunCmd<CR>", desc = "Run Command" }
          maps.n[prefix .. "r"] = { "<Cmd>OverseerRun<CR>", desc = "Run Task" }
          maps.n[prefix .. "q"] = { "<Cmd>OverseerQuickAction<CR>", desc = "Quick Action" }
          maps.n[prefix .. "a"] = { "<Cmd>OverseerTaskAction<CR>", desc = "Task Action" }
          maps.n[prefix .. "i"] = { "<Cmd>OverseerInfo<CR>", desc = "Overseer Info" }

          commands.OverseerRestartLast = {
            function()
              local overseer = require "overseer"
              local tasks = overseer.list_tasks { recent_first = true }
              if vim.tbl_isempty(tasks) then
                vim.notify("No tasks found", vim.log.levels.WARN)
              else
                overseer.run_action(tasks[1], "restart")
              end
            end,
            desc = "Restart last tasks",
          }
        end,
      },
    },
    config = function(_, opts)
      local overseer = require "overseer"
      local tasks = require "tasks"

      for _, templates in ipairs(tasks) do
        overseer.register_template(templates)
      end

      overseer.setup(opts)
    end,
  },
  {
    "jonarrien/telescope-cmdline.nvim",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              [";"] = { "<cmd>Telescope cmdline<cr>", desc = "Cmdline" },
              ["<leader><leader>"] = { "<cmd>Telescope cmdline<cr>", desc = "Cmdline" },
            },
            v = {
              [";"] = { "<cmd>Telescope cmdline visual<cr>", desc = "Cmdline" },
              ["<leader><leader>"] = { "<cmd>Telescope cmdline visual<cr>", desc = "Cmdline" },
            },
          },
        },
      },
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "jonarrien/telescope-cmdline.nvim" },
        opts = function(_, opts)
          opts.extensions = {
            cmdline = {
              picker = {
                initial_mode = "insert",
              },
            },
          }
          require("telescope").load_extension "cmdline"
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
