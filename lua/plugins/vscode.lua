if not vim.g.vscode then return {} end -- don't do anything in non-vscode instances

local function toggle_preview(command, direction, extensions)
    local vscode = require "vscode"

    local args = {
        cmd = command,
        dir = direction,
        exts = extensions
    }

    local js_code = [[
        const { cmd, dir, exts } = args;

        const editor = vscode.window.activeTextEditor;
        const currentFile = editor ? editor.document.fileName.toLowerCase() : "";
        const isTargetFile = exts.some(ext => currentFile.endsWith(ext.toLowerCase()));

        const tabGroups = vscode.window.tabGroups;
        let existingTab = null;
        for (const group of tabGroups.all) {
            for (const tab of group.tabs) {
                const label = (tab.label || "").toLowerCase();
                if ((label.includes("preview") || label.includes("预览")) && 
                    exts.some(ext => label.endsWith(ext.toLowerCase()))) {
                    existingTab = tab;
                    break;
                }
            }
            if (existingTab) break;
        }

        if (existingTab) {
            await tabGroups.close(existingTab);
            return "Closed";
        }

        if (!isTargetFile) {
            return "Ignored: Not a target file extension";
        }

        const config = vscode.workspace.getConfiguration('workbench.editor');
        try {
            await config.update('openSideBySideDirection', dir, vscode.ConfigurationTarget.Workspace);
            await new Promise(resolve => setTimeout(resolve, 50));
            await vscode.commands.executeCommand(cmd);
            await vscode.commands.executeCommand('workbench.action.focusFirstEditorGroup');

            return "Opened";
        } catch (e) {
            return "Error: " + e.message;
        } finally {
            await config.update('openSideBySideDirection', undefined, vscode.ConfigurationTarget.Workspace);
        }
    ]]

    return vscode.eval_async(js_code, { args = args })
end

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
        require("vscode-neovim").action("cursorMove", {
          args = { to = "down", by = "wrappedLine", value = 1 },
        })
      end
      maps.n["k"] = function()
        require("vscode-neovim").action("cursorMove", {
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
      maps.n["<Leader>p"] = function() require("vscode").action "solutionExplorer.focus" end

      -- indentation

      -- diagnostics

      -- pickers (emulate telescope mappings)
      maps.n["<Leader><Leader>"] = function() require("vscode").action "workbench.action.showCommands" end

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

      -- AI Mappings

      -- Tasks
      maps.n["<Leader>um"] = function()
        toggle_preview("markdown.showPreviewToSide", "right", { ".md" });
        --vim.defer_fn(function() require("vscode").action "workbench.action.focusFirstEditorGroup" end, 200)
      end
      maps.n["<Leader>ua"] = function()
        toggle_preview("avalonia.showPreviewToSide", "down", { ".axaml", "xaml"});
        -- vim.defer_fn(function() require("vscode").action "workbench.action.focusFirstEditorGroup" end, 200)
      end
    end,
  },
}
