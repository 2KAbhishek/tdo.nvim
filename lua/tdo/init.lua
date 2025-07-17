local M = {}
local config = require('tdo.config')
local notes = require('tdo.notes')

M.root = vim.env.NOTES_DIR
M.run_with = notes.run_with
M.new_note = notes.new_note
M.find_note = notes.find_note
M.all_notes = notes.all_notes
M.pending_todos = notes.pending_todos
M.toggle_todo = notes.toggle_todo

M.setup = function(user_config)
    config.setup(user_config)

    if config.config.use_new_command then
        require('tdo.commands').setup()
    else
        require('tdo.legacy').setup()
    end
end

return M
