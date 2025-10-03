# NvChad Config - Keybindings Reference

## General
- `;` → Enter command mode
- `jk` → Exit insert mode (in insert mode)
- `Ctrl+s` → Save file
- `<leader>q` → Quit current window
- `<leader>Q` → Quit all (force)

## Window Management
### Split Windows
- `<leader>wv` → Split vertically
- `<leader>wh` → Split horizontally
- `<leader>wc` → Close current window
- `<leader>wo` → Close all other windows
- `<leader>we` → Equalize window sizes

### Navigate Windows
- `Ctrl+h` → Move to left window
- `Ctrl+j` → Move to bottom window
- `Ctrl+k` → Move to top window
- `Ctrl+l` → Move to right window

### Resize Windows
- `Ctrl+Up` → Increase height
- `Ctrl+Down` → Decrease height
- `Ctrl+Left` → Decrease width
- `Ctrl+Right` → Increase width

## Buffer/Tab Management
### Buffers
- `Shift+h` → Previous buffer
- `Shift+l` → Next buffer
- `<leader>bd` → Delete buffer
- `<leader>bD` → Force delete buffer

### Tabs
- `<leader><tab>n` → New tab
- `<leader><tab>c` → Close tab
- `<leader><tab>]` → Next tab
- `<leader><tab>[` → Previous tab

## File Operations
- `<leader>o` → Open Oil file manager (edit filesystem like a buffer)
- `<leader>e` → Toggle NvimTree

### Oil.nvim Operations (when in Oil buffer)
- `Enter` → Open file/directory
- `-` → Go to parent directory
- `Ctrl+v` → Open in vertical split
- `Ctrl+x` → Open in horizontal split
- `g.` → Toggle hidden files
- Edit filename → Rename file
- `dd` → Delete file (cut)
- Save buffer → Apply all changes

## Fuzzy Finder (Telescope)
- `<leader>ff` → Find files
- `<leader>fg` → Live grep (global search)
- `<leader>fb` → Find buffers
- `<leader>fr` → Recent files
- `<leader>fw` → Find word under cursor
- `<leader>fh` → Help tags
- `<leader>fc` → Find commands
- `<leader>fk` → Find keymaps

## Terminal Management
### Basic Terminals
- `Ctrl+\` → Toggle horizontal terminal
- `<leader>tb` → Toggle bottom terminal
- `<leader>tr` → Toggle right terminal
- `<leader>tf` → Toggle floating terminal

### Multiple Terminals
- `<leader>tbn` → New bottom terminal
- `<leader>tb1/2/3` → Bottom terminals 1/2/3
- `<leader>trn` → New right terminal
- `<leader>tr1/2/3` → Right terminals 1/2/3
- `<leader>tfn` → New floating terminal

### Terminal Navigation
- `Esc` → Exit terminal mode (when in terminal)
- `Ctrl+h/j/k/l` → Navigate to windows (works in terminal mode)
- `<leader>tc` → Close all terminals
- `<leader>ts` → Send command to terminal

## LSP
- `gd` → Go to definition
- `gD` → Go to declaration
- `gi` → Go to implementation
- `gr` → Go to references
- `K` → Hover documentation
- `<leader>rn` → Rename symbol
- `<leader>ca` → Code actions
- `<leader>lf` → Format buffer

## File Explorer (nvim-tree)
- `<leader>ee` → Toggle file explorer

---

## Tips
1. **Floating Terminal Focus Issue**: Press `Esc` to exit terminal mode, then use `Ctrl+h/j/k/l` to navigate
2. **Global Search**: Use `<leader>fg` for searching text across all files
3. **File Operations**: Use `<leader>o` to open Oil.nvim - edit filesystem like text!
4. **Quick Save**: `Ctrl+s` works in any mode

---

# Oil.nvim - File Operations Guide

Oil.nvim lets you edit your filesystem like a text buffer. It's more intuitive than traditional file managers.

## Opening Oil
```
<leader>o  → Open Oil in current directory
```

## Basic Operations

### Navigation
- `Enter` → Open file or enter directory
- `-` → Go to parent directory
- `_` → Go to current working directory
- `g.` → Toggle hidden files

### Opening Files
- `Enter` → Open in current window
- `Ctrl+v` → Open in vertical split
- `Ctrl+x` → Open in horizontal split
- `Ctrl+t` → Open in new tab
- `Ctrl+p` → Preview file

### File Operations (Edit Like Text!)

#### Rename File
1. Navigate to the file
2. Press `i` to enter insert mode
3. Edit the filename directly
4. Press `Esc` then `:w` to save (applies rename)

#### Create New File
1. Press `i` to enter insert mode
2. Create a new line (`o` in normal mode, or `Enter` in insert)
3. Type the new filename
4. Press `Esc` then `:w` to save

#### Delete File
1. Navigate to the file line
2. Press `dd` (like deleting a line in Vim)
3. Press `Esc` then `:w` to save (file deleted)

#### Move File (Cut & Paste)
1. Navigate to the file
2. Press `dd` to cut
3. Navigate to destination directory (use `-` to go up, `Enter` to go down)
4. Press `p` to paste
5. Press `Esc` then `:w` to save

#### Copy File
1. Navigate to the file
2. Press `yy` to yank (copy)
3. Navigate to destination directory
4. Press `p` to paste
5. Press `Esc` then `:w` to save

#### Create Directory
1. Press `i` to enter insert mode
2. Type the directory name ending with `/` (e.g., `new-folder/`)
3. Press `Esc` then `:w` to save

### Bulk Operations
You can edit multiple files at once:

1. Press `i` to enter insert mode
2. Use Vim's text editing (visual mode, macros, etc.)
3. Edit multiple filenames
4. Press `Esc` then `:w` to apply ALL changes at once

### Other Commands
- `Ctrl+c` → Close Oil (cancel changes)
- `g?` → Show help
- `gs` → Change sort order
- `gx` → Open file with system default app

## Examples

### Rename multiple files with a pattern
1. Open Oil: `<leader>o`
2. Enter visual line mode: `V`
3. Select files you want to rename
4. Use substitution: `:'<,'>s/old/new/g`
5. Save: `:w`

### Organize files into folders
1. Open Oil
2. Create folders (add lines ending with `/`)
3. Cut files (`dd`) and paste into folder locations
4. Save once: `:w` (all moves happen together)

## Why Oil > NvimTree?

- **Faster**: Edit filenames directly, no separate rename prompt
- **Powerful**: Use Vim's full text editing (macros, substitution, etc.)
- **Batch Operations**: Rename/move 100 files in one save
- **Undo Support**: Made a mistake? Just `:u` to undo
- **Familiar**: If you know Vim, you know Oil

## Pro Tips

1. **Preview before save**: Make all edits, review, then `:w`
2. **Use visual mode**: Select and edit multiple files
3. **Use macros**: Record repetitive rename patterns
4. **Abort changes**: `:q!` or `Ctrl+c` to cancel without saving
5. **Trash protection**: Files are moved to trash (if configured), not permanently deleted
