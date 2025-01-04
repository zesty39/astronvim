local function terminal_exec(cmd, dir)
  local terms = require "toggleterm.terminal"
  local exit_cmd = " && echo -e \"\\n\\nPress any key to exit ...\" && read " .. (vim.o.shell:find("zsh") and "-k 1" or "-n 1 -s") .. "&& exit $?"

  local term = terms.Terminal:new {
    cmd = (cmd .. exit_cmd),
    dir = dir,
    direction = "float",
    name = "Run",
    close_on_exit = true,
    hidden = false,
  }

  term:toggle()
end

return {
  "akinsho/toggleterm.nvim",
  opts = function(_, opts) opts.direction = "float" end,
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local utils = require "astrocore"

        local maps = {
          n = {
            ["<a-=>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
          },
          t = {
            ["<a-=>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
            ["<m-q>"] = { [[<c-\><c-n>]], desc = "Enter normal mode on terminal" },
          },
        }

        local cmds = {
          TermRunFile = {
            function()
              local file = vim.fn.expand "%:p"
              local dir = file:match "(.+)/[^/]*$" or "."
              local exec_file = file:match "(.+)%..+$"
              local cmd = nil
              if vim.bo.filetype == "c" then
                cmd = 'gcc "' .. file .. '" -g -ggdb -o "' .. exec_file .. '" && "' .. exec_file .. '"'
              elseif vim.bo.filetype == "cpp" then
                cmd = 'g++ "' .. file .. '" -g -ggdb -o "' .. exec_file .. '" && "' .. exec_file .. '"'
              end

              if cmd == nil then
                utils.notify("Cannot run " .. file, vim.log.levels.ERROR)
              else
                terminal_exec(cmd, dir)
              end
            end,
            desc = "Run file on terminal",
          },
        }

        if opts.mappings.n["<F7>"] then opts.mappings.n["<F7>"] = false end
        if opts.mappings.i["<F7>"] then opts.mappings.i["<F7>"] = false end
        if opts.mappings.n["<C-'>"] then opts.mappings.n["<C-'>"] = false end
        if opts.mappings.i["<C-'>"] then opts.mappings.i["<C-'>"] = false end

        opts.mappings = utils.extend_tbl(opts.mappings, maps)
        opts.commands = utils.extend_tbl(opts.commands, cmds)
      end,
    },
  },
}
