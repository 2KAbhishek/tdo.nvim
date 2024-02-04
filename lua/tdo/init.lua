local tdo = {}

tdo.open_file = function(command)
    local full_command = command or "tdo"
    local file_name = vim.api.nvim_call_function('system', { full_command })
    vim.api.nvim_command('edit ' .. file_name)
end

return tdo

