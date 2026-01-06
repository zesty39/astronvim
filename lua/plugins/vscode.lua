if not vim.g.vscode then return {} end -- don't do anything in non-vscode instances

return {
  {
    "AstroNvim/astrocore",
    ---@param opts AstroCoreOpts
    opts = function(_, opts)
      local opt = vim.tbl_get(opts, "options", "opt")
      if opt then opt.cmdheight = nil end

      local maps = assert(opts.mappings)

      -- basic actions
      maps.n["j"] = function()
        require("vscode-neovim").call("cursorMove", {
          args = { to = "down", by = "wrappedLine", value = 1 },
        })
      end
      maps.n["k"] = function()
        require("vscode-neovim").call("cursorMove", {
          args = { to = "up", by = "wrappedLine", value = 1 },
        })
      end
      maps.n["za"] = function() require("vscode").action "editor.toggleFold" end
      maps.v["za"] = function() require("vscode").action "editor.toggleFold" end
      maps.n["zo"] = function() require("vscode").action "editor.unfold" end
      maps.v["zo"] = function() require("vscode").action "editor.unfold" end
      maps.n["zO"] = function() require("vscode").action "editor.unfoldAll" end
      maps.v["zO"] = function() require("vscode").action "editor.unfoldAll" end
      maps.n["zc"] = function() require("vscode").action "editor.fold" end
      maps.v["zc"] = function() require("vscode").action "editor.fold" end
      maps.n["zC"] = function() require("vscode").action "editor.foldAll" end
      maps.v["zC"] = function() require("vscode").action "editor.foldAll" end
      maps.v["zf"] = function() require("vscode").action "editor.createFoldingRangeFromSelection" end
      maps.n["<Leader>q"] = function() require("vscode").action "workbench.action.closeActiveEditor" end

      -- splits navigation

      -- terminal
      maps.n["<F7>"] = false

      -- buffer management
      maps.n["L"] = "<Cmd>Tabnext<CR>"
      maps.n["H"] = "<Cmd>Tabprevious<CR>"

      -- file explorer
      maps.n["<Leader>o"] = false

      -- indentation

      -- diagnostics

      -- pickers (emulate telescope mappings)
      maps.n["<Leader><Leader>"] = function() require("vscode").action "workbench.action.quickOpen" end

      -- git client
      maps.n["]g"] = function() require("vscode").action "workbench.action.editor.nextChange" end
      maps.n["[g"] = function() require("vscode").action "workbench.action.editor.previousChange" end
      maps.n["<Leader>gp"] = function() require("vscode").action "editor.action.dirtydiff.next" end
      maps.n["<Leader>gr"] = function() require("vscode").action "git.revertSelectedRanges" end
      maps.v["<Leader>gr"] = function() require("vscode").action "git.revertSelectedRanges" end
      maps.n["<Leader>gR"] = function() require("vscode").action "git.clean" end
      maps.n["<Leader>gs"] = function() require("vscode").action "git.stageSelectedRanges" end
      maps.v["<Leader>gs"] = function() require("vscode").action "git.stageSelectedRanges" end
      maps.n["<Leader>gS"] = function() require("vscode").action "git.stageFile" end
      maps.n["<Leader>gu"] = function() require("vscode").action "git.unstageFile" end
      maps.n["<Leader>gU"] = function() require("vscode").action "git.unstageAll" end

      -- LSP Mappings

      -- Tasks
      maps.n["<Leader>rr"] = function() require("vscode").action "workbench.action.tasks.runTask" end
      maps.n["<Leader>rc"] = function() require("vscode").action "workbench.action.tasks.configureTaskRunner" end
    end,
  },
}
