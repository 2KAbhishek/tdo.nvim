local M = {}

local function telescope_select(options, options_desc, select_prompt)
    require('telescope.pickers')
        .new({}, {
            prompt_title = select_prompt,
            results_title = options_desc,
            finder = require('telescope.finders').new_table({
                results = options,
                entry_maker = require('telescope.make_entry').gen_from_file(),
            }),
            sorter = require('telescope.sorters').get_fzy_sorter(),
            previewer = require('telescope.previewers').vim_buffer_cat.new({}),
        })
        :find()
end

M.run_with = function(argument)
    local full_command = 'tdo ' .. argument
    local file_name = vim.fn.system(full_command)
    if file_name == '' then
        return
    end

    local file_names = vim.split(file_name, '\n')
    table.remove(file_names, #file_names)

    if #file_names > 1 then
        telescope_select(file_names, 'Notes with similar name', 'Select Note')
    else
        vim.cmd('e ' .. file_name)
    end
end

M.new_note = function()
    local note = vim.fn.input({ prompt = 'Note Path: ', cancelreturn = false })
    if not note then
        return
    end
    if note == '' then
        local current_time = os.date('%m-%d-%H-%M-%S')
        note = 'drafts/' .. current_time
    end
    M.run_with(string.format("'%s'", note))
end

M.find_note = function()
    local root = vim.env.NOTES_DIR
    require('telescope.builtin').live_grep({ cwd = root, prompt_title = 'Search Notes' })
end

M.all_notes = function()
    local root = vim.env.NOTES_DIR
    require('telescope.builtin').find_files({ cwd = root, prompt_title = 'All Notes' })
end

M.pending_todos = function()
    local results = vim.fn.systemlist('tdo todo')
    vim.o.hlsearch = true
    vim.fn.setreg('/', ' ]')
    telescope_select(results, 'Pending Todos', 'Select Todo')
end

M.toggle_todo = function()
    local startline = vim.api.nvim_buf_get_mark(0, '<')[1]
    local endline = vim.api.nvim_buf_get_mark(0, '>')[1]
    local cursorlinenr = vim.api.nvim_win_get_cursor(0)[1]

    vim.api.nvim_buf_set_mark(0, '<', 0, 0, {})
    vim.api.nvim_buf_set_mark(0, '>', 0, 0, {})
    if startline <= 0 or endline <= 0 then
        startline = cursorlinenr
        endline = cursorlinenr
    end
    for curlinenr = startline, endline do
        local curline = vim.api.nvim_buf_get_lines(0, curlinenr - 1, curlinenr, false)[1]
        local stripped = vim.trim(curline)
        local repline
        if vim.startswith(stripped, '- ') and not vim.startswith(stripped, '- [') then
            repline = curline:gsub('%- ', '- [ ] ', 1)
        else
            if vim.startswith(stripped, '- [ ]') then
                repline = curline:gsub('%- %[ %]', '- [x]', 1)
            else
                if vim.startswith(stripped, '- [x]') then
                    repline = curline:gsub('%- %[x%]', '-', 1)
                else
                    repline = curline:gsub('(%S)', '- [ ] %1', 1)
                end
            end
        end
        vim.api.nvim_buf_set_lines(0, curlinenr - 1, curlinenr, false, { repline })
    end
end

return M
