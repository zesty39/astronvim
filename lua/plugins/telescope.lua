return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    local actions = require "telescope.actions"
    local maps = {
      n = {
        ["<C-U>"] = actions.results_scrolling_down,
        ["<C-D>"] = actions.results_scrolling_up,
        ["|"] = actions.file_vsplit,
        ["\\"] = actions.file_split,
      }
    }
    opts.defaults.initial_mode = "normal"
    opts.defaults.mappings = require("astrocore").extend_tbl(opts.defaults.mappings, maps)
  end,
  specs = {
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        if opts.mappings.n.gra then opts.mappings.n.gra = false end
        if opts.mappings.x.gra then opts.mappings.x.gra = false end
        if opts.mappings.n.grn then opts.mappings.n.grn = false end
        if opts.mappings.n.grr then opts.mappings.n.grr = false end

        if vim.fn.executable "git" == 1 then
          if opts.mappings.n.gra then opts.mappings.n.gra = false end
          if opts.mappings.n["<Leader>gb"] then
            opts.mappings.n["<Leader>gb"][1] = function() require("telescope.builtin").git_branches() end
          end
          if opts.mappings.n["<Leader>gc"] then
            opts.mappings.n["<Leader>gc"][1] = function() require("telescope.builtin").git_commits() end
          end
          if opts.mappings.n["<Leader>gC"] then
            opts.mappings.n["<Leader>gC"][1] = function() require("telescope.builtin").git_bcommits() end
          end
          if opts.mappings.n["<Leader>gt"] then
            opts.mappings.n["<Leader>gt"][1] = function() require("telescope.builtin").git_status() end
          end
        end

        opts.mappings.n["<Leader>fj"] = {
          function() require("telescope.builtin").jumplist {} end,
          desc = "Jumplists",
        }
      end,
    },
    {
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        if opts.mappings.n.gd then
          opts.mappings.n.gd[1] = function() require("telescope.builtin").lsp_definitions { reuse_win = true } end
        end
        if opts.mappings.n.gI then
          opts.mappings.n.gI[1] = function() require("telescope.builtin").lsp_implementations { reuse_win = true } end
        end
        if opts.mappings.n.gy then
          opts.mappings.n.gy[1] = function() require("telescope.builtin").lsp_type_definitions { reuse_win = true } end
        end
        if opts.mappings.n["<Leader>lG"] then
          opts.mappings.n["<Leader>lG"][1] = function()
            vim.ui.input({ prompt = "Symbol Query: (leave empty for word under cursor)" }, function(query)
              if query then
                -- word under cursor if given query is empty
                if query == "" then query = vim.fn.expand "<cword>" end
                require("telescope.builtin").lsp_workspace_symbols {
                  query = query,
                  prompt_title = ("Find word (%s)"):format(query),
                }
              end
            end)
          end
        end
        if opts.mappings.n["<Leader>lR"] then
          opts.mappings.n["<Leader>lR"][1] = function() require("telescope.builtin").lsp_references() end
        end

        opts.mappings.n["gr"] = {
          function() require("telescope.builtin").lsp_references() end,
          desc = "Search references",
          cond = "textDocument/references",
        }
      end,
    },
  },
}
