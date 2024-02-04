if vim.g.loaded_tdo then
    return
end

vim.g.loaded_tdo = true

local tdo = require("tdo")

vim.api.nvim_create_user_command('Tdo', function(input)
    tdo.open_file('tdo' .. ' ' .. input.args)
end, { nargs = '*' })

