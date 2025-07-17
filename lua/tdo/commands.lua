local M = {}
local notes = require('tdo.notes')
local completion = require('tdo.completion')

local subcommands = {
    'entry',
    'note',
    'todos',
    'toggle',
    'find',
    'files',
}

local function complete_subcommands(arglead, cmdline, cursorpos)
    local parts = vim.split(cmdline, '%s+')
    local cmd_parts = {}
    for _, part in ipairs(parts) do
        if part ~= '' then
            table.insert(cmd_parts, part)
        end
    end

    if #cmd_parts <= 2 then
        local matches = {}
        for _, subcommand in ipairs(subcommands) do
            if vim.startswith(subcommand, arglead) then
                table.insert(matches, subcommand)
            end
        end
        return matches
    end

    return {}
end

local function complete_tdo_command(arglead, cmdline, cursorpos)
    local parts = vim.split(cmdline, '%s+')
    local cmd_parts = {}
    for _, part in ipairs(parts) do
        if part ~= '' then
            table.insert(cmd_parts, part)
        end
    end

    if #cmd_parts <= 2 then
        local subcommand_matches = complete_subcommands(arglead, cmdline, cursorpos)
        local file_matches = completion.tab_completion(arglead, cmdline, cursorpos)

        local all_matches = {}
        for _, match in ipairs(subcommand_matches) do
            table.insert(all_matches, match)
        end
        for _, match in ipairs(file_matches) do
            table.insert(all_matches, match)
        end

        return all_matches
    elseif #cmd_parts == 3 and cmd_parts[2] == 'get' then
        return completion.tab_completion(arglead, cmdline, cursorpos)
    end

    return {}
end

local function handle_tdo_command(opts)
    local args = opts.fargs

    if #args == 0 then
        notes.run_with('')
        return
    end

    local subcommand = args[1]

    if subcommand == 'entry' then
        local offset = args[2] or ''
        notes.create_entry(offset)
    elseif subcommand == 'note' then
        local title = table.concat(args, ' ', 2)
        notes.new_note(title)
    elseif subcommand == 'todos' then
        notes.pending_todos()
    elseif subcommand == 'toggle' then
        notes.toggle_todo()
    elseif subcommand == 'find' then
        local text = table.concat(args, ' ', 2)
        notes.find_note(text)
    elseif subcommand == 'files' then
        notes.all_notes()
    else
        local full_args = table.concat(args, ' ')
        notes.run_with(full_args)
    end
end

M.setup = function()
    vim.api.nvim_create_user_command('Tdo', handle_tdo_command, {
        nargs = '*',
        complete = complete_tdo_command,
        desc = 'tdo.nvim unified command interface',
    })
end

return M
