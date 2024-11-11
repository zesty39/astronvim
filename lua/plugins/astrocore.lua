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
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        virtualedit = "onemore",
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
        -- setting a mapping to false will disable it
        ["<F7"] = false,
        ["<C-q>"] = false,
        ["<Leader>o"] = false,
        ["gra"] = false,
        ["grn"] = false,
        ["grr"] = false,

        -- setting user mapping
        ["<tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<S-tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<a-=>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
        ["<Leader>gb"] = {
          function() require("telescope.builtin").git_branches {} end,
          desc = "Git branches",
        },
        ["<Leader>gc"] = {
          function() require("telescope.builtin").git_commits {} end,
          desc = "Git commits (repository)",
        },
        ["<Leader>gC"] = {
          function() require("telescope.builtin").git_bcommits {} end,
          desc = "Git commits (current file)",
        },
        ["<Leader>gt"] = {
          function() require("telescope.builtin").git_status {} end,
          desc = "Git status",
        },
      },
      t = {
        -- setting a mapping to false will disable it

        -- setting user mapping
        ["<m-q>"] = { [[<c-\><c-n>]] },
        ["<a-=>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      },
      x = {
        -- setting a mapping to false will disable it
        ["gra"] = false,

        -- setting user mapping
      },
    },
    autocmds = {
      restore_curosr_on_exit = {
        {
          event = "VimLeave",
          callback = function()
            vim.opt.guicursor = ""
            vim.fn.chansend(vim.v.stderr, "\27[ q")
          end,
        },
      },
    },
    commands = {
      -- create user command here
    },
  },
}
