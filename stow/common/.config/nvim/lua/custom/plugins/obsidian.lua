-- This sets up the obsidian.nvim
-- see https://github.com/epwalsh/obsidian.nvim

-- see https://github.com/epwalsh/obsidian.nvim?tab=readme-ov-file#concealing-characters
--	Value		Effect ~
--	0		Text is shown normally
--	1		Each block of concealed text is replaced with one
--			character.  If the syntax item does not have a custom
--			replacement character defined (see |:syn-cchar|) the
--			character defined in 'listchars' is used.
--			It is highlighted with the "Conceal" highlight group.
--	2		Concealed text is completely hidden unless it has a
--			custom replacement character defined (see
--			|:syn-cchar|).
vim.opt.conceallevel = 2
return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  -- ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    -- refer to `:h file-pattern` for more examples
    'BufReadPre '
      .. vim.fn.expand '~'
      .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/Work/*.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/Work/*.md',
    'BufReadPre ' .. vim.fn.expand '~' .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/default/*.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/default/*.md',
  },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp', -- when typing [ or [[ can help auto complete

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = 'default',
        path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/default',
      },
      {
        name = 'Work',
        path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Work',
      },
    },

    -- see below for full list of options 👇
  },
}
