if vim.g.loaded_tdo then
    return
end

vim.g.loaded_tdo = true

vim.api.nvim_create_user_command('Tdo', function()
    require("tdo").open_file("tdo ")
end, {})
