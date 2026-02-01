vim.keymap.set('n', '<leader>:', function()
  require('telescope.builtin').commands()
end, {
  desc = 'Telescope: search commands',
})

return {}
