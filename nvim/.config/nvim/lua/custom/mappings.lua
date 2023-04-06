local M = {}

-- In order to disable a default keymap, use
M.disabled = {
  n = {
    ["<leader>h"] = {""},
    ["<leader>l"] = {""},
    ["<leader>ls"] = {""}
  }
}
-- Your custom mappings
M.abc = {
  n = {
    ["H"] = {"^"},
    ["L"] = {"$"},
    ["<leader>h"] = {":bp <CR>"},
    ["<leader>l"] = {":bn <CR>"},
    ["<leader>x"] = {":bd <CR>"}
  },

  i = {
  }
}

return M

