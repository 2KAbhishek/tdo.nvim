local M = {}

local function fuzzy_match(str, pattern)
    if pattern == '' then return true end
    
    -- Convert pattern to case-insensitive fuzzy match pattern
    pattern = vim.fn.tolower(pattern):gsub('.', function(c)
        return c .. '.*'
    end)
    
    return vim.fn.tolower(str):match(pattern) ~= nil
end

local function get_directory_contents(dir_path)
    local handle = vim.loop.fs_scandir(dir_path)
    if not handle then return {} end

    local contents = {}
    while true do
        local name, type = vim.loop.fs_scandir_next(handle)
        if not name then break end
        
        -- Skip hidden files/directories
        if not name:match('^%.') then
            contents[name] = type
        end
    end
    return contents
end

local function build_completion_list(contents, base_path)
    local results = {}
    for name, type in pairs(contents) do
        -- Build the full relative path
        local relative_path = base_path and (base_path .. name) or name

        if type == 'directory' then
            table.insert(results, relative_path .. '/')
        else
            table.insert(results, relative_path)
        end
    end

    table.sort(results)
    return results
end

M.tab_completion = function(ArgLead, CmdLine, CursorPos)
    local notes_dir = vim.env.NOTES_DIR
    if not notes_dir then return {} end

    -- Parse input path
    local base_dir = notes_dir
    local search_pattern = ArgLead
    local base_path = ''

    local last_slash = ArgLead:match('.*/()')
    if last_slash then
        base_path = ArgLead:sub(1, last_slash)  -- Keep the trailing slash
        base_dir = vim.fn.resolve(notes_dir .. '/' .. ArgLead:sub(1, last_slash - 1))
        search_pattern = ArgLead:sub(last_slash)
    end

    -- Get directory contents and build completion list
    local contents = get_directory_contents(base_dir)
    local results = build_completion_list(contents, base_path)

    -- Filter results using fuzzy matching
    if search_pattern ~= '' then
        local filtered = {}
        for _, name in ipairs(results) do
            local filename = vim.fn.fnamemodify(name, ':t')
            if fuzzy_match(filename, search_pattern) then
                table.insert(filtered, name)
            end
        end
        results = filtered
    end

    return results
end

return M
