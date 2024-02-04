if vim.g.loaded_tdo then
    return
end

vim.g.loaded_tdo = true

vim.api.nvim_create_user_command('Tdo', function(input)
    require("tdo").run(input.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('TdoEntry', function(input)
    require("tdo").run('entry ' .. input.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('TdoNote', 'lua require("tdo").note()', {})
vim.api.nvim_create_user_command('TdoYesterday', 'lua require("tdo").run("-1")', {})
vim.api.nvim_create_user_command('TdoTomorrow', 'lua require("tdo").run("1")', {})
vim.api.nvim_create_user_command('TdoPending', 'lua require("tdo").pending()', {})
vim.api.nvim_create_user_command('TdoSearch', 'lua require("tdo").search()', {})
vim.api.nvim_create_user_command('TdoFind', 'lua require("tdo").search()', {})
vim.api.nvim_create_user_command('TdoFiles', 'lua require("tdo").files()', {})
vim.api.nvim_create_user_command('TdoToggle', 'lua require("tdo").toggle()', {})

vim.api.nvim_set_keymap('n', ']t', [[/\v\[ \]\_s*[^[]<CR>:noh<CR>]],
    { noremap = true, silent = true, desc = 'Next Todo' })
vim.api.nvim_set_keymap('n', '[t', [[?\v\[ \]\_s*[^[]<CR>:noh<CR>]],
    { noremap = true, silent = true, desc = 'Prev Todo' })
