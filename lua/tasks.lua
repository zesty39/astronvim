return {
  {
    name = "Build (single file) ⎯  C/C++",
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
  },
  {
    name = "Run (single file) ⎯  C/C++",
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
  },
  {
    name = "Clean (single file) ⎯  C/C++",
    builder = function()
      -- Full path to current file (see :help expand())
      local file = vim.fn.expand "%:p"
      local exec_file = file:match "(.+)%..+$"
      return {
        cmd = { "rm" },
        args = { "-f", exec_file },
        components = { "default" },
      }
    end,
    condition = {
      filetype = { "c", "cpp", "cc" },
    },
  },
  {
    name = "Build & Run (single file) ⎯  C/C++",
    builder = function()
      local file = vim.fn.expand "%:p"
      local exec_file = file:match "(.+)%..+$"
      local compile_cmd = "g++"
      local cmd = ""
      if vim.bo.filetype == "c" then compile_cmd = "gcc" end

      cmd = 'rm -f "'
        .. exec_file
        .. '" || true'
        .. " && "
        .. compile_cmd
        .. " "
        .. file
        .. ' -g -ggdb -o "'
        .. exec_file
        .. '"'
        .. ' && "'
        .. exec_file
        .. '"'

      return {
        cmd = cmd,
        components = { "default" },
      }
    end,
    condition = {
      filetype = { "c", "cpp", "cc" },
    },
  },
  {
    name = "Run (script language)",
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
  },
}
