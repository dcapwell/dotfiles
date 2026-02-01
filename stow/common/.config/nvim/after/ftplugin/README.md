# Filetype Plugins (`after/ftplugin`)

This directory contains configuration files that are automatically loaded when a file of a specific type is opened.

### How it works
- **Naming**: Use the **Neovim filetype** as the filename (e.g., `java.lua`, `python.lua`, `markdown.lua`). 
  - *Note*: This is the internal name Neovim uses, which is not always the file extension. For example, a `.py` file uses `python.lua`.
- **Finding the filetype**: To find the correct name for a new file, open a file of that type and run:
  ```vim
  :set filetype?
  ```
  Or in Lua:
  ```lua
  :lua print(vim.bo.filetype)
  ```
- **Precedence**: Because this is in the `after/` directory, these settings are applied *after* standard plugins, making it the ideal place to override default behaviors or plugin settings.

### What to put in these files
1. **Buffer-local settings**: Use `vim.opt_local` (e.g., `vim.opt_local.shiftwidth = 4`) to ensure settings don't leak into other filetypes.
2. **Buffer-local keymaps**: Define mappings that only make sense for a specific language.
3. **Indentation logic**: Language-specific rules like `cindent`, `cinoptions`, or custom `indentexpr`.

### Example
To add settings for Python, create `python.lua` here and add:
```lua
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
```
