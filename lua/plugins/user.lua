-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  { "max397574/better-escape.nvim", enabled = false },

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
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts) opts.indent.tab_char = "»" end,
  },

  {
    "xiyaowong/transparent.nvim",
    opts = function(_, opts)
      local transparent = require "transparent"
      opts.extra_groups = {
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
      }
      transparent.clear_prefix "Telescope"
      transparent.clear_prefix "Notify"
      transparent.clear_prefix "Overseer"
      vim.g.transparent_enabled = true
    end,
  },

  {
    "stevearc/overseer.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<leader>M"
          maps.n[prefix .. "<CR>"] = { "<Cmd>OverseerRestartLast<CR>", desc = "Restart Last Task" }
        end,
      },
    },
    opts = function(_, opts)
      vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local overseer = require "overseer"
        local tasks = overseer.list_tasks { recent_first = true }
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
        end
      end, {})
      local overseer = require "overseer"
      overseer.register_template {
        name = "build single C/C++ file",
        builder = function()
          -- Full path to current file (see :help expand())
          local file = vim.fn.expand "%:p"
          local exec_file = file:match "(.+)%..+$"
          local cmd = { "g++" }
          if vim.bo.filetype == "c" then cmd = { "gcc" } end
          return {
            cmd = cmd,
            args = { file, "-o", exec_file },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "c", "cpp", "cc" },
        },
      }
      overseer.register_template {
        name = "run single C/C++ file",
        builder = function()
          -- Full path to current file (see :help expand())
          local file = vim.fn.expand "%:p"
          local exec_file = file:match "(.+)%..+$"
          return {
            cmd = { exec_file },
            components = { "default" },
          }
        end,
        condition = {
          filetype = { "c", "cpp", "cc" },
        },
      }
      overseer.register_template {
        name = "run script",
        builder = function()
          local file = vim.fn.expand "%:p"
          local cmd = { file }
          if vim.bo.filetype == "go" then cmd = { "go", "run", file } end
          return {
            cmd = cmd,
            components = {
              "default",
            },
          }
        end,
        condition = {
          filetype = { "sh", "python", "go" },
        },
      }
    end,
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
          local snippet_jumpable = function() return vim.snippet and vim.snippet.active { direction = 1 } end
          local snippet_jump = vim.schedule_wrap(function() vim.snippet.jump(1) end)
          local luasnip_avail, luasnip = pcall(require, "luasnip")
          if luasnip_avail then
            snippet_jumpable = luasnip.expand_or_jumpable
            snippet_jump = luasnip.expand_or_jump
          end
          opts.mapping["<C-E>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" })
          opts.mapping["<Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.api.nvim_get_mode() ~= "c" and snippet_jumpable() then
              snippet_jump()
            elseif not luasnip_avail and pcall(vim.snippet.active, { direction = 1 }) then
              vim.snippet.jump(1)
            else
              neotab.tabout()
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
}
