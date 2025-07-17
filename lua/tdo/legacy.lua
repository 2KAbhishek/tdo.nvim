local M = {}
local notes = require('tdo.notes')

M.setup = function()
    vim.api.nvim_create_user_command('Tdo', function(input)
        notes.run_with(input.args)
    end, {
        nargs = '*',
    })

    vim.api.nvim_create_user_command('TdoEntry', function(input)
        notes.create_entry(input.args)
    end, { nargs = '*' })

    vim.api.nvim_create_user_command('TdoNote', function()
        notes.new_note()
    end, {})

    vim.api.nvim_create_user_command('TdoTodos', function()
        notes.pending_todos()
    end, {})

    vim.api.nvim_create_user_command('TdoToggle', function()
        notes.toggle_todo()
    end, {})

    vim.api.nvim_create_user_command('TdoFind', function()
        notes.find_note()
    end, {})

    vim.api.nvim_create_user_command('TdoFiles', function()
        notes.all_notes()
    end, {})
end

return M
