require('toggleterm').setup {
  size = 20,
  float_opts = {
    border = 'curved',
  },
}

local horizontalterm = function()
  vim.cmd 'ToggleTerm direction=horizontal'
end

local floatterm = function()
  vim.cmd 'ToggleTerm direction=float'
end

vim.keymap.set({ 'n', 't' }, [[<c-h>]], horizontalterm, { desc = 'Launch a horizontal term' })
vim.keymap.set({ 'n', 't' }, [[<c-\>]], floatterm, { desc = 'Launch a floating term' })

return {}
