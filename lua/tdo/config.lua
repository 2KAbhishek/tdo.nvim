local M = {}

M.config = {
    use_new_command = false,
    add_default_keybindings = true,
    completion = {
        offsets = {},
        ignored_files = { 'README.md', 'templates' },
    },
    cache = {
        timeout = 5000,
        max_entries = 100,
    },
    lualine = {
        update_frequency = 300,
        only_show_in_notes = false,
    },
}

M.setup = function(user_config)
    M.config = vim.tbl_deep_extend('force', M.config, user_config or {})
end

return M
