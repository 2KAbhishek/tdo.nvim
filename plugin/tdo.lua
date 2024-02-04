if vim.g.loaded_tdo then
    return
end

vim.g.loaded_tdo = true

local tdo = require("tdo")

vim.api.nvim_create_user_command('Tdo', function(input)
    tdo.run(input.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('TdoEntry', function(input)
    tdo.run('entry ' .. input.args)
end, { nargs = '*' })

vim.api.nvim_create_user_command('TdoYesterday', function()
    tdo.run('-1')
end, {})

vim.api.nvim_create_user_command('TdoTomorrow', function()
    tdo.run('1')
end, {})
