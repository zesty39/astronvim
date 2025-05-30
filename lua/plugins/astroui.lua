-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = "astrodark",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = { -- this table overrides highlights in all themes
        -- Normal = { bg = "#000000" },
      },
      astrodark = { -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
      },
    },
  },
  specs = {
    {
      "AstroNvim/astrotheme",
      opts = {
        palettes = {
          astrodark = {
            term = {
              black = "#1B1D1E",
              bright_black = "#808080",
              white = "#CCCCCC",
              bright_white = "#F8F8F2",
              foreground = "#CCCCCC",
              background = "1B1D1E",
            },
          },
        },
      },
    },
  },
}
