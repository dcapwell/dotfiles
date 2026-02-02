# AGENTS.md - Dotfiles Repository

Personal dotfiles managed with GNU `stow`. Primarily targets macOS with Zsh, Neovim, Tmux, and modern CLI tools.

## Build/Install Commands

```bash
# Full setup (dirs + brew + stow)
make setup

# Individual targets
make setup-dirs    # Create ~/bin and ~/.oh-my-zsh/custom
make stow          # Symlink dotfiles to $HOME
make brew          # Install Homebrew packages from Brewfile
make check         # Verify Brewfile packages are installed

# Bootstrap on fresh machine
./install.sh       # Installs Xcode CLI tools, Homebrew, then runs make setup
```

## Repository Structure

```
dotfiles-v2/
├── Makefile              # Build automation
├── Brewfile              # Homebrew dependencies
├── install.sh            # Bootstrap script
└── stow/common/          # All stow-managed dotfiles
    ├── .config/
    │   ├── nvim/         # Neovim config (Kickstart.nvim-based)
    │   ├── tmux/         # Tmux configuration
    │   └── ghostty/      # Terminal emulator config
    ├── .oh-my-zsh/custom/
    │   ├── aliases.zsh   # Shell aliases
    │   ├── functions.zsh # Shell functions
    │   ├── export.zsh    # Environment variables
    │   ├── paths.zsh     # PATH modifications
    │   └── plugins/      # Custom Oh My Zsh plugins
    ├── bin/              # Utility scripts (~30+ tools)
    ├── .zshrc            # Main Zsh configuration
    ├── .gitconfig        # Git configuration
    └── .ssh/config       # SSH configuration
```

## Linting

```bash
# Lint shell scripts
shellcheck stow/common/bin/*.sh

# Lint a specific script
shellcheck path/to/script.sh
```

## Tool Preferences

Use modern CLI replacements (installed via Brewfile):

| Instead of | Use     | Notes                          |
|------------|---------|--------------------------------|
| `find`     | `fd`    | Simpler syntax, respects .gitignore |
| `grep`     | `rg`    | Faster, respects .gitignore    |
| `cat`      | `bat`   | Syntax highlighting            |
| `ls`       | `eza`   | Colors, git integration        |
| `cd`       | `zoxide`| Frecency-based navigation      |

## Bash Script Conventions

### Shebang and Strict Mode
```bash
#!/usr/bin/env bash

#set -o xtrace   # Uncomment for debugging
set -o errexit
set -o pipefail
set -o nounset
```

### Structure Pattern
```bash
#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

_main() {
  local some_var="value"
  
  while [ $# -gt 0 ]; do
    case "$1" in
      -f|--flag)
        # handle flag
        shift
        ;;
      *)
        break
        ;;
    esac
  done
  
  # main logic here
}

_main "$@"
```

### Key Conventions
- Use `local` for all function variables
- Use `case` statements for argument parsing
- Quote variables: `"$var"` not `$var`
- Use `[[ ]]` for conditionals (bash), `[ ]` for POSIX sh
- Redirect errors to stderr: `echo "error" >&2`

## Python Script Conventions

### Use uv Inline Script Format (PEP 723)
```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.8"
# dependencies = [
#     "requests",
#     "beautifulsoup4",
# ]
# ///

import argparse

def parse_args():
    parser = argparse.ArgumentParser(description="Tool description")
    parser.add_argument("input", type=str, help="Input argument")
    return parser.parse_args()

def main():
    args = parse_args()
    # main logic here

if __name__ == "__main__":
    main()
```

### Key Conventions
- Always use `argparse` for CLI arguments
- Use `parse_args()` function pattern
- Wrap main logic in `main()` function
- Use `if __name__ == "__main__":` guard
- Print errors to stderr: `print("error", file=sys.stderr)`
- Exit with non-zero on error: `sys.exit(1)`
- Type hints encouraged: `def func(name: str) -> dict:`

## Lua Conventions (Neovim)

Based on Kickstart.nvim patterns:
- Two-space indentation
- Single quotes for strings: `'string'`
- Plugin manager: lazy.nvim
- Custom plugins go in: `lua/custom/plugins/`

```lua
-- Plugin definition pattern
return {
  'author/plugin-name',
  lazy = false,
  dependencies = {
    'other/dependency',
  },
  config = function()
    require('plugin').setup()
  end,
}
```

## Zsh Conventions

### Functions
```zsh
my_function() {
  local var="value"
  # logic here
}
```

### Platform Detection
```zsh
if is_osx; then
  # macOS specific
elif is_linux; then
  # Linux specific
fi
```

### Key Patterns
- Custom Oh My Zsh files use `.zsh` extension
- Aliases in `aliases.zsh`, functions in `functions.zsh`
- Local overrides supported via `~/.gitconfig_local`, `~/.ssh/config.local`

## Adding New Configurations

1. Add files to `stow/common/` mirroring their `$HOME` location
2. Run `make stow` to create symlinks
3. For new brew packages, add to `Brewfile` with comment explaining purpose

### Adding a New Script

1. Create in `stow/common/bin/`
2. Make executable: `chmod +x script-name`
3. Run `make stow`
4. Script is now available as `script-name` in PATH

### Script Naming
- Use lowercase with hyphens: `my-script.sh`, `my-tool.py`
- Python scripts: `.py` extension
- Bash scripts: `.sh` extension (or no extension for generic tools)

### Script Aliases (Symlinks)

For scripts with long names, create symlinks in `stow/common/bin/` as short aliases:

```bash
cd stow/common/bin/
ln -s parse-java-stacktrace-from-logs.py pjstack
```

This creates:
```
stow/common/bin/
├── parse-java-stacktrace-from-logs.py   # actual script
└── pjstack -> parse-java-stacktrace-from-logs.py  # alias symlink
```

**Why symlinks instead of shell aliases:**
- Shell aliases only work in interactive shells
- Tools that spawn non-interactive bash/sh won't load `.bashrc` aliases
- Symlinks work at the filesystem level, independent of shell configuration
