local tdo = {}

tdo.run_with = function(argument)
    local full_command = 'tdo ' .. argument
    local file_name = vim.fn.system(full_command)
    vim.cmd('edit ' .. file_name)
end

tdo.new_note = function()
    local note = vim.fn.input('Note Path: ')
    if note == '' then
        local current_time = os.date('%m-%d-%H-%M-%S')
        note = 'drafts/' .. current_time
    end
    tdo.run(note)
end

tdo.find_notes = function()
    local root = vim.env.NOTES_DIR
    require('telescope.builtin').live_grep({ cwd = root, prompt_title = 'Search Notes' })
end

tdo.all_notes = function()
    local root = vim.env.NOTES_DIR
    require('telescope.builtin').find_files({ cwd = root, prompt_title = 'All Notes' })
end

tdo.pending_todos = function()
    local result = vim.fn.systemlist('tdo todo')
    if #result > 0 then
        vim.ui.select(result, { prompt = 'Pending Todos' }, function(item, _)
            if item ~= nil then
                vim.cmd('edit ' .. item)
            end
        end)
    end
end

tdo.toggle_todo = function()
    local startline = vim.api.nvim_buf_get_mark(0, "<")[1]
    local endline = vim.api.nvim_buf_get_mark(0, ">")[1]
    local cursorlinenr = vim.api.nvim_win_get_cursor(0)[1]

    vim.api.nvim_buf_set_mark(0, "<", 0, 0, {})
    vim.api.nvim_buf_set_mark(0, ">", 0, 0, {})
    if startline <= 0 or endline <= 0 then
        startline = cursorlinenr
        endline = cursorlinenr
    end
    for curlinenr = startline, endline do
        local curline = vim.api.nvim_buf_get_lines(0, curlinenr - 1, curlinenr, false)[1]
        local stripped = vim.trim(curline)
        local repline
        if vim.startswith(stripped, "- ") and not vim.startswith(stripped, "- [") then
            repline = curline:gsub("%- ", "- [ ] ", 1)
        else
            if vim.startswith(stripped, "- [ ]") then
                repline = curline:gsub("%- %[ %]", "- [x]", 1)
            else
                if vim.startswith(stripped, "- [x]") then
                    repline = curline:gsub("%- %[x%]", "-", 1)
                else
                    repline = curline:gsub("(%S)", "- [ ] %1", 1)
                end
            end
        end
        vim.api.nvim_buf_set_lines(0, curlinenr - 1, curlinenr, false, { repline })
    end
end

return tdo
