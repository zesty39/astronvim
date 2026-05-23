-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        fileencodings = "utf-8,gbk,chinese,latin1",
        list = true,
        listchars = { tab = "   ", extends = "›", precedes = "‹", trail = "·", nbsp = "␣" },
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        ["<C-q>"] = false,
        ["L"] = function()
          if not vim.g.vscode then
            require("astrocore.buffer").nav(vim.v.count1)
          else
            return "<Cmd>Tabnext<CR>"
          end
        end,
        ["H"] = function()
          if not vim.g.vscode then
            require("astrocore.buffer").nav(-vim.v.count1)
          else
            return "<Cmd>Tabprevious<CR>"
          end
        end,
      },
      i = {
        ["<F7>"] = false,
        ["<C-'>"] = false,
        ["<Esc>"] = {
          function()
            local ok, luasnip = pcall(require, "luasnip")
            if ok then
              local bufnr = vim.api.nvim_get_current_buf()
              local node = luasnip.session
                and luasnip.session.current_nodes
                and luasnip.session.current_nodes[bufnr]

              if node then
                luasnip.unlink_current()
              end
            end

            return "<Esc>"
          end,
          expr = true,
          desc = "Exit insert mode and clear LuaSnip session",
        },
      },
      s = {
        ["<Esc>"] = {
          function()
            local ok, luasnip = pcall(require, "luasnip")
            if ok then
              local bufnr = vim.api.nvim_get_current_buf()
              local node = luasnip.session
                and luasnip.session.current_nodes
                and luasnip.session.current_nodes[bufnr]

              if node then
                luasnip.unlink_current()
              end
            end

            return "<Esc>"
          end,
          expr = true,
          desc = "Exit select mode and clear LuaSnip session",
        },
      },
    },
    autocmds = {
    },
    commands = {
      TrimFile = {
        function()
          local utils = require "astrocore"

          vim.cmd([[%s/\s\+$//e]])
          vim.cmd([[%s/\r//e]])

          utils.notify("Formatting cleaned: Trailing spaces removed, CRLF replaced with LF.")
        end,
        desc = "Remove trialing white space and \\r",
      },
      Filename = {
        function()
          local utils = require "astrocore"
          local filename = vim.api.nvim_buf_get_name(0)

          utils.notify("File Name: " .. filename)
        end,
        desc = "Remove trialing white space and \\r",
      },
    },
  },
}
