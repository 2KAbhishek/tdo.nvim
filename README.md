<div align = "center">

<h1><a href="https://github.com/2kabhishek/tdo.nvim">tdo.nvim</a></h1>

<a href="https://github.com/2KAbhishek/tdo.nvim/blob/main/LICENSE">
<img alt="License" src="https://img.shields.io/github/license/2kabhishek/tdo.nvim?style=flat&color=eee&label="> </a>

<a href="https://github.com/2KAbhishek/tdo.nvim/graphs/contributors">
<img alt="People" src="https://img.shields.io/github/contributors/2kabhishek/tdo.nvim?style=flat&color=ffaaf2&label=People"> </a>

<a href="https://github.com/2KAbhishek/tdo.nvim/stargazers">
<img alt="Stars" src="https://img.shields.io/github/stars/2kabhishek/tdo.nvim?style=flat&color=98c379&label=Stars"></a>

<a href="https://github.com/2KAbhishek/tdo.nvim/network/members">
<img alt="Forks" src="https://img.shields.io/github/forks/2kabhishek/tdo.nvim?style=flat&color=66a8e0&label=Forks"> </a>

<a href="https://github.com/2KAbhishek/tdo.nvim/watchers">
<img alt="Watches" src="https://img.shields.io/github/watchers/2kabhishek/tdo.nvim?style=flat&color=f5d08b&label=Watches"> </a>

<a href="https://github.com/2KAbhishek/tdo.nvim/pulse">
<img alt="Last Updated" src="https://img.shields.io/github/last-commit/2kabhishek/tdo.nvim?style=flat&color=e06c75&label="> </a>

<h3>Fast & Simple Notes in Neovim 📃🚀</h3>

<figure>
  <img src="images/screenshot.jpg" alt="tdo.nvim in action">
  <br/>
  <figcaption>tdo.nvim in action</figcaption>
</figure>

</div>

