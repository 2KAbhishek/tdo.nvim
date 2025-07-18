local M = {}

M.config = {
    use_new_command = false,
    cache = {
        timeout = 5000,
        max_entries = 100,
    },
    completion = {
        offsets = { '1', '-1', '2', '-2', '3', '-3' },
        ignore = { 'README.md', 'templates' },
    },
}

M.setup = function(user_config)
    M.config = vim.tbl_deep_extend('force', M.config, user_config or {})
end

return M
