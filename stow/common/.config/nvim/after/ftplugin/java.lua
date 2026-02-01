-- Java-specific indentation settings to ensure we respect the current file format
-- Reference Style Guides:
-- Oracle (4 spaces): https://www.oracle.com/java/technologies/javase/codeconventions-contents.html
-- Google (2 spaces): https://google.github.io/styleguide/javaguide.html

-- Enable C-style indentation
vim.opt_local.cindent = true

-- Configure cinoptions to match Java standards
-- j1: Indent anonymous classes correctly
-- m1: Indent comment stars
-- +2s: Indent continuation lines by 2 * shiftwidth (standard for Java)
-- (0: Don't indent extra for nested parentheses
-- t0: Don't indent function return types
-- ks: Indent 'case' labels relative to 'switch'
vim.opt_local.cinoptions = "j1,m1,+2s,(0,t0,ks"

-- Use a standard 4-space indent for Java by default
-- This acts as a better fallback than the global 2-space setting
-- guess-indent.nvim should still be able to override this if it detects 2 spaces
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true

-- Disable treesitter indent and smartindent to let cindent take full control
vim.opt_local.indentexpr = ""
vim.opt_local.smartindent = false
vim.opt_local.autoindent = true
