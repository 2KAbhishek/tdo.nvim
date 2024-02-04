local tdo = {}

tdo.run = function(command)
    local full_command = 'tdo ' .. command
    local file_name = vim.api.nvim_call_function('system', { full_command })
    vim.api.nvim_command('edit ' .. file_name)
end

return tdo

