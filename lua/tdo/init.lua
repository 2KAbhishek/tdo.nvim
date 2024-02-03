local tdo = {}

tdo.open_file = function(command)
    local file_name = vim.api.nvim_call_function('system', { command })
    vim.api.nvim_command('edit ' .. file_name)
end

return tdo
