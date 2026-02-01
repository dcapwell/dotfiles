# Nerd Font Installation for iTerm2 + Neovim

## Overview

Install a Nerd Font via Homebrew, configure iTerm2 to use it, and update Neovim config to enable icon support.

## Step 1: Choose a Nerd Font

Popular choices for coding/terminal use:

| Font | Description |
|------|-------------|
| **JetBrains Mono** | Clean, excellent readability, popular with devs |
| **FiraCode** | Popular, has ligatures (e.g., `->` becomes an arrow) |
| **Hack** | Very readable, no ligatures |
| **Meslo LG** | Based on Apple's Menlo, very common |
| **Cascadia Code** | Microsoft's font, ligatures available |

**Recommendation:** JetBrains Mono Nerd Font - clean, very readable, widely loved.

## Step 2: Install via Homebrew

Run one of these commands in your terminal:

```bash
# JetBrains Mono (recommended)
brew install --cask font-jetbrains-mono-nerd-font

# FiraCode alternative
brew install --cask font-fira-code-nerd-font

# Hack alternative
brew install --cask font-hack-nerd-font

# Meslo alternative
brew install --cask font-meslo-lg-nerd-font
```

## Step 3: Configure iTerm2 to Use the Font

1. Open **iTerm2**
2. Go to **iTerm2 -> Settings** (or press Cmd+,)
3. Click **Profiles** (in the top bar)
4. Select your profile (usually "Default")
5. Click the **Text** tab
6. Under **Font**, click the font name dropdown
7. Select **"JetBrainsMono Nerd Font"** (or whichever you installed)
8. Set font size as desired (14-16 is common)
9. Close settings

## Step 4: Update Neovim Config

Change line 94 in `init.lua`:

```lua
-- Change from:
vim.g.have_nerd_font = false

-- To:
vim.g.have_nerd_font = true
```

This tells Neovim plugins (which-key, neo-tree, diagnostics, etc.) to use Nerd Font icons instead of ASCII/emoji fallbacks.

## Step 5: Restart and Verify

1. **Restart iTerm2** completely (quit and reopen)
2. **Restart Neovim**
3. Open a markdown file - headers should now render with proper icons instead of `?`

## Summary Checklist

- [ ] Pick a Nerd Font (recommended: JetBrains Mono)
- [ ] Run `brew install --cask font-jetbrains-mono-nerd-font`
- [ ] Configure iTerm2: Settings -> Profiles -> Text -> Font
- [ ] Edit `init.lua` line 94: `vim.g.have_nerd_font = true`
- [ ] Restart iTerm2 and Neovim
