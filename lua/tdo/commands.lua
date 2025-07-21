local M = {}
local config = require('tdo.config').config
local notes = require('tdo.notes')

local dir_cache = {}
local cache_order = {}
local pattern_cache = {}

---Add a normal mode keymap for a command
---@param keys string
---@param cmd string
---@param desc string
local function add_keymap(keys, cmd, desc)
    vim.api.nvim_set_keymap('n', keys, cmd, { noremap = true, silent = true, desc = desc })
end

local function add_legacy_keymaps()
    add_keymap(']t', [[/\v\[ \]\_s*[^[]<CR>:noh<CR>]], 'Next Todo')
    add_keymap('[t', [[?\v\[ \]\_s*[^[]<CR>:noh<CR>]], 'Prev Todo')
end

local function add_default_keymaps()
    add_keymap('<leader>nn', ':Tdo<CR>', "Today's Todo")
    add_keymap('<leader>ne', ':Tdo entry<CR>', "Today's Entry")
    add_keymap('<leader>nf', ':Tdo files<CR>', 'All Notes')
    add_keymap('<leader>ng', ':Tdo find<CR>', 'Find Notes')
    add_keymap('<leader>nh', ':Tdo yesterday<CR>', "Yesterday's Todo")
    add_keymap('<leader>nl', ':Tdo tomorrow<CR>', "Tomorrow's Todo")
    add_keymap('<leader>nc', ':Tdo note<CR>', 'Create Note')
    add_keymap('<leader>nt', ':Tdo todos<CR>', 'Incomplete Todos')
    add_keymap('<leader>nx', ':Tdo toggle<CR>', 'Toggle Todo')

    add_keymap(']t', [[/\v\[ \]\_s*[^[]<CR>:noh<CR>]], 'Next Todo')
    add_keymap('[t', [[?\v\[ \]\_s*[^[]<CR>:noh<CR>]], 'Prev Todo')

    add_keymap(
        '<leader>ns',
        ':lua require("tdo.notes").run_with("commit " .. vim.fn.expand("%:p")) vim.notify("Tdo Committed!")<CR>',
        'Commit Note'
    )

    for i = 1, 9 do
        add_keymap(
            string.format('<leader>nd%d', i),
            string.format(':Tdo %d<CR>', i),
            string.format('Todo %d Days Later', i)
        )

        add_keymap(
            string.format('<leader>nD%d', i),
            string.format(':Tdo -%d<CR>', i),
            string.format('Todo %d Days Ago', i)
        )

        add_keymap(
            string.format('<leader>nw%d', i),
            string.format(':Tdo %d-weeks-later<CR>', i),
            string.format('Todo %d Weeks Later', i)
        )

        add_keymap(
            string.format('<leader>nW%d', i),
            string.format(':Tdo %d-weeks-ago<CR>', i),
            string.format('Todo %d Weeks Ago', i)
        )

        add_keymap(
            string.format('<leader>nw%d', i),
            string.format(':Tdo %d-months-later<CR>', i),
            string.format('Todo %d Months Later', i)
        )

        add_keymap(
            string.format('<leader>nW%d', i),
            string.format(':Tdo %d-months-ago<CR>', i),
            string.format('Todo %d Months Ago', i)
        )

        add_keymap(
            string.format('<leader>ny%d', i),
            string.format(':Tdo %d-years-later<CR>', i),
            string.format('Todo %d Years Later', i)
        )

        add_keymap(
            string.format('<leader>nY%d', i),
            string.format(':Tdo %d-years-ago<CR>', i),
            string.format('Todo %d Years Ago', i)
        )
    end
end

local subcommands = {
    'entry',
    'note',
    'todos',
    'toggle',
    'find',
    'files',
}

local subcommand_handlers = {
    entry = function(args)
        local offset = args[2] or ''
        notes.create_entry(offset)
    end,
    note = function(args)
        local title = table.concat(args, ' ', 2)
        notes.new_note(title)
    end,
    todos = function(args)
        notes.pending_todos()
    end,
    toggle = function(args)
        notes.toggle_todo()
    end,
    find = function(args)
        local text = table.concat(args, ' ', 2)
        notes.find_note(text)
    end,
    files = function(args)
        notes.all_notes()
    end,
}

--- Validates if a path exists and is accessible
--- @param path string Path to validate
--- @return boolean true if path is valid and accessible
local function is_valid_path(path)
    if not path or path == '' then
        return false
    end

    local stat = vim.loop.fs_stat(path)
    return stat ~= nil
end

--- Performs enhanced fuzzy matching on a string against a pattern
--- @param str string The string to match against
--- @param pattern string The pattern to match
--- @return boolean true if the pattern matches the string
local function fuzzy_match(str, pattern)
    if pattern == '' then
        return true
    end

    local lower_str = vim.fn.tolower(str)
    local lower_pattern = vim.fn.tolower(pattern)

    if vim.startswith(lower_str, lower_pattern) then
        return true
    end

    local fuzzy_pattern = pattern_cache[lower_pattern]
    if not fuzzy_pattern then
        fuzzy_pattern = lower_pattern:gsub('.', function(c)
            return vim.pesc(c) .. '.*'
        end)
        if vim.tbl_count(pattern_cache) < config.cache.max_entries then
            pattern_cache[lower_pattern] = fuzzy_pattern
        end
    end

    return lower_str:match(fuzzy_pattern) ~= nil
end

--- Cleans up old cache entries using LRU strategy
local function cleanup_cache()
    local max_entries = config.cache.max_entries
    if #cache_order <= max_entries then
        return
    end

    local to_remove = math.max(1, math.floor(max_entries * 0.25))
    for i = 1, to_remove do
        local old_key = table.remove(cache_order, 1)
        if old_key then
            dir_cache[old_key] = nil
        end
    end
end

--- Gets directory contents with caching for performance
--- @param dir_path string Path to the directory to scan
--- @return table<string, string>|nil Map of filenames to their types, nil on error
local function get_directory_contents(dir_path)
    if not is_valid_path(dir_path) then
        return nil
    end

    local current_time = vim.loop.now()
    local cache_key = dir_path

    if dir_cache[cache_key] and (current_time - dir_cache[cache_key].timestamp) < config.cache.timeout then
        return dir_cache[cache_key].contents
    end

    local handle, err = vim.loop.fs_scandir(dir_path)
    if not handle then
        return nil
    end

    local contents = {}
    while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then
            break
        end

        -- Skip hidden files/directories
        if not name:match('^%.') then
            contents[name] = type
        end
    end

    table.insert(cache_order, cache_key)
    dir_cache[cache_key] = {
        contents = contents,
        timestamp = current_time,
    }

    cleanup_cache()
    return contents
end

--- Parses input path into directory and search components
--- @param arglead string The current argument being completed
--- @param notes_dir string Base notes directory path
--- @return table|nil {base_dir: string, search_pattern: string, base_path: string} or nil on error
local function parse_path_input(arglead, notes_dir)
    if not notes_dir or notes_dir == '' then
        return nil
    end

    local base_dir = notes_dir
    local search_pattern = arglead
    local base_path = ''

    local last_slash = arglead:match('.*/()')
    if last_slash then
        base_path = arglead:sub(1, last_slash)
        local dir_part = arglead:sub(1, last_slash - 1)

        local success, resolved_path = pcall(vim.fn.resolve, notes_dir .. '/' .. dir_part)
        if not success then
            return nil
        end

        base_dir = resolved_path
        search_pattern = arglead:sub(last_slash)
    end

    return {
        base_dir = base_dir,
        search_pattern = search_pattern,
        base_path = base_path,
    }
end

--- Provides offset completions for entry and main tdo commands
--- @param arglead string The current argument being completed
--- @return string[] Array of matching offset values
local function get_offset_completions(arglead)
    return vim.tbl_filter(function(offset)
        return vim.startswith(offset, arglead)
    end, config.completion.offsets)
end

--- Provides tab completion for file paths within the notes directory
--- @param arglead string The current argument being completed
--- @return string[] Array of matching file/directory paths
local function get_file_completions(arglead)
    local notes_dir = vim.env.NOTES_DIR
    if not notes_dir then
        return {}
    end

    local path_info = parse_path_input(arglead, notes_dir)
    if not path_info then
        return {}
    end

    local contents = get_directory_contents(path_info.base_dir)
    if not contents then
        return {}
    end

    local results = {}
    local ignore_list = config.completion.ignored_files

    for name, type in pairs(contents) do
        if
            not vim.tbl_contains(ignore_list, name)
            and (path_info.search_pattern == '' or fuzzy_match(name, path_info.search_pattern))
        then
            local relative_path = path_info.base_path ~= '' and (path_info.base_path .. name) or name
            local display_path = type == 'directory' and (relative_path .. '/') or relative_path
            table.insert(results, display_path)
        end
    end

    table.sort(results)
    return results
end

--- Main completion function for the Tdo command
--- @param arglead string The current argument being completed
--- @param cmdline string The full command line
--- @param cursorpos number The cursor position in the command line
--- @return string[] Array of completion candidates
local function complete_tdo_command(arglead, cmdline, cursorpos)
    local cmd_parts = vim.tbl_filter(function(part)
        return part ~= ''
    end, vim.split(cmdline, '%s+'))

    if #cmd_parts == 1 or (#cmd_parts == 2 and arglead ~= '') then
        local matches = {}

        if arglead == '' then
            vim.list_extend(matches, subcommands)
            local offset_matches = get_offset_completions('')
            vim.list_extend(matches, offset_matches)
            local file_matches = get_file_completions('')
            vim.list_extend(matches, file_matches)
            return matches
        end

        local matching_subcommands = vim.tbl_filter(function(subcommand)
            return vim.startswith(subcommand, arglead)
        end, subcommands)
        vim.list_extend(matches, matching_subcommands)

        local offset_matches = get_offset_completions(arglead)
        vim.list_extend(matches, offset_matches)

        local file_matches = get_file_completions(arglead)
        vim.list_extend(matches, file_matches)

        return matches
    elseif #cmd_parts >= 2 then
        local subcommand = cmd_parts[2]

        if subcommand == 'entry' then
            return get_offset_completions(arglead)
        elseif subcommand == 'note' then
            return get_file_completions(arglead)
        else
            return {}
        end
    end

    return {}
end

--- Handles the main Tdo command by routing to appropriate subcommands
--- @param opts table Command options containing fargs array
local function handle_tdo_command(opts)
    local args = opts.fargs

    if #args == 0 then
        notes.run_with('')
        return
    end

    local subcommand = args[1]
    local handler = subcommand_handlers[subcommand]

    if handler then
        handler(args)
    else
        local full_args = table.concat(args, ' ')
        notes.run_with(full_args)
    end
end

--- Sets up the Tdo user command with completion
M.setup = function()
    if config.use_new_command then
        vim.api.nvim_create_user_command('Tdo', handle_tdo_command, {
            nargs = '*',
            complete = complete_tdo_command,
            desc = 'tdo.nvim unified command interface',
        })
        if config.add_default_keybindings then
            add_default_keymaps()
        end
    else
        require('tdo.legacy').setup()
        add_legacy_keymaps()
    end
end

return M
