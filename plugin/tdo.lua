if vim.g.loaded_tdo then
    return
end

vim.g.loaded_tdo = true

require('tdo.legacy').setup()

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
