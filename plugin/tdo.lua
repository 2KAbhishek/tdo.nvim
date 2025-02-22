if vim.g.loaded_tdo then
    return
end

vim.g.loaded_tdo = true

vim.api.nvim_create_user_command('Tdo', function(input)
    require('tdo').run_with(input.args)
end, {
    nargs = '*',
    complete = require('tdo.completion').tab_completion,
})

vim.api.nvim_create_user_command('TdoEntry', function(input)
    require('tdo').run_with('entry ' .. input.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('TdoNote', 'lua require("tdo").new_note()', {})
vim.api.nvim_create_user_command('TdoTodos', 'lua require("tdo").pending_todos()', {})
vim.api.nvim_create_user_command('TdoToggle', 'lua require("tdo").toggle_todo()', {})
vim.api.nvim_create_user_command('TdoFind', 'lua require("tdo").find_note()', {})
vim.api.nvim_create_user_command('TdoFiles', 'lua require("tdo").all_notes()', {})

vim.api.nvim_set_keymap(
    'n',
    ']t',
    [[/\v\[ \]\_s*[^[]<CR>:noh<CR>]],
    { noremap = true, silent = true, desc = 'Next Todo' }
)

vim.api.nvim_set_keymap(
    'n',
    '[t',
    [[?\v\[ \]\_s*[^[]<CR>:noh<CR>]],
    { noremap = true, silent = true, desc = 'Prev Todo' }
)