tdo.nvim integrates [tdo](https://github.com/2kabhishek/tdo) into your neovim workflow to make managing notes and todos super simple and fast. [Demo video](https://youtu.be/N4IRT7M-RLg)

## ✨ Features

- All features provided by [tdo](https://github.com/2kabhishek/tdo?tab=readme-ov-file#-features)
- Various commands to make working with tdo seamless
- Todo navigation and toggle helpers
- Fuzzy autocompletion for notes navigation
- Integration with various pickers via [pickme.nvim](https://github.com/2kabhishek/pickme.nvim) for easy notes searching

## ⚡ Setup

### ⚙️ Requirements

- [tdo](https://github.com/2kabhishek/tdo) must be setup
- [pickme.nvim](https://github.com/2kabhishek/pickme.nvim) for picker support

### 💻 Installation

Add the following to your lazy/packer config

```lua
    -- Lazy
    {
        '2kabhishek/tdo.nvim',
        dependencies =  '2kabhishek/pickme.nvim',
        cmd = { 'Tdo' },
        keys = { '<leader>nn', '<leader>nx', '[t', ']t' }, -- Add more keybindings you need for lazy loading
    },
```

## 🚀 Usage

### ⚙️ Configuration

tdo.nvim can be configured using the following options:

```lua
local tdo = require('tdo')

tdo.setup({
    use_new_command = false,        -- Use the new unified `Tdo` command
    add_default_keybindings = true, -- Add default keybindings for the plugin
    completion = {
        offsets = {},               -- Custom offsets / date expressions for completion
        ignored_files = { 'README.md', 'templates' }, -- Files/directories to ignore in completions
        cache = {                       -- You don't really need to change these
            timeout = 5000,             -- Completion cache timeout in milliseconds
            max_entries = 100,          -- Maximum number of cached completion entries
        },
    },
})
```

> **Note:** Set `use_new_command = true` to enable the modern unified `Tdo` command with natural language date support and enhanced completion.

### 📡 Commands

`tdo.nvim` provides the following commands.

- `:Tdo [date_expression / note]`: Opens todo with flexible date formats - [available expressions](https://github.com/2kabhishek/tdo#-natural-date-parsing)
  - Ex: `:Tdo` - Open today's todo
  - Ex: `:Tdo tomorrow` - Open tomorrow's todo
  - Ex: `:Tdo monday` - Open this Monday's todo
  - Ex: `:Tdo next-friday` - Open next Friday's todo
  - Ex: `:Tdo 2-weeks-ago` - Open todo from 2 weeks ago
  - Ex: `:Tdo 2025-07-14` - Open todo for specific date
  - Ex: `:Tdo vim` - Open note file "vim.md" in notes dir
- `:Tdo entry [date_expression]`: Opens journal entry with same flexible date formats
  - Ex: `:Tdo entry` - Open today's journal entry
  - Ex: `:Tdo entry last-tue` - Open last Tuesday's journal entry
- `:Tdo note [title/note-file]`: Create new note, if empty creates timestamped draft
- `:Tdo files`: Review all your notes
- `:Tdo find [text]`: Search for text in all notes
- `:Tdo todos`: Show all incomplete todos
- `:Tdo toggle`: Toggle todo state

#### Command Completion

The modern `Tdo` command supports comprehensive tab completion:

- **Subcommands**: `entry`, `note`, `files`, `find`, `todos`, `toggle`
- **File paths**: Auto-complete note paths with fuzzy matching
- **Natural dates**: `today`, `tomorrow`, `yesterday`, `monday`, `next-friday`, `last-week` - powered by your `completion.offsets` config, [available expressions](https://github.com/2kabhishek/tdo#-natural-date-parsing)
- **Context-aware**: Shows relevant completions based on subcommand

#### Legacy Commands (Backward Compatibility)

> **⚠️ DEPRECATION NOTICE**: The following commands are deprecated and will be removed on August 15th, 2025. Please migrate to the new unified `Tdo` command above.
> More information: https://github.com/2kabhishek/tdo.nvim/issues/8

The original commands are still available for backward compatibility:

- `TdoEntry <offset>`: open today's journal entry, accepts `offset`
- `TdoNote`: create new note with title, if left empty creates a draft with current timestamp
- `TdoTodos`: show all your incomplete todos
- `TdoToggle`: toggle todo state
- `TdoFind <text>`: interactively search for `text` in all your notes
- `TdoFiles`: review all your notes

**Migration Guide:**

- `TdoEntry` → `:Tdo entry`
- `TdoNote` → `:Tdo note`
- `TdoTodos` → `:Tdo todos`
- `TdoToggle` → `:Tdo toggle`
- `TdoFind` → `:Tdo find`
- `TdoFiles` → `:Tdo files`

### ⌨️ Keybindings

By default, these are the configured keybindings.

| Keybinding        | Command                                            | Description         |
| ----------------- | -------------------------------------------------- | ------------------- |
| `<leader>nn`      | `:Tdo<CR>`                                         | Today's Todo        |
| `<leader>ne`      | `:Tdo entry<CR>`                                   | Today's Entry       |
| `<leader>nf`      | `:Tdo files<CR>`                                   | All Notes           |
| `<leader>ng`      | `:Tdo find<CR>`                                    | Find Notes          |
| `<leader>nh`      | `:Tdo yesterday<CR>`                               | Yesterday's Todo    |
| `<leader>nl`      | `:Tdo tomorrow<CR>`                                | Tomorrow's Todo     |
| `<leader>nc`      | `:Tdo note<CR>`                                    | Create Note         |
| `<leader>ns`      | `:lua require("tdo.notes").run_with("commit")<CR>` | Commit Note         |
| `<leader>nt`      | `:Tdo todos<CR>`                                   | Incomplete Todos    |
| `<leader>nx`      | `:Tdo toggle<CR>`                                  | Toggle Todo         |
| `]t`              | `/\v\[ \]\_s*[^[]<CR>:noh<CR>`                     | Next Todo           |
| `[t`              | `?\v\[ \]\_s*[^[]<CR>:noh<CR>`                     | Prev Todo           |
| `<leader>nd[1-9]` | `:Tdo [1-9]<CR>`                                   | Todo N Days Later   |
| `<leader>nD[1-9]` | `:Tdo -[1-9]<CR>`                                  | Todo N Days Ago     |
| `<leader>nw[1-9]` | `:Tdo [1-9]-weeks-later<CR>`                       | Todo N Weeks Later  |
| `<leader>nW[1-9]` | `:Tdo [1-9]-weeks-ago<CR>`                         | Todo N Weeks Ago    |
| `<leader>nm[1-9]` | `:Tdo [1-9]-months-later<CR>`                      | Todo N Months Later |
| `<leader>nM[1-9]` | `:Tdo [1-9]-months-ago<CR>`                        | Todo N Months Ago   |
| `<leader>ny[1-9]` | `:Tdo [1-9]-years-later<CR>`                       | Todo N Years Later  |
| `<leader>nY[1-9]` | `:Tdo [1-9]-years-ago<CR>`                         | Todo N Years Ago    |

I recommend customizing these keybindings based on your preferences.

**Note:** Keybindings are only active when `add_default_keybindings = true` in your configuration.

## 🏗️ What's Next

You tell me!

## 🧑‍💻 Behind The Code

### 🌈 Inspiration

Most note-taking systems offer a lot more than I needed, so I wrote [tdo](https://github.com/2kabhishek/tdo) and then tdo.nvim for better integration.

### 💡 Challenges/Learnings

- Dove deeper into nvim APIs
- Learned about not interactive shell scripting.

### 🧰 Tooling

- [dots2k](https://github.com/2kabhishek/dots2k) — Dev Environment
- [nvim2k](https://github.com/2kabhishek/nvim2k) — Personalized Editor
- [sway2k](https://github.com/2kabhishek/sway2k) — Desktop Environment
- [qute2k](https://github.com/2kabhishek/qute2k) — Personalized Browser

### 🔍 More Info

- [co-author.nvim](https://github.com/2kabhishek/co-author.nvim) — Easily add git co authors
- [nerdy.nvim](https://github.com/2kabhishek/nerdy.nvim) — Easily add nerd glyphs

<hr>

<div align="center">

<strong>⭐ hit the star button if you found this useful ⭐</strong><br>

<a href="https://github.com/2KAbhishek/tdo.nvim">Source</a>
| <a href="https://2kabhishek.github.io/blog" target="_blank">Blog </a>
| <a href="https://twitter.com/2kabhishek" target="_blank">Twitter </a>
| <a href="https://linkedin.com/in/2kabhishek" target="_blank">LinkedIn </a>
| <a href="https://2kabhishek.github.io/links" target="_blank">More Links </a>
| <a href="https://2kabhishek.github.io/projects" target="_blank">Other Projects </a>

</div>
