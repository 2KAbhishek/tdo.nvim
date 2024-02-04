local tdo = {}

tdo.run = function(command)
    local full_command = 'tdo ' .. command
    local file_name = vim.fn.system(full_command)
    vim.cmd('edit ' .. file_name)
end

tdo.note = function()
    local note = vim.fn.input('Note Path: ')
    if note == '' then
        local current_time = os.date('%m-%d-%H-%M-%S')
        note = 'drafts/' .. current_time
    end
    tdo.run(note)
end

tdo.search = function()
    local root = vim.env.NOTES_DIR
    require('telescope.builtin').live_grep({ cwd = root, prompt_title = 'Tdo Search' })
end

tdo.files = function()
    local root = vim.env.NOTES_DIR
    require('telescope.builtin').find_files({ cwd = root, prompt_title = 'Tdo Files' })
end

tdo.pending = function()
    local result = vim.fn.systemlist('tdo todo')
    if #result > 0 then
        vim.ui.select(result, { prompt = 'Tdo Pending' }, function(item, _)
            if item ~= nil then
                vim.cmd('edit ' .. item)
            end
        end)
    end
end

return tdo
